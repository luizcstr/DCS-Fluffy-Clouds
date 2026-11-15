// ============================================================================
// atmARPCConstants.hlsl
// -----------------------------------------------------------------------------
// Auto-generated constants from ARPC (Atmospheric Radiative Property Calculator)
// These values are PHYSICAL, STATIC, and MUST NOT change at runtime.
// Units:
//   - Lengths: meters
//   - Scattering / absorption coefficients: m^-1
//
// IMPORTANT:
//  * This file should ONLY be included by atmosphere / sky shaders
//    (atmPrecompute.fx, sky rendering passes, etc.)
//  * Do NOT include this file globally in common material shaders.
//  * Keep this file byte-for-byte identical unless ARPC is re-run.
// ============================================================================

#ifndef ATM_ARPC_CONSTANTS_HLSL
#define ATM_ARPC_CONSTANTS_HLSL

// -----------------------------------------------------------------------------
// Rayleigh (air) properties
// -----------------------------------------------------------------------------

// Fitted air density scale height
static const float ARPC_RAYLEIGH_SCALE_HEIGHT_M = 8696.45;

// Rayleigh scattering coefficients (RGB), m^-1
// Order: (R, G, B)
static const float3 ARPC_BETA_RAYLEIGH = float3(
    6.6049e-06,   // Red
    1.2345e-05,   // Green
    2.9413e-05    // Blue
);

// -----------------------------------------------------------------------------
// Ozone absorption layer (triangular profile)
// -----------------------------------------------------------------------------

// Base altitude of ozone layer (meters)
static const float ARPC_OZONE_LAYER_BASE_M = 22349.90;

// Total thickness of ozone layer (meters)
static const float ARPC_OZONE_LAYER_THICKNESS_M = 35660.71;

// Ozone absorption coefficients (RGB), m^-1
// Note: Blue channel ~0 due to negligible ozone absorption
static const float3 ARPC_BETA_OZONE_ABSORPTION = float3(
    2.2911e-06, // Red
    1.5404e-06, // Green
    0.0         // Blue
);

// -----------------------------------------------------------------------------
// Helper derived values (optional, but convenient)
// -----------------------------------------------------------------------------

// Half-thickness for triangular ozone density profile
static const float ARPC_OZONE_HALF_THICKNESS_M = ARPC_OZONE_LAYER_THICKNESS_M * 0.5;

// Linear coefficients for triangular ozone density (unit peak)
// density(h) = linear * h + constant
// Lower half: increasing
static const float ARPC_OZONE_LINEAR_LOWER   =  1.0 / ARPC_OZONE_HALF_THICKNESS_M;
static const float ARPC_OZONE_CONSTANT_LOWER = -ARPC_OZONE_LAYER_BASE_M * ARPC_OZONE_LINEAR_LOWER;

// Upper half: decreasing
static const float ARPC_OZONE_LINEAR_UPPER   = -1.0 / ARPC_OZONE_HALF_THICKNESS_M;
static const float ARPC_OZONE_CONSTANT_UPPER =
    (ARPC_OZONE_LAYER_BASE_M + ARPC_OZONE_LAYER_THICKNESS_M) *
    (-ARPC_OZONE_LINEAR_UPPER);

#endif // ATM_ARPC_CONSTANTS_HLSL
