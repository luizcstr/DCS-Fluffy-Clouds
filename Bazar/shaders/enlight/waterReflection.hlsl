#define SSR_Depth g_DepthTexture
#include "enlight/ssr.hlsl"
#define SSR_GetColor getPrevFrameColor
#include "enlight/ssr.hlsl"

#define USE_REFLECTION_TEST 0

// -----------------------------------------------------------------------------
// V11 REFLECTION TUNING
// The v11 surface carries stronger, longer animated normals than stock water.
// Keep SSR on the stock 32-step path, but use only screen-space and
// surface-normal confidence so the result never changes with camera distance.
// x/y: screen-edge fade range.
static const float2 WATER_REFLECTION_SSR_TUNE = float2(0.015, 0.10);
// x: maximum history weight; y: history retained on steep normals;
// z: reprojection rejection scale.
static const float3 WATER_REFLECTION_HISTORY_TUNE = float3(0.86, 0.55, 10.0);
// x/y: environment-map mip range; z: normal slope at maximum mip;
// w: amount of the stock flattened-normal sky lobe.
static const float4 WATER_REFLECTION_SKY_TUNE = float4(1.75, 3.00, 0.80, 0.50);

Texture2D prevReflection;

struct VS_REFLECTION_OUTPUT {
	float4 sv_pos:		SV_POSITION;
	float2 projPos:		TEXCOORD0;
};

VS_REFLECTION_OUTPUT VS_REFLECTION(uint vid: SV_VertexID) {
	VS_REFLECTION_OUTPUT o;
	o.sv_pos = float4(quad[vid], 0, 1);
	o.projPos = o.sv_pos.xy;
	return o;
}

float3 getReflectionSkyColorLDR(float3 v, float mipLevel) {
	return environmentMap.SampleLevel(ClampLinearSampler, v, mipLevel).rgb;
}

float3 reflectionSky(float3 wsPos, float3 wsNormal) {
	float3 wsView = wsPos - gCameraPos;
	wsView *= rsqrt(max(dot(wsView, wsView), 1e-6));
	wsNormal = normalize(wsNormal);

	float3 wsRay = reflect(wsView, wsNormal);
	wsRay.y = abs(wsRay.y);	// prevent the green lower cubemap hemisphere

	// Steeper v11 normals use a slightly softer cubemap level. This preserves
	// the large swell shape without turning fine normal energy into sparkle.
	float normalSlope = saturate(length(wsNormal.xz) / WATER_REFLECTION_SKY_TUNE.z);
	float mipLevel = lerp(WATER_REFLECTION_SKY_TUNE.x, WATER_REFLECTION_SKY_TUNE.y, normalSlope);
	return getReflectionSkyColorLDR(wsRay, mipLevel);
}

float3 restoreReflectionWorldPos(float4 NDC) {
	float4 wsPos = mul(NDC, gViewProjInv);
	return wsPos.xyz / wsPos.w;
}

float3 reflectionSky(float4 NDC, float2 tuv) {
	float3 wsPos = restoreReflectionWorldPos(NDC);
	float3 wsNormal = DecodeWaterNormal(tuv, 0);
	float3 r0 = reflectionSky(wsPos, wsNormal);
	wsNormal = normalize(lerp(wsNormal, float3(0, 1, 0), 0.33));
	float3 r1 = reflectionSky(wsPos, wsNormal);
	return lerp(r0, r1, WATER_REFLECTION_SKY_TUNE.w);
}

float reflectionScreenEdgeConfidence(float2 uv) {
	float2 edgeDistance = min(uv, 1.0 - uv);
	float nearestEdge = min(edgeDistance.x, edgeDistance.y);
	return smoothstep(
		WATER_REFLECTION_SSR_TUNE.x,
		WATER_REFLECTION_SSR_TUNE.y,
		nearestEdge
	);
}

float reflectionHistoryConfidence(float3 wsNormal) {
	// Water motion vectors describe the mesh, not v11's animated normal detail.
	// Retain less history on steep normals so long swells do not leave trails.
	float normalSlope = saturate(length(wsNormal.xz) / WATER_REFLECTION_SKY_TUNE.z);
	return lerp(1.0, WATER_REFLECTION_HISTORY_TUNE.y, normalSlope);
}

float3 mixPrevFrame(float3 refl, float4 NDC, float historyConfidence) {
	float4 prevNDC = mul(NDC, gPrevFrameTransform);
	float validW = step(1e-5, prevNDC.w);
	float2 prevProj = prevNDC.xy / max(abs(prevNDC.w), 1e-5);
	float2 puv = float2(prevProj.x, -prevProj.y) * 0.5 + 0.5;
	float4 prevRefl = prevReflection.SampleLevel(gTrilinearBlackBorderSampler, puv, 0);

	float2 edgeDistance = min(puv, 1.0 - puv);
	float inBounds = step(0.0, min(edgeDistance.x, edgeDistance.y));
	float2 currentProj = NDC.xy / max(abs(NDC.w), 1e-5);
	float reprojectionConfidence = saturate(
		1.0 - distance(prevProj, currentProj) * WATER_REFLECTION_HISTORY_TUNE.z
	);

	float w =
		WATER_REFLECTION_HISTORY_TUNE.x *
		saturate(prevRefl.w * validW * inBounds * reprojectionConfidence * historyConfidence * g_PrevFrameWeight);
	return max(0, lerp(refl, prevRefl.xyz, w));
}

float4 PS_REFLECTION_WATER(VS_REFLECTION_OUTPUT i, uniform bool usePrevHDRBuffer = false): SV_TARGET0 {
	float2 uv = float2(i.projPos.x, -i.projPos.y)*0.5 + 0.5;
	float2 tuv = transformColorBufferUV(uv) + 0.5;	// center of pixel

	// Calculate the sky fallback for missed SSR rays.
	float depth = LoadDepth(tuv);
	float4 NDC = float4(i.projPos.xy, depth, 1);
	float3 sky = reflectionSky(NDC, tuv);

	// Check water material.
	if (!isWater(LoadStencil(tuv)))
#if USE_REFLECTION_TEST
		return float4(1, 1, 0, 1);
#else
		return float4(sky, 0);
#endif

	float3 wsNormal = DecodeWaterNormal(tuv, 0);

	// Preserve the stock SSR implementation and cost.
	float4 refl;
	if (usePrevHDRBuffer)
		refl = getSSR_getPrevFrameColor(NDC, wsNormal, 20);
	else
		refl = getSSR(NDC, wsNormal, 20);

	// Stock alpha reports a valid hit. Crossfade unreliable screen-edge hits to
	// sky without introducing a camera-centered near-field transition.
	float ssrConfidence =
		saturate(refl.w * 0.97) *
		reflectionScreenEdgeConfidence(uv);
	float3 reflectionColor = lerp(sky, max(refl.xyz, 0), ssrConfidence);

	float historyConfidence = reflectionHistoryConfidence(wsNormal);
	return float4(mixPrevFrame(reflectionColor, NDC, historyConfidence), 1);
}

float4 PS_REFLECTION_SKY(VS_REFLECTION_OUTPUT i, uniform bool useMixPrevFrame = true) : SV_TARGET0 {
	float2 uv = float2(i.projPos.x, -i.projPos.y)*0.5 + 0.5;
	float2 tuv = transformColorBufferUV(uv);		// coords in pixels

	float depth = LoadDepth(tuv + 0.5);
	float4 NDC = float4(i.projPos.xy, depth, 1);

	float3 refl = reflectionSky(NDC, tuv);

	if (!isWater(LoadStencil(tuv)))
		return float4(refl, 0);

	if (useMixPrevFrame) {
		float3 wsNormal = DecodeWaterNormal(tuv, 0);
		float historyConfidence = reflectionHistoryConfidence(wsNormal);
		return float4(mixPrevFrame(refl, NDC, historyConfidence), 1);
	}
	else
		return float4(refl, 1);
}

#undef COMMON_PART
#define COMMON_PART 		SetHullShader(NULL);			\
							SetDomainShader(NULL);			\
							SetGeometryShader(NULL);		\
							SetComputeShader(NULL);			\
							SetDepthStencilState(disableDepthBuffer, 0);									\
							SetBlendState(disableAlphaBlend, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);	\
							SetRasterizerState(cullNone);

technique10 Reflection {
	pass P0	{
		SetVertexShader(CompileShader(vs_5_0, VS_REFLECTION()));
		SetPixelShader(CompileShader(ps_5_0, PS_REFLECTION_SKY()));
		COMMON_PART
	}
	pass P1	{
		SetVertexShader(CompileShader(vs_5_0, VS_REFLECTION()));
		SetPixelShader(CompileShader(ps_5_0, PS_REFLECTION_WATER()));
		COMMON_PART
	}
	pass P2 {
		SetVertexShader(CompileShader(vs_5_0, VS_REFLECTION()));
		SetPixelShader(CompileShader(ps_5_0, PS_REFLECTION_WATER(true)));
		COMMON_PART
	}
	pass P3	{
		SetVertexShader(CompileShader(vs_5_0, VS_REFLECTION()));
		SetPixelShader(CompileShader(ps_5_0, PS_REFLECTION_SKY(false)));
		COMMON_PART
	}
}
