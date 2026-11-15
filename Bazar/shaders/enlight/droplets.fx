#include "../common/samplers11.hlsl"
#include "../common/states11.hlsl"
#include "common/quat.hlsl"

#define GROUP_DIM 32

#define CNT_0 1024
#define CNT_1 4
//#define MAX_DROPLETS (CNT_0*CNT_1)
#define TEX_SIZE 2048

#define DROPLET_SIZE 3.2
#define AFFINITY_SCALE 50
#define VELOCITY_SCALE 0.25
#define CANOPY_FLOW_INTENSITY 16.5

#define CANOPY_STATIC_FRICTION 0.32
#define CANOPY_SLIDE_BOOST 0.72
#define CANOPY_WOBBLE 0.06
#define CANOPY_MAX_SPEED 0.065
#define CANOPY_VEL_SMOOTH 0.40
#define CANOPY_FORCE_SMOOTH 0.45
#define CANOPY_STORM_WIND 1.55
#define CANOPY_STICKY_MODE 0.38
#define CANOPY_FORCE_CLAMP 0.55
#define CANOPY_SHIMMER_DAMP 0.96
#define CANOPY_EVAP_RATE   0.014
#define CANOPY_REFERENCE_FPS 60.0
#define CANOPY_STICK_SETTLE 0.78
#define CANOPY_FORCE_SETTLE 0.70
#define CANOPY_DRAG_STICKY 0.86
#define CANOPY_DRAG_SLIDING 0.985
#define CANOPY_TERMINAL_MASS 1.62
#define CANOPY_CALM_SPEED_SCALE 0.86
#define CANOPY_STREAM_ALIGN 0.11
#define CANOPY_STREAM_SPEED_BOOST 1.38
#define CANOPY_STREAM_WALK_GAIN 1.75
#define CANOPY_SLIDE_WIND_START 6.0
#define CANOPY_SLIDE_WIND_FULL 30.0
#define CANOPY_AIRSPEED_STREAM_START 102.89 // 200 knots in meters per second
#define CANOPY_AIRSPEED_STREAM_FULL  180.06 // 350 knots in meters per second
#define CANOPY_AIRSPEED_CLEAR_START  180.06 // clearing begins above 350 knots
#define CANOPY_AIRSPEED_CLEAR_FULL   187.77 // fully clear by 365 knots
#define CANOPY_HIGH_SPEED_STREAM_BIAS 1.70
#define CANOPY_HIGH_SPEED_LONG_STREAM_PROBABILITY 1.00
#define CANOPY_HIGH_SPEED_IMPACT_RESERVE 0.00
#define CANOPY_HIGH_SPEED_TRAIL_SPLIT_SCALE 0.35
#define CANOPY_SLIDE_LOW_WIND_SLIP 0.58
#define CANOPY_SLIDE_LOW_WIND_STREAM_BIAS 0.34
#define CANOPY_SLIDE_LOW_WIND_SPLIT_SCALE 0.55
#define CANOPY_LONG_STREAM_PROBABILITY 0.12
#define CANOPY_LONG_STREAM_LENGTH 4.20
#define CANOPY_LONG_STREAM_TRAIL_GAIN 3.20
#define CANOPY_LONG_STREAM_SPEED_GAIN 1.38
#define CANOPY_LONG_STREAM_GROWTH_WALK 0.030
#define CANOPY_LONG_STREAM_WIGGLE 0.14
#define CANOPY_LONG_STREAM_WIGGLE_FREQ 2.35
#define CANOPY_LONG_STREAM_HEAD_BULGE 0.26
#define CANOPY_LONG_STREAM_TAIL_THIN 0.18
#define CANOPY_LONG_STREAM_TAIL_FLATTEN 0.48
#define CANOPY_STREAM_EDGE_AA_MIN 1.45
#define CANOPY_STREAM_EDGE_AA_MAX 2.25
#define CANOPY_STREAM_EDGE_RIPPLE 0.020
#define CANOPY_RENDER_SIZE_VARIATION 0.42
#define CANOPY_NORMAL_GAIN 1.50 //3.25
#define CANOPY_DROPLET_NORMAL_STRENGTH  (68.0 * CANOPY_NORMAL_GAIN) //20.0
#define CANOPY_DROPLET_NORMAL_REFERENCE 12.28
#define CANOPY_DROPLET_REFRACTION_GAIN 0.25
#define CANOPY_DROP_ASPECT_VARIATION 0.32
#define CANOPY_DROP_SHAPE_WARP 0.18
#define CANOPY_DROP_TAIL_VARIATION 0.38
#define CANOPY_STREAK_RENDER_BOOST 1.95
#define CANOPY_CURVATURE_SAMPLE_RADIUS 5.0
#define CANOPY_CURVATURE_STRETCH_RESPONSE 7.5
#define CANOPY_CURVATURE_STRETCH_MIN 0.58
#define CANOPY_CURVATURE_STREAK_MAX 3.35
#define CANOPY_SPAWN_JITTER 3.85
#define CANOPY_SPAWN_CLUSTER_JITTER 2.20
#define CANOPY_SPAWN_MASS_VARIATION 0.58
#define CANOPY_SPAWN_VEL_JITTER 0.008
#define CANOPY_LATERAL_MEANDER 0.42
#define CANOPY_MOTION_PHASE_VARIATION 0.34
#define CANOPY_SPLIT_WALK 0.22
#define CANOPY_SPLIT_MAX_FRACTION 0.50
#define CANOPY_SPLIT_MIN_MASS 0.014
#define CANOPY_TRAIL_VEL_MIN 0.10
#define CANOPY_TRAIL_VEL_MAX 0.50
#define CANOPY_TRAIL_SECONDARY_MASS 0.48
#define CANOPY_TRAIL_OFFSET 0.72
#define CANOPY_TRAIL_STAGGER 1.65
#define CANOPY_TRAIL_SIDE_DRIFT 0.58
#define CANOPY_TRAIL_BEAD_VARIATION 0.52
#define CANOPY_TRAIL_MATURITY_START 0.008
#define CANOPY_TRAIL_MATURITY_FULL 0.060
#define CANOPY_IMPACT_PROBABILITY_MIN 0.75
#define CANOPY_IMPACT_PROBABILITY_MAX 1.00
#define CANOPY_IMPACT_VISUAL_MASS_MIN 0.32
#define CANOPY_IMPACT_VISUAL_MASS_MAX 1.10
#define CANOPY_IMPACT_RADIUS_MIN 1.65
#define CANOPY_IMPACT_RADIUS_MAX 3.65
#define CANOPY_IMPACT_RENDER_SCALE 1.25
#define CANOPY_IMPACT_LIFETIME 1.25
#define CANOPY_IMPACT_HOLD_FRACTION 0.34
#define CANOPY_IMPACT_CAPACITY_RESERVE 0.95
#define CANOPY_IMPACT_CLEAR_RADIUS 8.50
#define CANOPY_IMPACT_RING_WIDTH_MIN 0.11
#define CANOPY_IMPACT_RING_WIDTH_MAX 0.22
#define CANOPY_IMPACT_NORMAL_STRENGTH 1.65
#define CANOPY_IMPACT_BEAD_COUNT 3
#define CANOPY_IMPACT_BEAD_OFFSET 2.55
#define CANOPY_IMPACT_BEAD_SIZE 0.68
#define WIPER_CLEAR_EPS 0.001

// Render-only high-speed canopy droplets. These constants are not referenced
// by the protected compute simulation or the baseline droplet calculations.
#define HIGH_SPEED_DROPLETS_ENABLED 1.0
#define HIGH_SPEED_START_MPS 51.44 // 100 knots
#define HIGH_SPEED_FULL_MPS 102.89 // fully established by 200 knots
#define HIGH_SPEED_FADE_START_MPS 180.06 // fade begins at 350 knots
#define HIGH_SPEED_FADE_END_MPS 187.77 // fully faded by 365 knots
#define HIGH_SPEED_VISUAL_INSTANCES 5
#define HIGH_SPEED_VISUAL_VERTICES 8
#define HIGH_SPEED_DENSITY 0.96
#define HIGH_SPEED_MIN_SIZE 0.46
#define HIGH_SPEED_MAX_SIZE 1.12
#define HIGH_SPEED_MIN_TRAIL_LENGTH 3.5
#define HIGH_SPEED_MAX_TRAIL_LENGTH 9.5
#define HIGH_SPEED_OPACITY 0.76
#define HIGH_SPEED_FLOW_SPEED 18.0
#define HIGH_SPEED_DIRECTION_VARIATION 0.14
#define HIGH_SPEED_POSITION_VARIATION 22.0
#define HIGH_SPEED_REFRACTION_STRENGTH 2.80
#define HIGH_SPEED_TRAVEL_MIN 5.0
#define HIGH_SPEED_TRAVEL_MAX 18.0
#define HIGH_SPEED_PHASE_FADE_IN 0.06
#define HIGH_SPEED_PHASE_FADE_OUT 0.90

#define HALF (127.0/255.0)

Texture2D src;
Texture2D surface;
Texture2D wiperFields;

float	timeDelta;
float3	wind;
float	windForce;
float	effectClear;
float	dropletScale;
float2	wipers;
uint	maxDroplets;

#define DROPLET_SCALE (dropletScale * DROPLET_SIZE / TEX_SIZE)

#define WIND_SCALE 0.35

struct Droplet {
	float2	pos, vel, force;
	float	mass, walk;
};

uint countAdd;
StructuredBuffer<Droplet> simAdd;
StructuredBuffer<Droplet> simSrc;
RWStructuredBuffer<Droplet> simDst;
RWStructuredBuffer<uint> dropletCount;
RWTexture2D<float> result;

groupshared uint gCount;


static const float2 quad[4] = {
	{-1, -1}, {1, -1},
	{-1,  1}, {1,  1}
};

struct VS_OUTPUT {
	float4 pos:		SV_POSITION;
	float4 projPos:	TEXCOORD0;
};

float3 canopyNeutralNormal() {
	return float3(HALF, HALF, 1.0);
}

float3 sanitizeCanopyFeedback(float3 packedNormal) {
	// All normals written by this effect use the upper Z hemisphere, so a low
	// packed Z is an uninitialized/cleared render target, not valid wet-canopy
	// history. Convert it immediately instead of feeding a black startup buffer
	// back through the refraction pass for several frames.
	return packedNormal.z >= 0.25 ? packedNormal : canopyNeutralNormal();
}

VS_OUTPUT VS(uint vid: SV_VertexID) {
	VS_OUTPUT o;
	o.projPos = o.pos = float4(quad[vid], 0, 1);
	return o;
}

float4 COPY_PS(const VS_OUTPUT i): SV_TARGET0 {
	float2 uv = float2(i.projPos.x*0.5 + 0.5, -i.projPos.y*0.5 + 0.5);
	float3 c = sanitizeCanopyFeedback(src.SampleLevel(ClampLinearSampler, uv, 0).xyz);
	return float4(c, 1);
//	return float4(surface.SampleLevel(ClampLinearSampler, float3(uv, 0), 0).xyz, 1);
//	return src.Load(int3(i.pos.xy, 0));
}

[numthreads(1, 1, 1)]
void INIT_CS(uint3 gid: SV_GroupId, uint3 gtid : SV_GroupThreadID) {
	dropletCount[0] = 0;
}

[numthreads(32, 32, 1)]
void ADD_CS(uint3 gid: SV_GroupId, uint3 gtid : SV_GroupThreadID) {

	uint gIdx = gtid.y * GROUP_DIM + gtid.x;

	uint dCount = min(dropletCount[0], maxDroplets);
	uint available = maxDroplets - dCount;
	float airspeedStreamAmount = smoothstep(CANOPY_AIRSPEED_STREAM_START, CANOPY_AIRSPEED_STREAM_FULL, max(windForce, 0.0));
	float impactReserveFraction = lerp(CANOPY_IMPACT_CAPACITY_RESERVE, CANOPY_HIGH_SPEED_IMPACT_RESERVE, airspeedStreamAmount);
	uint impactReserve = min(available, uint(ceil(float(available) * impactReserveFraction)));
	uint cntAdd = min(countAdd, available - impactReserve);
	uint cntProcess = min(countAdd, uint(CNT_0));
	uint impactBase = dCount + cntAdd;
	if (gIdx == 0)
		gCount = 0;
	GroupMemoryBarrierWithGroupSync();

	if (gIdx < cntProcess) {
		Droplet d = simAdd[gIdx];
		float fgIdx = float(gIdx + dCount);
		float2 seed = frac((d.pos + float2(fgIdx * 0.017, fgIdx * 0.031)) * float2(23.17, 41.43));
		seed += dot(seed, seed.yx + 19.19);
		float2 jitter = frac(float2(seed.x * seed.y, (seed.x + seed.y) * seed.y)) - 0.5;
		float2 clusterSeed = frac(float2(seed.x * 61.17 + seed.y * 13.31 + fgIdx * 0.071, seed.y * 47.73 - seed.x * 19.91 + fgIdx * 0.113));
		float2 clusterJitter = frac(float2(clusterSeed.x * clusterSeed.y * 71.7, (clusterSeed.x + clusterSeed.y) * 53.3)) - 0.5;
		float massRand = frac((seed.x + seed.y + clusterSeed.x) * 37.17);
		float massRand2 = frac(seed.x * 17.13 + seed.y * 43.71 + clusterSeed.y * 11.11);
		float massBias = pow(massRand, 1.65);
		float heavyDrop = smoothstep(0.82, 0.98, massRand2);
		float massScale = lerp(1.0 - CANOPY_SPAWN_MASS_VARIATION, 1.0 + CANOPY_SPAWN_MASS_VARIATION, massBias);
		massScale *= lerp(0.72, 1.24, massRand2);
		massScale = lerp(massScale, massScale * lerp(1.25, 1.85, massRand), heavyDrop);
		float2 jitter2 = frac(float2(seed.x * 13.31 + seed.y * 5.17, seed.x * 7.73 + seed.y * 11.91) * float2(17.13, 29.71)) - 0.5;
		float2 spawnJitter = jitter + jitter2 * 0.65 + clusterJitter * lerp(0.35, CANOPY_SPAWN_CLUSTER_JITTER, massRand2 * massRand2);
		d.pos += spawnJitter * DROPLET_SCALE * CANOPY_SPAWN_JITTER * lerp(0.70, 1.35, massRand2);
		d.vel += spawnJitter * CANOPY_SPAWN_VEL_JITTER * lerp(0.35, 1.0, massRand);
		d.force += (jitter + clusterJitter * 0.4) * CANOPY_SPAWN_VEL_JITTER * 0.35;
		d.mass = min(max(d.mass * massScale, 0.008), 1.95);
		// Fill the regular-droplet share first; existing positive-mass drops remain
		// untouched, while this batch leaves room for recurring transient impacts.
		d.walk = 0.0;
		if (gIdx < cntAdd)
			simDst[dCount + gIdx] = d;

		// Append an independent, negative-mass impact record when capacity allows.
		// It remains fixed at the contact point while its walk field stores age.
		float impactSeed = frac(clusterSeed.x * 31.73 + clusterSeed.y * 57.91 + massRand2 * 11.17);
		float impactProbability = lerp(CANOPY_IMPACT_PROBABILITY_MIN, CANOPY_IMPACT_PROBABILITY_MAX, saturate(d.mass * 0.72)) * (1.0 - airspeedStreamAmount);
		if (impactSeed < impactProbability) {
			uint impactOffset;
			InterlockedAdd(gCount, 1, impactOffset);
			uint impactIdx = impactBase + impactOffset;
			if (impactIdx < maxDroplets) {
				Droplet impact = d;
				impact.mass = -max(abs(d.mass), lerp(CANOPY_IMPACT_VISUAL_MASS_MIN, CANOPY_IMPACT_VISUAL_MASS_MAX, impactSeed));
				impact.walk = 0.0;
				impact.vel = 0.0;
				impact.force = float2(impactSeed, massRand2);
				simDst[impactIdx] = impact;
			}
		}
	}

	GroupMemoryBarrierWithGroupSync();

	if (gIdx == 0)
		dropletCount[0] = min(impactBase + gCount, maxDroplets);
}

///////////// SOLVER

static const float b = CANOPY_STATIC_FRICTION;

#define HASHSCALE1 .1031
#define HASHSCALE3 float3(.1031, .1030, .0973)

float hash12(float2 p) {
	float3 p3 = frac(float3(p.xyx) * HASHSCALE1);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.x + p3.y) * p3.z);	
}

float2 hash22(float2 p) {
	float3 p3 = frac(float3(p.xyx) * HASHSCALE3);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.xx + p3.yz)*p3.zy);

}

// Smooth periodic approximation used for secondary shape variation. This avoids
// special-function-unit sin() work in the geometry and pixel hot paths.
float fastSin(float radians) {
	float x = frac(radians * 0.159154943 + 0.5) * 2.0 - 1.0;
	float y = 4.0 * x * (1.0 - abs(x));
	return y * (0.775 + 0.225 * abs(y));
}

float2 safeNormalize2(float2 v, float2 fallback) {
	float len2 = dot(v, v);
	return len2 > 1.0e-8 ? v * rsqrt(len2) : fallback;
}

float2 perp2(float2 v) {
	return float2(-v.y, v.x);
}

float2 canopySeedCell(float2 pos, float scale) {
	return floor((pos + float2(1.0, 1.0)) * scale);
}

float canopyDropSeedFromMassKey(float2 pos, float massKey, float salt, float scale) {
	return hash12(canopySeedCell(pos, scale) + float2(massKey * 0.017 + salt, massKey * 0.029 - salt));
}

float2 canopyDropSeed2FromMassKey(float2 pos, float massKey, float salt, float scale) {
	return hash22(canopySeedCell(pos, scale) + float2(massKey * 0.013 + salt, massKey * 0.031 - salt));
}

float4 getTangentSpace(float2 uv) {
	return normalize((surface.SampleLevel(ClampPointSampler, uv, 0) - 127.0 / 255) * 2);
}

bool surfacePresent(float2 uv) {
	return any(surface.SampleLevel(ClampPointSampler, uv, 0).xyz);
}

float wipersValue(float2 uv) {
	float2 w = wiperFields.SampleLevel(ClampPointSampler, uv, 0).yz * wipers;
	return max(w.x, w.y);
}

float3 getForce() {
	return float3(0, -1, 0) + wind * (WIND_SCALE * 0.1);
}

float canopyAirspeedStreamAmount() {
	return smoothstep(CANOPY_AIRSPEED_STREAM_START, CANOPY_AIRSPEED_STREAM_FULL, max(windForce, 0.0));
}

float EvaluateHighSpeedDropletLayer() {
	float airspeed = max(windForce, 0.0);
	float fadeIn = smoothstep(HIGH_SPEED_START_MPS, HIGH_SPEED_FULL_MPS, airspeed);
	float fadeOut = 1.0 - smoothstep(HIGH_SPEED_FADE_START_MPS, HIGH_SPEED_FADE_END_MPS, airspeed);
	return HIGH_SPEED_DROPLETS_ENABLED * fadeIn * fadeOut;
}

float canopyLongStreamAmount(float streamAmount, float mass, float seed) {
	float airspeedAmount = canopyAirspeedStreamAmount();
	// Reach high trail density early in the 200-350-knot band rather than
	// waiting until the droplet has already achieved its maximum slide speed.
	float densityRamp = smoothstep(0.0, 0.45, airspeedAmount);
	float probability = lerp(CANOPY_LONG_STREAM_PROBABILITY, CANOPY_HIGH_SPEED_LONG_STREAM_PROBABILITY, densityRamp);
	float normalEligibility = smoothstep(0.42, 0.84, streamAmount) * smoothstep(0.30, 0.92, saturate(mass));
	float highSpeedEligibility = smoothstep(0.02, 0.42, airspeedAmount) * smoothstep(0.08, 0.62, saturate(mass));
	return step(1.0 - probability, seed) * max(normalEligibility, highSpeedEligibility);
}

float canopyImpactClearAmount() {
	// Impact splashes progressively give way to airflow-driven streams from
	// 200 through 350 knots.
	return canopyAirspeedStreamAmount();
}

float canopyAirspeedClearAmount() {
	// DCS asserts effectClear much later, so establish an explicit final-clear
	// band immediately above the requested 350-knot streaming range.
	return smoothstep(CANOPY_AIRSPEED_CLEAR_START, CANOPY_AIRSPEED_CLEAR_FULL, max(windForce, 0.0));
}

float canopyClearAmount() {
	return max(saturate(effectClear), canopyAirspeedClearAmount());
}

float getAffinity(float2 pos) {
	return saturate(hash12(pos))*0.8 + 0.1;
}

float3 normalFromTangentSpace(float4 q) {
	return float3(2 * q.x*q.z - 2 * q.y*q.w, 2 * q.y*q.z + 2 * q.x*q.w, 1 - 2 * q.x*q.x - 2 * q.y*q.y);
}

float canopyCurvatureMask(float2 uv) {
	float2 du = float2(CANOPY_CURVATURE_SAMPLE_RADIUS / TEX_SIZE, 0);
	float2 dv = float2(0, CANOPY_CURVATURE_SAMPLE_RADIUS / TEX_SIZE);

	float4 sxp = surface.SampleLevel(ClampPointSampler, uv + du, 0);
	float4 sxn = surface.SampleLevel(ClampPointSampler, uv - du, 0);
	float4 syp = surface.SampleLevel(ClampPointSampler, uv + dv, 0);
	float4 syn = surface.SampleLevel(ClampPointSampler, uv - dv, 0);

	float curvatureX = 0.0;
	float curvatureY = 0.0;
	if (any(sxp.xyz) && any(sxn.xyz)) {
		float4 qx0 = normalize((sxp - 127.0 / 255) * 2);
		float4 qx1 = normalize((sxn - 127.0 / 255) * 2);
		float3 nx0 = normalFromTangentSpace(qx0);
		float3 nx1 = normalFromTangentSpace(qx1);
		curvatureX = length(nx0 - nx1);
	}
	if (any(syp.xyz) && any(syn.xyz)) {
		float4 qy0 = normalize((syp - 127.0 / 255) * 2);
		float4 qy1 = normalize((syn - 127.0 / 255) * 2);
		float3 ny0 = normalFromTangentSpace(qy0);
		float3 ny1 = normalFromTangentSpace(qy1);
		curvatureY = length(ny0 - ny1);
	}

	return saturate(max(curvatureX, curvatureY) * CANOPY_CURVATURE_STRETCH_RESPONSE);
}

float canopyCurvatureStretchDamp(float2 uv) {
	return lerp(1.0, CANOPY_CURVATURE_STRETCH_MIN, canopyCurvatureMask(uv));
}

[numthreads(32, 32, 1)]
void SIM_CS(uint3 gid: SV_GroupId, uint3 gtid : SV_GroupThreadID, uniform bool clearEmpty, uniform bool useWipers) {

	uint gIdx = gtid.y * GROUP_DIM + gtid.x;

	if (gIdx == 0)
		gCount = 0;						// init new count
	GroupMemoryBarrierWithGroupSync();

	uint dCount = min(dropletCount[0], maxDroplets);
	float dtScale = min(max(timeDelta * CANOPY_REFERENCE_FPS, 0.0), 2.0);
	float simTime = min(max(timeDelta, 0.0), 2.0 / CANOPY_REFERENCE_FPS);
	float airspeedStreamAmount = canopyAirspeedStreamAmount();
	float impactClearAmount = canopyImpactClearAmount();
	float airspeedClearAmount = canopyAirspeedClearAmount();
	float slideWind = smoothstep(CANOPY_SLIDE_WIND_START, CANOPY_SLIDE_WIND_FULL, windForce);
	
	for (uint i = 0; i < CNT_1; ++i)
	{
		uint idx = gIdx + CNT_0 * i;
		if (idx >= dCount)
			break;

		Droplet d = simSrc[idx];
		if (d.mass < 0.0) {
			d.walk += simTime;
			float2 impactUv = d.pos * 0.5 + 0.5;
			bool keepImpact = d.walk < CANOPY_IMPACT_LIFETIME && surfacePresent(impactUv);
			keepImpact = keepImpact && impactClearAmount < 0.999 && airspeedClearAmount < 0.999;
			if (useWipers)
				keepImpact = keepImpact && wipersValue(impactUv) <= WIPER_CLEAR_EPS;
			if (keepImpact) {
				uint impactDst;
				InterlockedAdd(gCount, 1, impactDst);
				simDst[impactDst] = d;
			}
			continue;
		}
		if (!(d.mass > 0))
			continue;
		if (airspeedClearAmount >= 0.999)
			continue;

		float4 q = getTangentSpace(d.pos * 0.5 + 0.5);
		float3 normal = normalFromTangentSpace(q);
		float massKey = floor(abs(d.mass) * 4096.0);
		float dropPhase = canopyDropSeedFromMassKey(d.pos, massKey, 0.13, AFFINITY_SCALE * 0.09);
		float motionPhase = canopyDropSeedFromMassKey(d.pos, massKey, 3.71, AFFINITY_SCALE * 0.43);
		float lanePhase = canopyDropSeedFromMassKey(d.pos, massKey, 8.23, AFFINITY_SCALE * 0.62);
		float phaseSpeed = lerp(0.62, 1.38, dropPhase);
		float3 force = getForce() * d.mass; // world space
		float3 Vs = force - normal * dot(force, normal); // world space along surface
		float driveForce = length(Vs);
		float channelFriction = lerp(1.60, 0.58, canopyDropSeedFromMassKey(d.pos, massKey, 1.39, AFFINITY_SCALE * 0.16)) * lerp(0.82, 1.26, motionPhase);
		float massSlip = lerp(1.35, 0.34, saturate(d.mass * 0.76));
		float cForce = b * getAffinity(d.pos) * massSlip * channelFriction; // critical force

		float stickiness = canopyDropSeedFromMassKey(d.pos, massKey, 5.17, AFFINITY_SCALE * 0.58);
		float windThreshold = lerp(1.05, 0.12, stickiness * CANOPY_STICKY_MODE) * lerp(1.24, 0.72, dropPhase);
		if (driveForce > cForce || windForce > windThreshold) {
			float2 forceUv = mulQuatVec3(q, Vs).xy; // texture space
			float2 flowDir = safeNormalize2(forceUv, safeNormalize2(d.vel, float2(0, -1)));
			float responseBase = saturate(lerp(CANOPY_FORCE_SMOOTH, 0.85, saturate(windForce * 0.02)) * lerp(0.52, 1.45, motionPhase));
			float forceResponse = 1.0 - pow(1.0 - responseBase, dtScale);
			d.force = lerp(d.force, forceUv, forceResponse);

			float2 a = d.force / max(d.mass, 0.01);
			a *= rcp(max(1.0, length(a) * CANOPY_FORCE_CLAMP));
			float forceSlip = saturate((driveForce - cForce) / max(cForce + 0.14, 0.001));
			float windSlip = smoothstep(windThreshold, windThreshold + 1.0, windForce) * saturate(windForce * 0.04);
			windSlip = max(windSlip, slideWind * CANOPY_SLIDE_LOW_WIND_SLIP);
			float slip = max(forceSlip, windSlip);
			slip = smoothstep(0, 1, slip * slip) * lerp(0.70, 1.30, dropPhase);
			float massFactor = lerp(0.60, 2.55, saturate(d.mass * 0.82));
			float2 da = canopyDropSeed2FromMassKey(d.pos + d.vel * 1.7, massKey, 9.20, AFFINITY_SCALE * lerp(0.35, 0.75, lanePhase)) - 0.5;
			a += da * step(0, dot(a, da)) * CANOPY_WOBBLE * (0.5 + 0.5 * slip);
			float heavyT = smoothstep(0.25, 1.20, d.mass);
			float lane = (canopyDropSeedFromMassKey(d.pos, massKey, 12.60, AFFINITY_SCALE * 0.28) - 0.5) * 1.10;
			a += perp2(flowDir) * lane * CANOPY_LATERAL_MEANDER * lerp(1.30, 0.20, heavyT) * lerp(0.55, 1.45, lanePhase) * (0.35 + 0.65 * slip);
			float windSpeedScale = lerp(CANOPY_CALM_SPEED_SCALE, CANOPY_STORM_WIND, saturate(windForce * 0.035));
			float motionScale = lerp(1.0 - CANOPY_MOTION_PHASE_VARIATION, 1.0 + CANOPY_MOTION_PHASE_VARIATION, motionPhase);
			float2 impulse = a * (2 * CANOPY_FLOW_INTENSITY * CANOPY_SLIDE_BOOST) * slip * massFactor * windSpeedScale * phaseSpeed * motionScale * dtScale;

			float velocityResponse = saturate((CANOPY_VEL_SMOOTH * lerp(0.58, 1.35, motionPhase) + slip * lerp(0.12, 0.34, lanePhase)) * max(dtScale, 0.001));
			d.vel = lerp(d.vel, d.vel + impulse, velocityResponse);
			float streamT = saturate(smoothstep(0.24, 0.90, saturate(length(d.vel) / max(CANOPY_MAX_SPEED, 0.001))) * smoothstep(0.20, 1.00, saturate(d.mass * lerp(0.85, 1.20, motionPhase))) * lerp(0.68, 1.18, dropPhase));
			streamT = max(streamT, slideWind * CANOPY_SLIDE_LOW_WIND_STREAM_BIAS * smoothstep(0.08, 0.80, saturate(d.mass)));
			streamT = max(streamT, airspeedStreamAmount * CANOPY_HIGH_SPEED_STREAM_BIAS * smoothstep(0.08, 0.80, saturate(d.mass)));
			float longStreamSeed = canopyDropSeedFromMassKey(d.pos - flowDir * 0.35, massKey, 19.80, AFFINITY_SCALE * 0.06);
			float longStream = canopyLongStreamAmount(streamT, d.mass, longStreamSeed);
			d.vel = lerp(d.vel, flowDir * length(d.vel), streamT * CANOPY_STREAM_ALIGN * lerp(0.45, 1.20, lanePhase) * lerp(1.0, 1.45, longStream) * saturate(dtScale));
			float roughFlow = lerp(0.96, 1.0, smoothstep(0, 0.25, dot(da, da)));
			float drag = lerp(CANOPY_DRAG_STICKY, CANOPY_DRAG_SLIDING, slip) * roughFlow;
			drag = lerp(drag, CANOPY_DRAG_SLIDING, streamT * 0.55);
			drag = min(drag * lerp(0.94, 1.01, lanePhase) * lerp(1.0, 1.012, longStream), 0.9985);
			d.vel *= pow(max(drag, 0.001), dtScale);
			float vLen = length(d.vel);
			float terminalSpeed = CANOPY_MAX_SPEED * lerp(0.72, CANOPY_TERMINAL_MASS, saturate(d.mass * 0.65)) * lerp(1.0, 1.18, saturate(windForce * 0.035));
			terminalSpeed *= lerp(0.86, CANOPY_STREAM_SPEED_BOOST, streamT) * phaseSpeed * lerp(0.74, 1.34, lanePhase) * lerp(1.0, CANOPY_LONG_STREAM_SPEED_GAIN, longStream) * lerp(CANOPY_CALM_SPEED_SCALE, 1.0, saturate(windForce * 0.035));
			if (vLen > terminalSpeed)
				d.vel *= terminalSpeed / vLen;

			float2 dp = d.vel * simTime * VELOCITY_SCALE;
			d.pos += dp;
			d.walk += length(dp) * (3.4 * CANOPY_FLOW_INTENSITY) * massFactor * lerp(1.0, CANOPY_STREAM_WALK_GAIN, streamT) * phaseSpeed * lerp(0.72, 1.32, lanePhase) * lerp(1.0, CANOPY_LONG_STREAM_TRAIL_GAIN, longStream);
		}
		else {
			float settle = pow(lerp(CANOPY_STICK_SETTLE * 0.92, CANOPY_STICK_SETTLE * 1.08, motionPhase), dtScale);
			d.vel *= settle;
			d.force *= pow(lerp(CANOPY_FORCE_SETTLE * 0.90, CANOPY_FORCE_SETTLE * 1.08, lanePhase), dtScale);
			d.walk *= settle;
		}

		float2 uv = d.pos * 0.5 + 0.5;
		bool add = surfacePresent(uv);
		if (useWipers)
			add = add && wipersValue(uv) <= WIPER_CLEAR_EPS;
		if (add) {
			uint ii;
			InterlockedAdd(gCount, 1, ii);
			simDst[ii] = d;
		}
	}
	GroupMemoryBarrierWithGroupSync();
	if (gIdx == 0) {
		uint dstCount = min(gCount, maxDroplets);
		dropletCount[0] = dstCount;	// save new droplet count
		if (clearEmpty) {
			for (uint i = dstCount; i < maxDroplets; ++i)
				simDst[i].mass = 0;
		}
	}
}


[numthreads(32, 32, 1)]
void COLLISION_CS(uint3 gid: SV_GroupId, uint3 gtid : SV_GroupThreadID) {
	
	uint gIdx = gtid.y * GROUP_DIM + gtid.x;

	if (gIdx == 0) 
		gCount = 0;						// init new count
	GroupMemoryBarrierWithGroupSync();

	uint dCount = min(dropletCount[0], maxDroplets);
	float windCollisionBoost = (1 + saturate(windForce * 0.1) * 3) * dropletScale;
	for (uint i = 0; i < CNT_1; ++i)
	{
		uint idx = gIdx + CNT_0 * i;
		if (idx >= dCount)
			break;
		Droplet d = simSrc[idx];
		if (d.mass < 0.0) {
			uint impactDst;
			InterlockedAdd(gCount, 1, impactDst);
			simDst[impactDst] = d;
			continue;
		}
		if (!(d.mass > 0))
			continue;
		float r = pow(abs(d.mass), 0.33) * DROPLET_SCALE;
		// Reject distant pairs before evaluating the candidate radius or normalizing
		// its direction. The bound is conservative for the enforced mass <= 2 range,
		// so this removes work without changing which droplets can collide.
		float maxOtherRadius = 1.26 * DROPLET_SCALE;
		float maxCollisionDistance = (r + maxOtherRadius) * (1.0 + length(d.force)) * windCollisionBoost * 2.0;
		float maxCollisionDistance2 = maxCollisionDistance * maxCollisionDistance;

#if 1
		[loop]
		for (uint j = 0; j < dCount; ++j)
		{

			Droplet d2 = simSrc[j];

			if (j == idx || !(d2.mass > 0))// || d2.mass >= 2)
				continue;

//				if ((length(d2.pos - d.pos) < r + r2) && (dot(d2.pos - d.pos, d.vel) < 0)) { //	collide
			
			float2 delta = d2.pos - d.pos;
			float distance2 = dot(delta, delta);
			if (distance2 >= maxCollisionDistance2)
				continue;

			float r2 = pow(abs(d2.mass), 0.33) * DROPLET_SCALE;
			float2 dir = distance2 > 1.0e-12 ? delta * rsqrt(distance2) : float2(1, 0);
			float mult = (1 + abs(dot(d.force, dir))) * windCollisionBoost;
			float collisionDistance = (r + r2) * mult * 2.0;
			
			if (distance2 < collisionDistance * collisionDistance) { //	collide
				if (d.mass > d2.mass) {
					float mergedMass = d.mass + d2.mass;
					d.vel = (d.vel * d.mass + d2.vel * d2.mass) / max(mergedMass, 0.001);
					d.force = (d.force * d.mass + d2.force * d2.mass) / max(mergedMass, 0.001);
					maxCollisionDistance = (r + maxOtherRadius) * (1.0 + length(d.force)) * windCollisionBoost * 2.0;
					maxCollisionDistance2 = maxCollisionDistance * maxCollisionDistance;
					d.vel *= lerp(0.78, 0.94, saturate(mergedMass * 0.45));
					d.walk = min(d.walk, 0.15);
					d.mass = min(2, mergedMass); // eat droplet
				}
				else {
					d.mass = 0; // kill self droplet
					break;
				}
			}
		}
#endif					
		if (d.mass > 0)
		{
			uint ii;
			InterlockedAdd(gCount, 1, ii);
			simDst[ii] = d;
		}
	}
	GroupMemoryBarrierWithGroupSync();
	if (gIdx == 0) {						// save new droplet count
		uint dstCount = min(gCount, maxDroplets);
		for (uint i = dstCount; i < maxDroplets; ++i)
			simDst[i].mass = 0;
		dropletCount[0] = dstCount;
	}

}

[numthreads(32, 32, 1)]
void SPLIT_CS(uint3 gid: SV_GroupId, uint3 gtid : SV_GroupThreadID) {

	uint gIdx = gtid.y * GROUP_DIM + gtid.x;

	uint dCount = min(dropletCount[0], maxDroplets);
	float splitTime = min(max(timeDelta, 0.0), 2.0 / CANOPY_REFERENCE_FPS);
	float airspeedStreamAmount = canopyAirspeedStreamAmount();
	float slideWind = smoothstep(CANOPY_SLIDE_WIND_START, CANOPY_SLIDE_WIND_FULL, windForce);

	if (gIdx == 0)
		gCount = dCount;				// init new count
	GroupMemoryBarrierWithGroupSync();

	for (uint i = 0; i < CNT_1; ++i)
	{
		uint idx = gIdx + CNT_0 * i;
		if (idx >= dCount)
			break;

		Droplet d = simSrc[idx];
		if (d.mass < 0.0) {
			simDst[idx] = d;
			continue;
		}
		if (!(d.mass > 0)) {
			d.mass = 0;
			d.walk = 0;
			simDst[idx] = d;
			continue;
		}
		float speedT = saturate(length(d.vel) / max(CANOPY_MAX_SPEED, 0.001));
		float massKey = floor(abs(d.mass) * 4096.0);
		float streamT = smoothstep(0.30, 0.90, speedT) * smoothstep(0.22, 0.95, saturate(d.mass));
		streamT = max(streamT, slideWind * CANOPY_SLIDE_LOW_WIND_STREAM_BIAS * smoothstep(0.08, 0.80, saturate(d.mass)));
		streamT = max(streamT, airspeedStreamAmount * CANOPY_HIGH_SPEED_STREAM_BIAS * smoothstep(0.08, 0.80, saturate(d.mass)));
		float trailSeed = canopyDropSeedFromMassKey(d.pos + d.vel * 2.0, massKey, 21.20, AFFINITY_SCALE * 0.52);
		float trailSeed2 = canopyDropSeedFromMassKey(d.pos - d.vel * 1.3, massKey, 27.60, AFFINITY_SCALE * 0.83);
		float2 trailDir = safeNormalize2(d.vel, safeNormalize2(d.force, float2(0, -1)));
		float sideSign = trailSeed2 < 0.5 ? -1.0 : 1.0;
		float longStreamSeed = canopyDropSeedFromMassKey(d.pos - trailDir * 0.35, massKey, 19.80, AFFINITY_SCALE * 0.06);
		float longStream = canopyLongStreamAmount(streamT, d.mass, longStreamSeed);
		float splitWalk = CANOPY_SPLIT_WALK * lerp(1.30, 0.55, speedT) * lerp(1.15, 0.75, saturate(d.mass * 0.65)) * lerp(1.0, 0.46, streamT) * lerp(0.62, 1.48, trailSeed) * lerp(1.0, 0.52, longStream) * lerp(1.0, CANOPY_SLIDE_LOW_WIND_SPLIT_SCALE, slideWind) * lerp(1.0, CANOPY_HIGH_SPEED_TRAIL_SPLIT_SCALE, airspeedStreamAmount);
		if (d.walk > splitWalk)
		{
			float beadVariation = lerp(1.0 - CANOPY_TRAIL_BEAD_VARIATION * 0.50, 1.0 + CANOPY_TRAIL_BEAD_VARIATION, trailSeed);
			float trailShare = lerp(0.18, CANOPY_SPLIT_MAX_FRACTION, max(speedT, streamT)) * lerp(0.78, 1.22, trailSeed2) * lerp(1.0, 1.35, longStream);
			float splitMass = min(d.walk * lerp(0.35, 0.82, speedT) * beadVariation * lerp(1.0, 1.45, longStream), d.mass * trailShare);
			if (splitMass >= CANOPY_SPLIT_MIN_MASS)
			{
				float secondaryMass = (streamT > 0.45 && splitMass > CANOPY_SPLIT_MIN_MASS * 2.2) ? splitMass * CANOPY_TRAIL_SECONDARY_MASS * lerp(0.65, 1.25, trailSeed2) * lerp(1.0, 1.35, longStream) : 0.0;
				secondaryMass = min(secondaryMass, max(0.0, splitMass - CANOPY_SPLIT_MIN_MASS));
				float primaryMass = splitMass - secondaryMass;
				float consumedMass = 0;
				uint idx2;
				InterlockedAdd(gCount, 1, idx2);
				if (idx2 < maxDroplets)
				{

					Droplet d2 = d;
					d2.mass = primaryMass;
					d2.walk = 0;
					float2 sideOffset = perp2(trailDir) * (trailSeed2 - 0.5) * DROPLET_SCALE * CANOPY_TRAIL_SIDE_DRIFT * lerp(0.25, 1.0, streamT) * lerp(1.0, 0.45, longStream);
					d2.pos -= d.vel * splitTime * VELOCITY_SCALE * lerp(0.75, CANOPY_TRAIL_STAGGER, trailSeed) * lerp(1.0, CANOPY_LONG_STREAM_LENGTH * 0.62, longStream);
					d2.pos += sideOffset;
					d2.vel *= lerp(CANOPY_TRAIL_VEL_MIN, CANOPY_TRAIL_VEL_MAX, speedT) * lerp(0.65, 1.18, trailSeed2) * lerp(1.0, 0.72, longStream);
					d2.force *= lerp(0.45, 0.75, trailSeed) * lerp(1.0, 0.82, longStream);

					simDst[idx2] = d2;
					consumedMass += primaryMass;

					if (secondaryMass >= CANOPY_SPLIT_MIN_MASS) {
						uint idx3;
						InterlockedAdd(gCount, 1, idx3);
						if (idx3 < maxDroplets)
						{
							Droplet d3 = d;
							d3.mass = secondaryMass;
							d3.walk = 0;
							d3.pos -= d.vel * splitTime * VELOCITY_SCALE * lerp(CANOPY_TRAIL_STAGGER, CANOPY_TRAIL_STAGGER * 1.85, trailSeed2) * lerp(1.0, CANOPY_LONG_STREAM_LENGTH, longStream);
							d3.pos += perp2(trailDir) * (sideSign * DROPLET_SCALE * CANOPY_TRAIL_OFFSET * lerp(0.35, 1.15, streamT) * lerp(1.0, 0.38, longStream) + (trailSeed - 0.5) * DROPLET_SCALE * CANOPY_TRAIL_SIDE_DRIFT);
							d3.vel *= lerp(0.04, 0.22, speedT) * lerp(0.70, 1.30, trailSeed) * lerp(1.0, 0.58, longStream);
							d3.force *= lerp(0.25, 0.45, trailSeed2) * lerp(1.0, 0.70, longStream);
							simDst[idx3] = d3;
							consumedMass += secondaryMass;
						}
					}

					d.mass = max(0, d.mass - consumedMass);
				}
			}
			float walkDrain = splitWalk * lerp(0.72, 1.18, trailSeed2) * lerp(1.0, 0.44, longStream);
			float walkMemory = splitWalk * lerp(0.08, 0.45, streamT) * lerp(0.65, 1.35, trailSeed) * lerp(1.0, 4.20, longStream);
			d.walk = min(max(d.walk - walkDrain, 0), walkMemory);
		}
		simDst[idx] = d;
	}

	GroupMemoryBarrierWithGroupSync();
	if (gIdx == 0)						// save new droplet count
		dropletCount[0] = min(gCount, maxDroplets);

}


/////////////////////////////////  clear

struct DROPS_CLEAR_VS_OUTPUT {
	float4 pos:		TEXCOORD0;
	float  mass:	TEXCOORD1;
};

struct DROPS_CLEAR_PS_INPUT {
	float4 pos:		SV_POSITION;
	float2 uv:		TEXCOORD0;
	float2 uv2:		TEXCOORD1;
	float  impact:	TEXCOORD2;
};

DROPS_CLEAR_VS_OUTPUT DROPS_CLEAR_VS(uint vid: SV_VertexID) {
	DROPS_CLEAR_VS_OUTPUT o;
	Droplet d = simSrc[vid];
	float clearTime = min(max(timeDelta, 0.0), 2.0 / CANOPY_REFERENCE_FPS);
	o.pos = float4(d.pos.x, -d.pos.y, float2(d.vel.x, -d.vel.y) * clearTime * VELOCITY_SCALE);
	o.mass = d.mass;
	return o;
}

[maxvertexcount(4)]
void DROPS_CLEAR_GS(point DROPS_CLEAR_VS_OUTPUT i[1], inout TriangleStream<DROPS_CLEAR_PS_INPUT> os) {
	DROPS_CLEAR_PS_INPUT o;
	if (i[0].mass == 0.0)
		return;

	bool isImpact = i[0].mass < 0.0;
	float2 surfaceUv = float2(i[0].pos.x * 0.5 + 0.5, -i[0].pos.y * 0.5 + 0.5);
	float2 d = isImpact ? float2(0, 0) : i[0].pos.zw * canopyCurvatureStretchDamp(surfaceUv);
	float2 p[2] = { i[0].pos.xy, i[0].pos.xy-d };
	float scale = pow(abs(i[0].mass), 0.33)*DROPLET_SCALE;
	if (isImpact)
		scale *= CANOPY_IMPACT_CLEAR_RADIUS;
	o.impact = isImpact ? 1.0 : 0.0;

	float2 dn = safeNormalize2(d, float2(0, 1));
//	float2x2 m = float2x2(dn.y, dn.x, -dn.x, dn.y);
	float2x2 m = float2x2(-dn.y, dn.x, -dn.x, -dn.y);

	[unroll]
	for (int k = 0; k < 4; ++k) {
		float2 dp = mul(quad[k], m);
		o.pos = float4(p[k/2] + dp * scale, 0, 1);
		o.uv = dp;
		o.uv2 = float2(o.pos.x * 0.5 + 0.5, -o.pos.y * 0.5 + 0.5);
		os.Append(o);
	}
	os.RestartStrip();
}

float edgeCoverage(float2 uv) {
	float r2 = dot(uv, uv);
	float w = max(fwidth(r2), 1.0 / TEX_SIZE);
	return saturate((1.0 - r2) / w);
}

float streamEdgeCoverage(float2 uv, float streamWeight) {
	float r2 = dot(uv, uv);
	float aaWidth = lerp(CANOPY_STREAM_EDGE_AA_MIN, CANOPY_STREAM_EDGE_AA_MAX, saturate(streamWeight));
	float w = max(fwidth(r2) * aaWidth, 2.0 / TEX_SIZE);
	float coverage = saturate((1.0 - r2) / w);
	return coverage * coverage * (3.0 - 2.0 * coverage);
}

float4 DROPS_CLEAR_PS(const DROPS_CLEAR_PS_INPUT i, uniform bool useWipers) : SV_TARGET0 {
//	return float4(0, 0, 0, 1);
	if (i.impact > 0.5) {
		if (edgeCoverage(i.uv) <= 0.0)
			discard;
		return float4(canopyNeutralNormal(), 1);
	}
	
	float2 uv = i.uv; uv.y = abs(0.2*uv.y);

	float aa = edgeCoverage(uv);
	float d2 = max(0, 1 - dot(uv, uv));
	float3 n = normalize(float3(uv, sqrt(d2) + 20 ));
//	float3 n = normalize(float3(uv, sqrt(d2) + max(5, 50 - length(wind) * 2)));

	n = normalize(lerp(n, float3(0, 0, 1), saturate(windForce * timeDelta) * 0.01));
	n = normalize(lerp(float3(0, 0, 1), n, aa));

	if (useWipers) 
		n = lerp(n, float3(0, 0, 1), wipersValue(i.uv2));

	return float4(n*0.5 + HALF, 1);
}

///////////////////////////////// independent impact splashes

// DCS invokes Drops P2/P3 for the incoming simAdd batch. Rendering impacts
// here keeps them additive: the same input still enters ADD_CS and becomes a
// normal moving/sliding droplet in the persistent simulation.
struct DROPS_IMPACT_VS_OUTPUT {
	float2 pos:		TEXCOORD0;
	float  mass:	TEXCOORD1;
	float  seed:	TEXCOORD2;
};

struct DROPS_IMPACT_PS_INPUT {
	float4 pos:		SV_POSITION;
	float2 uv:		TEXCOORD0;
	float2 uv2:		TEXCOORD1;
	float  mass:	TEXCOORD2;
	float2 shape:	TEXCOORD3;	// x: random seed, y: 0 ring / 1 splash bead
};

DROPS_IMPACT_VS_OUTPUT DROPS_IMPACT_VS(uint vid: SV_VertexID) {
	Droplet d = simAdd[vid];
	DROPS_IMPACT_VS_OUTPUT o;
	o.pos = d.pos;
	o.seed = hash12(d.pos * 37.17 + float2(float(vid) * 0.013, float(vid) * 0.029));
	// simAdd mass can be much smaller than the clamped/rescaled mass used by
	// ADD_CS. Give the one-shot impact enough raster footprint to survive the
	// 2048x2048 canopy target and its subsequent linear filtering.
	o.mass = max(abs(d.mass), lerp(CANOPY_IMPACT_VISUAL_MASS_MIN, CANOPY_IMPACT_VISUAL_MASS_MAX, o.seed));
	return o;
}

[maxvertexcount(4 * (1 + CANOPY_IMPACT_BEAD_COUNT))]
void DROPS_IMPACT_GS(point DROPS_IMPACT_VS_OUTPUT i[1], inout TriangleStream<DROPS_IMPACT_PS_INPUT> os) {
	float mass = i[0].mass;
	if (!(mass > 0.0))
		return;

	float seed = i[0].seed;
	float impactProbability = lerp(CANOPY_IMPACT_PROBABILITY_MIN, CANOPY_IMPACT_PROBABILITY_MAX, saturate(mass * 0.72)) * (1.0 - canopyImpactClearAmount());
	if (seed >= impactProbability)
		return;

	DROPS_IMPACT_PS_INPUT o;
	float2 p = i[0].pos;
	float2 shapeSeed = hash22(p * 29.71 + float2(seed * 17.13, seed * 41.37));
	float2 impactDir = safeNormalize2(shapeSeed - 0.5, float2(0, 1));
	float2x2 impactFrame = float2x2(impactDir.y, impactDir.x, -impactDir.x, impactDir.y);
	float scale = pow(abs(mass), 0.33) * DROPLET_SCALE * CANOPY_IMPACT_RENDER_SCALE * lerp(0.78, 1.28, shapeSeed.x);
	float ringRadius = lerp(CANOPY_IMPACT_RADIUS_MIN, CANOPY_IMPACT_RADIUS_MAX, shapeSeed.y);
	float ringAspect = lerp(0.84, 1.16, shapeSeed.x);

	o.mass = mass;
	o.shape = float2(shapeSeed.x, 0.0);
	[unroll]
	for (int k = 0; k < 4; ++k) {
		float2 local = quad[k];
		local.x *= ringAspect;
		local.y /= ringAspect;
		float2 dp = mul(local, impactFrame);
		o.pos = float4(p + dp * scale * ringRadius, 0, 1);
		o.uv = quad[k];
		o.uv2 = float2(o.pos.x * 0.5 + 0.5, -o.pos.y * 0.5 + 0.5);
		os.Append(o);
	}
	os.RestartStrip();

	// A few small satellite beads make the contact read as a splash rather than
	// another ordinary stationary canopy droplet.
	[unroll]
	for (int j = 0; j < CANOPY_IMPACT_BEAD_COUNT; ++j) {
		float fj = float(j);
		float2 beadSeed = hash22(p * (43.17 + fj * 11.31) + float2(seed * 67.13 + fj * 3.71, seed * 19.91 - fj * 5.17));
		float2 beadDir = safeNormalize2(beadSeed - 0.5, impactDir);
		float beadDistance = scale * CANOPY_IMPACT_BEAD_OFFSET * lerp(0.68, 1.35, beadSeed.y);
		float beadScale = scale * CANOPY_IMPACT_BEAD_SIZE * lerp(0.62, 1.32, beadSeed.x);
		float2 beadCenter = p + beadDir * beadDistance;
		o.shape = float2(beadSeed.x, 1.0);

		[unroll]
		for (int k = 0; k < 4; ++k) {
			o.pos = float4(beadCenter + quad[k] * beadScale, 0, 1);
			o.uv = quad[k];
			o.uv2 = float2(o.pos.x * 0.5 + 0.5, -o.pos.y * 0.5 + 0.5);
			os.Append(o);
		}
		os.RestartStrip();
	}
}

float4 DROPS_IMPACT_PS(const DROPS_IMPACT_PS_INPUT i, uniform bool useWipers) : SV_TARGET0 {
	float3 n;
	if (i.shape.y < 0.5) {
		float radius = length(i.uv);
		float angularBreakup = fastSin((i.uv.x * lerp(5.0, 8.0, i.shape.x) + i.uv.y * lerp(7.0, 4.0, i.shape.x) + i.shape.x * 6.2831853) * 3.1415927);
		float ringCenter = 0.69 + angularBreakup * 0.035;
		float ringWidth = lerp(CANOPY_IMPACT_RING_WIDTH_MIN, CANOPY_IMPACT_RING_WIDTH_MAX, i.shape.x);
		float ringCoord = (radius - ringCenter) / max(ringWidth, 0.001);
		float ringInterior = 1.0 - abs(ringCoord);
		if (radius >= ringCenter + ringWidth)
			discard;

		float edgeAa = max(fwidth(radius) / max(ringWidth, 0.001), 0.02);
		float coverage = saturate(max(ringInterior, 0.0) / edgeAa);
		float ringSlope = -4.0 * ringCoord * saturate(ringInterior) * coverage;
		float dimpleT = saturate(radius / max(ringCenter, 0.001));
		float dimpleSlope = -1.6 * dimpleT * (1.0 - dimpleT) * step(radius, ringCenter);
		float slope = ringSlope + dimpleSlope;
		float2 radialDir = i.uv * rsqrt(max(dot(i.uv, i.uv), 1.0e-6));
		float massStrength = lerp(0.62, 1.18, saturate(i.mass * 0.72));
		n = normalize(float3(radialDir * slope * CANOPY_IMPACT_NORMAL_STRENGTH * massStrength, 1.0));
	}
	else {
		float aa = edgeCoverage(i.uv);
		if (aa <= 0.0)
			discard;
		float d2 = max(0.0, 1.0 - dot(i.uv, i.uv));
		float beadStrength = lerp(0.72, 1.18, i.shape.x);
		n = normalize(float3(i.uv * beadStrength, sqrt(d2) + 0.72));
		n = normalize(lerp(float3(0, 0, 1), n, aa));
	}

	float impactClearAmount = max(canopyImpactClearAmount(), canopyClearAmount());
	n = normalize(lerp(float3(0, 0, 1), n, 1.0 - impactClearAmount));
	if (useWipers)
		n = lerp(n, float3(0, 0, 1), wipersValue(i.uv2));
	return float4(n * 0.5 + HALF, 1);
}

// Complete no-op pipeline retained for DCS's legacy P2/P3 micro-droplet pass
// indices. The separate full-canopy water film is generated and transported by
// BLUR_PS; impact records remain in simSrc and are rendered by P4/P5.
float2 DROPS_DISABLED_VS(uint vid: SV_VertexID): TEXCOORD0 {
	return float2(0, 0);
}

[maxvertexcount(1)]
void DROPS_DISABLED_GS(point float2 i[1]: TEXCOORD0, inout TriangleStream<DROPS_CLEAR_PS_INPUT> os) {
}

float4 DROPS_DISABLED_PS() : SV_TARGET0 {
	return float4(HALF, HALF, 1, 1);
}

/////////////////////////////////  drops

struct DROPS_VS_OUTPUT {
	float4 pos:		TEXCOORD0;
	float4 vel:		TEXCOORD1;
};

struct DROPS_PS_INPUT {
	float4 pos:		SV_POSITION;
	float2 uv:		TEXCOORD0;
	float2 uv2:		TEXCOORD1;
	float  mass:	TEXCOORD2;
	float2 force:	TEXCOORD3;
	float3 shape:	TEXCOORD4;
	float3 stream:	TEXCOORD5;
	float2 impact:	TEXCOORD6;	// x: random seed, y: impact visibility
};

static const float2 strip[12] = {
	{ -1, -1 },{ 1, -1 },
	{ -1, -0.60 },{ 1, -0.60 },
	{ -0.94, -0.15 },{ 0.94, -0.15 },
	{ -0.78,  0.30 },{ 0.78,  0.30 },
	{ -0.52,  0.68 },{ 0.52,  0.68 },
	{ -0.2,  1 },{ 0.2,  1 }
};

static const float2 highSpeedStrip[HIGH_SPEED_VISUAL_VERTICES] = {
	{ -1, -1 },{ 1, -1 },
	{ -0.92, -0.32 },{ 0.92, -0.32 },
	{ -0.58, 0.42 },{ 0.58, 0.42 },
	{ -0.12, 1 },{ 0.12, 1 }
};

DROPS_VS_OUTPUT DROPS_VS(uint vid: SV_VertexID) {
	Droplet d = simSrc[vid];
	DROPS_VS_OUTPUT o;
	o.pos = float4(d.pos.x, -d.pos.y, d.mass, d.walk);
	o.vel = float4(d.vel, d.force);
	return o;
}

[maxvertexcount(12 + HIGH_SPEED_VISUAL_VERTICES * HIGH_SPEED_VISUAL_INSTANCES)]
void DROPS_GS(point DROPS_VS_OUTPUT i[1], inout TriangleStream<DROPS_PS_INPUT> os) {
	DROPS_PS_INPUT o;
	float mass = i[0].pos.z;
	float2 p = i[0].pos.xy;
	if (mass < 0.0) {
		float impactMass = abs(mass);
		float impactAge = max(i[0].pos.w, 0.0);
		float impactProgress = saturate(impactAge / CANOPY_IMPACT_LIFETIME);
		float melt = smoothstep(CANOPY_IMPACT_HOLD_FRACTION, 1.0, impactProgress);
		float impactVisibility = (1.0 - melt) * (1.0 - canopyImpactClearAmount());
		if (impactVisibility <= 0.0)
			return;

		float impactSeed = frac(abs(i[0].vel.z));
		float2 shapeSeed = hash22(p * 29.71 + float2(impactSeed * 17.13, impactSeed * 41.37));
		float2 impactDir = safeNormalize2(shapeSeed - 0.5, float2(0, 1));
		float2x2 impactFrame = float2x2(impactDir.y, impactDir.x, -impactDir.x, impactDir.y);
		float impactScale = pow(impactMass, 0.33) * DROPLET_SCALE * CANOPY_IMPACT_RENDER_SCALE;
		float impactRadius = lerp(CANOPY_IMPACT_RADIUS_MIN, CANOPY_IMPACT_RADIUS_MAX, shapeSeed.y) * lerp(1.0, 0.76, melt);
		float impactAspect = lerp(0.84, 1.16, shapeSeed.x);

		o.mass = impactMass;
		o.force = float2(0, 0);
		o.shape = float3(shapeSeed, impactSeed);
		o.stream = float3(0, 0, 0);
		o.impact = float2(impactSeed, impactVisibility);
		[unroll]
		for (int k = 0; k < 4; ++k) {
			float2 local = quad[k];
			local.x *= impactAspect;
			local.y /= impactAspect;
			float2 dp = mul(local, impactFrame);
			o.pos = float4(p + dp * impactScale * impactRadius, 0, 1);
			o.uv = quad[k];
			o.uv2 = float2(o.pos.x * 0.5 + 0.5, -o.pos.y * 0.5 + 0.5);
			os.Append(o);
		}
		os.RestartStrip();
		return;
	}
	if(!(mass > 0))
		return;
	float2 surfaceUv = float2(p.x * 0.5 + 0.5, -p.y * 0.5 + 0.5);
	float curvatureT = canopyCurvatureMask(surfaceUv);
	float curvatureStretch = lerp(1.0, CANOPY_CURVATURE_STRETCH_MIN, curvatureT);
	float walk = i[0].pos.w;
	float trailMaturity = smoothstep(CANOPY_TRAIL_MATURITY_START, CANOPY_TRAIL_MATURITY_FULL, max(walk, 0.0));
	float2 v = i[0].vel.xy;
	float2 f = i[0].vel.zw;
	float massKey = floor(abs(mass) * 4096.0);
	float sizeRand = canopyDropSeedFromMassKey(p, massKey, 31.00, AFFINITY_SCALE * 0.44);
	float2 shapeRand = canopyDropSeed2FromMassKey(p, massKey, 33.40, AFFINITY_SCALE * 0.39);
	float shapeRand3 = canopyDropSeedFromMassKey(p, massKey, 36.70, AFFINITY_SCALE * 0.51);
	float scale = pow(abs(mass), 0.38)*DROPLET_SCALE * lerp(1.0 - CANOPY_RENDER_SIZE_VARIATION, 1.0 + CANOPY_RENDER_SIZE_VARIATION, sizeRand);
	float widthScale = lerp(1.0 - CANOPY_DROP_ASPECT_VARIATION, 1.0 + CANOPY_DROP_ASPECT_VARIATION, shapeRand.x);
	float lengthScale = lerp(1.0 + CANOPY_DROP_ASPECT_VARIATION * 0.45, 1.0 - CANOPY_DROP_ASPECT_VARIATION * 0.25, shapeRand.x) * lerp(0.88, 1.30, shapeRand.y);

	float2 fn = safeNormalize2(f, float2(0, 1));
	float2x2 m = float2x2(fn.y, fn.x, -fn.x, fn.y);
	float vMag = length(v);
	float streamT = smoothstep(CANOPY_MAX_SPEED * 0.22, CANOPY_MAX_SPEED * 0.95, vMag) * smoothstep(0.20, 0.95, saturate(mass));
	float airspeedStreamAmount = canopyAirspeedStreamAmount();
	streamT = max(streamT, airspeedStreamAmount * CANOPY_HIGH_SPEED_STREAM_BIAS * smoothstep(0.08, 0.80, saturate(mass)));
	float streakRand = canopyDropSeedFromMassKey(p, massKey, 41.10, AFFINITY_SCALE * 0.62);
	float streakRender = saturate(streamT * lerp(0.65, 1.35, streakRand)) * trailMaturity;
	float2 streakDir = safeNormalize2(v, fn);
	float longStreamSeed = canopyDropSeedFromMassKey(p - streakDir * 0.35, massKey, 19.80, AFFINITY_SCALE * 0.06);
	float longStream = canopyLongStreamAmount(streamT, mass, longStreamSeed) * trailMaturity;
	longStream *= curvatureStretch;
	float streamGrowth = smoothstep(0.006, CANOPY_LONG_STREAM_GROWTH_WALK, walk) * longStream;
	float longTail = lerp(1.0, lerp(1.28, CANOPY_LONG_STREAM_LENGTH, streamGrowth), longStream);
	float stormStreak = 1.0 + saturate(windForce * 0.045) * 1.2;
	float streakBase = saturate(vMag * lerp(240.0, 420.0, shapeRand.x) + length(f) * lerp(9.0, 18.0, shapeRand.y)) * (0.8 + saturate(windForce * 0.02)) * stormStreak * lerp(1.0, CANOPY_STREAK_RENDER_BOOST, streakRender);
	float streak = lerp(streakBase, pow(max(streakBase, 0.001), 0.42) * lerp(1.7, 2.6, shapeRand.y), saturate(vMag * lerp(16.0, 28.0, shapeRand.x) - 0.12));
	// Velocity is populated before a newly added drop has traveled across the
	// canopy. Ramp its visual tail from a compact impact mark to the full streak.
	streak *= lerp(0.12, 1.0, trailMaturity);
	streak = min(streak * curvatureStretch, lerp(6.0, CANOPY_CURVATURE_STREAK_MAX, curvatureT));
	float wigglePhase = (shapeRand3 + walk * 3.7 + sizeRand * 0.41) * 6.2831853;

	o.impact = float2(0, 0);

	[unroll]
	for (int k = 0; k < 12; ++k) {
		float2 baseStrip = strip[k];
		float streakT = saturate((baseStrip.y + 1.0) * 0.5);
		streakT = streakT * streakT * (3.0 - 2.0 * streakT);
		float2 local = baseStrip;
		float tailNarrow = lerp(1.0, lerp(0.95, 0.34 + 0.22 * shapeRand.y, streakT), streakRender * (0.65 + CANOPY_DROP_TAIL_VARIATION));
		float headBulge = 1.0 + CANOPY_LONG_STREAM_HEAD_BULGE * streamGrowth * longStream * (1.0 - smoothstep(0.12, 0.48, streakT));
		float thinTail = lerp(1.0, lerp(1.0, CANOPY_LONG_STREAM_TAIL_THIN, pow(streakT, 1.45)), streamGrowth * longStream);
		tailNarrow *= headBulge * thinTail;
		float tailLength = lerp(1.0, lerp(1.0, 1.35 + shapeRand3 * 0.45, streakT), streakRender * CANOPY_DROP_TAIL_VARIATION);
		tailLength *= lerp(1.0, longTail, streakT * streakRender);
		tailLength = lerp(1.0, tailLength, curvatureStretch);
		local.x *= widthScale * tailNarrow;
		local.y *= lengthScale * tailLength;
		local.x += (shapeRand3 - 0.5) * CANOPY_DROP_SHAPE_WARP * (1.0 - abs(baseStrip.y)) * widthScale;
		float wiggleMask = streakT * streakT * (1.0 - 0.30 * streakT);
		float wiggle = fastSin(wigglePhase + streakT * CANOPY_LONG_STREAM_WIGGLE_FREQ * 6.2831853) * CANOPY_LONG_STREAM_WIGGLE * streamGrowth * streakRender * wiggleMask;
		local.x += wiggle;
		float2 dp = mul(local, m);
		float2 dv = -float2(streakDir.x, -streakDir.y) * streak * scale * lerp(0.80, 1.75, streakRender) * lerp(0.78, 1.35, shapeRand.y) * lerp(1.0, longTail, longStream) * streakT;
		o.pos = float4(p + dv + dp * scale, 0, 1);
		o.uv = baseStrip;
		o.mass = mass;
		o.force = f;
		o.shape = float3(shapeRand, shapeRand3);
		o.stream = float3(streamGrowth, longStream, streakT);
		o.uv2 = float2(o.pos.x * 0.5 + 0.5, -o.pos.y * 0.5 + 0.5);
		os.Append(o);
	}
	os.RestartStrip();

	// Render-only high-speed population. The original strip above is emitted
	// unchanged. Stable mass/instance hashes avoid cell-boundary seed changes,
	// while projected position supplies continuous phase without depending on
	// walk, which the baseline split pass periodically drains.
	float highSpeedFactor = EvaluateHighSpeedDropletLayer();
	float2 renderFlow = safeNormalize2(float2(streakDir.x, -streakDir.y), float2(0, 1));
	float2 renderAcross = perp2(renderFlow);
	[unroll]
	for (int hsInstance = 0; hsInstance < HIGH_SPEED_VISUAL_INSTANCES; ++hsInstance) {
		float instanceIndex = float(hsInstance);
		float2 instanceSeed = hash22(float2(
			massKey * 0.0017 + instanceIndex * 17.31 + 13.17,
			massKey * 0.0031 + instanceIndex * 31.91 + 47.73));
		float phaseRate = HIGH_SPEED_FLOW_SPEED * lerp(0.82, 1.22, instanceSeed.y) *
			lerp(0.62, 1.38, highSpeedFactor);
		float phase = frac(dot(p, renderFlow) * phaseRate + instanceSeed.x);
		float phaseVisibility = smoothstep(0.0, HIGH_SPEED_PHASE_FADE_IN, phase) *
			(1.0 - smoothstep(HIGH_SPEED_PHASE_FADE_OUT, 1.0, phase));
		float densityVisibility = smoothstep(instanceSeed.y - 0.16, instanceSeed.y + 0.06,
			highSpeedFactor * HIGH_SPEED_DENSITY);
		float visualOpacity = highSpeedFactor * phaseVisibility * densityVisibility * HIGH_SPEED_OPACITY;

		float sizeBias = instanceSeed.x * instanceSeed.x;
		float visualSize = lerp(HIGH_SPEED_MIN_SIZE, HIGH_SPEED_MAX_SIZE, sizeBias);
		float travelDistance = lerp(HIGH_SPEED_TRAVEL_MIN, HIGH_SPEED_TRAVEL_MAX, highSpeedFactor) *
			lerp(0.82, 1.18, instanceSeed.y);
		float trailLength = lerp(HIGH_SPEED_MIN_TRAIL_LENGTH, HIGH_SPEED_MAX_TRAIL_LENGTH, highSpeedFactor) *
			lerp(0.72, 1.28, instanceSeed.x);
		float lateralVariation = (instanceSeed.y - 0.5) * 2.0;
		float directionVariation = HIGH_SPEED_DIRECTION_VARIATION * lerp(1.0, 0.42, highSpeedFactor);
		float2 instanceFlow = safeNormalize2(renderFlow + renderAcross * lateralVariation * directionVariation, renderFlow);
		float2 instanceAcross = perp2(instanceFlow);
		float2 headCenter = p +
			instanceFlow * ((phase - 0.5) * travelDistance * DROPLET_SCALE * highSpeedFactor) +
			renderAcross * lateralVariation * HIGH_SPEED_POSITION_VARIATION * DROPLET_SCALE * highSpeedFactor;
		// Zero-area below 200 knots: fixed GS work, negligible inactive raster cost.
		float visualScale = DROPLET_SCALE * visualSize * highSpeedFactor;

		o.mass = max(visualSize, 0.001);
		o.force = instanceFlow;
		o.shape = float3(instanceSeed, 2.0);
		o.impact = float2(visualOpacity, -1.0); // negative y selects the new PS path
		[unroll]
		for (int k = 0; k < HIGH_SPEED_VISUAL_VERTICES; ++k) {
			float2 baseStrip = highSpeedStrip[k];
			float trailT = saturate((baseStrip.y + 1.0) * 0.5);
			float smoothTrailT = trailT * trailT * (3.0 - 2.0 * trailT);
			float headBulge = 1.0 + (1.0 - smoothstep(0.0, 0.26, trailT)) * lerp(0.22, 0.48, sizeBias);
			float taperedWidth = lerp(1.0, 0.09, pow(trailT, 0.70)) * headBulge;
			float pathCurve = fastSin((trailT * lerp(1.1, 1.7, instanceSeed.x) + instanceSeed.y * 2.3) * 6.2831853) *
				directionVariation * visualScale * 1.6 * smoothTrailT;
			float2 trailCenter = headCenter -
				instanceFlow * (trailLength * visualScale * smoothTrailT) +
				instanceAcross * pathCurve;
			o.pos = float4(trailCenter + instanceAcross * baseStrip.x * visualScale * taperedWidth, 0, 1);
			o.uv = float2(baseStrip.x, trailT);
			o.uv2 = float2(o.pos.x * 0.5 + 0.5, -o.pos.y * 0.5 + 0.5);
			o.stream = float3(visualOpacity, highSpeedFactor, trailT);
			os.Append(o);
		}
		os.RestartStrip();
	}
}

float3x3 rotMatrix(float3 from, float3 to) {
	float3 c = cross(from, to);
	float e = dot(from, to);
	float h = 1.0 / max(1.0 + e, 1.0e-4);

	return float3x3(
		e + h * c[0] * c[0],
		h * c[0] * c[1] - c[2],
		h * c[0] * c[2] + c[1],

		h * c[0] * c[1] + c[2],
		e + h * c[1] * c[1],
		h * c[1] * c[2] - c[0],

		h * c[0] * c[2] - c[1],
		h * c[1] * c[2] + c[0],
		e + h * c[2] * c[2]
		);
}

float4 DROPS_PS(const DROPS_PS_INPUT i, uniform bool useWipers) : SV_TARGET0 {
	if (!(i.mass > 0))
		discard;

	if (i.impact.y < -0.5) {
		// Separate render-only shading for the procedural instances. Invisible
		// instances discard, so a disabled/inactive layer cannot overwrite the
		// baseline normal target.
		float visualOpacity = saturate(i.impact.x);
		if (visualOpacity <= 0.001)
			discard;

		float trailT = saturate(i.uv.y);
		float sideDistance = abs(i.uv.x);
		float sideAa = max(fwidth(sideDistance) * 1.6, 1.5 / TEX_SIZE);
		float sideCoverage = saturate((1.0 - sideDistance) / sideAa);
		float endCoverage = smoothstep(0.0, 0.045, trailT) *
			(1.0 - smoothstep(0.94, 1.0, trailT));
		float coverage = sideCoverage * endCoverage;
		if (coverage <= 0.001)
			discard;

		float2 flowDir = safeNormalize2(i.force, float2(0, 1));
		float2 acrossDir = perp2(flowDir);
		float headWeight = 1.0 - smoothstep(0.04, 0.32, trailT);
		float tailRelief = lerp(1.0, 0.24, smoothstep(0.16, 1.0, trailT));
		float instanceVariation = lerp(0.88, 1.12, i.shape.x);
		float sideSlope = i.uv.x * HIGH_SPEED_REFRACTION_STRENGTH * tailRelief * instanceVariation;
		float headSlope = (0.5 - trailT) * headWeight * HIGH_SPEED_REFRACTION_STRENGTH * 0.68;
		float2 normalXy = acrossDir * sideSlope - flowDir * headSlope;
		float3 n = normalize(float3(normalXy, 1.0));
		n = normalize(lerp(float3(0, 0, 1), n, visualOpacity * coverage));

		if (useWipers)
			n = lerp(n, float3(0, 0, 1), wipersValue(i.uv2));
		return float4(n * 0.5 + HALF, 1);
	}

	if (i.impact.y > 0.0) {
		float radius = length(i.uv);
		float angularBreakup = fastSin((i.uv.x * lerp(5.0, 8.0, i.impact.x) + i.uv.y * lerp(7.0, 4.0, i.impact.x) + i.impact.x * 6.2831853) * 3.1415927);
		float ringCenter = 0.69 + angularBreakup * 0.035;
		float ringWidth = lerp(CANOPY_IMPACT_RING_WIDTH_MIN, CANOPY_IMPACT_RING_WIDTH_MAX, i.impact.x);
		float ringCoord = (radius - ringCenter) / max(ringWidth, 0.001);
		float ringInterior = 1.0 - abs(ringCoord);
		if (radius >= ringCenter + ringWidth)
			discard;

		float edgeAa = max(fwidth(radius) / max(ringWidth, 0.001), 0.02);
		float coverage = saturate(max(ringInterior, 0.0) / edgeAa);
		float ringSlope = -4.0 * ringCoord * saturate(ringInterior) * coverage;
		float dimpleT = saturate(radius / max(ringCenter, 0.001));
		float dimpleSlope = -1.6 * dimpleT * (1.0 - dimpleT) * step(radius, ringCenter);
		float2 radialDir = i.uv * rsqrt(max(dot(i.uv, i.uv), 1.0e-6));
		float massStrength = lerp(0.72, 1.28, saturate(i.mass * 0.72));
		float visibleImpact = i.impact.y * (1.0 - canopyClearAmount());
		float3 impactNormal = normalize(float3(radialDir * (ringSlope + dimpleSlope) * CANOPY_IMPACT_NORMAL_STRENGTH * massStrength * visibleImpact, 1.0));
		if (useWipers)
			impactNormal = lerp(impactNormal, float3(0, 0, 1), wipersValue(i.uv2));
		return float4(impactNormal * 0.5 + HALF, 1);
	}

	float2 uv = i.uv;
	float asym = (i.shape.x - 0.5) * 2.0;
	float streamGrowth = i.stream.x;
	float longStream = i.stream.y;
	float tailT = i.stream.z;
	float lobe = saturate(1.0 - abs(uv.y)) * (0.55 + 0.45 * saturate(1.0 - abs(uv.x)));
	uv.x += asym * lobe * CANOPY_DROP_SHAPE_WARP;
	uv.y *= lerp(1.10, 0.88, i.shape.y);
	float edgeRipple = fastSin((uv.x * lerp(5.0, 9.0, i.shape.x) + uv.y * lerp(7.0, 4.0, i.shape.y) + i.shape.z * 6.2831853) * 3.1415927) * CANOPY_STREAM_EDGE_RIPPLE * CANOPY_DROP_TAIL_VARIATION;
	uv *= 1.0 + edgeRipple * saturate(1.0 - abs(uv.y));

	float streamAaWeight = saturate(max(streamGrowth, longStream) + tailT * 0.35);
	float aa = streamEdgeCoverage(uv, streamAaWeight);
	if (aa <= 0)
		discard;
	float d2 = max(0, 1 - dot(uv, uv));

	float2 f2 = i.force.xy / max(i.mass, 0.08);
	// The old two-stage clamps performed two vector lengths even though the
	// second, tighter clamp always dominated the first.
	f2 *= rsqrt(max(1.0, dot(f2, f2) * 12.25));
	float3 f = float3(f2, sqrt(saturate(1 - dot(f2, f2))));
	float3x3 rm = rotMatrix(float3(0, 0, 1), normalize(float3(f2 * 0.4, 1.0)));
	float normalBoost = max(CANOPY_DROPLET_NORMAL_STRENGTH / CANOPY_DROPLET_NORMAL_REFERENCE, 0.05);

	float3 n = mul(normalize(float3(uv * CANOPY_DROPLET_NORMAL_STRENGTH, sqrt(d2))), rm);
	float headWeight = longStream * streamGrowth * (1.0 - smoothstep(0.18, 0.55, tailT));
	float tailWeight = longStream * streamGrowth * smoothstep(0.35, 1.0, tailT);
	n.xy *= lerp(1.0, 1.22, headWeight);
	n = normalize(n);
	n = normalize(lerp(n, float3(0, 0, 1), tailWeight * CANOPY_LONG_STREAM_TAIL_FLATTEN));

	float tf = smoothstep(0.05, 0.9, saturate(dot(-f, n)));
	float tf_damp = saturate(tf * sqrt(tf) * 0.5 + windForce * 0.010);
	n = normalize(lerp(n, float3(0, 0, 1), tf_damp * CANOPY_SHIMMER_DAMP));
	n = normalize(float3(n.xy * normalBoost, max(n.z, 1.0e-4)));

	// Clearing and antialiased edge coverage both fade toward the neutral
	// normal; combining them removes one normalization per shaded fragment.
	float visibleRelief = (1.0 - canopyClearAmount()) * aa * CANOPY_DROPLET_REFRACTION_GAIN;
	n = normalize(lerp(float3(0, 0, 1), n, visibleRelief));

	if (useWipers)
		n = lerp(n, float3(0, 0, 1), wipersValue(i.uv2));

	return float4(n*0.5 + HALF, 1);
}

/////////////////////////////////////////////////////////////////////////////////

float4 BLUR_PS(const VS_OUTPUT i, uniform bool useWipers) : SV_TARGET0 {
	float2 uv = float2(i.projPos.x*0.5 + 0.5, -i.projPos.y*0.5 + 0.5);
	float3 neutral = canopyNeutralNormal();
	float clearAmount = canopyClearAmount();
	if (clearAmount >= 0.999)
		return float4(neutral, 1);
	float3 srcCenter = sanitizeCanopyFeedback(src.SampleLevel(ClampLinearSampler, uv, 0).xyz);
	float3 relief = srcCenter - neutral;
	if (dot(relief, relief) <= 1.0e-8)
		return float4(neutral, 1);

	float4 q = getTangentSpace(uv);
	float3 normal = normalFromTangentSpace(q);
	float3 Vs = (wind - normal * dot(wind, normal)) * WIND_SCALE; // world space along surface
	float2 windUv = mulQuatVec3(q, Vs).xy; // texture space
	float blurTime = min(max(timeDelta, 0.0), 2.0 / CANOPY_REFERENCE_FPS);
	float windAmount = saturate(max(windForce, 0.0) * blurTime);

	// Baseline feedback transport only: there is no independent full-canopy
	// full-canopy water layer. High-speed rain is represented by long trails.
	float3 advected = sanitizeCanopyFeedback(src.SampleLevel(ClampLinearSampler, uv - windUv * (0.15 / TEX_SIZE), 0).xyz);
	float3 c = lerp(srcCenter, advected, windAmount);

	// The clamped step is visually equivalent to the prior exponential at these
	// small rates, but is cheaper and remains stable after a long frame.
	float evaporate = saturate(blurTime * (CANOPY_EVAP_RATE + saturate(windForce * WIND_SCALE) * 0.08));
	c = lerp(c, neutral, evaporate);
	c = lerp(c, neutral, clearAmount);

	if (useWipers) 
		c = lerp(c, neutral, wipersValue(uv)*0.5);
	
	return float4(c, 1);
}

/////////////////////////////////////////////////////////////////////////////////

#define COMMON_COMPUTE	SetVertexShader(NULL);		\
						SetGeometryShader(NULL);	\
						SetPixelShader(NULL);

#define COMMON_DROPS	SetDepthStencilState(disableDepthBuffer, 0);									\
						SetBlendState(disableAlphaBlend, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);	\
						SetRasterizerState(cullNone);

#define COMMON_PART		SetVertexShader(CompileShader(vs_4_0, VS()));	\
						SetGeometryShader(NULL);						\
						COMMON_DROPS

technique10 Sim {
	pass P0 {
		SetComputeShader(CompileShader(cs_5_0, INIT_CS()));
		COMMON_COMPUTE
	}
	pass P1 {
		SetComputeShader(CompileShader(cs_5_0, ADD_CS()));
		COMMON_COMPUTE
	}
	pass P2 {
		SetComputeShader(CompileShader(cs_5_0, SIM_CS(false, false)));
		COMMON_COMPUTE
	}
	pass P3 {
		SetComputeShader(CompileShader(cs_5_0, SIM_CS(false, true)));
		COMMON_COMPUTE
	}
	pass P4 {
		SetComputeShader(CompileShader(cs_5_0, SIM_CS(true, false)));
		COMMON_COMPUTE
	}
	pass P5 {
		SetComputeShader(CompileShader(cs_5_0, SIM_CS(true, true)));
		COMMON_COMPUTE
	}
	pass P6 {
		SetComputeShader(CompileShader(cs_5_0, COLLISION_CS()));
		COMMON_COMPUTE
	}
	pass P7 {
		SetComputeShader(CompileShader(cs_5_0, SPLIT_CS()));
		COMMON_COMPUTE
	}
}

technique10 Drops {
	pass P0 {		// clear droplet tracks
		SetVertexShader(CompileShader(vs_5_0, DROPS_CLEAR_VS()));
		SetGeometryShader(CompileShader(gs_5_0, DROPS_CLEAR_GS()));
		SetPixelShader(CompileShader(ps_5_0, DROPS_CLEAR_PS(false)));
		COMMON_DROPS
	}
	pass P1 {		// clear droplet tracks
		SetVertexShader(CompileShader(vs_5_0, DROPS_CLEAR_VS()));
		SetGeometryShader(CompileShader(gs_5_0, DROPS_CLEAR_GS()));
		SetPixelShader(CompileShader(ps_5_0, DROPS_CLEAR_PS(true)));
		COMMON_DROPS
	}
	pass P2 {		// legacy micro-droplet pass disabled
		SetVertexShader(CompileShader(vs_5_0, DROPS_DISABLED_VS()));
		SetGeometryShader(CompileShader(gs_5_0, DROPS_DISABLED_GS()));
		SetPixelShader(CompileShader(ps_5_0, DROPS_DISABLED_PS()));
		COMMON_DROPS
	}
	pass P3 {		// legacy micro-droplet pass disabled
		SetVertexShader(CompileShader(vs_5_0, DROPS_DISABLED_VS()));
		SetGeometryShader(CompileShader(gs_5_0, DROPS_DISABLED_GS()));
		SetPixelShader(CompileShader(ps_5_0, DROPS_DISABLED_PS()));
		COMMON_DROPS
	}
	pass P4 {		// add big droplets
		SetVertexShader(CompileShader(vs_5_0, DROPS_VS()));
		SetGeometryShader(CompileShader(gs_5_0, DROPS_GS()));
		SetPixelShader(CompileShader(ps_5_0, DROPS_PS(false)));
		COMMON_DROPS
	}
	pass P5 {		// add big droplets
		SetVertexShader(CompileShader(vs_5_0, DROPS_VS()));
		SetGeometryShader(CompileShader(gs_5_0, DROPS_GS()));
		SetPixelShader(CompileShader(ps_5_0, DROPS_PS(true)));
		COMMON_DROPS
	}
}

technique10 Blur {
	pass P0 {		
		SetPixelShader(CompileShader(ps_5_0, BLUR_PS(false)));
		COMMON_PART
	}
	pass P1 {
		SetPixelShader(CompileShader(ps_5_0, BLUR_PS(true)));
		COMMON_PART
	}
}

technique10 Copy {
	pass P0 {
		SetPixelShader(CompileShader(ps_4_0, COPY_PS()));
		COMMON_PART
	}
}
