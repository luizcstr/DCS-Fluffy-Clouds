#ifndef ATM_ARPC_OVERRIDES_HLSL
#define ATM_ARPC_OVERRIDES_HLSL

#include "atmDefinitions.hlsl"  

void ApplyAtmosphereLookTuning(inout AtmosphereParameters atmosphere);

static const float ATM_ARPC_CIE2006_RAYLEIGH_SCALE_HEIGHT_KM = 8.69645;

static const float3 ATM_ARPC_CIE2006_RAYLEIGH_SCATTERING = float3(
  5.9501e-3,
  1.2787e-2,
  3.0504e-2
);

static const float3 ATM_ARPC_CIE2006_ABSORPTION_EXTINCTION = float3(
  2.3609e-3,
  1.4851e-3,
  0.0
);

static const float3 ATM_ARPC_CIE2006_SCATTERING_TO_SINGLE_MIE = float3(
  1.0,
  (5.9501e-3 / 1.2787e-2),
  (5.9501e-3 / 3.0504e-2)
);

static const float ATM_ARPC_OZONE_LAYER_BASE_M = 22349.90;
static const float ATM_ARPC_OZONE_LAYER_THICKNESS_M = 35660.71;

static const float ATM_ARPC_SUPPLEMENTARY_MIE_EXTINCTION = 0.0;
static const float ATM_ARPC_SUPPLEMENTARY_MIE_SSA = 0.9;

void ApplyARPCOverrides(inout AtmosphereParameters atmosphere)
{
    const float lengthUnitsInMeter = 1000.0; // km-based Length

  // CIE 2006-derived Rayleigh baseline.
  atmosphere.rayleigh_scale_height = ATM_ARPC_CIE2006_RAYLEIGH_SCALE_HEIGHT_KM;
  atmosphere.rayleigh_scattering = ATM_ARPC_CIE2006_RAYLEIGH_SCATTERING;
  atmosphere.scatteringToSingleMie = ATM_ARPC_CIE2006_SCATTERING_TO_SINGLE_MIE;

  // CIE 2006-derived ozone absorption baseline.
  atmosphere.absorption_extinction = ATM_ARPC_CIE2006_ABSORPTION_EXTINCTION;

    atmosphere.absorption_factor = 1.0;

    // Ozone density (triangular)
  const float baseKm      = ATM_ARPC_OZONE_LAYER_BASE_M / lengthUnitsInMeter;
  const float thicknessKm = ATM_ARPC_OZONE_LAYER_THICKNESS_M / lengthUnitsInMeter;
    const float halfKm      = 0.5 * thicknessKm;

    const float peakKm = baseKm + halfKm;
    const float topKm  = baseKm + thicknessKm;

    atmosphere.absorption_density.layers[0].width         = peakKm;
    atmosphere.absorption_density.layers[0].exp_term      = 0;
    atmosphere.absorption_density.layers[0].exp_scale     = 0;
    atmosphere.absorption_density.layers[0].linear_term   =  1.0 / halfKm;
    atmosphere.absorption_density.layers[0].constant_term = -baseKm / halfKm;

    atmosphere.absorption_density.layers[1].width         = 0;
    atmosphere.absorption_density.layers[1].exp_term      = 0;
    atmosphere.absorption_density.layers[1].exp_scale     = 0;
    atmosphere.absorption_density.layers[1].linear_term   = -1.0 / halfKm;
    atmosphere.absorption_density.layers[1].constant_term =  topKm / halfKm;

    // Additive broadband aerosol haze baseline from the live DCS variant.
    atmosphere.mie_extinction += ATM_ARPC_SUPPLEMENTARY_MIE_EXTINCTION;
    atmosphere.mie_scattering += ATM_ARPC_SUPPLEMENTARY_MIE_EXTINCTION * ATM_ARPC_SUPPLEMENTARY_MIE_SSA;

    ApplyAtmosphereLookTuning(atmosphere);
}


// ============================================================================
// Artistic / "look" tuning (dimensionless multipliers)
// -----------------------------------------------------------------------------
// These are INTENTIONAL non-physical adjustments applied *after* ARPC values.
// Use them to quickly dial the overall vibe without re-running ARPC.
//
// How to use:
//   1) Pick a preset by setting ATM_LOOK_PRESET below (or in your build system).
//   2) Optionally nudge the global multipliers (ATM_LOOK_* constants) for fine-tuning.
//
// Notes:
//   - Increasing Mie generally increases haze, sun halos, and aerial perspective.
//   - Increasing Rayleigh tends to deepen blue sky and increase blue skylight.
//   - "Dirty" haze often has higher extinction vs scattering and a warm tint.
//
// Presets:
//   0 = ATMOSX Default
//   1 = ATMOSX Ultra Clear
//   2 = ATMOSX Hazy
//   3 = ATMOSX Heavy Haze
//   4 = Custom / App-driven controls
//
// The custom block below is intentionally organized so an external tool can
// patch individual numeric literals in-place without needing to touch shader
// logic or add new permutations. That keeps experimentation flexible while
// avoiding unnecessary shader-cache churn.
//
// Control mapping to Atmos-style UI:
//   Atmosphere Depth         -> ATM_CUSTOM_ATMOSPHERE_DEPTH_MULT
//   Scattering Height        -> ATM_CUSTOM_RAYLEIGH_SCALE_HEIGHT_MULT,
//                               ATM_CUSTOM_MIE_SCALE_HEIGHT_MULT
//   Rayleigh RGB             -> ATM_CUSTOM_RAYLEIGH_RGB
//   Global Scene Illum.      -> ATM_CUSTOM_SOLAR_IRRADIANCE_MULT
//   Overall Light Tuning     -> ATM_CUSTOM_OVERALL_LIGHT_MULT
//   Phase Function           -> ATM_CUSTOM_MIE_G_BIAS
//   Particle Absorption RGB  -> ATM_CUSTOM_MIE_EXTINCTION_TINT
//   Particle Scattering RGB  -> ATM_CUSTOM_MIE_SCATTER_TINT
//   Particle Distribution    -> ATM_CUSTOM_MIE_SCALE_HEIGHT_MULT
//
// ============================================================================

#ifndef ATM_LOOK_PRESET
  #define ATM_LOOK_PRESET 0 
#endif

// Global fine-tune knobs (applied on top of the preset).
// Keep these near 1.0; use the preset for the "big move".
static const float  ATM_LOOK_RAYLEIGH_MULT          = 1.0;
static const float  ATM_LOOK_MIE_SCATTER_MULT       = 1.0;
static const float  ATM_LOOK_MIE_EXTINCTION_MULT    = 1.0;
static const float  ATM_LOOK_MIE_SCALE_HEIGHT_MULT  = 1.0;
static const float  ATM_LOOK_OZONE_EXTINCTION_MULT  = 1.0;
static const float  ATM_LOOK_ABSORPTION_FACTOR_MULT = 1.0;  // scales atmosphere.absorption_factor
static const float  ATM_LOOK_MIE_G_BIAS             = 0.0;  // +/- small changes to forward scattering

// Optional color tints for aerosols (1 = neutral).
// Tip: For "dusty/smoggy", reduce blue and slightly boost red.
static const float3 ATM_LOOK_MIE_SCATTER_TINT       = float3(1.0, 1.0, 1.0);
static const float3 ATM_LOOK_MIE_EXTINCTION_TINT    = float3(1.0, 1.0, 1.0);

// Custom preset (ATM_LOOK_PRESET == 3) editable values.
// The app can update these lines in-place.
//
// High-level control multipliers.
// Expands or contracts the total atmospheric shell thickness. Higher values
// increase far-distance aerial perspective and make the horizon fade sooner.
static const float  ATM_CUSTOM_ATMOSPHERE_DEPTH_MULT      = 1.00;
// Multiplies incoming sun energy before scattering. Higher values brighten the
// whole sky/airmass response, especially at long view distances.
static const float  ATM_CUSTOM_SOLAR_IRRADIANCE_MULT      = 1.00;
// Post-lighting brightness trim applied with solar irradiance. Use this as a
// broad intensity knob after the physical scattering terms are tuned.
static const float  ATM_CUSTOM_OVERALL_LIGHT_MULT         = 1.00;
// Master multiplier for Rayleigh scattering strength. Higher values deepen blue
// sky color and increase clear-air atmospheric perspective.
static const float  ATM_CUSTOM_RAYLEIGH_MULT              = 1.00;
// Scales Rayleigh vertical distribution height. Higher values lift clear-air
// scattering higher into the sky; lower values keep it more compressed.
static const float  ATM_CUSTOM_RAYLEIGH_SCALE_HEIGHT_MULT = 1.00;
// Per-channel tint for Rayleigh scattering. Use this to bias sky color without
// changing overall Rayleigh density.
static const float3 ATM_CUSTOM_RAYLEIGH_RGB               = float3(1.00, 1.00, 1.00);
// Master multiplier for Mie scattering. Higher values add more visible haze,
// stronger sun glow, and more light scattered toward the camera.
static const float  ATM_CUSTOM_MIE_SCATTER_MULT           = 1.00;
// Master multiplier for Mie extinction. Higher values remove more light along
// the view path, increasing washout and reducing distant scene contrast.
static const float  ATM_CUSTOM_MIE_EXTINCTION_MULT        = 1.00;
// Scales the Mie vertical distribution height. This is the main "scattering
// height" control for haze: higher values raise the haze layer, lower values
// keep it closer to the ground.
static const float  ATM_CUSTOM_MIE_SCALE_HEIGHT_MULT      = 1.00;
// Multiplies ozone absorption/extinction. Higher values strengthen warm/cool
// spectral separation, especially around sunrise and sunset.
static const float  ATM_CUSTOM_OZONE_EXTINCTION_MULT      = 1.00;
// Extra multiplier on absorption_factor. Use this as a broad absorption shaping
// control when you want stronger or weaker spectral filtering overall.
static const float  ATM_CUSTOM_ABSORPTION_FACTOR_MULT     = 1.00;
// Additive bias to the Mie phase-function g term. Positive values make aerosol
// scattering more forward-peaked; negative values spread the light more evenly.
static const float  ATM_CUSTOM_MIE_G_BIAS                 = 0.00;

// RGB shaping for aerosol response.
// Per-channel tint for light scattered by aerosols toward the camera. Lowering
// a channel reduces that channel's haze glow contribution.
static const float3 ATM_CUSTOM_MIE_SCATTER_TINT           = float3(1.00, 1.00, 1.00);
// Per-channel tint for light removed by aerosols along the view path. Lowering
// a channel preserves more of that channel at distance; raising it increases loss.
static const float3 ATM_CUSTOM_MIE_EXTINCTION_TINT        = float3(1.00, 1.00, 1.00);

void ApplyAtmosphereLookTuning(inout AtmosphereParameters atmosphere)
{
  float  atmosphereDepthMult = 1.0;
  float  solarIrradianceMult = 1.0;
  float  overallLightMult    = 1.0;
  float  rayleighMult        = 1.0;
  float  rayleighScaleMult   = 1.0;
  float  mieScaMult          = 1.0;
  float  mieExtMult          = 1.0;
  float  mieScaleMult        = 1.0;
  float  ozoneExtMult        = 1.0;
  float  absorptionFacMult   = 1.0;
  float  mieGBias            = 0.0;

  float3 rayleighRgb = float3(1.0, 1.0, 1.0);
  float3 mieScaTint  = float3(1.0, 1.0, 1.0);
  float3 mieExtTint  = float3(1.0, 1.0, 1.0);

#if ATM_LOOK_PRESET == 0
  // Default / Clear, dry: Default settings.
  rayleighMult      = 0.85;
  mieScaMult        = 1.00;
  mieExtMult        = 1.00;
  mieScaleMult      = 1.00;
  absorptionFacMult = 1.00;
  mieGBias          = 0.0;

  // Slight cool/neutral tint
  mieScaTint          = float3(0.95, 1.00, 1.08);
  mieExtTint          = float3(0.95, 1.00, 1.08);

#elif ATM_LOOK_PRESET == 1
  // Ultra Clear: Zeroed Mie eliminates all aerosol haze over terrain.
 
  rayleighMult      = 0.35;
  mieScaMult        = 0.12;
  mieExtMult        = 0.10;
  mieScaleMult      = 0.70;
  mieGBias          = -0.01;

  // Slight cool/neutral tint
  mieScaTint          = float3(0.95, 1.00, 1.08);
  mieExtTint          = float3(0.95, 1.00, 1.08);

#elif ATM_LOOK_PRESET == 2
  // Hazy, but with vibrant colorful sunsets:
 
  rayleighMult      = 1.08;   // more spectral separation = richer sky gradients
  mieScaMult        = 2.35;   // keep strong haze glow
  mieExtMult        = 1.85;   // LOWER than scattering -> less gray wash
  mieScaleMult      = 3.20;   // still hazy, less "uniform milk"
  mieGBias          = +0.02;  // slightly forward, but not too peaky

  // Aerosol tint: warm, but preserve some blue for magenta/purple transitions.
  mieScaTint        = float3(1.10, 1.03, 0.96);
  mieExtTint        = float3(1.08, 1.02, 0.92);

  // Stronger ozone-like shaping helps push oranges/reds at low sun angles.
  ozoneExtMult      = 1.35;
  absorptionFacMult = 1.12;


#elif ATM_LOOK_PRESET == 3
  // Heavy terrain haze: pale blue-white low-level veil with heavy
  // distance washout, but a cleaner upper sky than the generic hazy preset.
  atmosphereDepthMult = 1.75;
  solarIrradianceMult = 2.00;
  overallLightMult    = 1.00;
  rayleighMult        = 0.98;
  rayleighScaleMult   = 1.00;
  mieScaMult          = 8.20;
  mieExtMult          = 6.80;
  mieScaleMult        = 1.00;
  ozoneExtMult        = 1.00;
  absorptionFacMult   = 1.00;
  mieGBias            = 0.65;
  rayleighRgb         = float3(0.98, 1.00, 1.03);
  mieScaTint          = float3(0.97, 0.99, 1.00);
  mieExtTint          = float3(0.97, 0.99, 1.00);

#elif ATM_LOOK_PRESET == 4
  // Custom: use app-controlled values.
  atmosphereDepthMult = ATM_CUSTOM_ATMOSPHERE_DEPTH_MULT;
  solarIrradianceMult = ATM_CUSTOM_SOLAR_IRRADIANCE_MULT;
  overallLightMult    = ATM_CUSTOM_OVERALL_LIGHT_MULT;
  rayleighMult        = ATM_CUSTOM_RAYLEIGH_MULT;
  rayleighScaleMult   = ATM_CUSTOM_RAYLEIGH_SCALE_HEIGHT_MULT;
  rayleighRgb         = ATM_CUSTOM_RAYLEIGH_RGB;
  mieScaMult          = ATM_CUSTOM_MIE_SCATTER_MULT;
  mieExtMult          = ATM_CUSTOM_MIE_EXTINCTION_MULT;
  mieScaleMult        = ATM_CUSTOM_MIE_SCALE_HEIGHT_MULT;
  ozoneExtMult        = ATM_CUSTOM_OZONE_EXTINCTION_MULT;
  absorptionFacMult   = ATM_CUSTOM_ABSORPTION_FACTOR_MULT;
  mieGBias            = ATM_CUSTOM_MIE_G_BIAS;

  mieScaTint          = ATM_CUSTOM_MIE_SCATTER_TINT;
  mieExtTint          = ATM_CUSTOM_MIE_EXTINCTION_TINT;
#endif

  // Apply global fine-tune knobs on top of the chosen preset.
  rayleighMult      *= ATM_LOOK_RAYLEIGH_MULT;
  mieScaMult        *= ATM_LOOK_MIE_SCATTER_MULT;
  mieExtMult        *= ATM_LOOK_MIE_EXTINCTION_MULT;
  mieScaleMult      *= ATM_LOOK_MIE_SCALE_HEIGHT_MULT;
  ozoneExtMult      *= ATM_LOOK_OZONE_EXTINCTION_MULT;
  absorptionFacMult *= ATM_LOOK_ABSORPTION_FACTOR_MULT;
  mieGBias          += ATM_LOOK_MIE_G_BIAS;

  mieScaTint *= ATM_LOOK_MIE_SCATTER_TINT;
  mieExtTint *= ATM_LOOK_MIE_EXTINCTION_TINT;

  // Commit.
  const float baseAtmosphereThickness = max(atmosphere.top_radius - atmosphere.bottom_radius, 1e-3);
  atmosphere.top_radius = atmosphere.bottom_radius + baseAtmosphereThickness * atmosphereDepthMult;
  atmosphere.solar_irradiance *= (solarIrradianceMult * overallLightMult);
  atmosphere.rayleigh_scale_height *= rayleighScaleMult;
  atmosphere.rayleigh_scattering   *= (rayleighMult * rayleighRgb);
  atmosphere.mie_scattering        *= (mieScaMult * mieScaTint);
  atmosphere.mie_extinction        *= (mieExtMult * mieExtTint);
  atmosphere.mie_scale_height      *= mieScaleMult;
  atmosphere.absorption_extinction *= ozoneExtMult;
  atmosphere.absorption_factor     *= absorptionFacMult;

  // Keep g in a sane range (Cornette–Shanks typical: ~0.6 to 0.9).
  atmosphere.mie_phase_function_g = clamp(atmosphere.mie_phase_function_g + mieGBias, 0.60, 0.92);
}
#endif
