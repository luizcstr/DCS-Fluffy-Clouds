// Cirrus detail layer (C2_Forte): high-frequency density modulation, softer distance mip bias, slightly higher extinction.
// Based on the installed 'refinement 02' cirrus.fx. Experimental: validate in DCS (compile + visuals + FPS).
// Cirrus shader refinement 02 - pattern variation for Weather_v0.3 - Test.
// Per-event orientation/offset, smooth UV warp, and per-cycle permutations.
// Uses the existing two five-slice DDS arrays; no additional assets required.
// Experimental: requires compilation and visual/performance validation in DCS.
// Shared coverage in self-shadowing; distance mip bias 6 -> 4.5; altitude input fix.
// Original DDS arrays, presets, lighting constants and visible coverage preserved.
#include "common/TextureSamplers.hlsl"
#include "common/States11.hlsl"
#include "common/samplers11.hlsl"
#include "common/context.hlsl"
#include "common/ambientCube.hlsl"
#include "common/haloSampling.hlsl"
#include "deferred/atmosphere.hlsl"

#define CIRRUS_DETAIL_SCALE    5.3
#define CIRRUS_DETAIL_STRENGTH 1.0
#define CIRRUS_DETAIL_MEAN     0.15
#define CIRRUS_LOD_DIST        2.5
#define CIRRUS_EXT_MULT        1.35

//------------------------------------------------------------------------------
// Texture arrays bound to t0 and t1
//------------------------------------------------------------------------------
Texture2DArray DiffTex   : register(t0);
Texture2DArray DiffTex2  : register(t1);

float4 params;
#define time    gModelTime
#define phase   params.y
#define origin  gOrigin

//-------------------------------------------------------------------------------
// Geometry & placement 
//-------------------------------------------------------------------------------
static const float cirrusAltitude     = 12000.0;
static const float quadSize           = 550000.0;
static const float fadeInv            = 1.0 / 1000.0;
static const float earthRadiusBottom    = gEarthRadius * 0.25;
static const float earthRadiusTop       = gEarthRadius;
static const float rangeInv             = 2.0 / quadSize;
static const float rangeTopInv          = 2.0 / 450000.0;
static const float tile                 = 3.5;
static const float windSpeed            = 40.0; // gentler cirrus advection

//-------------------------------------------------------------------------------
// Scattering & cloud appearance
//-------------------------------------------------------------------------------
static const float cirrusThickness      = 1.0;
static const float cirrusThicknessMax   = 60.0;
static const float extinction           = 0.35 * 0.8 * CIRRUS_EXT_MULT;
static const float albedo               = 0.68; // modest increase in scattered light
static const float shadowExtinctionMult = 6.5;
static const float shadowRadius         = 300000.0;
static const float multipleScatCoef     = 0.6;
static const float opacityClamp         = 0.001;
static const float altitudeBlurIntensity = 0.0;


//------------------------------------------------------------------------------
// Texture array and slice timing
//------------------------------------------------------------------------------
static const int LAYERS_PER_ARRAY = 5;
static const int NUM_CLOUD_TEX    = 10;
static const float SLICE_HOLD_TIME    = 600.0;
static const float SLICE_FADE_TIME    = 120.0;
static const float SLICE_PERIOD       = SLICE_HOLD_TIME + SLICE_FADE_TIME;
static const float SLICE_CYCLE_TIME   = SLICE_PERIOD * NUM_CLOUD_TEX;

//-------------------------------------------------------------------------------
// ==== Per-mission shuffled slice order =======================
//-------------------------------------------------------------------------------
uint SliceOrderSeed()
{
    uint u = (uint)abs(phase * 131.0 + 0.5);
    u ^= u >> 16; u *= 0x7feb352du;
    u ^= u >> 15; u *= 0x846ca68bu;
    u ^= u >> 16;
    if (u == 0u) u = 0x85ebca6bu;

#ifdef SLICE_RANDOM_SEED_OVERRIDE
    u ^= (uint)(SLICE_RANDOM_SEED_OVERRIDE) * 0x27d4eb2du;
    if (u == 0u) u = 0x9e3779b9u;
#endif
    return u;
}

uint PickA(uint s) {
    const uint table[4] = {1u, 3u, 7u, 9u};
    uint idx = (s ^ (s >> 7) ^ (s >> 13)) & 3u;
    return table[idx];
}
uint PickB(uint s) {
    uint x = s * 1103515245u + 12345u;
    return ((x >> 27) % 10u);
}

// Stable integer mixing: cycle and event identity never depend on the camera.
uint CirrusHash(uint x)
{
    x ^= x >> 16; x *= 0x7feb352du;
    x ^= x >> 15; x *= 0x846ca68bu;
    x ^= x >> 16;
    return x;
}

int PermuteSlice(uint eventIndex)
{
    uint cycleIndex = eventIndex / 10u;
    uint localIndex = eventIndex % 10u;
    uint seed = CirrusHash(SliceOrderSeed() ^ CirrusHash(cycleIndex + 1u));
    return int((PickA(seed) * localIndex + PickB(seed)) % 10u);
}

// Each occurrence has its own orientation and offset, including repeated slices.
// Orthogonal transforms preserve the texture footprint and wrap compatibility.
float2 CirrusPatternUV(float2 uv, uint eventIndex)
{
    uint seed = CirrusHash(SliceOrderSeed() ^ CirrusHash(eventIndex + 0x9e3779b9u));
    float2 p = uv;
    if ((seed & 1u) != 0u) p.x = -p.x;
    uint rotation = (seed >> 1) & 3u;
    if (rotation == 1u) p = float2(-p.y, p.x);
    else if (rotation == 2u) p = -p;
    else if (rotation == 3u) p = float2(p.y, -p.x);

    uint offsetSeed = CirrusHash(seed ^ 0x68bc21ebu);
    float2 offset = float2(float(offsetSeed & 65535u), float(offsetSeed >> 16)) / 65536.0;
    p += offset;

    // Low-frequency domain warp driven by the continuous world UV (not the per-tile
    // coordinate): it varies slowly across many tiles, so each region of sky is
    // displaced differently and the grid repetition is broken without hard seams.
    // Two octaves give organic, non-aligned meandering.
    const float warpAmplitude = 0.20;
    float evolution = time * 0.0006;
    float2 wlo  = uv * 0.37;   // large regions
    float2 wmid = uv * 0.90;   // ~1 tile period: makes adjacent tiles differ
    float2 warp = float2(
        sin(wlo.y * 1.30 + wlo.x * 0.70 + evolution)        + 0.75 * sin(wmid.y * 1.10 - wmid.x * 0.90),
        sin(wlo.x * 1.10 - wlo.y * 1.30 - evolution * 0.83) + 0.75 * sin(wmid.x * 1.00 + wmid.y * 0.80));
    return p + warpAmplitude * warp;
}


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
    Area discriminant = r * r * (mu * mu - 1.0) + rc * rc;
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

//------------------------------------------------------------------------------
// Vertex Shader 
//------------------------------------------------------------------------------
VS_OUTPUT VertOut(VS_INPUT i)
{
    i.vPos.xy *= quadSize;
    float ex = i.vPos.x*0.001;
    float ez = i.vPos.y*0.001;

    float cameraAltitude = gCameraAltitude;
    float cameraAboveCirrus = step(cirrusAltitude, cameraAltitude);

    float r0 = earthRadiusBottom + cirrusAltitude*0.001;
    float r1 = earthRadiusTop + cirrusAltitude*0.001;
    float ey0 = sqrt(r0*r0 - ex*ex - ez*ez) - earthRadiusBottom;
    float ey1 = sqrt(r1*r1 - ex*ex - ez*ez) - earthRadiusTop;

    float3 tw;
    tw.xz = i.vPos.xy;
    tw.y = lerp(ey0, ey1, cameraAboveCirrus)*1000.0 - origin.y;

    VS_OUTPUT o;
    o.posWS = tw + float3(gCameraPos.x, 0, gCameraPos.z);
    o.oPos  = mul(float4(o.posWS,1), gViewProj);

    float windOffset = time * windSpeed;
    o.oT0.xy = (i.vTex + (origin.xz/quadSize) + (gCameraPos.xz+windOffset)/quadSize) * tile;
    float nDist = length(tw.xz)*lerp(rangeInv, rangeTopInv, cameraAboveCirrus);
    o.oT0.z = nDist;

    float fadeFactor = min(abs(cirrusAltitude - cameraAltitude)*fadeInv, 1);
    
    o.params.xy = float2(1.0, 1.0);

    float tVS = fmod(time, SLICE_CYCLE_TIME);
    o.params.z = saturate(min(tVS / SLICE_FADE_TIME, 1.0));
    o.params.w = fadeFactor * fadeFactor;

    float3 posAS = OriginSpaceToAtmosphereSpace(o.posWS);
    float3 camAS = float3(gEarthCenter.x,
                                max(0.0, gEarthCenter.y-gEarthRadius) + gEarthRadius,
                                gEarthCenter.z);
    float3 realPos = getRealCirrusPos(camAS, posAS);
    o.inscatter      = calculateAtmosphereForCirrus(camAS, realPos, o.transmittance);
    o.normal         = normalize(realPos);
    float NoL        = dot(gSunDir, o.normal);
    NoL              = smoothstep(-0.123, 0.0213, NoL);
    o.sunColor       = GetSunRadiance(realPos, gSunDir) * gSunIntensity;
    o.sunColor      *= 0.6 + 0.4*NoL*NoL;

    return o;
}

//------------------------------------------------------------------------------
// SampleCirrus: hold, fade-out current, fade-in next using a shuffled order
//------------------------------------------------------------------------------
// Conservative opacity shaping: preserve dense cores, feather faint edges.
float4 ShapeCirrusTexel(float4 texel)
{
    float a = saturate(texel.a);
    texel.a = a * lerp(0.82, 1.0, smoothstep(0.0, 0.35, a));
    return texel;
}

float4 SampleCirrus(float2 uv, float2 opacity, float ratio, float bias)
{
    // Absolute event indices keep the next/current UVs identical across boundaries.
    float eventTime = max(time, 0.0) / SLICE_PERIOD;
    uint eventIndex = (uint)floor(eventTime);
    float sliceT = (eventTime - floor(eventTime)) * SLICE_PERIOD;
    int slice0 = PermuteSlice(eventIndex);
    int nextI = PermuteSlice(eventIndex + 1u);
    float2 uvCurr = CirrusPatternUV(uv, eventIndex);
    float2 uvNext = CirrusPatternUV(uv, eventIndex + 1u);
    float4 texCurr = (slice0 < LAYERS_PER_ARRAY)
        ? DiffTex .SampleBias(WrapLinearSampler, float3(uvCurr, slice0), bias)
        : DiffTex2.SampleBias(WrapLinearSampler, float3(uvCurr, slice0 - LAYERS_PER_ARRAY), bias);
    float4 texNext = (nextI < LAYERS_PER_ARRAY)
        ? DiffTex .SampleBias(WrapLinearSampler, float3(uvNext, nextI), bias)
        : DiffTex2.SampleBias(WrapLinearSampler, float3(uvNext, nextI - LAYERS_PER_ARRAY), bias);
    texCurr = ShapeCirrusTexel(texCurr);
    texNext = ShapeCirrusTexel(texNext);
    float opCurr = (slice0 < LAYERS_PER_ARRAY) ? opacity.x : opacity.y;
    float opNext = (nextI  < LAYERS_PER_ARRAY) ? opacity.x : opacity.y;

    if (sliceT < SLICE_HOLD_TIME)
    {
        return texCurr * opCurr;
    }

    if (sliceT < SLICE_HOLD_TIME + SLICE_FADE_TIME)
    {
        float t = (sliceT - SLICE_HOLD_TIME) / SLICE_FADE_TIME;
        float fade = cosine01(t);
        float w0 = 1.0 - fade;
        float w1 = fade;
        return texCurr * (w0 * opCurr) + texNext * (w1 * opNext);
    }

    return texNext * opNext;
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

// Shared coverage mask for visible cirrus and self-shadow samples.
float CirrusPatchMask(float2 uv)
{
    // Ported from ATMOS-X: a domain-warped, multi-field smooth-min FBM mask carves
    // organic coverage patches, which hides the texture tiling far better than a
    // straight FBM mask does.
    static const float UV_PER_METER      = tile / quadSize;
    const float BLOB_SIZE_KM       = 40.0;
    const float SMALL_BLOB_SIZE_KM = 6.0;
    const float BLOB_FILL          = 0.235;
    const float BLOB_SOFTNESS      = 0.26;
    const float BLOB_JITTER        = 0.95;
    const float WARP_STRENGTH      = 0.35;
    const float SMIN_K             = 0.18;

    float2 windOffset   = float2(time * 0.005, time * 0.002);
    float blobPeriodUV  = max(BLOB_SIZE_KM       * 1000.0 * UV_PER_METER, 1e-5);
    float smallPeriodUV = max(SMALL_BLOB_SIZE_KM * 1000.0 * UV_PER_METER, 1e-5);

    // Slow secondary noise distorts the patch UVs for organic, non-aligned blobs.
    float2 warpUV = uv / blobPeriodUV * 0.37 + windOffset * 0.3;
    float2 domainWarp = float2(
        noise2D(warpUV + 5.3) - 0.5,
        noise2D(warpUV + float2(9.1, 3.7)) - 0.5) * WARP_STRENGTH;

    float2 patchUV       = uv / blobPeriodUV  + windOffset       + domainWarp;
    float2 patchUV_small = uv / smallPeriodUV + windOffset * 2.5 + domainWarp * 0.5;

    float baseN   = fbm3(patchUV);
    float detailN = fbm3(patchUV_small + 17.0);
    float n = lerp(baseN, baseN * 0.6 + 0.4 * detailN, BLOB_JITTER);

    {
        float n1 = fbm3(patchUV + 37.21);
        float h  = saturate(0.5 + 0.5 * (n1 - n) / SMIN_K);
        n = lerp(n1, n, h) - SMIN_K * h * (1.0 - h);
    }
    {
        float n2 = fbm3(patchUV * float2(1.03, 0.97) + 11.7);
        float h  = saturate(0.5 + 0.5 * (n2 - n) / SMIN_K);
        n = lerp(n2, n, h) - SMIN_K * h * (1.0 - h);
    }

    float nBalanced = saturate((n - 0.5) * 0.85 + 0.5);
    return smoothstep(BLOB_FILL, BLOB_FILL + BLOB_SOFTNESS, nBalanced);
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

        const float step0 = 0.01;
        const uint count = 2;

        float d = 0.0;
        for (uint i = 0; i < count; ++i)
        {
            float stepMultiplier = 1.0; // two equal steps, same total path length
			float s = step0 * stepMultiplier;
			uv += lightDir * s;
            float density = SampleCirrus(uv, opacity, ratio, bias + i).a;
            density = max(0, density) * CirrusPatchMask(uv);
            d += density * s;
        }

        return 1 - localShadowPower + localShadowPower * exp( -extinction * max(0, d));
    }
    return 1;
}

//------------------------------------------------------------------------------
// Pixel Shader
//------------------------------------------------------------------------------
float4 psCirrus(VS_OUTPUT i, uniform bool FLIR_mode, uniform bool HALO_mode): SV_TARGET0
{
    float psDist = i.oT0.z*i.oT0.z;
    float psDistSq = i.oT0.z*i.oT0.z;
    float2 psVis = i.params.xy;
    float psLerpFactor = i.params.z;
    float psFadeFactor = i.params.w;

    if (!FLIR_mode)
        clip(0.99 - psDistSq);

    float distToEye = length(i.posWS.xyz - gCameraPos.xyz);
    float3 viewDir = normalize(i.posWS.xyz - gCameraPos.xyz);

    const float maxBlurAltitude = 30000.0;
    const float maxAltitudeBlur = 8.0 * altitudeBlurIntensity;
    float altitudeBlurFactor = saturate(gCameraAltitude / maxBlurAltitude);
    // Retain positive mip bias for distant stability; avoid negative sharpening.
    float lodBias = psDistSq * CIRRUS_LOD_DIST + (altitudeBlurFactor * maxAltitudeBlur);

    float density = SampleCirrus(i.oT0.xy, psVis, psLerpFactor, lodBias).a;
    density = max(0, density);
    // Detail layer: second sample at higher frequency, normalised by the average texture alpha so mean density is preserved.
    float detailFade = saturate(1.0 - psDistSq * 1.2);
    float detailA = SampleCirrus(i.oT0.xy * CIRRUS_DETAIL_SCALE + float2(0.371, 0.613), psVis, psLerpFactor, lodBias + 1.0).a;
    float detailRatio = clamp(detailA / CIRRUS_DETAIL_MEAN, 0.25, 2.5);
    density *= lerp(1.0, detailRatio, CIRRUS_DETAIL_STRENGTH * detailFade);

    float cosVN = abs(dot(viewDir, normalize(i.normal)));
    float thicknessScale = 1.0 / max(0.20, cosVN);
    float cirrusSlopeThickness = min(cirrusThickness * thicknessScale, cirrusThicknessMax);
    float shadowLength = min(cirrusThickness / max(0.02, abs(dot(gSunDir, normalize(i.normal)))), cirrusThicknessMax);

    float opacity = 1 - exp(-extinction * density * cirrusSlopeThickness);
    float opacityHack = psFadeFactor * max(0, 1 - 2*psDistSq*(1-saturate(gSurfaceNdotL*8))); 
	
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
    //color.a = opacity * opacityHack * edgesDecay * patchMask;
	color.a = opacity * opacityHack * edgesDecay;
	
			  
    if ((HALO_mode && !FLIR_mode) && gIceHaloParams.cirrusCloudsFactor > 0)
    {
        float3 iceHalo = sampleHalo(gBilinearClampSampler, viewDir, gSunDir);
        color.rgb += i.sunColor * iceHalo * (posToLightTransmittance * gIceHaloParams.cirrusCloudsFactor);
    }

    color.rgb *= i.transmittance;
    color.rgb += i.inscatter;

    color.a *= CirrusPatchMask(i.oT0.xy);
    if (FLIR_mode)
    {
        color.rgb = lerp(0, color.rgb, gFLIR_CloudsIntesity);
        color = lerp(color, 1, gFLIR_SkyIntesity);
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
