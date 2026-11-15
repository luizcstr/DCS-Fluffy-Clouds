#include "FFT_512.hlsl"

RWTexture2D<float> u_Phase;
RWTexture2DArray<float4> u_Normal;
Texture2DArray<float> u_WindMap;

Texture2DArray<float4> u_NormalRead;
#define u_WindMapWrite u_Phase		// reuse phase texture

float u_windmapLerp;

float2 u_wind;
uint u_resolution;
float u_size;
float u_deltaTime;
float u_choppiness;

static const float G = 9.81;
static const float KM = 370.0;
static const float CM = 0.23;


#ifndef WATER_FFT_CREST_SPACING_SCALE
#define WATER_FFT_CREST_SPACING_SCALE 1.70
#endif

#ifndef WATER_FFT_AMPLITUDE_SCALE
#define WATER_FFT_AMPLITUDE_SCALE 2.25
#endif

#ifndef WATER_FFT_NORMAL_STRENGTH
#define WATER_FFT_NORMAL_STRENGTH 1.60
#endif

#ifndef WATER_FFT_FOAM_CURVATURE_THRESHOLD
#define WATER_FFT_FOAM_CURVATURE_THRESHOLD 0.01
#endif

#ifndef WATER_FFT_FOAM_WIND_START
#define WATER_FFT_FOAM_WIND_START 1.0
#endif

#ifndef WATER_FFT_FOAM_WIND_FULL
#define WATER_FFT_FOAM_WIND_FULL 11.8
#endif

#ifndef WATER_FFT_FOAM_WIND_POWER
#define WATER_FFT_FOAM_WIND_POWER 1.00
#endif

#ifndef WATER_FFT_FOAM_WAVE_ENERGY_GAIN
#define WATER_FFT_FOAM_WAVE_ENERGY_GAIN 1.60
#endif

#ifndef WATER_FFT_MAX_PHASE_DELTA_TIME
#define WATER_FFT_MAX_PHASE_DELTA_TIME 0.0333333
#endif


#ifndef WATER_FFT_DOWNWIND_ENERGY
#define WATER_FFT_DOWNWIND_ENERGY 1.8 // 1.4
#endif

#ifndef WATER_FFT_CROSSWIND_ENERGY
#define WATER_FFT_CROSSWIND_ENERGY 0.35
#endif

#ifndef WATER_FFT_UPWIND_ENERGY
#define WATER_FFT_UPWIND_ENERGY 0.003
#endif

#ifndef WATER_FFT_DIRECTIONAL_FLOOR
#define WATER_FFT_DIRECTIONAL_FLOOR 0.005
#endif


static const float4 WINDMAP_CAPTURE_PRESET      = float4(0.34, 0.22, 1.08, 1.22); // sharpen, captureDirectional, captureGain, broadGain
static const float4 WINDMAP_DETAIL_PRESET       = float4(0.10, 0.34, 0.74, 0.26); // macroContrast, detailGain, directionalGain, foamGain

// Legacy aliases.
#define WINDMAP_CAPTURE_SHARPEN      WINDMAP_CAPTURE_PRESET.x
#define WINDMAP_CAPTURE_DIRECTIONAL  WINDMAP_CAPTURE_PRESET.y
#define WINDMAP_CAPTURE_GAIN         WINDMAP_CAPTURE_PRESET.z
#define WINDMAP_BROAD_GAIN           WINDMAP_CAPTURE_PRESET.w
#define WINDMAP_MACRO_CONTRAST       WINDMAP_DETAIL_PRESET.x
#define WINDMAP_DETAIL_GAIN          WINDMAP_DETAIL_PRESET.y
#define WINDMAP_DIRECTIONAL_GAIN     WINDMAP_DETAIL_PRESET.z
#define WINDMAP_FOAM_GAIN            WINDMAP_DETAIL_PRESET.w


static const float4 WINDMAP_VISIBILITY_TUNE       = float4(1.00, 1.00, 0.95, 1.00); // stableStructure, captureStructure, finalVisibility, periodicRidge

static const float WINDMAP_TILE_BLEND_MARGIN      = 0.10;

#define WINDMAP_STABLE_STRUCTURE_GAIN  WINDMAP_VISIBILITY_TUNE.x
#define WINDMAP_CAPTURE_STRUCTURE_GAIN WINDMAP_VISIBILITY_TUNE.y
#define WINDMAP_FINAL_VISIBILITY_GAIN  WINDMAP_VISIBILITY_TUNE.z
#define WINDMAP_PERIODIC_RIDGE_GAIN    WINDMAP_VISIBILITY_TUNE.w


#ifndef WATER_WINDMAP_TILE_TUNE
#define WATER_WINDMAP_TILE_TUNE 2.0
#endif

float waterFFTSize() {
	// Keep domain size bound to engine-provided u_size.
	return max(1.0, u_size);
}

float3 tuneFFTNormal(float3 n) {
	return normalize(float3(n.x * WATER_FFT_NORMAL_STRENGTH, max(n.y, 1e-4), n.z * WATER_FFT_NORMAL_STRENGTH));
}

float square(float x) {
	return x * x;
}

float omega(float k) {
	return sqrt(G * k * (1.0 + square(k / KM)));
}

float tanh(float x) {
	return (1.0 - exp(-2.0 * x)) / (1.0 + exp(-2.0 * x));
}

float rand(float2 co) {  
	return frac(sin(dot(co.xy, float2(12.9898,78.233))) * 43758.5453);
}

float2 multiplyComplex(float2 a, float2 b) {
	return float2(a[0] * b[0] - a[1] * b[1], a[1] * b[0] + a[0] * b[1]);
}

float2 multiplyByI(float2 z) {
	return float2(-z[1], z[0]);
}

float spectrumInit(float2 coordinates) {
	float n = (coordinates.x < u_resolution * 0.5) ? coordinates.x : coordinates.x - u_resolution;
	float m = (coordinates.y < u_resolution * 0.5) ? coordinates.y : coordinates.y - u_resolution;
	float2 waveVector = (2.0 * PI * float2(n, m)) / waterFFTSize();
	float k = length(waveVector) + 1e-9;

	float windSpeed = length(u_wind);
	float U10 = max(windSpeed, 0.1);

	float Omega = 0.84;
	// Larger crestSpacingScale shifts kp lower, widening crest spacing.
	float crestSpacingScale = max(WATER_FFT_CREST_SPACING_SCALE, 0.1);
	float kp = G * square(Omega / U10) / crestSpacingScale;

	float c = omega(k) / k;
	float cp = omega(kp) / kp;

	float Lpm = exp(-1.25 * square(kp / k));
	float gamma = 1.7;
	float sigma = 0.08 * (1.0 + 4.0 * pow(Omega, -3.0));
	float Gamma = exp(-square(sqrt(k / kp) - 1.0) / (2.0 * square(sigma)));
	float Jp = pow(gamma, Gamma);
	float Fp = Lpm * Jp * exp(-Omega / sqrt(10.0) * (sqrt(k / kp) - 1.0));
	float alphap = 0.006 * sqrt(Omega);
	float Bl = 0.5 * alphap * cp / c * Fp;

	float z0 = 0.000037 * square(U10) / G * pow(U10 / cp, 0.9);
	float uStar = 0.41 * U10 / log(10.0 / z0);
	float alpham = 0.01 * ((uStar < CM) ? (1.0 + log(uStar / CM)) : (1.0 + 3.0 * log(uStar / CM)));
	float Fm = exp(-0.25 * square(k / KM - 1.0));
	float Bh = 0.5 * alpham * CM / c * Fm * Lpm;

	float a0 = log(2.0) / 4.0;
	float am = 0.13 * uStar / CM;
	float Delta = tanh(a0 + 4.0 * pow(c / cp, 2.5) + am * pow(CM / c, 2.5));

	float2 windDir = (windSpeed > 1e-5) ? (u_wind / windSpeed) : float2(1.0, 0.0);
	float cosPhi = dot(windDir, waveVector / k);

	// Downwind-biased directional spread with tunable cross/upwind energy.
	float downwind = WATER_FFT_DOWNWIND_ENERGY * pow(saturate(cosPhi), 2.0);
	float crosswind = WATER_FFT_CROSSWIND_ENERGY * pow(saturate(1.0 - abs(cosPhi)), 1.5);
	float upwind = WATER_FFT_UPWIND_ENERGY * pow(saturate(-cosPhi), 2.0);
	float directionalSpread = max(WATER_FFT_DIRECTIONAL_FLOOR, lerp(1.0, downwind + crosswind + upwind, saturate(Delta)));

	float S = (1.0 / (2.0 * PI)) * pow(k, -4.0) * (Bl + Bh) * directionalSpread;

	float dk = 2.0 * PI / waterFFTSize();
	float crestSpacingAmplitudeCompensation = 0.85 / crestSpacingScale;
	return sqrt(S / 2.0) * dk * crestSpacingAmplitudeCompensation * WATER_FFT_AMPLITUDE_SCALE;
}

[numthreads(32, 32, 1)]
void CS_PHASE(uint2 coordinates : SV_DispatchThreadId) {
	u_Phase[coordinates] = rand(coordinates / float(u_resolution)) * 2.0 * PI;
}

[numthreads(32, 32, 1)]
void CS_SPECTRUM(uint2 coordinates : SV_DispatchThreadId) {

	float n = (coordinates.x < float(u_resolution) * 0.5) ? coordinates.x : coordinates.x - float(u_resolution);
	float m = (coordinates.y < float(u_resolution) * 0.5) ? coordinates.y : coordinates.y - float(u_resolution);
	float2 waveVector = (2.0 * PI * float2(n, m)) / waterFFTSize();

	float phase;
	{	// update phase
		phase = u_Phase[coordinates.xy];
		float phaseDeltaTime = clamp(u_deltaTime, 0.0, WATER_FFT_MAX_PHASE_DELTA_TIME);
		float deltaPhase = omega(length(waveVector)) * phaseDeltaTime;
		phase = fmod(phase + deltaPhase, 2.0 * PI);
		u_Phase[coordinates.xy] = phase;
	}
	{	// update spectrum
		float2 phaseVector = float2(cos(phase), sin(phase));

		float2 h0 = spectrumInit(coordinates.xy);
		float2 h0Star = spectrumInit(u_resolution - coordinates.xy);
		h0Star.y *= -1.0;

		float2 h = multiplyComplex(h0, phaseVector) + multiplyComplex(h0Star, float2(phaseVector.x, -phaseVector.y));

		float rwv = 1.0 / (length(waveVector) + 1e-9);
		float2 hX = -multiplyByI(h * waveVector.x * rwv) * u_choppiness;
		float2 hZ = -multiplyByI(h * waveVector.y * rwv) * u_choppiness;

		hX = hX + multiplyByI(h);
	
		u_FFT[uint3(coordinates.xy, 0)] = hX;
		u_FFT[uint3(coordinates.xy, 1)] = hZ;
	}
}

float3 get_displace(int2 coordinates) {
	coordinates = (-coordinates + u_resolution*2) % u_resolution;
	float2 hX = u_FFT[uint3(coordinates, 0)];
	float2 hZ = u_FFT[uint3(coordinates, 1)];
	return float3(hX.x, (hX.y + hZ.y)*0.5, hZ.x);
}

float2 safeNormalizeWind(float2 v) {
	return v * rsqrt(max(dot(v, v), 1e-6));
}

float signPreservingContrast(float v, float contrast) {
	return v * (1.0 + contrast * saturate(abs(v)));
}

float crestResponse(float x, float gain) {
	// Fast saturating response.
	float v = max(x, 0.0) * gain;
	return saturate(v / (1.0 + v));
}

float windMapSmooth01(float x) {
	x = saturate(x);
	return x * x * (3.0 - 2.0 * x);
}

float windMapPatchBlend(float windSpeed) {
	// Low-wind patch layer weight.
	return 1.0 - windMapSmooth01((windSpeed - 0.30) * (1.0 / 2.35));
}

float windMapStreakBlend(float windSpeed) {
	// Streak/lane layer weight.
	return windMapSmooth01((windSpeed - 0.35) * (1.0 / 2.85));
}

float windMapHighWindBlend(float windSpeed) {
	// High-wind mode weight.
	return windMapSmooth01((windSpeed - 0.70) * (1.0 / 3.10));
}

float windMapHash21(float2 p) {
	// Fast deterministic hash for breakup noise.
	float3 p3 = frac(float3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return frac((p3.x + p3.y) * p3.z);
}

float windMapValueNoise(float2 p) {
	float2 i = floor(p);
	float2 f = frac(p);
	f = f * f * (3.0 - 2.0 * f);

	float a = windMapHash21(i);
	float b = windMapHash21(i + float2(1.0, 0.0));
	float c = windMapHash21(i + float2(0.0, 1.0));
	float d = windMapHash21(i + float2(1.0, 1.0));

	return lerp(lerp(a, b, f.x), lerp(c, d, f.x), f.y);
}

float windMapSignedNoise(float2 p) {
	return windMapValueNoise(p) * 2.0 - 1.0;
}

float windMapRidgedNoise(float2 p) {
	float n = windMapValueNoise(p) * 2.0 - 1.0;
	return 1.0 - abs(n);
}

float windMapStablePatchField(int2 coordinates, float2 windDir, float windSpeed) {
	// Stable patch/gust envelope in FFT-space.
	float2 uv = (float2(coordinates) + 0.5) / max(float(u_resolution), 1.0) - 0.5;
	float windLen2 = dot(windDir, windDir);
	windDir = (windLen2 < 0.25) ? float2(1.0, 0.0) : windDir * rsqrt(max(windLen2, 1e-6));
	float2 crossDir = float2(-windDir.y, windDir.x);
	float along = dot(uv, windDir);
	float across = dot(uv, crossDir);
	float hi = windMapHighWindBlend(windSpeed);

	float2 p0 = float2(across * 5.2 + along * 0.55, along * 2.5 - across * 0.22);
	float2 p1 = float2(across * 10.4 - along * 0.30, along * 4.7 + across * 0.40);
	float2 p2 = float2(across * 19.0 + along * 0.15, along * 8.3 - across * 0.20);

	float broad  = windMapSignedNoise(p0 + float2(14.1, 91.7));
	float medium = windMapSignedNoise(p1 + float2(73.4, 22.9));
	float fine   = windMapSignedNoise(p2 + float2(181.2, 41.6));
	float gust   = windMapSignedNoise(float2(across * 3.6 - along * 0.70, along * 2.0 + across * 0.45) + float2(9.7, 61.3));
	float pockets = windMapRidgedNoise(float2(across * 8.8 + along * 1.25, along * 3.8 - across * 0.55) + float2(45.2, 17.9));
	float pawLobes = saturate((pockets - 0.22) * 1.35);

	// Keep patches at high wind as uneven lane energy.
	float cells = broad * lerp(0.62, 0.30, hi) + medium * lerp(0.30, 0.42, hi) + fine * lerp(0.08, 0.18, hi);
	cells *= lerp(0.80, 0.56, hi) + gust * 0.20 + pawLobes * 0.36;
	cells += (pawLobes * 2.0 - 1.0) * 0.14;
	return cells;
}

float windMapSignedStreakField(int2 coordinates, float2 windDir, float windSpeed) {
	// Mixed streak field with patch-modulated anisotropy.
	float2 uv = (float2(coordinates) + 0.5) / max(float(u_resolution), 1.0) - 0.5;
	float windLen2 = dot(windDir, windDir);
	windDir = (windLen2 < 0.25) ? float2(1.0, 0.0) : windDir * rsqrt(max(windLen2, 1e-6));
	float2 crossDir = float2(-windDir.y, windDir.x);
	float along = dot(uv, windDir);
	float across = dot(uv, crossDir);
	float st = windMapStreakBlend(windSpeed);
	float hi = windMapHighWindBlend(windSpeed);

	// Large, slow domain warp to avoid ruler-straight lanes.
	float patch = windMapStablePatchField(coordinates, windDir, windSpeed);
	float warpCross = patch * lerp(0.038, 0.026, hi);
	warpCross += windMapSignedNoise(float2(across * 13.0 + along * 1.30, along * 4.0 - across * 0.40) + float2(71.1, 13.7)) * lerp(0.016, 0.012, hi);
	float warpAlong = windMapSignedNoise(float2(along * 4.2 + across * 0.85, across * 5.1) + float2(29.5, 83.4)) * lerp(0.034, 0.024, hi);

	float ac = across + warpCross;
	float al = along + warpAlong;
	float freqJitter = 1.0 + windMapSignedNoise(float2(across * 4.4 + along * 0.85, along * 3.1 - across * 0.35) + float2(33.9, 72.4)) * 0.20;
	float laneShift = windMapSignedNoise(float2(across * 6.6 - along * 1.7, along * 2.8 + across * 0.95) + float2(118.2, 11.6)) * lerp(0.020, 0.048, st);
	ac += laneShift;
	al += laneShift * 0.35;

	// Moderate anisotropy with lower frequencies to reduce shimmer.
	float crossA = lerp(18.0, 44.0, st) * freqJitter;
	float crossB = lerp(34.0, 78.0, st) * (1.0 + (freqJitter - 1.0) * 0.72);
	float crossC = lerp(62.0, 138.0, st) * (1.0 - (freqJitter - 1.0) * 0.44);
	float longA  = lerp(4.2, 3.2, hi);
	float longB  = lerp(7.6, 5.6, hi);
	float longC  = lerp(12.0, 9.5, hi);

	float laneA = windMapSignedNoise(float2(ac * crossA, al * longA) + float2(11.2, 5.7));
	float laneB = windMapSignedNoise(float2(ac * crossB + laneA * 0.35, al * longB) + float2(43.8, 91.6));
	float laneC = windMapSignedNoise(float2(ac * crossC + laneB * 0.22, al * longC) + float2(87.4, 33.1));

	float ridgeA = windMapRidgedNoise(float2(ac * lerp(45.0, 95.0, st), al * lerp(3.5, 6.0, st)) + float2(8.8, 144.2));
	float ridgeB = windMapRidgedNoise(float2(ac * lerp(90.0, 180.0, st), al * lerp(6.5, 11.0, st)) + float2(201.5, 62.7));
	float ridge = (ridgeA * 0.58 + ridgeB * 0.42) * 2.0 - 1.0;
	float patchPockets = windMapRidgedNoise(float2(ac * 11.0 - al * 0.70, al * 4.7 + ac * 0.22) + float2(67.1, 24.8));

	// Patch envelope prevents evenly spaced repeating lanes.
	float envelopeBase = saturate(0.50 + patch * 0.37 + windMapSignedNoise(float2(ac * 7.5 - al * 0.55, al * 5.0) + float2(55.3, 19.8)) * 0.22);
	float envelope = saturate(envelopeBase * lerp(0.76, 1.22, patchPockets));
	float lanes = (laneA * 0.24 + laneB * 0.23 + laneC * 0.15 + ridge * 0.14 + patch * 0.24) * envelope;

	// Keep some patch contribution at high wind.
	float mixed = lerp(patch * 0.78 + lanes * 0.22, lanes * 0.60 + patch * 0.40, st);
	return mixed * lerp(0.30, 0.72, st);
}

float windMapTileEdgeBlend(float uvCentered) {
	// Edge ramp used for seamless tiled cross-fade.
	float tileBlendMargin = saturate(WINDMAP_TILE_BLEND_MARGIN * max(WATER_WINDMAP_TILE_TUNE, 0.0));
	tileBlendMargin = clamp(tileBlendMargin, 0.01, 0.45);
	float t = uvCentered + 0.5;
	return windMapSmooth01((t - (1.0 - tileBlendMargin)) / max(tileBlendMargin, 1e-4));
}

float windMapStablePatchFieldTiled(int2 coordinates, float2 windDir, float windSpeed, int res) {
	// Tile the non-periodic patch field via toroidal edge cross-fade.
	float2 uv = (float2(coordinates) + 0.5) / max(float(res), 1.0) - 0.5;
	float bx = windMapTileEdgeBlend(uv.x);
	float by = windMapTileEdgeBlend(uv.y);
	float a00 = windMapStablePatchField(coordinates, windDir, windSpeed);
	if (bx <= 0.0 && by <= 0.0)
		return a00;
	float a10 = windMapStablePatchField(coordinates + int2(-res, 0), windDir, windSpeed);
	float a01 = windMapStablePatchField(coordinates + int2(0, -res), windDir, windSpeed);
	float a11 = windMapStablePatchField(coordinates + int2(-res, -res), windDir, windSpeed);
	return lerp(lerp(a00, a10, bx), lerp(a01, a11, bx), by);
}

float windMapSignedStreakFieldTiled(int2 coordinates, float2 windDir, float windSpeed, int res) {
	// Toroidal edge cross-fade for streak field.
	float2 uv = (float2(coordinates) + 0.5) / max(float(res), 1.0) - 0.5;
	float bx = windMapTileEdgeBlend(uv.x);
	float by = windMapTileEdgeBlend(uv.y);
	float a00 = windMapSignedStreakField(coordinates, windDir, windSpeed);
	if (bx <= 0.0 && by <= 0.0)
		return a00;
	float a10 = windMapSignedStreakField(coordinates + int2(-res, 0), windDir, windSpeed);
	float a01 = windMapSignedStreakField(coordinates + int2(0, -res), windDir, windSpeed);
	float a11 = windMapSignedStreakField(coordinates + int2(-res, -res), windDir, windSpeed);
	return lerp(lerp(a00, a10, bx), lerp(a01, a11, bx), by);
}



[numthreads(32, 32, 1)]
void CS_NORMAL(int2 coordinates : SV_DispatchThreadId) {

	float texelSize = waterFFTSize() / u_resolution;

	float3 center = get_displace(coordinates);
	float3 dispXP = get_displace(coordinates + int2( 1, 0));
	float3 dispXN = get_displace(coordinates + int2(-1, 0));
	float3 dispYP = get_displace(coordinates + int2( 0, 1));
	float3 dispYN = get_displace(coordinates + int2( 0,-1));

	float3 dx = float3(texelSize, 0, 0) + dispXP - center;
	float3 dy = float3(0, 0, texelSize) + dispYP - center;
	float3 normal = normalize(cross(dy, dx));
	if (normal.y < 0.0)
		normal = -normal;
	normal = tuneFFTNormal(normal);

	int tx = 30; // gDev0.x;  broad crest stencil (dominant wave scale)
	float3 wXP = get_displace(int2(coordinates) + int2( tx, 0));
	float3 wXN = get_displace(int2(coordinates) + int2(-tx, 0));
	float3 wYP = get_displace(int2(coordinates) + int2( 0, tx));
	float3 wYN = get_displace(int2(coordinates) + int2( 0,-tx));

	// Whitecap source from displacement curvature, gated by crest/wind energy.
	float fx1 = wXP.z - center.z;
	float fx2 = wXN.z - center.z;
	float fy1 = wYP.z - center.z;
	float fy2 = wYN.z - center.z;
	float foamCurvature = -fx1 - fx2 - fy1 - fy2;
	float windSpeed = length(u_wind);
	float foamWind = saturate((windSpeed - WATER_FFT_FOAM_WIND_START) / max(WATER_FFT_FOAM_WIND_FULL - WATER_FFT_FOAM_WIND_START, 1e-4));
	foamWind = pow(foamWind, WATER_FFT_FOAM_WIND_POWER);
	float waveEnergy = (abs(dispXP.y - dispXN.y) + abs(dispYP.y - dispYN.y)) * WATER_FFT_FOAM_WAVE_ENERGY_GAIN;
	float crestHeight = max(center.y, 0);
	float foamSource = max(foamCurvature - WATER_FFT_FOAM_CURVATURE_THRESHOLD, 0);
	float foam = foamSource * saturate(crestHeight + waveEnergy) * foamWind * (u_resolution / 256.0 * 0.05); // gDev0.y;

	float c0 = u_WindMap[uint3(coordinates, 0)];
	float c1 = u_WindMap[uint3(coordinates, 1)];
	float mul = 1.5 - abs(u_windmapLerp - 0.5);
	float windMapBase = lerp(c0, c1, u_windmapLerp) * mul;

	// Multi-scale wind-map shaping from slope, curvature, and foam cues.
	float2 windDir = safeNormalizeWind(u_wind);
	float2 crossDir = float2(-windDir.y, windDir.x);
	float2 heightGradient = float2(dx.y, dy.y);
	float windSlope = abs(dot(heightGradient, windDir));
	float crossSlope = abs(dot(heightGradient, crossDir));
	float laplaceY = abs(dispXP.y + dispXN.y + dispYP.y + dispYN.y - center.y * 4.0);

	float localSlope = abs(dx.y) + abs(dy.y);
	windSpeed = length(u_wind);
	float patchBlend = windMapPatchBlend(windSpeed);
	float streakBlend = windMapStreakBlend(windSpeed);
	float highWindBlend = windMapHighWindBlend(windSpeed);
	float slopeDetail = crestResponse(localSlope * 0.55 + (1.0 - saturate(normal.y)) * 3.5, 0.85);
	float directionalDetail = crestResponse(windSlope * 1.65 + crossSlope * 0.30 + laplaceY * 0.35, 0.95);
	float foamDetail = saturate(foam * 1.95);
	float streakAniso = saturate(windSlope / (windSlope + crossSlope + 1e-3));
	int windRes = int(u_resolution);
	float patchField = windMapStablePatchFieldTiled(coordinates, crossDir, windSpeed, windRes);
	float streakField = windMapSignedStreakFieldTiled(coordinates, crossDir, windSpeed, windRes);

	// Wind-speed shaping: low wind favors broad patches, high wind favors streaks.
	float patchWeight = patchBlend * patchBlend * (1.0 - highWindBlend * 0.65);
	float broadGain = WINDMAP_BROAD_GAIN * lerp(0.82, 0.018, highWindBlend);
	float broadContrast = WINDMAP_MACRO_CONTRAST * lerp(0.85, 0.025, highWindBlend);
	float calmPatchDetail = crestResponse(abs(windMapBase) * 0.62 + (localSlope + laplaceY) * 0.045, 0.42) * patchWeight;

	// Keep animated FFT ridges subtle; stable fields carry the main structure.
	float shimmerDamp = lerp(0.78, 0.32, highWindBlend);
	float highStreakDetail = crestResponse(windSlope * 2.15 + crossSlope * 0.12 + laplaceY * 0.30 + localSlope * 0.08, 0.92)
		* lerp(0.30, 1.10, streakAniso) * streakBlend * shimmerDamp;

	// Blend broad macro with stable patch/streak and periodic FFT ridge terms.
	float macro = signPreservingContrast(windMapBase * broadGain, broadContrast) * patchWeight * lerp(0.72, 0.030, highWindBlend);
	float stableWindStructure = lerp(patchField * 0.70 + streakField * 0.28, streakField * 0.50 + patchField * 0.50, streakBlend);
	float analyticStreaks = stableWindStructure * (WINDMAP_DIRECTIONAL_GAIN * lerp(0.95, 3.10, highWindBlend) + highWindBlend * 0.245) * WINDMAP_STABLE_STRUCTURE_GAIN;
	float fineLaneLift = (streakField * 0.5 + 0.5) * crestResponse(windSlope * 0.65 + laplaceY * 0.16, 0.48) * streakBlend * highWindBlend;
	float periodicRidgeStructure = signPreservingContrast((windSlope * 0.62 + crossSlope * 0.36 + laplaceY * 0.18 + localSlope * 0.08) * WINDMAP_PERIODIC_RIDGE_GAIN, 0.16) * lerp(0.18, 0.56, streakBlend);
	float windMap = macro
		+ calmPatchDetail * (WINDMAP_DETAIL_GAIN * 0.18 + 0.004)
		+ slopeDetail * WINDMAP_DETAIL_GAIN * lerp(0.22, 0.38, highWindBlend) * shimmerDamp
		+ directionalDetail * WINDMAP_DIRECTIONAL_GAIN * lerp(0.30, 1.25, streakBlend) * shimmerDamp
		+ highStreakDetail * (WINDMAP_DIRECTIONAL_GAIN * 1.05 + 0.055)
		+ periodicRidgeStructure
		+ analyticStreaks
		+ fineLaneLift * (WINDMAP_DIRECTIONAL_GAIN * 0.38 + 0.030)
		+ foamDetail * WINDMAP_FOAM_GAIN * lerp(0.12, 0.50, streakBlend);

	windMap = signPreservingContrast(windMap * WINDMAP_FINAL_VISIBILITY_GAIN, lerp(0.16, 0.46, streakBlend));

	u_Normal[uint3(coordinates, 0)] = float4(normal.xz, center.y * 0.25, saturate(foam)); // normal + foam
	u_Normal[uint3(coordinates, 1)] = float4(center, windMap); // displace + enhanced wind map
}

[numthreads(32, 32, 1)]
void CS_WIND_MAP_SHOT(uint2 coordinates : SV_DispatchThreadId) {
	// Capture displacement-derived wind map and reshape by wind speed.
	uint2 e   = uint2((coordinates.x + 1) % u_resolution, coordinates.y);
	uint2 w   = uint2((coordinates.x + u_resolution - 1) % u_resolution, coordinates.y);
	uint2 n   = uint2(coordinates.x, (coordinates.y + 1) % u_resolution);
	uint2 s   = uint2(coordinates.x, (coordinates.y + u_resolution - 1) % u_resolution);
	uint2 e2  = uint2((coordinates.x + 2) % u_resolution, coordinates.y);
	uint2 w2  = uint2((coordinates.x + u_resolution - 2) % u_resolution, coordinates.y);
	uint2 n2  = uint2(coordinates.x, (coordinates.y + 2) % u_resolution);
	uint2 s2  = uint2(coordinates.x, (coordinates.y + u_resolution - 2) % u_resolution);
	float center = u_NormalRead[uint3(coordinates, 1)].x;
	float vE = u_NormalRead[uint3(e, 1)].x;
	float vW = u_NormalRead[uint3(w, 1)].x;
	float vN = u_NormalRead[uint3(n, 1)].x;
	float vS = u_NormalRead[uint3(s, 1)].x;
	float vE2 = u_NormalRead[uint3(e2, 1)].x;
	float vW2 = u_NormalRead[uint3(w2, 1)].x;
	float vN2 = u_NormalRead[uint3(n2, 1)].x;
	float vS2 = u_NormalRead[uint3(s2, 1)].x;
	float nearAvg = (vE + vW + vN + vS) * 0.25;

	float windSpeed = length(u_wind);
	float patchBlend = windMapPatchBlend(windSpeed);
	float streakBlend = windMapStreakBlend(windSpeed);
	float highWindBlend = windMapHighWindBlend(windSpeed);
	int windRes = int(u_resolution);
	float2 windDirSigned = safeNormalizeWind(u_wind);
	float2 windDirAbs = abs(windDirSigned);
	float2 crestDirSigned = float2(-windDirSigned.y, windDirSigned.x);
	float alongAvg = lerp((vN + vS) * 0.5, (vE + vW) * 0.5, windDirAbs.x);
	float crossAvg = lerp((vE + vW) * 0.5, (vN + vS) * 0.5, windDirAbs.x);
	float alongAvgFar = lerp((vN2 + vS2) * 0.5, (vE2 + vW2) * 0.5, windDirAbs.x);
	float crossAvgFar = lerp((vE2 + vW2) * 0.5, (vN2 + vS2) * 0.5, windDirAbs.x);
	float alongBlur = lerp(alongAvg, alongAvgFar, 0.62);
	float crossBlur = lerp(crossAvg, crossAvgFar, 0.32);

	float patchWeight = patchBlend * patchBlend * (1.0 - highWindBlend);
	float lowPatchBase = lerp(center, nearAvg, patchWeight * 0.58);
	float crossRidge = center - crossBlur;
	float alongRidge = center - alongBlur;
	float fineRidge = (vE - vW) * windDirSigned.x + (vN - vS) * windDirSigned.y;
	float patchAnalytic = windMapStablePatchFieldTiled(int2(coordinates), crestDirSigned, windSpeed, windRes);
	float highLaneAnalytic = windMapSignedStreakFieldTiled(int2(coordinates), crestDirSigned, windSpeed, windRes);
	float mixedAnalytic = lerp(patchAnalytic * 0.70 + highLaneAnalytic * 0.26, highLaneAnalytic * 0.46 + patchAnalytic * 0.54, streakBlend);

	// High wind emphasizes cross-wind ridges and multi-scale lane structure.
	float periodicLaneBase = alongRidge * 0.68 + fineRidge * 0.16 + crossRidge * 0.035 + center * 0.10;
	float highLaneBase = periodicLaneBase * WINDMAP_PERIODIC_RIDGE_GAIN + mixedAnalytic * 0.62;
	float base = lerp(lowPatchBase * lerp(0.94, 0.34, highWindBlend), highLaneBase, highWindBlend * 0.82);
	float dynamicDirectional = WINDMAP_CAPTURE_DIRECTIONAL * lerp(0.12, 2.05, streakBlend);
	float dynamicSharpen = WINDMAP_CAPTURE_SHARPEN * lerp(0.18, 0.52, streakBlend);
	float ridge = alongRidge * dynamicDirectional + fineRidge * (dynamicDirectional * 0.18) + crossRidge * (dynamicDirectional * 0.045);
	float unsharp = (center - nearAvg) * dynamicSharpen * lerp(0.60, 0.10, highWindBlend)
		+ alongRidge * (dynamicSharpen * 0.62 * highWindBlend);
	float dynamicGain = WINDMAP_CAPTURE_GAIN * lerp(1.02, 1.42, streakBlend);
	float restoredStructure = mixedAnalytic * (0.26 + highWindBlend * 0.36) * WINDMAP_CAPTURE_STRUCTURE_GAIN;

	u_WindMapWrite[coordinates] = (base + unsharp + ridge + restoredStructure) * dynamicGain;
}

#define COMMON_CS_PART 		SetVertexShader(NULL);		\
							SetHullShader(NULL);		\
							SetDomainShader(NULL);		\
							SetGeometryShader(NULL);	\
							SetPixelShader(NULL);							

technique10 Tech {
	pass P0	{
		SetComputeShader(CompileShader(cs_5_0, CS_PHASE()));
		COMMON_CS_PART
	}
	pass P1	{
		SetComputeShader(CompileShader(cs_5_0, CS_SPECTRUM()));
		COMMON_CS_PART
	}
	pass P2	{
		SetComputeShader(CompileShader(cs_5_0, CS_FFT(true)));
		COMMON_CS_PART
	}
	pass P3	{
		SetComputeShader(CompileShader(cs_5_0, CS_FFT(false)));
		COMMON_CS_PART
	}
	pass P4	{
		SetComputeShader(CompileShader(cs_5_0, CS_NORMAL()));
		COMMON_CS_PART
	}
	pass P5	{
		SetComputeShader(CompileShader(cs_5_0, CS_WIND_MAP_SHOT()));
		COMMON_CS_PART
	}
}
