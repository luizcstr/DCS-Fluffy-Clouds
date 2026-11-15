//#define DEBUG_HUGE_PARTICLE

static const float snowflakeScaleMin = 0.010;
static const float snowflakeScaleMax = 0.025;
static const float snowflakeLengthFactor = 2.0;
static const float snowFlutterStepSin = 0.9129456;
static const float snowFlutterStepCos = 0.4080813;

static const float snowSpecularPower = 0.2;
static const float snowSpecularAphaFactor = 0.08;
static const float snowOpacityBase = 0.22;
static const float snowHaloFactor = 0.8;
static const float snowHaloAlphaFactor = 0.1;
static const float snowLightsAlphaFactor = 0.08;


#if !defined(PRECIPITATION_TILED_LIGHTING)

static const float snowflakeBrightness = 1.2;
static const float snowDiffusePower = 500.0f * snowflakeBrightness;

#else

static const float snowflakeBrightness = 2.0;
// Tweak this to change impact of light sources 
static const float snowDiffusePower = 1.5f;
static const float snowExposurePower = 0.05f;

#endif


// Number of snowflake quads emitted per input vertex (multiply snow density)
// D3D11 limit: maxvertexcount * output_scalars(22) <= 1024, so max is 11
static const uint SNOW_FLAKES_PER_VERTEX = 11;

// GEOMETRY SHADER ---------------------------------
[maxvertexcount(4 * SNOW_FLAKES_PER_VERTEX)]
void gsSnow(point VS_OUTPUT input[1], inout TriangleStream<PS_INPUT_RAIN> outputStream)
{
	float RAND = input[0].pos.w;

	float effectPower = SampleCloudsDensity(input[0].pos.xyz, true);

	// Boost effective density ? light zones get a floor, dense zones push past 1.0 for heavier snow
	float rawDensity = effectPower;
	effectPower = rawDensity > 0 ? min(effectPower * 6.4 + 0.12, 2.0) : 0;

	if (effectPower==0 || (float(input[0].vertId) > particlesMax * effectPower))
		return;
	
	float4 baseVPos = mul(float4(input[0].pos.xyz,1), gView); baseVPos /= baseVPos.w;

	float nDistToCam = min(1, length(input[0].pos.xyz - gCameraPos.xyz) / (clipRadius + clipSphereOffset));
	float effectPowerClamped = min(effectPower, 1.0);
	float worldAlt = input[0].pos.y + gOrigin.y;
	float snowAltMin = rainCloudsAltitudeMin - 300;
	float snowAltMax = snowAltMin + 0.3 * (rainCloudsAltitudeMax - snowAltMin);
	float altT = saturate((worldAlt - snowAltMin) / max(1.0, snowAltMax - snowAltMin));
	float altitudeScale = lerp(1.0, 0.62, altT);
	float distScale = 1.0 + pow(abs(nDistToCam * 0.5), 1.6) * 0.55;
	float densityScale = 0.85 + 0.15 * effectPowerClamped;

	// Dampen horizontal wind so snow falls more vertically (snow has high drag)
	float3 windVel = rainVel;
	windVel.x *= 0.25;
	windVel.z *= 0.25;
	float3 baseSpeedWorldSpace = -cameraVel + windVel;
	float3 baseSpeedViewSpace = mul(baseSpeedWorldSpace, (float3x3)gView);

	// Shared output fields
	PS_INPUT_RAIN o;
#if !defined(PRECIPITATION_TILED_LIGHTING)
	o.sunDirM = 0;
#endif
	o.wPos.xyz = input[0].pos.xyz - gCameraPos.xyz;
	o.wPos.w = getHaloFactor(gSunDir, o.wPos.xyz, 16);

	float shadow = getCloudsShadow(input[0].pos.xyz)*0.9+0.1;
	o.wPos.w *= shadow;

	float baseFade = max(0, 1 - max(0, nDistToCam-0.7)*3.3);
	float densityOpacityBoost = lerp(1.0, 1.5, saturate(rawDensity * 2.0 - 0.5));
	float flutterSin;
	float flutterCos;
	sincos((gModelTime * 3.0 + RAND * 20.0) * PI, flutterSin, flutterCos);
#if (PRECIPITATION_TILED_LIGHTING)
	float3 billboardToCamera = -normalize(o.wPos.xyz);
#endif

	// Emit multiple flakes per vertex to increase snow density
	for (uint flakeIdx = 0; flakeIdx < SNOW_FLAKES_PER_VERTEX; ++flakeIdx)
	{
		// Unique random seed per flake
		float flakeRAND = frac(RAND + flakeIdx * 0.3183099);

		// Jitter view-space position for extra flakes so they don't stack
		float4 vPos = baseVPos;
		if (flakeIdx > 0) {
			float2 jitter = noise2(float2(flakeRAND * 7.13, flakeRAND * 3.91 + flakeIdx)) * 2 - 1;
			vPos.xy += jitter * 0.35;
		}

		// Size distribution: heavily biased toward small flakes, rare large ones
		float rnd2 = noise1D(flakeRAND * 5.731 + 0.3);
		float sizeT = flakeRAND * rnd2;
		sizeT *= sizeT;
		sizeT = sizeT + (1.0 - sizeT) * rnd2 * rnd2 * 0.25;
		float snowflakeScale = lerp(snowflakeScaleMin, snowflakeScaleMax, sizeT);

		float scale = snowflakeScale * distScale * altitudeScale * densityScale;

		// Per-flake aspect ratio variation
		float aspectRnd = noise1D(flakeRAND * 13.37 + 0.7);
		float aspectRatio = lerp(lerp(0.8, 1.2, aspectRnd), lerp(0.6, 1.4, aspectRnd), sizeT);

		// Per-flake turbulence / flutter
		float3 speedWorldSpace = baseSpeedWorldSpace;
		float2 rndBase = noise2(float2(flakeRAND, flakeRAND + 2.718)) * 2 - 1;
		float flutter = flutterSin * 0.4;
		float2 rndVel = rndBase * effectPowerClamped * (0.3 + 0.3 * nDistToCam) * flutter;
		speedWorldSpace += float3(rndVel.x, 0, rndVel.y);

		float3 speedViewSpace = baseSpeedViewSpace + mul(float3(rndVel.x, 0, rndVel.y), (float3x3)gView);
		float  speedLengthSq = dot(speedViewSpace, speedViewSpace);
		float  invSpeed = rsqrt(max(speedLengthSq, 1.0e-8));
		float  speedValue = speedLengthSq * invSpeed;
		float3 speedDir = speedViewSpace * invSpeed;
		float  blurOffset = -(speedDir.z)*0.5;

		float3 dir = getScreenDirLength(vPos, speedViewSpace);
		
		float screenDist = dir.z;
		float stretchFactor = max(1, min(60,  screenDist * (1+min(speedValue, 1000) * 0.12) )) * snowflakeLengthFactor;
		float opacityFactor = 1.0 / (1 + 0.35 * screenDist + 0.015*(speedValue));

		float sizeOpacity = 0.75 + 0.25 * sizeT;
		opacityFactor *= sizeOpacity;

#ifdef DEBUG_HUGE_PARTICLE
		stretchFactor = 1.0;
		scale *= 10.0;
#endif

		speedDir = float3(dir.xy, 0) * stretchFactor * scale;
		float3 side = float3(-dir.y, dir.x, 0) * scale * aspectRatio;

		o.params.z = baseFade * opacityFactor * densityOpacityBoost;
		if (o.params.z > 1.5e-2) {
			o.params.w = saturate(vPos.z-1);

#if (PRECIPITATION_TILED_LIGHTING)
			float3 billboardUp = -normalize(speedWorldSpace); 
			float3 billboardRight = normalize(cross(billboardUp, billboardToCamera));
			o.billboardToWorld = float3x3(billboardRight, billboardUp, billboardToCamera);
			o.exposureFactor = 1.0 / max(1.0, stretchFactor * snowExposurePower);
#endif 

			[unroll]
			for (uint ii = 0; ii < 4; ++ii)
			{
				float4 p = {staticVertexData[ii].xy, vPos.z, 1};
				p.xy = vPos.xy + side.xy * p.x + speedDir.xy * (p.y+blurOffset);
				o.pos = mul(p, gProj);
				o.params.xy = staticVertexData[ii].zw;
				outputStream.Append(o);
			}
			outputStream.RestartStrip();
		}

		float nextFlutterSin = flutterSin * snowFlutterStepCos + flutterCos * snowFlutterStepSin;
		flutterCos = flutterCos * snowFlutterStepCos - flutterSin * snowFlutterStepSin;
		flutterSin = nextFlutterSin;
	}
}

#if !defined(PRECIPITATION_TILED_LIGHTING)

float4 psSnow(in PS_INPUT_RAIN i, uniform bool bLighting = false) : SV_TARGET0
{
	float fadeFactor = i.params.z;
	float haloFactor = i.wPos.w;

	float3 toCam = normalize(-i.wPos.xyz);

	float4 normSphere = particleTex.Sample(gTrilinearClampSampler, i.params.xy);
	normSphere.a *= fadeFactor;
	clip(normSphere.a - 0.01);

	// Soft edge falloff
	float edgeSoft = smoothstep(0.0, 0.3, normSphere.a);
	normSphere.a *= edgeSoft;

	// Ice crystal tint: slight blue-ish cast instead of pure white
	float3 iceTint = float3(0.92, 0.95, 1.0);
	float3 diffuse = (AmbientTop + sunDiffuse.xyz * gSunIntensity * 0.6) * (snowflakeBrightness / PI) * iceTint;

	// Halo
	float haloAlpha = haloFactor * (1-normSphere.a);
	float3 sunHalo = sunDiffuse.xyz * haloFactor * (1-normSphere.a*0.5) * gSunIntensity * snowHaloFactor * iceTint;
	diffuse += sunHalo;

	float opacity = snowOpacityBase + haloAlpha*snowHaloAlphaFactor;
	if(bLighting)
	{
		float4 additiveLightColor = calculateSumLighting(toCam, i.wPos.xyz);
		diffuse.rgb += additiveLightColor.rgb*0.3;
		opacity += additiveLightColor.a * snowLightsAlphaFactor;
	}

	return float4(diffuse, normSphere.a * opacity * i.params.w );
}

#else

float4 psSnow(in PS_INPUT_RAIN i, uniform bool bLighting = false) : SV_TARGET0
{
	float fadeFactor = i.params.z;
	float haloFactor = i.wPos.w;

	float3 toCam = normalize(-i.wPos.xyz);

	float4 normSphere = particleTex.Sample(gTrilinearClampSampler, i.params.xy);
	normSphere.a *= fadeFactor;
	clip(normSphere.a - 0.01);

	// Soft edge falloff
	float edgeSoft = smoothstep(0.0, 0.3, normSphere.a);
	normSphere.a *= edgeSoft;

	float3 worldNormal = normalize(mul(normSphere.xyz, i.billboardToWorld).xyz);

	// Ice crystal tint
	float3 iceTint = float3(0.92, 0.95, 1.0);
	
	float sunAmbient = dot(worldNormal, gSunDir) * 0.25 + 0.75;
	float3 ambient = (AmbientTop + 0.02 * sunDiffuse.xyz * gSunIntensity) * snowflakeBrightness * sunAmbient * iceTint;

	float3 diffuse = 0.08;

	float haloAlpha = haloFactor * (1-normSphere.a);
	float3 sunHalo = sunDiffuse.xyz * haloFactor * (1-normSphere.a*0.5) * gSunIntensity * snowHaloFactor * iceTint;

	float opacity = snowOpacityBase + haloAlpha * snowHaloAlphaFactor;

	float diffusePower = snowDiffusePower;
	float3 additiveLightColor = CalculateDynamicLightingTiled(i.pos.xy, diffuse, 0.15f,
		0.2f, worldNormal.xyz, -toCam, i.wPos.xyz + gCameraPos, 0.0f, float2(diffusePower, 1.0f), 1.0f, LL_TRANSPARENT, false, false);
	
	float3 finalColor = additiveLightColor.rgb + ambient + sunHalo;

	return float4(finalColor, normSphere.a * opacity * i.params.w) * i.exposureFactor;
}

#endif
