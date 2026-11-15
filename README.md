# DCS Fluffy Clouds — Weather MSFS Realistic Standalone

**DCS Fluffy Clouds — Weather MSFS Realistic Standalone** is a complete visual weather and cloud overhaul for **DCS World**. It changes the way the simulator draws and presents the sky, clouds, cirrus, precipitation, water, lightning, and related atmospheric effects, with a visual style inspired by Microsoft Flight Simulator.

The package is **standalone**: the ATMOS-X shader and terrain files required by the custom cloud renderer are included inside the mod. You do not need to install or enable ATMOS-X separately.

> **Important:** this mod replaces DCS installation files while enabled. Use a mod manager such as OvGME so every change can be reverted safely. DCS updates may require the mod to be disabled, reviewed, and re-enabled. Multiplayer integrity-check compatibility is not guaranteed.

[Download the complete package](https://github.com/luizcstr/DCS-Fluffy-Clouds/releases/latest) · [Quick instructions](LEIA-ME.txt) · [Standalone notes](LEIA-ME_STANDALONE.txt) · [License](LICENSE)

## What the mod changes

The mod replaces the default weather-rendering components with one consistent package:

- **Cloud presets:** reworked ATMOS-X presets with adjusted altitude, thickness, density, coverage, detail scale, and cloud-top variation.
- **Cloud coverage:** a smoother coverage map reduces repetitive patterns and produces more natural transitions between cloud areas.
- **Volumetric rendering:** the patched `fxo.edcz` shader cache provides fuller cloud bases, more varied tops, and more defined cloud lobes.
- **Cirrus and sky:** custom cirrus detail, Moon, star, and atmospheric shaders improve the upper-sky layers and distant atmosphere.
- **Weather effects:** rain, snow, water, lightning, smoke, steam, and particle-system shaders are bundled so the package remains visually consistent.
- **Mission Editor:** the included weather-panel files and thumbnails make the custom presets available while creating or editing missions.
- **Runtime support:** `enlight.dll` is included for both standard and multithreaded DCS executables.

The goal is a denser, more dimensional, and less repetitive sky. The exact result still depends on the selected mission preset, altitude, lighting, time of day, camera position, and DCS graphics settings.

## What is included

- Reworked ATMOS-X cloud presets in `Config/Effects/clouds.lua`.
- ATMOS-X terrain and renderer configuration required for standalone operation.
- Patched `fxo.edcz`, cloud coverage textures, cirrus, sky, precipitation, water, lightning, and particle shaders.
- `enlight.dll` for both the standard and multithreaded DCS executables.
- Mission Editor weather integration and cloud thumbnails.
- The complete effect texture archive required by the package.

This is a **standalone** package. Do not enable it together with ATMOS-X or the older `Weather_MSFS_Realista_Completo` package.

## Installation with OvGME

1. Close DCS World.
2. Download the complete ZIP from the [Releases page](https://github.com/luizcstr/DCS-Fluffy-Clouds/releases).
3. Extract the mod folder into the Mods folder used by your OvGME profile.
4. Confirm that the profile's **Root Folder** is the DCS World installation directory, not `Saved Games`.
5. Disable ATMOS-X and any other cloud, weather, or shader mod that overwrites files under `Bazar`, `Config`, `MissionEditor`, `bin`, or `bin-mt`.
6. Enable only `Fluffy Clouds`.
7. Start DCS and allow the first shader rebuild to finish.

If OvGME reports file conflicts, cancel activation and disable the conflicting mod first.

## First launch and shader cache

The first DCS launch after changing mods can take several minutes while shaders are recompiled. Clouds may briefly disappear and reload; this is expected. Complete a flight, close DCS normally, and launch it again without changing the active mod set.

If a clean rebuild is needed, close DCS and delete the contents of the appropriate `fxo` and `metashaders2` folders under `Saved Games\\DCS.openbeta`. DCS recreates them automatically.

## Before-and-after comparison

The first image shows **Without the mod**. The second image shows **With mod applied**. These are the original screenshots, presented without content changes.

| Without the mod | With mod applied |
| --- | --- |
| ![Without the mod](https://raw.githubusercontent.com/luizcstr/DCS-Fluffy-Clouds/main/docs/screenshots/without-mod.jpg) | ![With mod applied](https://raw.githubusercontent.com/luizcstr/DCS-Fluffy-Clouds/main/docs/screenshots/with-mod.jpg) |

## Reverting

Close DCS and disable `Fluffy Clouds` in OvGME. OvGME restores the original simulator files.

## Credits and license

This is an independent community mod using ATMOS-X-related configuration and custom cloud-rendering work. Microsoft Flight Simulator is referenced only as visual inspiration. This project is not affiliated with Microsoft, Eagle Dynamics, or ATMOS-X.

See [LICENSE](LICENSE) for the repository license.
