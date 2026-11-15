#ifndef WATERCOMPOSE_HLSL
#define WATERCOMPOSE_HLSL

#define COMPOSING
#include "enlight/waterCommon.hlsl"
#include "common/lighting.hlsl"

#define USE_DISTORSION 1

#ifndef WATER_SATURATION
#define WATER_SATURATION 0.90
#endif

#ifndef WATER_CLOUD_SHADOW_SATURATION
#define WATER_CLOUD_SHADOW_SATURATION 0.55
#endif

#ifndef WATER_CLOUD_SHADOW_START
#define WATER_CLOUD_SHADOW_START 0.15
#endif

#ifndef WATER_CLOUD_SHADOW_FULL
#define WATER_CLOUD_SHADOW_FULL 0.92
#endif

// Suppress unstable seabed transmission when the coast is viewed nearly
// parallel to the water plane. The geometric angle is independent of wave LOD.
#ifndef WATER_BOTTOM_GRAZING_FADE_START
#define WATER_BOTTOM_GRAZING_FADE_START 0.025
#endif

#ifndef WATER_BOTTOM_GRAZING_FADE_FULL
#define WATER_BOTTOM_GRAZING_FADE_FULL 0.120
#endif

// Use the complete engine cloud response in waterShading and apply one final
// desaturation pass from the local cloud shadow.
#ifndef WATER_RECEIVE_CASCADE_SHADOWS
#define WATER_RECEIVE_CASCADE_SHADOWS 0
#endif

float3 applyWaterSaturation(float3 color, float saturation) {
	float luminance = dot(color, float3(0.2126, 0.7152, 0.0722));
	return lerp(luminance.xxx, color, max(saturation, 0.0));
}

float4 getRefractionColor(float2 uv) {
	return g_RefractionTexture.SampleLevel(ClampLinearSampler, float3(uv, 0), 0);
}

float4 calcRefractionColor(float3 normal, float3 pos, float2 uv) {
	float4 disturbance_eyespace = mul(float4(normal.x, 0, normal.z, 0), gView);
	float2 refraction_disturbance = float2(-disturbance_eyespace.x, disturbance_eyespace.y) * 0.05 / sqrt(g_Scale.x);

	float dist = distance(pos, gCameraPos);
	refraction_disturbance /= dist * 0.02;

	float2 duv = saturate(uv.xy + refraction_disturbance);
	float4 refraction_color = getRefractionColor(duv);

	float bottomNoL = g_RefractionTexture.SampleLevel(ClampLinearSampler, float3(duv, 1), 0).x;

	return float4(refraction_color.xyz, bottomNoL);
}

float4 getReflection(float2 uv) {
	return g_ReflectionTexture.SampleLevel(SamplerLinearClamp, uv, 0);
}

static int2 toffs[4] = { int2(0,-1), int2(0,1), int2(-1,0), int2(1,0) };

float4 getReflectionDistorsionColor(float2 uv, float3 normal, float distance) {
	float4 r = getReflection(uv);
#if USE_DISTORSION
	[unroll]
	for (uint i = 0; i < 4; ++i) {
	#if defined(COMPILER_ED_FXC)
		float4 r1;
		switch (i)
		{
			case 0:
				r1 = g_ReflectionTexture.SampleLevel(SamplerLinearClamp, uv, 0, toffs[0]);
			case 1:
				r1 = g_ReflectionTexture.SampleLevel(SamplerLinearClamp, uv, 0, toffs[1]);
			case 2:
				r1 = g_ReflectionTexture.SampleLevel(SamplerLinearClamp, uv, 0, toffs[2]);
			case 3:
				r1 = g_ReflectionTexture.SampleLevel(SamplerLinearClamp, uv, 0, toffs[3]);
		}
	#else
		float4 r1 = g_ReflectionTexture.SampleLevel(SamplerLinearClamp, uv, 0, toffs[i]);
	#endif
		r = lerp(r, r1, step(r.w, r1.w));
	}

	float f = (0.001 + distance * 0.001) * 0.5;
	float2 d = normalize(float2(normal.xz)) * r.w * f;

	float4 rcolor = float4(r.xyz * r.w, r.w);
	[unroll]
	for (i = 1; i < 4; ++i) {
		float2 dd = d * i;
		r = getReflection(uv + dd);
		float4 r1 = getReflection(uv - dd);
		r = lerp(r, r1, step(r.w, r1.w));
		r1 = getReflection(uv + dd.yx);
		r = lerp(r, r1, step(r.w, r1.w));
		r1 = getReflection(uv - dd.yx);
		r = lerp(r, r1, step(r.w, r1.w));
		rcolor += float4(r.xyz * r.w, r.w);
	}

	return rcolor.w == 0 ? r : rcolor / rcolor.w;
#else
	return r;
#endif
}

float3 waterCompose(uint2 uvPix, float2 uvTex, float3 pos, float3 normal, float shadow, float wLevel, float foam, float deepFactor, float riverLerp) {

	float3 toCamera = gCameraPos - pos;
	float distance = max(length(toCamera), 1e-6);
	float3 viewDir = toCamera / distance;
	float bottomViewVisibility = smoothstep(
		WATER_BOTTOM_GRAZING_FADE_START,
		WATER_BOTTOM_GRAZING_FADE_FULL,
		abs(viewDir.y));
	float visibleDeepFactor = deepFactor * bottomViewVisibility;

	float3 sunLight = getSunLight(pos);

	float3 deepColor = getDeepColor(riverLerp);
	float3 color = deepColor * sunLight;
	if (visibleDeepFactor > 0) {
		float4 rc = calcRefractionColor(normal, pos, uvTex);
		float bottomNoL = rc.w;
		float3 baseColor = GammaToLinearSpace(rc.xyz);
		float3 refraction = baseShading(pos, baseColor, sunLight, bottomNoL);
		refraction += CalculateDynamicLightingTiled(uvPix, baseColor, 0, 1, float3(0, 1, 0), viewDir, pos, 0, float2(1, 0), 0, LL_SOLID, false);
		color = lerp(color, refraction, visibleDeepFactor);
	}

	float4 underwaterTransparent = g_RefractionTexture.SampleLevel(ClampLinearSampler, float3(uvTex, 2), 0);
	color = lerp(color, underwaterTransparent.xyz, underwaterTransparent.a);

	float4 reflection_color = getReflectionDistorsionColor(uvTex, normal, 1.0);
	float3 scatterColor = GammaToLinearSpace(lerp(g_ScatterColor, g_RiverScatterColor, riverLerp)) * g_ScatterIntensity;

#if WATER_RECEIVE_CASCADE_SHADOWS
	float surfaceShadow = shadow;
#else
	float surfaceShadow = 1.0;
#endif
	float3 result = waterShading(
		pos,
		float4(viewDir, distance),
		normal,
		color,
		reflection_color.xyz,
		surfaceShadow,
		foam,
		sunLight,
		riverLerp);

	result += CalculateDynamicLightingTiled(uvPix, deepColor + scatterColor * 0.5, float3(0.25,0.25,0.25), 0.2, normal, viewDir, pos, 0, float2(1, g_SpecularIntensity), 0, LL_SOLID, true);

	float2 cloudShadowAO = saturate(SampleShadowClouds(pos));
	float cloudOcclusion = 1.0 - cloudShadowAO.x;
	float cloudCoverage = smoothstep(
		WATER_CLOUD_SHADOW_START,
		WATER_CLOUD_SHADOW_FULL,
		cloudOcclusion);
	float finalSaturation = lerp(
		WATER_SATURATION,
		WATER_CLOUD_SHADOW_SATURATION,
		cloudCoverage);
	return applyWaterSaturation(result, finalSaturation);
}

float3 underwaterCompose(uint2 uvPix, float2 uvTex, float3 pos, float3 normal, float3 baseColor, float shadow, float aboveSurfaceNoL) {
	float waterDeep = g_Level - (pos.y + gOrigin.y);
	float deepFactor = calcWaterDeepFactor(waterDeep, 0);

	float NoL = max(0, dot(normal, gSunDir));
	NoL = lerp(0, NoL, deepFactor);

	shadow = lerp(1, shadow, calcWaterDeepFactor(waterDeep * 0.2, 0));
	NoL = min(NoL, shadow);
	NoL = min(NoL, aboveSurfaceNoL);

	float3 sunLight = getSunLight(float3(0, g_Level - gOrigin.y, 0));
	float3 color = GammaToLinearSpace(baseColor);
	color = baseShading(pos, color, sunLight, NoL);

	float dist = distance(pos, gCameraPos);
	float distFactor = calcWaterDeepFactor(dist, 0);
	color = lerp(getDeepColor(0) * sunLight, color, distFactor);

	float4 underwaterTransparent = g_RefractionTexture.SampleLevel(ClampLinearSampler, float3(uvTex, 2), 0);
	color = lerp(color, underwaterTransparent.xyz, underwaterTransparent.w);

	return color;
}

#endif
