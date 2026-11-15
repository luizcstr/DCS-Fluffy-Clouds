# Changelog

## DCS Fluffy Clouds v1.0.0

The first complete packaged release of **DCS Fluffy Clouds** for one-step activation with OvGME.

### Included features

- Reworked ATMOS-X presets in `Config/Effects/clouds.lua`.
- Experimental vertical congestus preset in the Mission Editor.
- Tuned cloud altitude, thickness, density, coverage, noise scale, blur, and coverage-map behavior.
- Smooth coverage map at `Bazar/Effects/Clouds/cloudsMap01.png`.
- Detailed cirrus shader with pattern variation and refined distance behavior.
- Moon, star, and lightning shaders integrated into the unified package.
- Patched compiled `fxo.edcz` cache for fuller volumetric bases, varied cloud tops, and more defined lobes.
- Forty atmospheric effect textures, including clouds, cirrus, the Moon, stars, rain, and snow.
- `enlight.dll` for both the standard and multithreaded DCS executables.
- Mission Editor weather-panel integration.

### Complete Release package

The installable package is distributed as `DCS-Fluffy-Clouds-v1.0.0.zip`. Its root mod folder is named `DCS Fluffy Clouds`.

The complete archive includes the two large runtime files that cannot be stored directly in the repository branch:

| File | Size | SHA-256 |
| --- | ---: | --- |
| `Bazar/Effects/EffectTextures.zip` | 203,342,908 bytes | `E771C7253FFDC83180BF5E1B0B8E36E739710021C25D24F98F83C1CA7657EE2D` |
| `Bazar/shaders/fxo/fxo.edcz` | 82,008,783 bytes | `AC272BBE4E807861EBF6A681F4C9327891FE93747ABCA8B1B82C341341478073` |
