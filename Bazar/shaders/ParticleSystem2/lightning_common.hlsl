#ifndef LIGHTNING_COMMON_HLSL
#define LIGHTNING_COMMON_HLSL

// ---------------------------------------------------------------------------
//  lightning_common.hlsl - shared helpers for all lightning techniques
// ---------------------------------------------------------------------------

#include "common/samplers11.hlsl"
#include "enlight/materialParams.hlsl"
#include "common/AmbientCube.hlsl"

// ---------------------------------------------------------------------------
//  Cloud presence detection
// ---------------------------------------------------------------------------

static const float CLOUD_VOLUME_RELIABLE_RADIUS_KM = 12.0;
static const float CLOUD_BAND_PAD_M = 1500.0;
static const float LIGHTNING_MIN_CLOUDINESS = 0.02;

bool HasLightningCloudLayer()
{
	return (gCloudiness >= LIGHTNING_MIN_CLOUDINESS)
	    && (gCloudsHigh > gCloudsLow + 1.0);
}

float SampleCloudDensityForLightning(float3 pos)
{
	float3 uvw = pos * gCloudVolumeScale + gCloudVolumeOffset;
	float2 s = cloudsDensityMap.SampleLevel(gBilinearClampSampler, uvw.xzy, 0).xy;
	s.y *= s.y;
	s.y = smoothstep(0.0, 0.1, s.y);
	float densityGrad = s.x * 2 - 1;
	float shapeSignal = saturate(densityGrad * 3 + 0.1);
	return 1 - exp(-shapeSignal * s.y * 6000);
}

bool IsInsideCloudVolume(float3 pos)
{
	float3 uvw = pos * gCloudVolumeScale + gCloudVolumeOffset;
	const float margin = 0.02;
	bool inside = (uvw.x > margin) && (uvw.y > margin) && (uvw.z > margin)
	           && (uvw.x < (1.0 - margin)) && (uvw.y < (1.0 - margin)) && (uvw.z < (1.0 - margin));
	return inside;
}

bool IsInCloudBand(float worldAltitude)
{
	if (!HasLightningCloudLayer())
		return false;

	float lo = gCloudsLow  - CLOUD_BAND_PAD_M;
	float hi = gCloudsHigh + CLOUD_BAND_PAD_M;
	return (worldAltitude >= lo) && (worldAltitude <= hi);
}

bool CloudGateClose(float3 posMiddle, float3 pos0, float3 pos1,
                    float distanceKm, float threshold)
{
	if (!HasLightningCloudLayer())
		return false;

	bool result = true;
	if (gUseVolumetricClouds > 0.5 &&
	    distanceKm < CLOUD_VOLUME_RELIABLE_RADIUS_KM &&
	    IsInsideCloudVolume(posMiddle))
	{
		float dM = SampleCloudDensityForLightning(posMiddle);
		float d0 = SampleCloudDensityForLightning(pos0);
		float d1 = SampleCloudDensityForLightning(pos1);
		float maxD = max(dM, max(d0, d1));
		float relaxT = saturate(distanceKm / CLOUD_VOLUME_RELIABLE_RADIUS_KM);
		float effThreshold = lerp(threshold, 0.0, relaxT);
		result = (maxD >= effThreshold);
	}
	else
	{
		float altM = posMiddle.y + gOrigin.y;
		float alt0 = pos0.y + gOrigin.y;
		float alt1 = pos1.y + gOrigin.y;
		result = IsInCloudBand(altM) || IsInCloudBand(alt0) || IsInCloudBand(alt1);
	}
	return result;
}

bool CloudGateDistant(float3 posMiddle)
{
	float alt = posMiddle.y + gOrigin.y;
	return IsInCloudBand(alt);
}

// ---------------------------------------------------------------------------
//  Altitude gate
// ---------------------------------------------------------------------------

bool AltitudeGate(float3 posMiddle, float y0, float y1, float maxAltM)
{
	float altMid = posMiddle.y + gOrigin.y;
	float alt0   = y0 + gOrigin.y;
	float alt1   = y1 + gOrigin.y;
	return min(altMid, min(alt0, alt1)) > maxAltM;
}

// ---------------------------------------------------------------------------
//  Day/night factor  (must precede all helpers that reference it)
// ---------------------------------------------------------------------------

float GetNightFactor()
{
	float dayFactor = smoothstep(0.0, 1.0, gSunIntensity / 15.0);
	return 1.0 - dayFactor;
}

// ---------------------------------------------------------------------------
//  Exposure-adaptive HDR scaling
// ---------------------------------------------------------------------------

float ExposureAdaptiveBoost()
{
	float ex = max(0.01, gExposure);
	return clamp(0.6 / ex, 0.5, 6.0);
}

// ---------------------------------------------------------------------------
//  Strike envelope with stepped leader pre-glow and multi-stroke pattern
//  Improved: sharper initial return stroke, more dramatic re-strokes,
//  variable inter-stroke timing for natural look
// ---------------------------------------------------------------------------

float StrikeEnvelope(float birthTime, float t, float holdS, float fadeS)
{
	float life = max(0.0, t - birthTime);

	// Instant return-stroke onset with a brief hold, then rapid non-linear decay.
	float holdSpan = max(0.001, holdS);
	float decaySpan = max(0.001, fadeS);
	float holdMask = 1.0 - smoothstep(holdSpan, holdSpan + 0.006, life);
	float decayT = saturate((life - holdSpan) / decaySpan);
	float decay = exp(-6.0 * decayT * decayT);
	float primary = lerp(decay, 1.0, holdMask);

	// Deterministic, weak secondary pulse with per-strike timing variance.
	float seed = frac(sin((birthTime + 13.7) * 91.73) * 43758.5453);
	float rsDelay = lerp(0.030, 0.090, seed);
	float rsWidth = lerp(0.010, 0.017, frac(seed * 7.13));
	float rsAmp = lerp(0.20, 0.45, frac(seed * 3.71));
	float rs = rsAmp * exp(-((life - rsDelay) * (life - rsDelay)) / max(1e-4, rsWidth * rsWidth));

	return saturate(primary + rs);
}

// ---------------------------------------------------------------------------
//  Thermal afterglow channel
// ---------------------------------------------------------------------------

float ThermalAfterglow(float birthTime, float t, float holdS, float fadeS)
{
	float life = max(0.0, t - birthTime);
	float boltEnd = holdS + fadeS;
	float afterLife = max(0.0, life - boltEnd);
	float afterglowDuration = min(0.060, max(0.020, fadeS * 0.45));
	float glow = 0.015 * (1.0 - smoothstep(0.0, afterglowDuration, afterLife));
	return glow * step(0.003, life);
}

float3 ThermalAfterglowColor()
{
	float nightT = GetNightFactor();
	float3 warmClr = float3(1.0, 0.82, 0.50);
	float3 neutralClr = float3(0.9, 0.9, 0.95);
	return lerp(neutralClr, warmClr, nightT * 0.7);
}

// ---------------------------------------------------------------------------
//  Re-stroke width pulsation  (improved: sharper pulses)
// ---------------------------------------------------------------------------

float StrikeWidthPulsation(float birthTime, float t)
{
	float life = max(0.0, t - birthTime);

	float initialPulse = 0.78 * exp(-120.0 * life * life);
	float rp1 = 0.42 * exp(-980.0 * (life - 0.014) * (life - 0.014));
	float rp2 = 0.32 * exp(-1080.0 * (life - 0.034) * (life - 0.034));
	float rp3 = 0.23 * exp(-1180.0 * (life - 0.056) * (life - 0.056));
	float rp4 = 0.14 * exp(-1280.0 * (life - 0.082) * (life - 0.082));
	float rp5 = 0.08 * exp(-1380.0 * (life - 0.112) * (life - 0.112));

	return 1.0 + initialPulse + rp1 + rp2 + rp3 + rp4 + rp5;
}

// ---------------------------------------------------------------------------
//  Re-stroke colour temperature shift
// ---------------------------------------------------------------------------

float3 RestrikeColorShift(float birthTime, float t)
{
	float life = max(0.0, t - birthTime);
	float phase = saturate(life * 6.0);
	float3 warm = float3(1.00, 0.97, 0.92);
	float3 cool = float3(0.85, 0.88, 1.08);
	return lerp(warm, cool, phase * phase);
}

// ---------------------------------------------------------------------------
//  Altitude-aware fog attenuation
// ---------------------------------------------------------------------------

float AltitudeFogAttenuation(float distKm)
{
	float visKm = max(0.1, gFogParams.visibilityKm);
	float sigma = 3.912 / visKm;
	float fogImmersion = saturate(1.0 - gFogCameraHeightNorm);
	float layerPresence = saturate(gFogParams.layerHeight * 0.001);
	float effectiveSigma = sigma * fogImmersion * layerPresence;
	return exp(-effectiveSigma * distKm);
}

float3 ApplyFogTint(float3 color, float fogTransmittance)
{
	float3 fogClr = gFogParams.color;
	float fogLum  = max(0.01, dot(fogClr, float3(0.2126, 0.7152, 0.0722)));
	fogClr = fogClr / fogLum;
	float inscatterT = 1.0 - fogTransmittance;
	return lerp(color, color * fogClr, inscatterT * 0.25);
}

// ---------------------------------------------------------------------------
//  Time-of-day aware bolt colour  (improved: more vivid, physically based)
// ---------------------------------------------------------------------------

float3 GetEnvironmentLightColor()
{
	float3 ambUp = AmbientLight(float3(0, 1, 0));
	float3 envClr = gSunDiffuse * gSunIntensity * 0.02 + ambUp * 0.15;
	float envLum = max(0.01, dot(envClr, float3(0.2126, 0.7152, 0.0722)));
	return envClr / envLum;
}

struct BoltColors
{
	float3 core;
	float3 corona;
	float3 glow;
};

BoltColors GetBoltColorsTOD()
{
	float3 envTint = GetEnvironmentLightColor();
	float nightT = GetNightFactor();

	BoltColors c;
	// Core: near-white with subtle blue shift, more saturated at night
	c.core   = lerp(float3(0.96, 0.97, 1.00), float3(0.90, 0.93, 1.00), nightT);
	c.core   = lerp(c.core, c.core * envTint, 0.04);

	// Corona: blue-white, stronger blue at night
	c.corona = lerp(float3(0.78, 0.83, 1.00), float3(0.70, 0.78, 1.00), nightT);
	c.corona = lerp(c.corona, c.corona * envTint, 0.12);

	// Glow: deep blue-violet, highly saturated
	c.glow   = lerp(float3(0.38, 0.48, 1.15), float3(0.32, 0.42, 1.20), nightT);
	c.glow   = lerp(c.glow, c.glow * envTint, 0.25);

	return c;
}

// ---------------------------------------------------------------------------
//  Moonlight glow tint
// ---------------------------------------------------------------------------

float3 MoonlightGlowTint(float glowMask)
{
	float nightT = GetNightFactor();
	float3 moonClr = gMoonDiffuse;
	float moonLum = max(0.01, dot(moonClr, float3(0.2126, 0.7152, 0.0722)));
	moonClr = moonClr / moonLum;
	moonClr = lerp(float3(1, 1, 1), moonClr, 0.35);
	float strength = nightT * glowMask * 0.35;
	return lerp(float3(1, 1, 1), moonClr, strength);
}

float3 BoltColorTOD(float coreMask, float3 baseCoreClr, float3 baseEdgeClr)
{
	float3 envTint = GetEnvironmentLightColor();
	float3 core = lerp(baseCoreClr, baseCoreClr * envTint, 0.08);
	float3 edge = lerp(baseEdgeClr, baseEdgeClr * envTint, 0.25);
	return lerp(edge, core, coreMask);
}

// ---------------------------------------------------------------------------
//  Core bloom desaturation  (improved: stronger white-out at peak)
// ---------------------------------------------------------------------------

float3 CoreBloomDesaturate(float3 color, float coreMask, float env)
{
	float desatT = coreMask * saturate(env * env * 2.0);
	float lum = dot(color, float3(0.2126, 0.7152, 0.0722));
	return lerp(color, float3(lum, lum, lum), desatT * 0.75);
}

// ---------------------------------------------------------------------------
//  Three-layer radial profile  (improved: smoother transitions, wider glow)
// ---------------------------------------------------------------------------

float3 BoltRadialProfile(float x)
{
	float core   = exp(-x * x * 180.0);
	float corona = exp(-x * x * 12.0);
	float glow   = exp(-x * x * 2.8);
	return float3(saturate(core), saturate(corona), saturate(glow));
}

// ---------------------------------------------------------------------------
//  Distance-dependent glow broadening
// ---------------------------------------------------------------------------

float DistantProfileBroaden(float x, float distKm)
{
	float broadenT = saturate((distKm - 3.0) / 40.0);
	float broadenScale = lerp(1.0, 0.45, broadenT);
	return saturate(x * broadenScale);
}

// ---------------------------------------------------------------------------
//  Vertical brightness gradient  (improved: brighter at cloud base)
// ---------------------------------------------------------------------------

float VerticalBrightnessGrad(float v)
{
	// Brightest at cloud base (v=0), natural dimming toward ground
	float mainDim  = lerp(1.0, 0.35, v * v * v);
	float tipFlash = 0.20 * exp(-1000.0 * (v - 0.97) * (v - 0.97));
	// Cloud base glow
	float baseGlow = 0.15 * exp(-600.0 * v * v);
	return mainDim + tipFlash + baseGlow;
}

// ---------------------------------------------------------------------------
//  Ground-strike junction flash  (improved: brighter, wider)
// ---------------------------------------------------------------------------

float GroundStrikeFlash(float v, float env)
{
	float flash = exp(-800.0 * (v - 0.98) * (v - 0.98));
	flash *= saturate(env * env * 4.0);
	return flash * 4.0;
}

// ---------------------------------------------------------------------------
//  Branch taper
// ---------------------------------------------------------------------------

float BranchTaper(float v)
{
	return lerp(1.0, 0.35, pow(v, 1.3));
}

// ---------------------------------------------------------------------------
//  Segment-level intensity jitter  (improved: more variation)
// ---------------------------------------------------------------------------

float SegmentJitter(float v, float seed)
{
	float n = snoise(float2(v * 28.0, seed * 9.17));
	return 0.72 + 0.28 * n;
}

// ---------------------------------------------------------------------------
//  Multi-frequency flicker  (improved: more chaotic, realistic)
// ---------------------------------------------------------------------------

float BoltFlicker(float t, float v, float seed)
{
	float phase = frac(seed * 137.51) * 6.2832;
	// Ultra-fast chaotic flicker (ionization channel instability)
	float fUltra = 0.97 + 0.03 * sin(t * 280.0 + v * 97.0 + phase);
	// Random ultra-fast noise component
	float fChaos = 0.96 + 0.04 * frac(sin(t * 173.0 + v * 53.0 + phase * 3.1) * 43758.5);
	// Medium-speed flicker (current pulsation)
	float fFast  = 0.90  + 0.10  * sin(t * 45.0  + v * 33.0 + phase * 2.17);
	// Slow breathing (thermal channel variation)
	float fSlow  = 0.85  + 0.15  * (0.5 + 0.5 * sin(t * 7.0 + phase * 0.73));
	return fUltra * fChaos * fFast * fSlow;
}

float BoltFlickerDistant(float t, float v, float seed)
{
	float phase = frac(seed * 137.51) * 6.2832;
	float fFast = 0.95 + 0.05 * sin(t * 55.0 + v * 25.0 + phase);
	float fSlow = 0.88 + 0.12 * (0.5 + 0.5 * sin(t * 5.0 + phase * 0.73));
	return fFast * fSlow;
}

// ---------------------------------------------------------------------------
//  Atmospheric fog extinction for distant bolts
// ---------------------------------------------------------------------------

float AtmosphericExtinction(float distKm)
{
	float visKm = max(1.0, gFogParams.visibilityKm);
	float sigma = 3.912 / visKm;
	return exp(-sigma * distKm);
}

// ---------------------------------------------------------------------------
//  Rayleigh scattering blue shift at distance
// ---------------------------------------------------------------------------

float3 RayleighDistanceShift(float3 color, float distKm)
{
	float3 sigmaR = gAtmBetaR * 1000.0;
	float3 scatter = exp(-sigmaR * distKm * 0.15);
	float blendT = saturate(distKm * 0.004);
	return lerp(color, color * scatter, blendT);
}

// ---------------------------------------------------------------------------
//  Mie forward-scattering halo
// ---------------------------------------------------------------------------

float MieForwardScatterHalo(float3 viewDir, float3 boltDirWorld, float distKm)
{
	float cosA = abs(dot(normalize(viewDir), normalize(boltDirWorld)));
	float g  = gAtmMieG;
	float g2 = g * g;
	float denom = 1.0 + g2 - 2.0 * g * cosA;
	float hg = (1.0 - g2) / (4.0 * 3.14159 * pow(max(denom, 0.001), 1.5));
	float hgNorm = hg / max(0.01, (1.0 - g2) / (4.0 * 3.14159 * pow(max(1.0 + g2 - 2.0 * g * 0.5, 0.001), 1.5)));
	float distFactor = saturate(distKm * 0.01);
	return lerp(1.0, hgNorm, distFactor * 0.35);
}

// ---------------------------------------------------------------------------
//  Cloud-embedded segment dimming
// ---------------------------------------------------------------------------

float CloudEmbeddedDimming(float3 worldPos, float distKm)
{
	bool reliable = (distKm < CLOUD_VOLUME_RELIABLE_RADIUS_KM)
	             && IsInsideCloudVolume(worldPos);
	float dimming = 1.0;
	if (reliable)
	{
		float density = SampleCloudDensityForLightning(worldPos);
		dimming = lerp(1.0, 0.40, saturate(density * 2.5));
	}
	return dimming;
}

// ---------------------------------------------------------------------------
//  Cloud-embedded glow broadening
// ---------------------------------------------------------------------------

float CloudEmbeddedGlowBroaden(float3 worldPos, float distKm)
{
	bool reliable = (distKm < CLOUD_VOLUME_RELIABLE_RADIUS_KM)
	             && IsInsideCloudVolume(worldPos);
	if (reliable)
	{
		float density = SampleCloudDensityForLightning(worldPos);
		return lerp(1.0, 2.0, saturate(density * 2.0));
	}
	return 1.0;
}

// ---------------------------------------------------------------------------
//  Cloudiness-responsive area flash scaling  (improved: stronger response)
// ---------------------------------------------------------------------------

float CloudinessFlashScale()
{
	return lerp(0.4, 1.8, saturate(gCloudiness));
}

// ---------------------------------------------------------------------------
//  View-angle forward scattering boost
// ---------------------------------------------------------------------------

float ViewAngleGlowBoost(float3 boltDirView)
{
	float alignment = abs(boltDirView.z);
	return lerp(1.0, 1.5, alignment * alignment);
}

// ---------------------------------------------------------------------------
//  Cloud illumination proxy  (improved: stronger, wider, more dramatic)
// ---------------------------------------------------------------------------

float3 CloudIlluminationGlow(float env, float coreMask, float distKm)
{
	float glowStrength = saturate(1.0 - coreMask) * env * env;
	float distFade = 1.0 / (1.0 + distKm * 0.10);
	float3 cloudClr = AmbientLight(float3(0, -1, 0));
	float cloudLum = max(0.01, dot(cloudClr, float3(0.2126, 0.7152, 0.0722)));
	cloudClr = cloudClr / cloudLum;
	cloudClr = lerp(float3(1, 1, 1), cloudClr, 0.3);
	float nightBoost = lerp(1.0, 2.0, GetNightFactor());
	float cloudFlash = CloudinessFlashScale();
	return cloudClr * glowStrength * distFade * 12.0 * nightBoost * cloudFlash;
}

// ---------------------------------------------------------------------------
//  Screen flash helpers - whole-screen illumination near clouds
// ---------------------------------------------------------------------------

// Compute the screen flash intensity for a fullscreen pass.
// boltWorldPos: world position of the lightning bolt midpoint
// boltEnvelope: current bolt envelope value (0..1)
// Returns the flash intensity (0..1) to apply as additive screen flash
float ScreenFlashIntensity(float3 boltWorldPos, float boltEnvelope, float t, float birthTime)
{
	if (boltEnvelope < 0.01)
		return 0.0;

	float life = max(0.0, t - birthTime);

	// Flash is strongest in the first few ms (return stroke), then fades fast
	float flashPeak = exp(-12.0 * life * life);
	// Re-strokes contribute smaller flashes
	float rs1 = 0.5 * exp(-300.0 * (life - 0.030) * (life - 0.030));
	float rs2 = 0.3 * exp(-350.0 * (life - 0.072) * (life - 0.072));
	float rs3 = 0.15 * exp(-400.0 * (life - 0.130) * (life - 0.130));
	float flashEnv = saturate(flashPeak + rs1 + rs2 + rs3);

	// Distance attenuation: flash fades with distance from camera
	float distM = length(boltWorldPos - gCameraPos);
	float distKm = distM * 0.001;
	// Close: full intensity, falls off gently with sqrt
	float distAtten = 1.0 / (1.0 + distKm * 0.08);

	// Cloud proximity: flash is much stronger when camera is near/inside clouds
	float cloudProx = saturate(gCloudiness * 1.5);
	// Also boost if camera is near cloud band altitude
	float camAlt = gCameraHeightAbs;
	float cloudMidAlt = (gCloudsLow + gCloudsHigh) * 0.5;
	float altDist = abs(camAlt - cloudMidAlt);
	float altProx = saturate(1.0 - altDist / 5000.0);
	float cloudFactor = max(cloudProx, altProx * 0.6);

	// Night boost: flashes are much more visible at night
	float nightF = GetNightFactor();
	float nightBoost = lerp(0.4, 1.0, nightF);

	return flashEnv * distAtten * cloudFactor * nightBoost;
}

// Screen flash colour: blue-white wash with time-of-day adaptation
float3 ScreenFlashColor()
{
	float nightT = GetNightFactor();
	float3 dayFlash   = float3(0.85, 0.88, 1.00);
	float3 nightFlash = float3(0.75, 0.82, 1.00);
	float3 baseClr = lerp(dayFlash, nightFlash, nightT);

	// Tint slightly with ambient to match scene lighting
	float3 ambUp = AmbientLight(float3(0, 1, 0));
	float ambLum = max(0.01, dot(ambUp, float3(0.2126, 0.7152, 0.0722)));
	float3 ambNorm = ambUp / ambLum;
	return lerp(baseClr, baseClr * ambNorm, 0.15);
}

// Directional screen flash: flash should be brighter in the direction of the bolt
// screenUV: 0..1 screen coordinates
// boltScreenPos: bolt position projected to screen 0..1
// Returns a directional mask (0..1)
float ScreenFlashDirectional(float2 screenUV, float2 boltScreenPos)
{
	float2 delta = screenUV - boltScreenPos;
	// Aspect-correct distance
	delta.x *= gScreenAspect;
	float dist = length(delta);

	// Wide Gaussian centred on bolt position, covers most of the screen
	float dirMask = exp(-dist * dist * 1.2);
	// Add a broad ambient floor so the whole screen gets some flash
	float ambientFloor = 0.25;
	return saturate(dirMask + ambientFloor);
}

// ---------------------------------------------------------------------------
//  Legacy helpers (kept for compatibility)
// ---------------------------------------------------------------------------

float3 BoltColor(float coreMask, float3 coreColor, float3 edgeColor)
{
	return lerp(edgeColor, coreColor, coreMask);
}

float3 ApplyTexGain(float3 color, float4 texClr, float gainMult, float floorVal)
{
	float texL = max(max(texClr.r, texClr.g), texClr.b);
	float g = saturate(texL * gainMult) + floorVal;
	return color * (g * g);
}

float2 BoltFalloff(float u, float v, float wPow, float lPow)
{
	float wf = saturate(cos((2.0*(1.0-u) - 1.0) * PI / wPow));
	float lf = saturate(min(1.0, cos((2.0*(1.0-v) - 1.0) * PI / lPow) * 1.5 * 2.0));
	return float2(wf, lf);
}

#endif
