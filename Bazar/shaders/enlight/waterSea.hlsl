#ifndef WATERSEA_HLSL
#define WATERSEA_HLSL

#include "enlight/waterCommon.hlsl"
#include "noise/noise2D.hlsl"

Texture2DArray g_WaveTexture;
Texture2D g_MaskTexture;

Texture2D foamTexture;

static const float3 LUM = { 0.2125f, 0.7154f, 0.0721f };
static const float  HALF= 127.0 / 255.0;

// -----------------------------------------------------------------------------
// CUSTOM WATER TUNING
// Increase WATER_DETAIL_WAVELENGTH_SCALE for longer normal-map wavelengths.
// Detail-normal strength is constant across sea states.
// Whitecaps use the TEST 7 model: curvature-of-displacement x crest height from
// water_fft.fx, composited with a camera-distance-invariant foam texture.
#ifndef WATER_DETAIL_WAVELENGTH_SCALE
#define WATER_DETAIL_WAVELENGTH_SCALE 1.25
#endif

#ifndef WATER_DETAIL_NORMAL_STRENGTH
#define WATER_DETAIL_NORMAL_STRENGTH 0.85
#endif

#ifndef WATER_STABLE_FFT_SAMPLING
// Stock sampling is tied to g_TexOffset. When the engine recenters/wraps that
// offset, stochastic cells and non-stock wavelength scales can visibly jump.
#define WATER_STABLE_FFT_SAMPLING 1
#endif

#ifndef WATER_STABLE_DETILE_CELL_SCALE
#define WATER_STABLE_DETILE_CELL_SCALE 1.0
#endif

#ifndef WATER_STABLE_DETILE_HASH_PERIOD
#define WATER_STABLE_DETILE_HASH_PERIOD 128
#endif

#ifndef WATER_STABLE_DETILE_BLEND
#define WATER_STABLE_DETILE_BLEND 1.0
#endif

#ifndef WATER_STABLE_FOAM_DETILE_BLEND
#define WATER_STABLE_FOAM_DETILE_BLEND 1.0
#endif

// Packed tuning groups keep the top-level constant list compact.
// Legacy symbol aliases below preserve existing shader callsites.
static const float2 WATER_OPACITY_TUNE = float2(0.75, 4.65); // maskPower, gain
#define WATER_OPACITY_MASK_POWER WATER_OPACITY_TUNE.x
#define WATER_OPACITY_GAIN       WATER_OPACITY_TUNE.y

// FFT whitecap tuning (ported from TEST 7 / OCEAN_SURFACE_PRESET 0 "custom v6").
static const float4 FFT_WHITECAP_CORE          = float4(1.65, 1.40, 1.80, 2.50);      // gain, brightness, opacity (1.85), grazingBoost
static const float4 FFT_WHITECAP_WIND_TUNE     = float4(2.00, 6.00, 0.85, 0.42);      // windStart, windFull, windPower, seaFloorFromWind
static const float2 FFT_WHITECAP_MASK_TUNE     = float2(0.28, 1.38);                    // textureFloor, textureMaskPower
static const float4 FFT_WHITECAP_WAVE_TUNE     = float4(7.5, 8.0, 0.70, 0.0);          // waveHeightGain, waveSteepnessGain, wavePower, unused
static const float4 FFT_WHITECAP_TEXTURE_TUNE  = float4(0.080, 0.10, 1.45, 0.0);       // textureScaleBase, textureScaleWind, textureAniso, unused
static const float4 FFT_WHITECAP_DRIFT_TUNE    = float4(0.08, 0.16, 0.30, 0.0);        // driftBase, driftWindScale, driftWaveScale, unused
static const float4 COASTAL_FOAM_TUNE          = float4(0.90, 0.82, 0.90, 0.35);       // brightness, opacity, texturePower, textureFloor

// Backward-compatible aliases: existing shader code can keep old names.
#define FFT_WHITECAP_GAIN               FFT_WHITECAP_CORE.x
#define FFT_WHITECAP_BRIGHTNESS         FFT_WHITECAP_CORE.y
#define FFT_WHITECAP_OPACITY            FFT_WHITECAP_CORE.z
#define FFT_WHITECAP_GRAZING_BOOST      FFT_WHITECAP_CORE.w

#define FFT_WHITECAP_WIND_START         FFT_WHITECAP_WIND_TUNE.x
#define FFT_WHITECAP_WIND_FULL          FFT_WHITECAP_WIND_TUNE.y
#define FFT_WHITECAP_WIND_POWER         FFT_WHITECAP_WIND_TUNE.z
#define FFT_WHITECAP_SEA_FLOOR_FROM_WIND FFT_WHITECAP_WIND_TUNE.w

#define FFT_WHITECAP_TEXTURE_FLOOR      FFT_WHITECAP_MASK_TUNE.x
#define FFT_WHITECAP_TEXTURE_MASK_POWER FFT_WHITECAP_MASK_TUNE.y

#define FFT_WHITECAP_WAVE_HEIGHT_GAIN   FFT_WHITECAP_WAVE_TUNE.x
#define FFT_WHITECAP_WAVE_STEEPNESS_GAIN FFT_WHITECAP_WAVE_TUNE.y
#define FFT_WHITECAP_WAVE_POWER         FFT_WHITECAP_WAVE_TUNE.z

#define FFT_WHITECAP_TEXTURE_SCALE_BASE FFT_WHITECAP_TEXTURE_TUNE.x
#define FFT_WHITECAP_TEXTURE_SCALE_WIND FFT_WHITECAP_TEXTURE_TUNE.y
#define FFT_WHITECAP_TEXTURE_ANISO      FFT_WHITECAP_TEXTURE_TUNE.z

#define FFT_WHITECAP_DRIFT_BASE         FFT_WHITECAP_DRIFT_TUNE.x
#define FFT_WHITECAP_DRIFT_WIND_SCALE   FFT_WHITECAP_DRIFT_TUNE.y
#define FFT_WHITECAP_DRIFT_WAVE_SCALE   FFT_WHITECAP_DRIFT_TUNE.z

#define COASTAL_FOAM_BRIGHTNESS         COASTAL_FOAM_TUNE.x
#define COASTAL_FOAM_OPACITY            COASTAL_FOAM_TUNE.y
#define COASTAL_FOAM_TEXTURE_POWER      COASTAL_FOAM_TUNE.z
#define COASTAL_FOAM_TEXTURE_FLOOR      COASTAL_FOAM_TUNE.w

// -----------------------------------------------------------------------------
// Complementary FFT-scaled normal swell
// -----------------------------------------------------------------------------
// Shading-only long swell ported from BACKUP 1. Packed FFT height controls its
// local strength; it does not replace or alter either existing swell path.
#define USE_FFT_SCALED_NORMAL_SWELL 1
static const float FFT_SCALED_NORMAL_SWELL_PI2          = 6.283185307179586;
static const float3 FFT_SCALED_NORMAL_SWELL_CORE        = float3(1.00, 0.28, 1.15); // masterGain, shallowAmount, virtualHeight
static const float4 FFT_SCALED_NORMAL_SWELL_WIND_GAIN   = float4(0.0, 10.0, 0.5, 2.0); // wind start/full (knots), normal gain minimum/maximum
static const float FFT_SCALED_NORMAL_SWELL_MPS_TO_KNOTS = 1.94384449;
static const float4 FFT_SCALED_NORMAL_SWELL_WAVE        = float4(6160.0, 0.0, 0.50, 1.4); // length, speed, heightCenter, heightScale
static const float FFT_SCALED_NORMAL_SWELL_HEIGHT_POWER = 1.1;
static const float4 FFT_SCALED_NORMAL_SWELL_PHASE_WARP  = float4(0.0, 3180.0, 7850.0, 0.0); // gain, propagationLen, crestLen, unused
static const float4 FFT_SCALED_NORMAL_SWELL_AMPLITUDE   = float4(0.0, 220.0, 4800.0, 0.0); // variation, propagationLen, crestLen, unused
static const float4 FFT_SCALED_NORMAL_SWELL_ZIGZAG_MAIN = float4(0.95, 1130.0, 1880.0, 0.88); // gain, propagationLen, crestLen, fineGain
static const float4 FFT_SCALED_NORMAL_SWELL_ZIGZAG_EXTRA = float4(0.25, 0.0, 42.0, 0.0); // bendGain, speed, gradStep, unused

#define FFT_SCALED_NORMAL_SWELL_MASTER_GAIN       FFT_SCALED_NORMAL_SWELL_CORE.x
#define FFT_SCALED_NORMAL_SWELL_SHALLOW_AMOUNT    FFT_SCALED_NORMAL_SWELL_CORE.y
#define FFT_SCALED_NORMAL_SWELL_VIRTUAL_HEIGHT    FFT_SCALED_NORMAL_SWELL_CORE.z
#define FFT_SCALED_NORMAL_SWELL_LENGTH            FFT_SCALED_NORMAL_SWELL_WAVE.x
#define FFT_SCALED_NORMAL_SWELL_SPEED             FFT_SCALED_NORMAL_SWELL_WAVE.y
#define FFT_SCALED_NORMAL_SWELL_HEIGHT_CENTER     FFT_SCALED_NORMAL_SWELL_WAVE.z
#define FFT_SCALED_NORMAL_SWELL_HEIGHT_SCALE      FFT_SCALED_NORMAL_SWELL_WAVE.w
#define FFT_SCALED_NORMAL_SWELL_PHASE_WARP_GAIN   FFT_SCALED_NORMAL_SWELL_PHASE_WARP.x
#define FFT_SCALED_NORMAL_SWELL_PHASE_PROP_LEN    FFT_SCALED_NORMAL_SWELL_PHASE_WARP.y
#define FFT_SCALED_NORMAL_SWELL_PHASE_CREST_LEN   FFT_SCALED_NORMAL_SWELL_PHASE_WARP.z
#define FFT_SCALED_NORMAL_SWELL_AMPLITUDE_VARIATION FFT_SCALED_NORMAL_SWELL_AMPLITUDE.x
#define FFT_SCALED_NORMAL_SWELL_AMPLITUDE_PROP_LEN FFT_SCALED_NORMAL_SWELL_AMPLITUDE.y
#define FFT_SCALED_NORMAL_SWELL_AMPLITUDE_CREST_LEN FFT_SCALED_NORMAL_SWELL_AMPLITUDE.z
#define FFT_SCALED_NORMAL_SWELL_ZIGZAG_GAIN       FFT_SCALED_NORMAL_SWELL_ZIGZAG_MAIN.x
#define FFT_SCALED_NORMAL_SWELL_ZIGZAG_PROP_LEN   FFT_SCALED_NORMAL_SWELL_ZIGZAG_MAIN.y
#define FFT_SCALED_NORMAL_SWELL_ZIGZAG_CREST_LEN  FFT_SCALED_NORMAL_SWELL_ZIGZAG_MAIN.z
#define FFT_SCALED_NORMAL_SWELL_ZIGZAG_FINE_GAIN  FFT_SCALED_NORMAL_SWELL_ZIGZAG_MAIN.w
#define FFT_SCALED_NORMAL_SWELL_ZIGZAG_BEND_GAIN  FFT_SCALED_NORMAL_SWELL_ZIGZAG_EXTRA.x
#define FFT_SCALED_NORMAL_SWELL_ZIGZAG_SPEED      FFT_SCALED_NORMAL_SWELL_ZIGZAG_EXTRA.y
#define FFT_SCALED_NORMAL_SWELL_ZIGZAG_GRAD_STEP  FFT_SCALED_NORMAL_SWELL_ZIGZAG_EXTRA.z

// -----------------------------------------------------------------------------
// Far-field normal swell
// -----------------------------------------------------------------------------
// This shading-normal-only field takes over from the exact WIND_SWELL normal at
// distance. Its phase is aligned with the primary analytic displacement swell. Turned OFF 
// for now. May tune it later.
#define USE_FFT_NORMAL_SWELL 0
static const float FFT_NORMAL_SWELL_FAR_GAIN          = 0.15;
static const float FFT_NORMAL_SWELL_FAR_AMPLITUDE_VARIATION = 0.95; //0.55
static const float4 FFT_NORMAL_SWELL_FAR_BREAKUP_TUNE = float4(2.6, 7.5, 0.25, 0.0); // short/long amplitude scales, diagonal skew, unused
static const float FFT_NORMAL_SWELL_PI2              = 6.283185307179586;
static const float2 FFT_NORMAL_SWELL_FALLBACK_DIR    = float2(1.0, 0.0);

#define FFT_NORMAL_SWELL_FAR_BREAKUP_SHORT_SCALE  FFT_NORMAL_SWELL_FAR_BREAKUP_TUNE.x
#define FFT_NORMAL_SWELL_FAR_BREAKUP_LONG_SCALE   FFT_NORMAL_SWELL_FAR_BREAKUP_TUNE.y
#define FFT_NORMAL_SWELL_FAR_DIAGONAL_SKEW        FFT_NORMAL_SWELL_FAR_BREAKUP_TUNE.z

// -----------------------------------------------------------------------------
// Wind-driven analytic displacement swell
// -----------------------------------------------------------------------------
#define USE_WIND_DISPLACEMENT_SWELL 1

// The analytic swell's geometric displacement reaches zero at this horizontal
// camera distance. Stock FFT/coastal displacement keeps its original 2 km fade.
#ifndef WIND_SWELL_DISPLACEMENT_FADE_DISTANCE
#define WIND_SWELL_DISPLACEMENT_FADE_DISTANCE 1000.0
#endif

#define WIND_SWELL_PRESET_GENTLE_WIND_SEA       0
#define WIND_SWELL_PRESET_MODERATE_WIND_SEA     1
#define WIND_SWELL_PRESET_ROUGH_WIND_SEA        2
#define WIND_SWELL_PRESET_LONG_GROUNDSWELL       3

#ifndef WIND_SWELL_PRESET
#define WIND_SWELL_PRESET 1
#endif

static const float WIND_SWELL_GRAVITY = 9.81;

#if WIND_SWELL_PRESET == WIND_SWELL_PRESET_GENTLE_WIND_SEA
// Short, low wind sea. Calm water remains flat and local wind builds the swell.
static const float4 WIND_SWELL_CORE              = float4(1.75, 0.18, 0.35, 1.00); // full amplitude, choppiness, shallow amount, normal gain
static const float4 WIND_SWELL_WIND_TUNE         = float4(-1.00, 10.0, 1.35, 0.00); // start, full, response power, minimum swell amount
static const float4 WIND_SWELL_WAVE_TUNE         = float4(55.0, 0.58, 0.34, 0.62); // primary length, secondary ratio, tertiary ratio, minimum length scale
static const float4 WIND_SWELL_AMPLITUDE_WEIGHTS = float4(0.68, 0.22, 0.10, 0.0);
static const float4 WIND_SWELL_DIRECTION_OFFSETS = float4(0.0, 0.32, -0.48, 0.0);
#elif WIND_SWELL_PRESET == WIND_SWELL_PRESET_MODERATE_WIND_SEA
// Developed local sea with moderate height and directional variation.
static const float4 WIND_SWELL_CORE              = float4(2.00, 0.25, 0.26, 1.00);
static const float4 WIND_SWELL_WIND_TUNE         = float4(-1.00, 10.0, 1.20, 0.00);
static const float4 WIND_SWELL_WAVE_TUNE         = float4(125.0, 0.55, 0.31, 0.55);
static const float4 WIND_SWELL_AMPLITUDE_WEIGHTS = float4(0.64, 0.24, 0.12, 0.0);
static const float4 WIND_SWELL_DIRECTION_OFFSETS = float4(0.0, 0.27, -0.42, 0.0);
#elif WIND_SWELL_PRESET == WIND_SWELL_PRESET_ROUGH_WIND_SEA
// Existing tuned condition retained as the default preset.
static const float4 WIND_SWELL_CORE              = float4(2.25, 0.25, 0.20, 0.95);
static const float4 WIND_SWELL_WIND_TUNE         = float4(-1.00, 10.0, 1.20, 0.00);
static const float4 WIND_SWELL_WAVE_TUNE         = float4(65.0, 0.53, 0.28, 0.45);
static const float4 WIND_SWELL_AMPLITUDE_WEIGHTS = float4(0.62, 0.26, 0.12, 0.0);
static const float4 WIND_SWELL_DIRECTION_OFFSETS = float4(0.0, 0.24, -0.38, 0.0);
#elif WIND_SWELL_PRESET == WIND_SWELL_PRESET_LONG_GROUNDSWELL
// Long-period remote swell with a narrow directional spread and a weak wind floor.
static const float4 WIND_SWELL_CORE              = float4(3.40, 0.18, 0.12, 0.65);
static const float4 WIND_SWELL_WIND_TUNE         = float4(-1.00, 10.0, 1.00, 0.50);
static const float4 WIND_SWELL_WAVE_TUNE         = float4(320.0, 0.62, 0.40, 0.85);
static const float4 WIND_SWELL_AMPLITUDE_WEIGHTS = float4(0.72, 0.20, 0.08, 0.0);
static const float4 WIND_SWELL_DIRECTION_OFFSETS = float4(0.0, 0.12, -0.18, 0.0);
#else
#error Unknown WIND_SWELL_PRESET
#endif

#define WIND_SWELL_AMPLITUDE           WIND_SWELL_CORE.x
#define WIND_SWELL_CHOPPINESS          WIND_SWELL_CORE.y
#define WIND_SWELL_SHALLOW_AMOUNT      WIND_SWELL_CORE.z
#define WIND_SWELL_NORMAL_GAIN         WIND_SWELL_CORE.w

#define WIND_SWELL_WIND_START          WIND_SWELL_WIND_TUNE.x
#define WIND_SWELL_WIND_FULL           WIND_SWELL_WIND_TUNE.y
#define WIND_SWELL_WIND_POWER          WIND_SWELL_WIND_TUNE.z
#define WIND_SWELL_MIN_AMOUNT          WIND_SWELL_WIND_TUNE.w

#define WIND_SWELL_PRIMARY_LENGTH      WIND_SWELL_WAVE_TUNE.x
#define WIND_SWELL_SECONDARY_RATIO     WIND_SWELL_WAVE_TUNE.y
#define WIND_SWELL_TERTIARY_RATIO      WIND_SWELL_WAVE_TUNE.z
#define WIND_SWELL_MIN_LENGTH_SCALE    WIND_SWELL_WAVE_TUNE.w

// Screen-space normal LOD in pixels per wavelength. The detailed three-wave
// normal hands off to the far primary-wave proxy as its shortest component
// becomes under-resolved; the proxy fades only when the primary is unresolved.
static const float4 WIND_SWELL_NORMAL_LOD_TUNE = float4(6.0, 18.0, 1.0, 8.0); // detail minimum/full, primary minimum/full
static const float4 WIND_SWELL_NORMAL_SHAPE_TUNE = float4(0.55, 0.45, 0.45, 0.65); // component normal gains, meander phase gain
static const float4 WIND_SWELL_MEANDER_TUNE = float4(5.2, 11.5, 0.16, 0.0); // crest lengths in primary waves, along-crest skew, unused
static const float3 WIND_SWELL_MEANDER_COMPONENT_GAIN = float3(1.00, 0.65, 0.45);

#define WIND_SWELL_PRIMARY_NORMAL_GAIN   WIND_SWELL_NORMAL_SHAPE_TUNE.x
#define WIND_SWELL_SECONDARY_NORMAL_GAIN WIND_SWELL_NORMAL_SHAPE_TUNE.y
#define WIND_SWELL_TERTIARY_NORMAL_GAIN  WIND_SWELL_NORMAL_SHAPE_TUNE.z
#define WIND_SWELL_PHASE_MEANDER_GAIN    WIND_SWELL_NORMAL_SHAPE_TUNE.w
#define WIND_SWELL_MEANDER_SHORT_SCALE   WIND_SWELL_MEANDER_TUNE.x
#define WIND_SWELL_MEANDER_LONG_SCALE    WIND_SWELL_MEANDER_TUNE.y
#define WIND_SWELL_MEANDER_ALONG_SKEW    WIND_SWELL_MEANDER_TUNE.z

static const float WIND_SWELL_LOW_PASS_DEPTH_MARGIN = 1.0;
// x/y: encoded coastal depth where the backing bias is disabled/full;
// z: maximum fraction of local depth the backing may consume; w: clearance.
static const float4 WIND_SWELL_LOW_PASS_COAST_TUNE = float4(2.0, 8.0, 0.50, 0.25);
// The extended Gerstner tail also has horizontal motion. Remove that motion on
// very shallow shelves and restore it only where the displaced mesh can remain
// inside the water volume.
static const float2 WIND_SWELL_TAIL_CHOP_DEPTH = float2(2.0, 8.0);

struct WaterLocalParams {
	float4 wave, flow;
	float2 mask;
};

WaterLocalParams getWaterLocalParams(float3 wpos) {

	WaterLocalParams p;

//	gLocal must be applied on rendering of mask and wave targets
	
	float4 muv = mul(float4(wpos, 1.0), g_MaskMatrix); // g_MaskMatrix and g_WaveMatrix is adjusted matrix gViewProj
	muv.xy /= muv.w;
	p.mask = g_MaskTexture.SampleLevel(gTrilinearClampSampler, muv.xy, 0).xy;

	float4 wuv = mul(float4(wpos, 1.0), g_WaveMatrix);
	wuv.xy /= wuv.w;

	p.wave = g_WaveTexture.SampleLevel(gTrilinearClampSampler, float3(wuv.xy, 0), 0);
	p.flow = g_WaveTexture.SampleLevel(gTrilinearClampSampler, float3(wuv.xy, 1), 0);

	return p;
}

float3 decodeNormal(float4 wave) {
	wave.xy = (wave.xy - HALF) * 2; // xz of normal
	float len2 = dot(wave.xy, wave.xy);
	if (len2 > 1.0)
		wave.xy *= rsqrt(len2);
	float ny = sqrt(max(0.0, 1.0 - dot(wave.xy, wave.xy)));
	return float3(wave.x, ny, wave.y);
}

float3 decodeDisplace(float4 wave) {
	//	float3 n = decodeNormal(wave);
	//	return	n * (wave.z - 0.5) * 10;
	return float3(0, (wave.z - 0.5) * 10, 0);
}

float2 decodeFlow(float4 flow) {
	return (flow.yz - HALF) * 50;
}

float noiseCoast(float2 wposXZ) {
	return snoise((wposXZ + gOrigin.xz) * 0.01) * 0.2;
}

float3 addNormal(float3 normal1, float3 normal2) {
	normal1 = normalize(normal1);
	float3 helperAxis = (abs(normal1.y) < 0.999) ? float3(0.0, 1.0, 0.0) : float3(1.0, 0.0, 0.0);
	float3 zAxis = normalize(cross(helperAxis, normal1));
	float3 xAxis = cross(normal1, zAxis);
	float3x3 mat = float3x3(xAxis, normal1, zAxis);
	return mul(normal2, mat);
}

float2 normalToSlope(float3 n) {
	return n.xz / max(n.y, 1e-3);
}

float3 slopeToNormal(float2 slope) {
	return normalize(float3(slope.x, 1.0, slope.y));
}

float2 safeNormalizeWindPattern(float2 v) {
	return v * rsqrt(max(dot(v, v), 1e-6));
}


float2 safeNormalizeFftNormalSwell(float2 v) {
	return v * rsqrt(max(dot(v, v), 1e-6));
}

float2 fftNormalSwellWindAlignedDir() {
	// Match wind-map orientation; fall back to preset direction if wind dir is near zero.
	float2 windDir = g_WindDir;
	if (dot(windDir, windDir) < 0.25)
		windDir = FFT_NORMAL_SWELL_FALLBACK_DIR;
	return safeNormalizeFftNormalSwell(windDir);
}

float fftScaledNormalSwellMask(float2 mask) {
#if USE_FFT_SCALED_NORMAL_SWELL
	float deepRamp = saturate((mask.y - 0.35) * 3.0);
	float coastRamp = lerp(FFT_SCALED_NORMAL_SWELL_SHALLOW_AMOUNT, 1.0, deepRamp);
	return saturate((1.0 - mask.x) * coastRamp * FFT_SCALED_NORMAL_SWELL_MASTER_GAIN);
#else
	return 0.0;
#endif
}

float fftScaledNormalSwellHeightAmount(float fftHeight) {
	float heightAmount = abs(fftHeight - FFT_SCALED_NORMAL_SWELL_HEIGHT_CENTER) * FFT_SCALED_NORMAL_SWELL_HEIGHT_SCALE;
	return pow(saturate(heightAmount), FFT_SCALED_NORMAL_SWELL_HEIGHT_POWER);
}

float fftScaledNormalSwellWindGain() {
	float windKnots = max(g_WindForce, 0.0) * FFT_SCALED_NORMAL_SWELL_MPS_TO_KNOTS;
	float windRange = max(FFT_SCALED_NORMAL_SWELL_WIND_GAIN.y - FFT_SCALED_NORMAL_SWELL_WIND_GAIN.x, 1e-4);
	float windWeight = saturate((windKnots - FFT_SCALED_NORMAL_SWELL_WIND_GAIN.x) / windRange);
	return lerp(FFT_SCALED_NORMAL_SWELL_WIND_GAIN.z, FFT_SCALED_NORMAL_SWELL_WIND_GAIN.w, windWeight);
}

float fftScaledNormalSwellZigzagOffset(float2 worldPos, float2 propagationDir, float2 crestDir) {
	float propagation = dot(worldPos, propagationDir);
	float crest = dot(worldPos, crestDir);
	float t = g_Time * FFT_SCALED_NORMAL_SWELL_ZIGZAG_SPEED;

	float broadBend = snoise(float2(crest / max(FFT_SCALED_NORMAL_SWELL_ZIGZAG_CREST_LEN * 1.75, 1.0) + t,
		propagation / max(FFT_SCALED_NORMAL_SWELL_ZIGZAG_PROP_LEN * 2.35, 1.0) - 3.1));
	float localBend = snoise(float2(crest / max(FFT_SCALED_NORMAL_SWELL_ZIGZAG_CREST_LEN * 0.72, 1.0) - t * 0.61 + 4.4,
		propagation / max(FFT_SCALED_NORMAL_SWELL_ZIGZAG_PROP_LEN * 1.18, 1.0) + 7.2));
	float warpedPropagation = propagation + (broadBend * 0.72 + localBend * 0.28)
		* FFT_SCALED_NORMAL_SWELL_ZIGZAG_PROP_LEN * FFT_SCALED_NORMAL_SWELL_ZIGZAG_BEND_GAIN;

	float mainZig = snoise(float2(warpedPropagation / max(FFT_SCALED_NORMAL_SWELL_ZIGZAG_PROP_LEN, 1.0),
		crest / max(FFT_SCALED_NORMAL_SWELL_ZIGZAG_CREST_LEN, 1.0) - t * 0.37));
	float fineZig = snoise(float2(warpedPropagation / max(FFT_SCALED_NORMAL_SWELL_ZIGZAG_PROP_LEN * 0.48, 1.0) + 9.6,
		crest / max(FFT_SCALED_NORMAL_SWELL_ZIGZAG_CREST_LEN * 0.42, 1.0) + t * 0.23 - 2.8));
	return lerp(mainZig, fineZig, FFT_SCALED_NORMAL_SWELL_ZIGZAG_FINE_GAIN);
}

float2 fftScaledNormalSwellZigzagGradient(float2 worldPos, float2 propagationDir, float2 crestDir) {
	float e = max(FFT_SCALED_NORMAL_SWELL_ZIGZAG_GRAD_STEP, 1.0);
	float dx = fftScaledNormalSwellZigzagOffset(worldPos + float2(e, 0.0), propagationDir, crestDir)
		- fftScaledNormalSwellZigzagOffset(worldPos - float2(e, 0.0), propagationDir, crestDir);
	float dz = fftScaledNormalSwellZigzagOffset(worldPos + float2(0.0, e), propagationDir, crestDir)
		- fftScaledNormalSwellZigzagOffset(worldPos - float2(0.0, e), propagationDir, crestDir);
	return float2(dx, dz) / (2.0 * e);
}

void fftScaledNormalSwellState(float2 worldPos, out float phase, out float amplitudeScale,
	out float2 phaseGradient, out float2 amplitudeGradient) {
	float2 propagationDir = fftNormalSwellWindAlignedDir();
	float2 crestDir = float2(-propagationDir.y, propagationDir.x);
	float propagation = dot(worldPos, propagationDir);
	float crest = dot(worldPos, crestDir);

	float waveNumber = FFT_SCALED_NORMAL_SWELL_PI2 / max(FFT_SCALED_NORMAL_SWELL_LENGTH, 1.0);
	phase = propagation * waveNumber - g_Time * FFT_SCALED_NORMAL_SWELL_SPEED * waveNumber;
	phaseGradient = propagationDir * waveNumber;

	float phasePropK = FFT_SCALED_NORMAL_SWELL_PI2 / max(FFT_SCALED_NORMAL_SWELL_PHASE_PROP_LEN, 1.0);
	float phaseCrestK = FFT_SCALED_NORMAL_SWELL_PI2 / max(FFT_SCALED_NORMAL_SWELL_PHASE_CREST_LEN, 1.0);
	float warpA = propagation * phasePropK + g_Time * 0.035;
	float warpB = crest * phaseCrestK + propagation * (phaseCrestK * 0.55) - g_Time * 0.022 + 1.731;
	float warpASin, warpACos, warpBSin, warpBCos;
	sincos(warpA, warpASin, warpACos);
	sincos(warpB, warpBSin, warpBCos);
	phase += (warpASin * 0.62 + warpBSin * 0.38) * FFT_SCALED_NORMAL_SWELL_PHASE_WARP_GAIN;
	phaseGradient += propagationDir * (warpACos * phasePropK * 0.62 * FFT_SCALED_NORMAL_SWELL_PHASE_WARP_GAIN);
	phaseGradient += (crestDir * phaseCrestK + propagationDir * (phaseCrestK * 0.55))
		* (warpBCos * 0.38 * FFT_SCALED_NORMAL_SWELL_PHASE_WARP_GAIN);

	float zigzag = fftScaledNormalSwellZigzagOffset(worldPos, propagationDir, crestDir);
	float2 zigzagGradient = fftScaledNormalSwellZigzagGradient(worldPos, propagationDir, crestDir);
	phase += zigzag * FFT_SCALED_NORMAL_SWELL_ZIGZAG_GAIN;
	phaseGradient += zigzagGradient * FFT_SCALED_NORMAL_SWELL_ZIGZAG_GAIN;

	float amplitudePropK = FFT_SCALED_NORMAL_SWELL_PI2 / max(FFT_SCALED_NORMAL_SWELL_AMPLITUDE_PROP_LEN, 1.0);
	float amplitudeCrestK = FFT_SCALED_NORMAL_SWELL_PI2 / max(FFT_SCALED_NORMAL_SWELL_AMPLITUDE_CREST_LEN, 1.0);
	float amplitudeA = propagation * amplitudePropK - g_Time * 0.018 + 0.417;
	float amplitudeB = crest * (amplitudeCrestK * 0.48) + propagation * amplitudeCrestK - g_Time * 0.013 + 2.246;
	float amplitudeASin, amplitudeACos, amplitudeBSin, amplitudeBCos;
	sincos(amplitudeA, amplitudeASin, amplitudeACos);
	sincos(amplitudeB, amplitudeBSin, amplitudeBCos);
	float amplitudeRaw = amplitudeASin * 0.58 + amplitudeBSin * 0.42;
	amplitudeScale = saturate(0.5 + (1.0 + amplitudeRaw * FFT_SCALED_NORMAL_SWELL_AMPLITUDE_VARIATION) * 0.5) * 2.0;
	amplitudeScale = clamp(amplitudeScale, 0.68, 1.30);
	amplitudeGradient = propagationDir * (amplitudeACos * amplitudePropK * 0.58 * FFT_SCALED_NORMAL_SWELL_AMPLITUDE_VARIATION);
	amplitudeGradient += (crestDir * (amplitudeCrestK * 0.48) + propagationDir * amplitudeCrestK)
		* (amplitudeBCos * 0.42 * FFT_SCALED_NORMAL_SWELL_AMPLITUDE_VARIATION);
}

float3 fftScaledNormalSwellNormal(float2 wpos2, float2 mask, float fftHeight) {
#if USE_FFT_SCALED_NORMAL_SWELL
	float amount = fftScaledNormalSwellMask(mask) * fftScaledNormalSwellHeightAmount(fftHeight);
	if (amount > 1e-4) {
		float phase, amplitudeScale;
		float2 phaseGradient, amplitudeGradient;
		fftScaledNormalSwellState(wpos2 + gOrigin.xz, phase, amplitudeScale, phaseGradient, amplitudeGradient);
		float phaseSin, phaseCos;
		sincos(phase, phaseSin, phaseCos);
		float2 heightGradient = FFT_SCALED_NORMAL_SWELL_VIRTUAL_HEIGHT
			* (amplitudeScale * phaseCos * phaseGradient + phaseSin * amplitudeGradient);
		heightGradient *= amount * fftScaledNormalSwellWindGain();
		return normalize(float3(-heightGradient.x, 1.0, -heightGradient.y));
	}
#endif
	return float3(0.0, 1.0, 0.0);
}

struct WindSwellSample {
	float3 displace;
	float3 normal;
};

float windSwellAmount() {
	float wind = smoothstep(WIND_SWELL_WIND_START, WIND_SWELL_WIND_FULL, max(g_WindForce, 0.0));
	float windResponse = pow(saturate(wind), WIND_SWELL_WIND_POWER);
	return lerp(WIND_SWELL_MIN_AMOUNT, 1.0, windResponse);
}

float windSwellWaterMask(float2 mask) {
	float deepRamp = saturate((mask.y - 0.35) * 3.0);
	float coastRamp = lerp(WIND_SWELL_SHALLOW_AMOUNT, 1.0, deepRamp);
	return saturate((1.0 - mask.x) * coastRamp);
}

void windSwellPhaseState(float2 worldPos, float2 dir, float waveNumber,
	float angularFrequency, float phaseOffset, float referenceLength, float meanderWeight,
	out float phase, out float2 phaseGradient) {
	float2 crestDir = float2(-dir.y, dir.x);
	float along = dot(worldPos, dir);
	float across = dot(worldPos, crestDir);
	phase = along * waveNumber - g_Time * angularFrequency + phaseOffset;
	phaseGradient = dir * waveNumber;

	float shortK = FFT_NORMAL_SWELL_PI2 / max(referenceLength * WIND_SWELL_MEANDER_SHORT_SCALE, 1.0);
	float longK = FFT_NORMAL_SWELL_PI2 / max(referenceLength * WIND_SWELL_MEANDER_LONG_SCALE, 1.0);
	float phaseA = across * shortK + along * (shortK * WIND_SWELL_MEANDER_ALONG_SKEW) + g_Time * 0.013 + phaseOffset * 0.37;
	float phaseB = across * longK - along * (longK * WIND_SWELL_MEANDER_ALONG_SKEW * 0.63) - g_Time * 0.009 + phaseOffset * 0.71 + 1.731;
	float phaseASin, phaseACos, phaseBSin, phaseBCos;
	sincos(phaseA, phaseASin, phaseACos);
	sincos(phaseB, phaseBSin, phaseBCos);

	float meanderGain = WIND_SWELL_PHASE_MEANDER_GAIN * meanderWeight;
	phase += (phaseASin * 0.64 + phaseBSin * 0.36) * meanderGain;
	phaseGradient += (crestDir * shortK + dir * (shortK * WIND_SWELL_MEANDER_ALONG_SKEW)) * (phaseACos * 0.64 * meanderGain);
	phaseGradient += (crestDir * longK - dir * (longK * WIND_SWELL_MEANDER_ALONG_SKEW * 0.63)) * (phaseBCos * 0.36 * meanderGain);
}

void fftNormalSwellFarAmplitude(float2 worldPos, float2 dir, float referenceLength,
	out float amplitudeScale, out float2 amplitudeGradient) {
	float2 crestDir = float2(-dir.y, dir.x);
	float along = dot(worldPos, dir);
	float across = dot(worldPos, crestDir);

	float breakupShortK = FFT_NORMAL_SWELL_PI2 / max(referenceLength * FFT_NORMAL_SWELL_FAR_BREAKUP_SHORT_SCALE, 1.0);
	float breakupLongK = FFT_NORMAL_SWELL_PI2 / max(referenceLength * FFT_NORMAL_SWELL_FAR_BREAKUP_LONG_SCALE, 1.0);
	float breakupA = across * breakupShortK - along * (breakupShortK * 0.23) - g_Time * 0.005 + 1.129;
	float breakupB = across * breakupLongK + along * (breakupLongK * 0.31) + g_Time * 0.003 + 3.871;
	float breakupASin, breakupACos, breakupBSin, breakupBCos;
	sincos(breakupA, breakupASin, breakupACos);
	sincos(breakupB, breakupBSin, breakupBCos);

	float breakupRaw = breakupASin * 0.62 + breakupBSin * 0.38;
	float2 breakupGradient = (crestDir * breakupShortK - dir * (breakupShortK * 0.23)) * (breakupACos * 0.62);
	breakupGradient += (crestDir * breakupLongK + dir * (breakupLongK * 0.31)) * (breakupBCos * 0.38);
	amplitudeScale = 1.0 + breakupRaw * FFT_NORMAL_SWELL_FAR_AMPLITUDE_VARIATION;
	amplitudeGradient = breakupGradient * FFT_NORMAL_SWELL_FAR_AMPLITUDE_VARIATION;
}

float2 windSwellNormalLodWeights(float2 worldPos) {
	float metresPerPixel = max(
		max(length(ddx(worldPos)), length(ddy(worldPos))),
		1e-3);

	float windAmount = windSwellAmount();
	float primaryLength = WIND_SWELL_PRIMARY_LENGTH
		* lerp(WIND_SWELL_MIN_LENGTH_SCALE, 1.0, windAmount);
	float detailLength = primaryLength * WIND_SWELL_TERTIARY_RATIO;

	float detailPixels = detailLength / metresPerPixel;
	float primaryPixels = primaryLength / metresPerPixel;
	float nearWeight = smoothstep(
		WIND_SWELL_NORMAL_LOD_TUNE.x,
		WIND_SWELL_NORMAL_LOD_TUNE.y,
		detailPixels);
	float farResolved = smoothstep(
		WIND_SWELL_NORMAL_LOD_TUNE.z,
		WIND_SWELL_NORMAL_LOD_TUNE.w,
		primaryPixels);

	return float2(nearWeight, (1.0 - nearWeight) * farResolved);
}

float3 fftNormalSwellFarNormal(float2 wpos2, float2 mask, float lodWeight) {
#if USE_FFT_NORMAL_SWELL
	float windAmount = windSwellAmount();
	float swellAmount = windAmount * windSwellWaterMask(mask);
	if (lodWeight * swellAmount > 1e-4) {
		float2 worldPos = wpos2 + gOrigin.xz;
		float2 windDir = fftNormalSwellWindAlignedDir();
		float offsetSin, offsetCos;
		sincos(WIND_SWELL_DIRECTION_OFFSETS.x, offsetSin, offsetCos);
		float2 primaryDir = float2(
			windDir.x * offsetCos - windDir.y * offsetSin,
			windDir.x * offsetSin + windDir.y * offsetCos);
		float lengthScale = lerp(WIND_SWELL_MIN_LENGTH_SCALE, 1.0, windAmount);
		float primaryLength = WIND_SWELL_PRIMARY_LENGTH * lengthScale;
		float waveNumber = FFT_NORMAL_SWELL_PI2 / max(primaryLength, 1.0);
		float angularFrequency = sqrt(WIND_SWELL_GRAVITY * waveNumber);
		float phase;
		float2 phaseGradient;
		windSwellPhaseState(worldPos, primaryDir, waveNumber, angularFrequency, 0.0,
			primaryLength, WIND_SWELL_MEANDER_COMPONENT_GAIN.x, phase, phaseGradient);
		float amplitudeScale;
		float2 amplitudeGradient;
		fftNormalSwellFarAmplitude(worldPos, primaryDir, primaryLength,
			amplitudeScale, amplitudeGradient);

		float phaseSin, phaseCos;
		sincos(phase, phaseSin, phaseCos);
		float primaryAmplitude = WIND_SWELL_AMPLITUDE * WIND_SWELL_AMPLITUDE_WEIGHTS.x * swellAmount;
		float2 slope = primaryAmplitude * (amplitudeScale * phaseCos * phaseGradient + phaseSin * amplitudeGradient);
		slope *= lodWeight * WIND_SWELL_PRIMARY_NORMAL_GAIN * WIND_SWELL_NORMAL_GAIN * FFT_NORMAL_SWELL_FAR_GAIN;
		return normalize(float3(-slope.x, 1.0, -slope.y));
	}
#endif
	return float3(0.0, 1.0, 0.0);
}

void accumulateWindSwell(float2 worldPos, float2 windDir, float directionOffset,
	float wavelength, float referenceLength, float amplitude, float phaseOffset,
	float normalGain, float meanderWeight,
	inout float3 displace, inout float3 tangentX, inout float3 tangentZ) {
	float offsetSin, offsetCos;
	sincos(directionOffset, offsetSin, offsetCos);
	float2 dir = float2(
		windDir.x * offsetCos - windDir.y * offsetSin,
		windDir.x * offsetSin + windDir.y * offsetCos);

	float waveNumber = FFT_NORMAL_SWELL_PI2 / max(wavelength, 1.0);
	float angularFrequency = sqrt(WIND_SWELL_GRAVITY * waveNumber);
	float phase;
	float2 phaseGradient;
	windSwellPhaseState(worldPos, dir, waveNumber, angularFrequency, phaseOffset,
		referenceLength, meanderWeight, phase, phaseGradient);
	float phaseSin, phaseCos;
	sincos(phase, phaseSin, phaseCos);

	float horizontalAmplitude = min(WIND_SWELL_CHOPPINESS * amplitude, 0.72 / waveNumber);
	displace.xz += dir * (horizontalAmplitude * phaseCos);
	displace.y += amplitude * phaseSin;

	float horizontalDerivative = horizontalAmplitude * phaseSin;
	float verticalDerivative = amplitude * phaseCos;
	float2 horizontalDx = -dir * (horizontalDerivative * phaseGradient.x);
	float2 horizontalDz = -dir * (horizontalDerivative * phaseGradient.y);
	tangentX += float3(horizontalDx.x, verticalDerivative * phaseGradient.x, horizontalDx.y) * normalGain;
	tangentZ += float3(horizontalDz.x, verticalDerivative * phaseGradient.y, horizontalDz.y) * normalGain;
}

WindSwellSample sampleWindSwell(float2 wpos2, float2 mask) {
	WindSwellSample result;
	result.displace = 0.0;
	result.normal = float3(0.0, 1.0, 0.0);

#if USE_WIND_DISPLACEMENT_SWELL
	float windAmount = windSwellAmount();
	float swellAmount = windAmount * windSwellWaterMask(mask);
	if (swellAmount > 1e-4) {
		float2 worldPos = wpos2 + gOrigin.xz;
		float2 windDir = fftNormalSwellWindAlignedDir();
		float lengthScale = lerp(WIND_SWELL_MIN_LENGTH_SCALE, 1.0, windAmount);
		float amplitude = WIND_SWELL_AMPLITUDE * swellAmount;
		float primaryLength = WIND_SWELL_PRIMARY_LENGTH * lengthScale;
		float3 tangentX = float3(1.0, 0.0, 0.0);
		float3 tangentZ = float3(0.0, 0.0, 1.0);

		accumulateWindSwell(worldPos, windDir, WIND_SWELL_DIRECTION_OFFSETS.x,
			primaryLength, primaryLength, amplitude * WIND_SWELL_AMPLITUDE_WEIGHTS.x, 0.0,
			WIND_SWELL_PRIMARY_NORMAL_GAIN, WIND_SWELL_MEANDER_COMPONENT_GAIN.x,
			result.displace, tangentX, tangentZ);
		accumulateWindSwell(worldPos, windDir, WIND_SWELL_DIRECTION_OFFSETS.y,
			primaryLength * WIND_SWELL_SECONDARY_RATIO, primaryLength, amplitude * WIND_SWELL_AMPLITUDE_WEIGHTS.y, 2.0943951,
			WIND_SWELL_SECONDARY_NORMAL_GAIN, WIND_SWELL_MEANDER_COMPONENT_GAIN.y,
			result.displace, tangentX, tangentZ);
		accumulateWindSwell(worldPos, windDir, WIND_SWELL_DIRECTION_OFFSETS.z,
			primaryLength * WIND_SWELL_TERTIARY_RATIO, primaryLength, amplitude * WIND_SWELL_AMPLITUDE_WEIGHTS.z, 4.1887902,
			WIND_SWELL_TERTIARY_NORMAL_GAIN, WIND_SWELL_MEANDER_COMPONENT_GAIN.z,
			result.displace, tangentX, tangentZ);

		result.normal = normalize(cross(tangentZ, tangentX));
	}
#endif

	return result;
}

float waterDisplaceFade(float cameraDistance) {
	return max(0.0, 0.5 - cameraDistance / (cameraDistance + 2000.0)) * 2.0;
}

float windSwellDisplaceFade(float cameraDistance) {
	float fadeDistance = max(WIND_SWELL_DISPLACEMENT_FADE_DISTANCE, 1.0);
	return max(0.0, 0.5 - cameraDistance / (cameraDistance + fadeDistance)) * 2.0;
}

float windSwellLowPassDepthBias(float3 wpos) {
#if USE_WIND_DISPLACEMENT_SWELL
	float swellAmount = windSwellAmount();
	float fade = windSwellDisplaceFade(length(wpos.xz - gCameraPos.xz));
	if (swellAmount * fade <= 0.001)
		return 0.0;

	WaterLocalParams localParams = getWaterLocalParams(wpos);
	float weightEnvelope = dot(abs(WIND_SWELL_AMPLITUDE_WEIGHTS.xyz), float3(1.0, 1.0, 1.0));
	float depthGuard = (WIND_SWELL_AMPLITUDE * weightEnvelope + WIND_SWELL_LOW_PASS_DEPTH_MARGIN) * swellAmount;
	depthGuard *= windSwellWaterMask(localParams.mask) * fade;

	// Do not sink the coarse backing surface through a shallow coastal floor.
	// Use the same encoded depth that constrains the visible displacement.
	bool underwater = (g_Level - gOrigin.y) > gCameraPos.y;
	float deepMask = max(localParams.mask.y, underwater) * (1.0 - localParams.mask.x);
	float availableDepth = (deepMask - HALF) * 20.0;
	float3 waveDisplace = decodeDisplace(localParams.wave);
#if USE_NOISE_COAST
	waveDisplace += noiseCoast(wpos.xz);
#endif
	availableDepth += waveDisplace.y;
	availableDepth = max(availableDepth, 0.0);
	float coastalDepthWeight = smoothstep(
		WIND_SWELL_LOW_PASS_COAST_TUNE.x,
		WIND_SWELL_LOW_PASS_COAST_TUNE.y,
		availableDepth);
	depthGuard *= coastalDepthWeight;
	float safeBackingDepth = max(
		availableDepth * WIND_SWELL_LOW_PASS_COAST_TUNE.z - WIND_SWELL_LOW_PASS_COAST_TUNE.w,
		0.0);
	return min(depthGuard, safeBackingDepth);
#else
	return 0.0;
#endif
}

float2 NDCpos2uv(float4 NDCpos) {
	return float2(NDCpos.x, -NDCpos.y) / NDCpos.w * 0.5 + 0.5;
}

float waterDetailTexScale(float texScale) {
	return texScale / max(WATER_DETAIL_WAVELENGTH_SCALE, 0.001);
}

float2 waterStableWorldXZ(float2 wpos2) {
	return wpos2 + gOrigin.xz;
}

float2 waterStableNormalUV(float2 worldPos, float texScale) {
	return worldPos * (g_TexScale.x * texScale);
}

float2 waterStableWrapUV(float2 uv) {
	return frac(uv);
}

float waterDetailNormalStrength() {
	return WATER_DETAIL_NORMAL_STRENGTH;
}

float4 tuneWaterSurfaceResult(float4 result, uniform bool calcNormal) {
	if (calcNormal)
		result.xy = clamp(result.xy * waterDetailNormalStrength(), -0.98, 0.98);
	return result;
}

struct StableDetileUV {
	float2 uv0, uv1, uv2;
	float3 w;
};

// Keep stochastic cell selection in world space so g_TexOffset wrapping cannot pick new hashes.
StableDetileUV stableDetileUV(float2 uv, float2 detileCoord) {
	StableDetileUV r;
	int2 v0, v1, v2;
	triangleGrid(detileCoord * WATER_STABLE_DETILE_CELL_SCALE, r.w, v0, v1, v2);
#if WATER_STABLE_DETILE_HASH_PERIOD > 0
	v0 %= WATER_STABLE_DETILE_HASH_PERIOD;
	v1 %= WATER_STABLE_DETILE_HASH_PERIOD;
	v2 %= WATER_STABLE_DETILE_HASH_PERIOD;
#endif
	r.uv0 = uv + hash(v0);
	r.uv1 = uv + hash(v1);
	r.uv2 = uv + hash(v2);
	return r;
}

float4 sampleWaterNormalLayerStableGrad(float2 uv, float2 worldPos, float detileTexScale, uniform uint layer, float2 _ddx, float2 _ddy, float detileBlend) {
	StableDetileUV s = stableDetileUV(uv, worldPos * (g_TexScale.x * detileTexScale));
	float layerF = (float)layer;
	float4 s0 = g_NormalTexture.SampleGrad(gAnisotropicWrapSampler, float3(s.uv0, layerF), _ddx, _ddy);
	float4 s1 = g_NormalTexture.SampleGrad(gAnisotropicWrapSampler, float3(s.uv1, layerF), _ddx, _ddy);
	float4 s2 = g_NormalTexture.SampleGrad(gAnisotropicWrapSampler, float3(s.uv2, layerF), _ddx, _ddy);
	float4 direct = g_NormalTexture.SampleGrad(gAnisotropicWrapSampler, float3(uv, layerF), _ddx, _ddy);
	return lerp(direct, s0 * s.w.x + s1 * s.w.y + s2 * s.w.z, detileBlend);
}

float4 sampleWaterNormalLayerStableLevel(float2 uv, float2 worldPos, float detileTexScale, uniform uint layer, float detileBlend) {
	StableDetileUV s = stableDetileUV(uv, worldPos * (g_TexScale.x * detileTexScale));
	float layerF = (float)layer;
	float4 s0 = g_NormalTexture.SampleLevel(gTrilinearWrapSampler, float3(s.uv0, layerF), 0);
	float4 s1 = g_NormalTexture.SampleLevel(gTrilinearWrapSampler, float3(s.uv1, layerF), 0);
	float4 s2 = g_NormalTexture.SampleLevel(gTrilinearWrapSampler, float3(s.uv2, layerF), 0);
	float4 direct = g_NormalTexture.SampleLevel(gTrilinearWrapSampler, float3(uv, layerF), 0);
	return lerp(direct, s0 * s.w.x + s1 * s.w.y + s2 * s.w.z, detileBlend);
}

float sampleWaterFoamMaskStable(float2 uv, float2 worldPos, float detileScale, float2 _ddx, float2 _ddy) {
	StableDetileUV s = stableDetileUV(uv, worldPos * detileScale);
	float f0 = dot(foamTexture.SampleGrad(gAnisotropicWrapSampler, s.uv0, _ddx, _ddy).xyz, LUM);
	float f1 = dot(foamTexture.SampleGrad(gAnisotropicWrapSampler, s.uv1, _ddx, _ddy).xyz, LUM);
	float f2 = dot(foamTexture.SampleGrad(gAnisotropicWrapSampler, s.uv2, _ddx, _ddy).xyz, LUM);
	float direct = dot(foamTexture.SampleGrad(gAnisotropicWrapSampler, uv, _ddx, _ddy).xyz, LUM);
	return lerp(direct, dot(float3(f0, f1, f2), s.w), WATER_STABLE_FOAM_DETILE_BLEND);
}

float4 combineWaterNormalStable(float2 wpos2, float texScale, uniform bool calcNormal, uniform bool useFoamFFT) {
	float2 worldPos = waterStableWorldXZ(wpos2);
	float2 uvUnwrapped = waterStableNormalUV(worldPos, texScale);
	float2 uv = waterStableWrapUV(uvUnwrapped);

	if (calcNormal) {
		float2 _ddx = ddx(uvUnwrapped);
		float2 _ddy = ddy(uvUnwrapped);
		float4 n = sampleWaterNormalLayerStableGrad(uv, worldPos, texScale, 0, _ddx, _ddy, WATER_STABLE_DETILE_BLEND);
		float f = useFoamFFT ? n.w - 0.025 : 0;
		return float4(n.xyz, f);
	}
	else {
		float4 r = sampleWaterNormalLayerStableLevel(uv, worldPos, texScale, 1, WATER_STABLE_DETILE_BLEND);
		float f = 0.5 / texScale;
		r.xyz *= f * g_TexScale.y;
		return r;
	}
}

struct FlowParams {
	float2 offset0, offset1;
	float lerpFlow;
};

FlowParams calcFlowParams(float2 uv, float2 flow, float pulse, uniform bool useFlowNoise = true) {
	FlowParams o;

	float t = gModelTime * pulse;
	if (useFlowNoise)
		t += snoise(uv) * 0.5;

	float phase0 = frac(t);
	float phase1 = frac(t + 0.5);
	o.offset0 = flow * phase0;
	o.offset1 = flow * phase1 + 0.5;
#if 1
	o.lerpFlow = 2 * abs(phase0 - 0.5);						// triangle pulse
#else
	o.lerpFlow = cos(t * (2 * 3.14159265359)) * 0.5 + 0.5;	// sin pulse
#endif
	return o;
}

float4 combineWaterNormalFlow(float2 wpos2, float texScale, float2 flow, uniform bool calcNormal, uniform bool useFoamFFT) {
	float effectiveTexScale = waterDetailTexScale(texScale);
	float2 worldPos = waterStableWorldXZ(wpos2);
	float2 uvUnwrapped = waterStableNormalUV(worldPos, effectiveTexScale);
	float2 uv = waterStableWrapUV(uvUnwrapped);

	FlowParams fp = calcFlowParams(uvUnwrapped, flow * (g_TexScale.x * effectiveTexScale), 0.25);
#if !WATER_STABLE_FFT_SAMPLING
	StochasticUV s = stochasicUV(uv);
#endif

	if (calcNormal) {
		float2 _ddx = ddx(uvUnwrapped);
		float2 _ddy = ddy(uvUnwrapped);
#if WATER_STABLE_FFT_SAMPLING
		float4 n0 = sampleWaterNormalLayerStableGrad(waterStableWrapUV(uvUnwrapped + fp.offset0), worldPos, effectiveTexScale, 0, _ddx, _ddy, WATER_STABLE_DETILE_BLEND);
		float4 n1 = sampleWaterNormalLayerStableGrad(waterStableWrapUV(uvUnwrapped + fp.offset1), worldPos, effectiveTexScale, 0, _ddx, _ddy, WATER_STABLE_DETILE_BLEND);
#else
		float4 n0 = stochasticSampleGradArr(g_NormalTexture, 0, gAnisotropicWrapSampler, s, _ddx, _ddy, fp.offset0);
		float4 n1 = stochasticSampleGradArr(g_NormalTexture, 0, gAnisotropicWrapSampler, s, _ddx, _ddy, fp.offset1);
#endif
		float4 n = lerp(n0, n1, fp.lerpFlow);
		float f = 0;
		if (useFoamFFT)
			f = n.w - 0.025;
		return float4(n.xyz, f);
	}
	else {
#if WATER_STABLE_FFT_SAMPLING
		float4 r0 = sampleWaterNormalLayerStableLevel(waterStableWrapUV(uvUnwrapped + fp.offset0), worldPos, effectiveTexScale, 1, WATER_STABLE_DETILE_BLEND);
		float4 r1 = sampleWaterNormalLayerStableLevel(waterStableWrapUV(uvUnwrapped + fp.offset1), worldPos, effectiveTexScale, 1, WATER_STABLE_DETILE_BLEND);
#else
		float4 r0 = stochasticSampleLevelArr(g_NormalTexture, 1, gTrilinearWrapSampler, s, 0, fp.offset0);
		float4 r1 = stochasticSampleLevelArr(g_NormalTexture, 1, gTrilinearWrapSampler, s, 0, fp.offset1);
#endif
		float4 r = lerp(r0, r1, fp.lerpFlow);

		float f = 0.5 / texScale;	// displace multiplier
		r.xyz *= f * g_TexScale.y;
		return r;
	}
}

// constructing the displacement amount and normal for water surface geometry
float4 CombineWaterCommon(float2 wpos2, float2 flow, float tilingMask, uniform bool useTilingMask, uniform bool calcNormal, uniform bool useFoamFFT) {

	float4 result;

	if (useTilingMask) {
		float3 tiling = 1 + tilingMask * 3;
		int3 e = log2(tiling);
		int3 scale = (1 << e);

#if USE_FLOW_MAP
		float4 r0 = combineWaterNormalFlow(wpos2, scale[2], flow, calcNormal, useFoamFFT);
		float4 r1 = combineWaterNormalFlow(wpos2, 2 * scale[1], flow, calcNormal, useFoamFFT);
#else
#if WATER_STABLE_FFT_SAMPLING
		float4 r0 = combineWaterNormalStable(wpos2, waterDetailTexScale(scale[2]), calcNormal, useFoamFFT);
		float4 r1 = combineWaterNormalStable(wpos2, waterDetailTexScale(2 * scale[1]), calcNormal, useFoamFFT);
#else
		float4 r0 = combineWaterNormal(wpos2, waterDetailTexScale(scale[2]), calcNormal, useFoamFFT);
		float4 r1 = combineWaterNormal(wpos2, waterDetailTexScale(2 * scale[1]), calcNormal, useFoamFFT);
#endif
#endif
		float factor = (tiling[0] - scale[0]) / float(scale[0]);
		result = lerp(r0, r1, factor);
	}
	else {
#if USE_FLOW_MAP
		result = combineWaterNormalFlow(wpos2, 1, flow, calcNormal, useFoamFFT);
#else
#if WATER_STABLE_FFT_SAMPLING
		result = combineWaterNormalStable(wpos2, waterDetailTexScale(1), calcNormal, useFoamFFT);
#else
		result = combineWaterNormal(wpos2, waterDetailTexScale(1), calcNormal, useFoamFFT);
#endif
#endif
	}
	return tuneWaterSurfaceResult(result, calcNormal);
}


///////////////////////// interface functions

float3 calculateWaterDisplace(float3 wpos, WaterLocalParams localParams, uniform bool useTilingMask) {

    float2 wpos2 = wpos.xz;

	float3 water_displace = CombineWaterCommon(wpos2, decodeFlow(localParams.flow), localParams.flow.x, useTilingMask, false, false).xyz;
	// result.xy - normal.xz
	// result.z	 - displace.y

	float3 wave_displace = decodeDisplace(localParams.wave);
	float d = distance(wpos.xz, gCameraPos.xz);
	float3 windSwellDisplace = 0.0;

	water_displace += wave_displace;
#if USE_WIND_DISPLACEMENT_SWELL
	float2 swellPos = mul(float4(wpos, 1.0), gLocal).xz;
	windSwellDisplace = sampleWindSwell(swellPos, localParams.mask).displace;
	water_displace += windSwellDisplace;
#endif

#if GEOTERRAIN	// disable displace fade and noise
	return water_displace;
#endif

#if USE_NOISE_COAST
	wave_displace += noiseCoast(wpos2);
#endif

	bool underwater = (g_Level - gOrigin.y) > gCameraPos.y;
	float deepMask = max(localParams.mask.y, underwater) * (1 - localParams.mask.x);
	float deep = (deepMask - HALF) * 20.0;

	deep += wave_displace.y;
	water_displace.y = deep > 0 ? max(water_displace.y, -deep) : 0;

	float sm = abs(sigmoid(deep, 0.1));	// abs of sigmoid
	water_displace.y *= sm;

	//	water_displace *= exp(-d*0.0005);
	float stockDisplaceFade = waterDisplaceFade(d);
	water_displace *= stockDisplaceFade;
#if USE_WIND_DISPLACEMENT_SWELL
	float extendedSwellFade = windSwellDisplaceFade(d);
	float3 windSwellTail = windSwellDisplace * max(extendedSwellFade - stockDisplaceFade, 0.0);

	// Apply the shoreline suppression to the tail, retain its lateral motion
	// only in safely deep water, and clamp the final result above the seabed.
	windSwellTail.y *= sm;
	windSwellTail.xz *= smoothstep(
		WIND_SWELL_TAIL_CHOP_DEPTH.x,
		WIND_SWELL_TAIL_CHOP_DEPTH.y,
		max(deep, 0.0));
	water_displace += windSwellTail;
	water_displace.y = deep > 0 ? max(water_displace.y, -deep) : 0;
#endif

	water_displace.xz *= smoothstep(0.0, 8.0, d);
	return water_displace;
}

float3 calculateWaterDisplace(float3 wpos, uniform bool useTilingMask) {
	WaterLocalParams localParams = getWaterLocalParams(wpos);
	return calculateWaterDisplace(wpos, localParams, useTilingMask);
}

GBufferWater buildGBuffer(float3 wpos, float3 stableWpos, float2 stableWaterPos, float4 NDCpos, uniform bool useFoamFFT, uniform bool useTilingMask, uniform bool useWaveMap) {

	float2 uv = NDCpos2uv(NDCpos);

	// Anchor coastal opacity, depth, flow, and breaking-wave data to the
	// undisplaced grid so a displacement LOD change cannot move the shoreline.
	WaterLocalParams localParams = getWaterLocalParams(stableWpos);

	// Use the undisplaced domain coordinate for all procedural surface normals.
	// It interpolates identically at every tessellation factor, avoiding a normal
	// phase jump when the displaced mesh changes vertex density.
	float2 wpos2 = stableWaterPos;

#if USE_PS_MASK_DISCARD
	if (useWaveMap) {
		if (!any(localParams.wave.xyz))
			discard;
	}
#endif

	float2 flow = decodeFlow(localParams.flow);
	float4 result = CombineWaterCommon(wpos2, flow, localParams.flow.x, useTilingMask, true, useFoamFFT);
	// result.xy - normal.xz
	// result.z	 - displace.y
	// result.w  - foam

	float wLevel = result.z;
	float3 normal = restoreNormal(result.xy);
	float fftFoam = useFoamFFT ? saturate(result.w) : 0.0;
	float whitecapWind = 0.0;
	float whitecapSea = 0.0;
	float2 swellSlope = 0.0;
	float2 swellNormalLod = windSwellNormalLodWeights(wpos2);

#if USE_WIND_DISPLACEMENT_SWELL
	{
		WindSwellSample swell = sampleWindSwell(wpos2, localParams.mask);
		swellSlope += normalToSlope(swell.normal) * (swellNormalLod.x * WIND_SWELL_NORMAL_GAIN);
	}
#endif

#if USE_FFT_NORMAL_SWELL
	swellSlope += normalToSlope(fftNormalSwellFarNormal(wpos2, localParams.mask, swellNormalLod.y));
#endif

#if USE_FFT_SCALED_NORMAL_SWELL
	swellSlope += normalToSlope(fftScaledNormalSwellNormal(wpos2, localParams.mask, wLevel));
#endif

	normal = slopeToNormal(normalToSlope(normal) + swellSlope);

	float foam = 0;
	float openWaterFoam = 0;
	float coastalFoam = 0;
	float fftNormalY = normal.y;
	if (useFoamFFT) {	// calculate foam
		whitecapWind = saturate((g_WindForce - FFT_WHITECAP_WIND_START) / max(FFT_WHITECAP_WIND_FULL - FFT_WHITECAP_WIND_START, 1e-4));
		whitecapWind = pow(whitecapWind, FFT_WHITECAP_WIND_POWER);
		float waveHeight = saturate(abs(wLevel - 0.5) * FFT_WHITECAP_WAVE_HEIGHT_GAIN);
		float waveSteepness = saturate((1.0 - fftNormalY) * FFT_WHITECAP_WAVE_STEEPNESS_GAIN);
		whitecapSea = pow(saturate(max(waveHeight, waveSteepness)), FFT_WHITECAP_WAVE_POWER);
		whitecapSea = max(whitecapSea, whitecapWind * FFT_WHITECAP_SEA_FLOOR_FROM_WIND);
		openWaterFoam = pow(fftFoam, 1.00) * FFT_WHITECAP_GAIN * whitecapWind * whitecapSea;
	}

	if (useWaveMap) {
		float3 n = decodeNormal(localParams.wave);
		normal = addNormal(normal, n);
		coastalFoam = saturate(localParams.wave.w * COASTAL_FOAM_OPACITY) * COASTAL_FOAM_BRIGHTNESS;
		float displaceY = n.y * ((localParams.wave.z - 0.5) * 10);
		wLevel = saturate(((wLevel - 0.5) * 8 + displaceY) * 0.125 + 0.5);	// repack wLevel	// WTF?
	}

	// sample detailed foam texture
	{
		float foamScale = FFT_WHITECAP_TEXTURE_SCALE_BASE * lerp(1.0, 1.0 + FFT_WHITECAP_TEXTURE_SCALE_WIND, whitecapWind);
		float2 foamWorldPos = waterStableWorldXZ(wpos2);
		float2 windDir = fftNormalSwellWindAlignedDir();
		float2 crossDir = float2(-windDir.y, windDir.x);
		float along = dot(foamWorldPos, windDir);
		float across = dot(foamWorldPos, crossDir);
		float alongScale = foamScale * lerp(1.0, 1.0 + 0.25 * (FFT_WHITECAP_TEXTURE_ANISO - 1.0), whitecapWind);
		float acrossScale = foamScale / lerp(1.0, FFT_WHITECAP_TEXTURE_ANISO, whitecapWind);
		float foamDriftSpeed = FFT_WHITECAP_DRIFT_BASE + g_WindForce * FFT_WHITECAP_DRIFT_WIND_SCALE + whitecapSea * FFT_WHITECAP_DRIFT_WAVE_SCALE;
		along -= g_Time * foamDriftSpeed;
		float2 uvUnwrapped = float2(along * alongScale, across * acrossScale);
		float2 uv = waterStableWrapUV(uvUnwrapped);

#if USE_FLOW_MAP
		float2 foamFlow = float2(dot(flow, windDir) * alongScale, dot(flow, crossDir) * acrossScale);
		FlowParams fp = calcFlowParams(uv, foamFlow, 0.25, false);
		float2 _ddx = ddx(uvUnwrapped);
		float2 _ddy = ddy(uvUnwrapped);
#if WATER_STABLE_FFT_SAMPLING
		float f0 = sampleWaterFoamMaskStable(waterStableWrapUV(uvUnwrapped + fp.offset0), foamWorldPos, foamScale, _ddx, _ddy);
		float f1 = sampleWaterFoamMaskStable(waterStableWrapUV(uvUnwrapped + fp.offset1), foamWorldPos, foamScale, _ddx, _ddy);
#else
		StochasticUV s = stochasicUV(uv);
		float f0 = dot(stochasticSampleGrad(foamTexture, gAnisotropicWrapSampler, s, _ddx, _ddy, fp.offset0).xyz, LUM);
		float f1 = dot(stochasticSampleGrad(foamTexture, gAnisotropicWrapSampler, s, _ddx, _ddy, fp.offset1).xyz, LUM);
#endif
		float f = lerp(f0, f1, fp.lerpFlow);
#else
#if WATER_STABLE_FFT_SAMPLING
		float2 _ddx = ddx(uvUnwrapped);
		float2 _ddy = ddy(uvUnwrapped);
		float f = sampleWaterFoamMaskStable(uv, foamWorldPos, foamScale, _ddx, _ddy);
#else
		float f = dot(stochasticSample(foamTexture, gAnisotropicWrapSampler, uv).xyz, LUM);
#endif
#endif
//		foam *= pow(f, 2 - foam) * 2;
		float coastalFoamMask = lerp(COASTAL_FOAM_TEXTURE_FLOOR, 1.0, pow(saturate(f), COASTAL_FOAM_TEXTURE_POWER));
		coastalFoam = saturate(coastalFoam * coastalFoamMask);

		float foamPattern = pow(saturate(f), FFT_WHITECAP_TEXTURE_MASK_POWER);
		float foamTextureMask = max(foamPattern, FFT_WHITECAP_TEXTURE_FLOOR);
		openWaterFoam = saturate(foamTextureMask * openWaterFoam * FFT_WHITECAP_BRIGHTNESS * FFT_WHITECAP_OPACITY);
		float3 viewVec = gCameraPos - wpos;
		float3 viewDir = viewVec * rsqrt(max(dot(viewVec, viewVec), 1e-8));
		float viewGrazing = saturate(1.0 - abs(viewDir.y));
		openWaterFoam = saturate(openWaterFoam * lerp(1.0, FFT_WHITECAP_GRAZING_BOOST, viewGrazing));
	}
	foam = saturate(openWaterFoam + coastalFoam);

	float water_depth = calcWaterDepth(wpos, uv);
	float deepFactor = calcWaterDeepFactor(water_depth, 0);
	float alpha = saturate(pow(saturate(1.0 - localParams.mask.x), WATER_OPACITY_MASK_POWER) * WATER_OPACITY_GAIN);

	normal = mul(normal, (float3x3)gLocalInv); // TODO: GEOTERRAIN spherify normals

	return BuildGBufferWater(normal, wLevel, foam, deepFactor, NDCpos, 0, alpha);
}

#endif
