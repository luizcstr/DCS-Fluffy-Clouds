#include "common/TextureSamplers.hlsl"
#include "common/States11.hlsl"
#include "common/samplers11.hlsl"
#include "common/context.hlsl"
#include "common/ambientCube.hlsl"
#include "common/haloSampling.hlsl"
#include "deferred/atmosphere.hlsl"

Texture2D DiffTex;
// NOTE: Some installs only bind a single cirrus texture. Keep the declaration but don't rely on it.
Texture2D DiffTex2;

float4 params;
#define time    gModelTime
#define phase   params.y
#define origin  gOrigin

//-------------------------------------------------------------------------------
// Geometry & placement 
//-------------------------------------------------------------------------------
static const float cirrusAltitude         = 12192.0;
static const float quadSize               = 550000.0;
static const float fadeInv                = 1.0 / 50.0;
static const float earthRadiusBottom      = gEarthRadius * 0.25;
static const float earthRadiusTop         = gEarthRadius;
static const float rangeInv               = 2.0 / quadSize;
static const float rangeTopInv            = 2.0 / 450000.0;
static const float tile                   = 10.0;
static const float windSpeed              = 100.0;
// User adjustable wind direction in degrees (0=North, 90=East, 180=South, 270=West)
static const float windDirectionDeg       = 0.0; // RANGE 0 - 359

//-------------------------------------------------------------------------------
// Scattering & cloud appearance
//-------------------------------------------------------------------------------
static const float BASE_CIRRUS_THICKNESS = 0.8; 
static const float MIN_CIRRUS_THICKNESS  = 0.6; // The minimum thickness at high altitude
static const float cirrusThicknessMax    = 40.0;
static const float extinction            = 0.5;
// Use a single constant albedo for cirrus
static const float CIRRUS_ALBEDO         = 0.6;
static const float shadowExtinctionMult  = 8.0;
static const float shadowRadius          = 300000.0;
static const float multipleScatCoef      = 0.5;
static const float opacityClamp          = 0.001;
// fading cycle time constants (in seconds)
static const float cycleDuration    = 1440.0; // full cycle length (24 min)
static const float fadeInStart      = 480.0;  // time when cross-fade to 2nd texture begins
static const float fadeInEnd        = 720.0;  // time when cross-fade to 2nd texture ends
static const float fadeOutStart     = 1200.0; // time when cross-fade back to 1st texture begins
static const float fadeOutEnd       = 1440.0; // time when cross-fade back to 1st texture ends

static const float maxCirrusDistance     = 100000.0;
static const float cirrusFadeStart       = 40000.0;
// User adjustable overall opacity multiplier (injected/edited by app)
static const float cirrusOpacityUser     = 0.800; // RANGE 0.0 - 1.0
// User adjustable patchmask animation intensity (scaled by app)
static const float windShearIntensity    = 1.0; // RANGE ~0.0 - 3.0																				
// Additional opacity boost when camera is above cirrus altitude
// Max extra alpha +40% over a 2km altitude range above the cirrus layer
static const float cirrusAboveBoostMax   = 0.60;
static const float cirrusAboveBoostRange = 2000.0; // meters

// --- Anti-banding and close-up quality controls ---
// Strength of UV jitter as a fraction of the pixel footprint in UV space
static const float CIRRUS_DITHER_UV      = 0.2;   // 0..1
// Blend factor between base and jittered samples (more blending = softer grain)
static const float CIRRUS_DITHER_BLEND   = 0.4;   // 0..1
// Overall mip bias scale (smaller values preserve more detail up close)
static const float CIRRUS_LOD_BIAS_SCALE = 6.0;    // was 10.0

//------------------------------------------------------------------------------
// Input/Output structs
//------------------------------------------------------------------------------
struct VS_INPUT
{
    float2 vPos : POSITION0;
    float2 vTex : TEXCOORD0;
};

struct VS_OUTPUT
{
    float4 oPos         : SV_POSITION;
    float3 oT0          : TEXCOORD0;
    float4 params       : TEXCOORD1;
    float3 inscatter    : TEXCOORD2;
    float3 sunColor     : TEXCOORD3;
    float3 transmittance : TEXCOORD4;
    float3 posWS        : POSITION1;
    float3 normal       : TEXCOORD5;
};

#define mieG 0.7
#define M_PI 3.14159265

//------------------------------------------------------------------------------
// Phase functions
//------------------------------------------------------------------------------

float phaseFunctionM(float mu)
{
	return 1.5 * 1.0 / (4.0 * M_PI) * (1.0 - mieG*mieG) * pow( abs(1.0 + (mieG*mieG) - 2.0*mieG*mu ), -3.0/2.0) * (1.0 + mu * mu) / (2.0 + mieG*mieG);
}

float cosine01(float t) { return 0.5 - 0.5 * cos(saturate(t) * M_PI); }

float numericalMieFit(float costh)
{
    float bestParams[10];
    bestParams[0]=9.805233e-06;
    bestParams[1]=-6.500000e+01;
    bestParams[2]=-5.500000e+01;
    bestParams[3]=8.194068e-01;
    bestParams[4]=1.388198e-01;
    bestParams[5]=-8.370334e+01;
    bestParams[6]=7.810083e+00;
    bestParams[7]=2.054747e-03;
    bestParams[8]=2.600563e-02;
    bestParams[9]=-4.552125e-12;

    float p1 = costh + bestParams[3];
    float4 expValues = exp(float4(bestParams[1] *costh+bestParams[2], bestParams[5] *p1*p1, bestParams[6] *costh, bestParams[9] *costh));
    float4 expValWeight= float4(bestParams[0], bestParams[4], bestParams[7], bestParams[8]);
    float x = 1.0 - saturate((1.0 - costh) / 0.04);
    return dot(expValues, expValWeight) * 0.25 + 2.7 * ((x*x)*(x*x));
}

//------------------------------------------------------------------------------
// Geometric & atmosphere helpers
//------------------------------------------------------------------------------
float distanceToCirrus(float r, float mu)
{
    const float rg = gEarthRadius;
    float rc = cirrusAltitude*0.001 + rg;
    float discriminant = r * r * (mu * mu - 1.0) + rc * rc;
    float dist;
    if(rc>r)
        dist = ClampDistance(-r * mu + SafeSqrt(discriminant));
    else
        dist = ClampDistance(-r * mu - SafeSqrt(discriminant));
    return max(dist, 0.001);
}

float3 getRealCirrusPos(float3 camera, float3 pos)
{
    float3 cpos = (pos - camera) * 0.001;
    float d = length(cpos);
    float3 view = cpos / d;
    float mu = view.y;
    float r = length(camera);
    return camera + view * distanceToCirrus(r, view.y);
}

float3 calculateAtmosphereForCirrus(float3 cameraPos, float3 pos, out float3 transmittance)
{
    return GetSkyRadianceToPoint(cameraPos, pos, 0.0, gSunDir, transmittance) * gAtmIntensity;
}

// Simple hash to generate a stable per-pixel random from screen position
float rand2D(float2 p)
{
    return frac(sin(dot(p, float2(12.9898,78.233))) * 43758.5453);
}

//------------------------------------------------------------------------------
// Vertex Shader 
//------------------------------------------------------------------------------
VS_OUTPUT VertOut(VS_INPUT i)
{
	i.vPos.xy *= quadSize;

	float ex = i.vPos.x * 0.001;
	float ez = i.vPos.y * 0.001;

	float cameraAltitude = gCameraAltitude;
	float cameraAboveCirrus = step(cirrusAltitude, cameraAltitude);

	float r0 = earthRadiusBottom + cirrusAltitude * 0.001;
	float r1 = earthRadiusTop + cirrusAltitude * 0.001;
	
	float ey0 = sqrt(r0 * r0 - ex * ex - ez * ez) - earthRadiusBottom;
	float ey1 = sqrt(r1 * r1 - ex * ex - ez * ez) - earthRadiusTop;

	float3 tw;
	tw.xz = i.vPos.xy;
	tw.y = lerp(ey0, ey1, cameraAboveCirrus) * 1000.0 - origin.y;

	VS_OUTPUT o;
	o.posWS = tw.xyz + float3(gCameraPos.x, 0, gCameraPos.z);
	o.oPos = mul(float4(o.posWS, 1), gViewProj);

	// Calculate wind direction vector from degrees (0=North, 90=East, etc.)
	// Wind direction indicates where wind comes FROM, clouds drift in opposite direction
	// UV mapping: UV.x maps to world Z (North-South), UV.y maps to world X (East-West)
	float windDirRad = windDirectionDeg * (M_PI / 180.0);
	// For North wind (0�): clouds drift South, need positive UV.x offset
	// For East wind (90�): clouds drift West, need negative UV.y offset
	float2 windDir = float2(cos(windDirRad), -sin(windDirRad));
	float2 windOffset = windDir * time * windSpeed;
	
	o.oT0.xy = (i.vTex.xy + (origin.xz / quadSize) + (gCameraPos.xz + windOffset) / quadSize) * tile;

	float nDist = length(tw.xz) * lerp(rangeInv, rangeTopInv, cameraAboveCirrus);
	o.oT0.z = nDist;
	float fadeFactor = min(abs(cirrusAltitude - cameraAltitude) * fadeInv, 1);

	// Set cloud density and visibility to constant values for full opacity
	o.params.xy = float2(1.0, 1.0);

	float cycleT = fmod(time, cycleDuration);
	o.params.z = smoothstep(fadeInStart, fadeInEnd, cycleT) - smoothstep(fadeOutStart, fadeOutEnd, cycleT);

	float3 view = normalize(tw.xyz - float3(0, gCameraPos.y, 0));//camera is in {0,0,0}
	o.params.w = phaseFunctionM(dot(gSunDir, view));

	float3 pos = OriginSpaceToAtmosphereSpace(o.posWS);
	// Prevent sampling atmosphere from point lower than atmosphere.bottom_radius == gEarthRadius
	float3 cameraPos = float3(gEarthCenter.x, max(0.0f, gEarthCenter.y - gEarthRadius) + gEarthRadius, gEarthCenter.z);
	float3 realPos = getRealCirrusPos(cameraPos, pos);
	o.inscatter = calculateAtmosphereForCirrus(cameraPos, realPos, o.transmittance);
	o.normal = normalize(realPos);
	float NoL = dot(gSunDir, o.normal);
	NoL = smoothstep(-0.123, 0.0213, NoL);

	o.params.w = fadeFactor*fadeFactor;
	o.sunColor = GetSunRadiance(realPos, gSunDir) * gSunIntensity;
	o.sunColor *= 0.6 + 0.4*NoL*NoL;//self-shadow hack at sunset/sunrise
	return o;
}

float remap(float v, float s, float e) 
{
	return (v - s) / (e - s);
}

float3 getScatteringCoef(float3 T, float dist){
	return log(float3(1.0,1.0,1.0) / T) / dist;
}

//------------------------------------------------------------------------------
// SampleCirrus – cross-fades between DiffTex and DiffTex2
//------------------------------------------------------------------------------
float4 SampleCirrus(float2 uv, float2 opacity, float ratio, float bias)
{
    float4 r  = DiffTex.SampleBias(WrapLinearSampler,  uv, bias) * float4(1, 1, 1, opacity.x);
    float4 r1 = DiffTex2.SampleBias(WrapLinearSampler, uv, bias) * float4(1, 1, 1, opacity.y);
    return lerp(r, r1, ratio);
}

//------------------------------------------------------------------------------
// Shadows
//------------------------------------------------------------------------------
float GetShadowTransmittance(float extinction, float2 uv, float2 lightDir, float2 opacity, float ratio, float bias, float distToEye)
{
    if(distToEye < shadowRadius)
    {
        float distNorm = distToEye / shadowRadius;
        float localShadowPower = saturate(1 - distNorm*distNorm*distNorm);

        const float step0 = 0.02;
        const uint count = 1;
        const float stepFactor = 2;

        float d = 0.0;
        for (uint i = 0; i < count; ++i)
        {
            float stepMultiplier = pow(1.8, i); // Steps get exponentially larger
			float s = step0 * stepMultiplier;
			uv += lightDir * s;
            float density = SampleCirrus(uv, opacity, ratio, bias + i).a;
            density = max(0, density - i*0.01);
            d += density * s;
        }

        return 1 - localShadowPower + localShadowPower * exp( -extinction * max(0, d));
    }
    return 1;
}

//------------------------------------------------------------------------------
// -------- PatchMask noise helpers (FBM blobs) --------
//------------------------------------------------------------------------------
float hash11(float2 p) {
    return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453123);
}

float noise2D(float2 p) {
    float2 i = floor(p);
    float2 f = frac(p);
    float2 u = f*f*f*(f*(f*6.0 - 15.0) + 10.0);
    float a = hash11(i);
    float b = hash11(i + float2(1, 0));
    float c = hash11(i + float2(0, 1));
    float d = hash11(i + float2(1, 1));
    return lerp(lerp(a, b, u.x), lerp(c, d, u.x), u.y);
}

float fbm3(float2 p) {
    float a = 0.0;
    float amp = 0.5;
    float2 pp = p;
    [unroll] for (int k=0; k<3; ++k) {
        a += amp * noise2D(pp);
        pp = pp * 2.03 + 11.7;
        amp *= 0.5;
    }
    return a;
}

//------------------------------------------------------------------------------
// Pixel Shader
//------------------------------------------------------------------------------
float4 psCirrus(VS_OUTPUT i, uniform bool FLIR_mode, uniform bool HALO_mode): SV_TARGET0
{
    // Define the altitude range for the thinning effect. Feel free to tweak these!
    const float MIN_THICKNESS_ALTITUDE = cirrusAltitude / 2;
    const float MAX_THICKNESS_ALTITUDE = cirrusAltitude;

    // Calculate a multiplier from 1.0 (low altitude) to 0.0 (high altitude)
    float thicknessFactor = smoothstep(MIN_THICKNESS_ALTITUDE, MAX_THICKNESS_ALTITUDE, gCameraAltitude);
    float cirrusThickness = lerp(BASE_CIRRUS_THICKNESS, MIN_CIRRUS_THICKNESS, thicknessFactor);

    // Use a fixed albedo (remove altitude-dependent albedo logic)
    float albedo = CIRRUS_ALBEDO;
        
    float psDistSq = i.oT0.z*i.oT0.z;
    float2 psVis = i.params.xy;
    float psLerpFactor = i.params.z;
    float psFadeFactor = i.params.w;

    if (!FLIR_mode)
        clip(0.99 - psDistSq);

    float distToEye = length(i.posWS.xyz - gCameraPos.xyz);
	if (!FLIR_mode)
		clip(maxCirrusDistance - distToEye);
	float distanceFade = 1.0 - saturate((distToEye - cirrusFadeStart) / (maxCirrusDistance - cirrusFadeStart));
    float3 viewDir = normalize(i.posWS.xyz - gCameraPos.xyz);

    // Reduce the heavy LOD bias to keep more detail up close
    float lodBias = psDistSq * CIRRUS_LOD_BIAS_SCALE;

    // Estimate pixel footprint in UV space for jitter size
    float footprint = max(length(ddx(i.oT0.xy)), length(ddy(i.oT0.xy))) + 1e-5;
    float rnd = rand2D(i.oPos.xy);
    float ang = 6.2831853 * rnd;
    float2 jitterUV = float2(cos(ang), sin(ang)) * footprint * CIRRUS_DITHER_UV;

    // Two-tap stochastic sampling to break banding/quantization
    float density0 = SampleCirrus(i.oT0.xy,         psVis, psLerpFactor, lodBias).a;
    float density1 = SampleCirrus(i.oT0.xy+jitterUV, psVis, psLerpFactor, lodBias).a;
    float density  = lerp(density0, (density0 + density1)*0.5, CIRRUS_DITHER_BLEND);
    density = max(0, density);

    float cosVN = abs(dot(viewDir, normalize(i.normal)));
    float thicknessScale = 1.0 / max(0.20, cosVN);
    float cirrusSlopeThickness = min(cirrusThickness * thicknessScale, cirrusThicknessMax);
    float shadowLength = min(cirrusThickness / abs(dot(gSunDir, normalize(i.normal))), cirrusThicknessMax);

    float opacity = 1 - exp(-extinction * density * cirrusSlopeThickness);
    float opacityHack = psFadeFactor * max(0, 1 - 2*psDistSq*(1-saturate(gSurfaceNdotL*8))); 

    // --- PatchMask (edge feather with coverage preservation) ----------------------
    // Controls
    static const float BLOB_SIZE_KM        = 40.0;  // big blobs
    static const float SMALL_BLOB_SIZE_KM  = 6.0;   // small blobs
    static const float BLOB_FILL           = 0.1800;
    static const float BLOB_SOFTNESS       = 0.45;  // baseline softness (wider = softer holes)
    static const float BLOB_JITTER         = 0.95;
    static const float WARP_STRENGTH       = 0.35;  // domain-warp intensity (0 = off, ~0.3-0.5 = organic)
    static const float WARP_SHEAR_ANGLE    = 0.14;  // cross-wind shear for detail layer (~8 deg)
    #define  BLOB_FIELDS                   4

    // Primary wind drift
    float2 windOffset = float2(time * 0.005, time * 0.002) * windShearIntensity;

    // Safe scale setup
    float UV_PER_METER  = tile / max(quadSize, 1e-5);
    float blobPeriodUV  = max(BLOB_SIZE_KM       * 1000.0 * UV_PER_METER, 1e-5);
    float smallPeriodUV = max(SMALL_BLOB_SIZE_KM * 1000.0 * UV_PER_METER, 1e-5);

    // Domain warp: slow secondary noise distorts UVs for organic deformation
    float2 warpUV = i.oT0.xy / blobPeriodUV * 0.37 + windOffset * 0.3;
    float2 domainWarp = float2(
        noise2D(warpUV + 5.3) - 0.5,
        noise2D(warpUV + float2(9.1, 3.7)) - 0.5
    ) * WARP_STRENGTH;

    // Base UVs with domain warp applied
    float2 patchUV = i.oT0.xy / blobPeriodUV + windOffset + domainWarp;

    // Detail layer: differential wind shear (slight angular offset + faster drift)
    float2 detailWind = windOffset * 2.5
        + float2(-windOffset.y, windOffset.x) * WARP_SHEAR_ANGLE;
    float2 patchUV_small = i.oT0.xy / smallPeriodUV + detailWind + domainWarp * 0.5;
    // Base + detail (small blob size controlled explicitly above)
    float baseN   = fbm3(patchUV);
    float detailN = fbm3(patchUV_small + 17.0);

    // Blend amount keeps your look; only changes *influence*, not size
    float n = lerp(baseN, baseN * 0.6 + 0.4 * detailN, BLOB_JITTER);

    // Optional extra intersected fields — smooth-min preserves soft gradients at hole edges
    static const float SMIN_K = 0.18;  // smooth-min radius (larger = softer intersections)
    #if BLOB_FIELDS > 1
    {
        float n1 = fbm3(patchUV + 37.21);
        float h  = saturate(0.5 + 0.5 * (n1 - n) / SMIN_K);
        n = lerp(n1, n, h) - SMIN_K * h * (1.0 - h);
    }
    #endif
    #if BLOB_FIELDS > 2
    {
        float n2 = fbm3(patchUV * float2(1.03, 0.97) + 11.7);
        float h  = saturate(0.5 + 0.5 * (n2 - n) / SMIN_K);
        n = lerp(n2, n, h) - SMIN_K * h * (1.0 - h);
    }
    #endif

    // Balance fbm distribution — gentle contrast keeps holes soft
    float nBalanced = saturate((n - 0.5) * 0.85 + 0.5);

    // --- Edge feathering ---
    static const float BLOB_EDGE_FEATHER = 0.25;
    static const float BLOB_AA_FEATHER   = 1.5;

    // Keep the 50% threshold stable relative to your baseline softness
    static const float REF_SOFTNESS = BLOB_SOFTNESS;

    float wRaw = BLOB_SOFTNESS + BLOB_EDGE_FEATHER;
    float aa   = fwidth(nBalanced) * BLOB_AA_FEATHER;  // screenspace AA widen
    float w    = saturate(max(wRaw, aa));
    w          = min(w, 0.5);                          // avoid absurdly huge bands

    float tMid_ref = BLOB_FILL + 0.5 * REF_SOFTNESS;   // reference midpoint
    float t        = clamp(tMid_ref - 0.5 * w, 0.0, 1.0 - w);

    float patchMask = smoothstep(t, t + w, nBalanced);

    // Integrate mask BEFORE clip so edges feather instead of being hard-clipped
    opacity *= patchMask;

    if (!FLIR_mode)
        clip(opacity - opacityClamp);

    float edgesDecay = smoothstep(opacityClamp, opacityClamp*2, opacity);

    float miePhase = numericalMieFit(dot(gSunDir, viewDir));
    float posToLightTransmittance =
        GetShadowTransmittance(extinction * shadowExtinctionMult * shadowLength,
                               i.oT0.xy, gSunDir.xz, psVis, psLerpFactor, lodBias, distToEye);
    float3 ambientLight = GetSkyIrradiance(OriginSpaceToAtmosphereSpace(i.posWS), gSunDir)
                          * (gSunIntensity * gIBLIntensity);
    float4 color;
    color.rgb = i.sunColor * ((albedo/3.1415) * (multipleScatCoef + miePhase) * posToLightTransmittance) + (albedo/3.1415) * ambientLight;
    // Multiply alpha by user adjustable cirrusOpacityUser
    color.a = opacity * opacityHack * edgesDecay * distanceFade * cirrusOpacityUser;

    // --- Extra opacity when camera is above the cirrus layer ---
    float above = step(cirrusAltitude, gCameraAltitude);
    float boostT = saturate((gCameraAltitude - cirrusAltitude) / max(cirrusAboveBoostRange, 1e-3));
    float opacityBoost = 1.0 + above * (cirrusAboveBoostMax * boostT);
    color.a = saturate(color.a * opacityBoost);

    if ((HALO_mode && !FLIR_mode) && gIceHaloParams.cirrusCloudsFactor > 0)
    {
        float3 iceHalo = sampleHalo(gBilinearClampSampler, viewDir, gSunDir);
        color.rgb += i.sunColor * iceHalo * (posToLightTransmittance * gIceHaloParams.cirrusCloudsFactor);
    }

    color.rgb *= i.transmittance;
    color.rgb += i.inscatter;

    // FLIR tidying
    if (FLIR_mode)
    {
        color.rgb *= gFLIR_CloudsIntesity;
        color = lerp(color, 1.0, gFLIR_SkyIntesity);
    }

    return color;
}



RasterizerState cirrusRS
{
    CullMode = None;
    FillMode = Solid;
    MultisampleEnable = false;
    DepthClipEnable = false;
};

VertexShader vsComp = CompileShader(vs_4_0, VertOut());

technique10 T0
{
    pass MAIN
    {
        SetVertexShader(vsComp);
        SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, psCirrus(false, false)));
        SetBlendState(enableAlphaBlend, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
        SetDepthStencilState(enableDepthBufferNoWrite, 0);
        SetRasterizerState(cirrusRS);
    }
    pass FLIR
    {
        SetVertexShader(vsComp);
        SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, psCirrus(true, false)));
        SetBlendState(enableAlphaBlend, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
        SetDepthStencilState(enableDepthBufferNoWrite, 0);
        SetRasterizerState(cirrusRS);
    }
    pass MAIN_wHalo
    {
        SetVertexShader(vsComp);
        SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, psCirrus(false, true)));
        SetBlendState(enableAlphaBlend, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
        SetDepthStencilState(enableDepthBufferNoWrite, 0);
        SetRasterizerState(cirrusRS);
    }
    pass FLIR_wHalo
    {
        SetVertexShader(vsComp);
        SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, psCirrus(true, true)));
        SetBlendState(enableAlphaBlend, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
        SetDepthStencilState(enableDepthBufferNoWrite, 0);
        SetRasterizerState(cirrusRS);
    }
}
