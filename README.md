# DCS Fluffy Clouds — Weather MSFS Realistic Standalone

An all-in-one weather and cloud overhaul for **DCS World**, based on the Weather MSFS Realistic standalone package. It includes the required ATMOS-X shader files and configuration, so it does **not** require ATMOS-X to be enabled separately.

> **Important:** this mod replaces DCS installation files while enabled. Use a mod manager such as OvGME so every change can be reverted safely. DCS updates may require the mod to be disabled, reviewed, and re-enabled. Multiplayer integrity-check compatibility is not guaranteed.

[Download the complete package](https://github.com/luizcstr/DCS-Fluffy-Clouds/releases/latest) · [Quick instructions](LEIA-ME.txt) · [Standalone notes](LEIA-ME_STANDALONE.txt) · [License](LICENSE)

## What is included

- Reworked ATMOS-X cloud presets in `Config/Effects/clouds.lua`, including the custom preset set.
- The required ATMOS-X terrain and renderer configuration files.
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
6. Enable only `Weather_MSFS_Realista_Standalone`.
7. Start DCS and allow the first shader rebuild to finish.

If OvGME reports file conflicts, cancel activation and disable the conflicting mod first.

## First launch and shader cache

The first DCS launch after changing mods can take several minutes while shaders are recompiled. Clouds may briefly disappear and reload; this is expected. Complete a flight, close DCS normally, and launch it again without changing the active mod set.

If a clean rebuild is needed, close DCS and delete the contents of the appropriate `fxo` and `metashaders2` folders under `Saved Games\\DCS.openbeta`. DCS recreates them automatically.

## Reverting

Close DCS and disable `Weather_MSFS_Realista_Standalone` in OvGME. OvGME restores the original simulator files.

## Credits and license

This is an independent community mod using ATMOS-X-related configuration and custom cloud-rendering work. Microsoft Flight Simulator is referenced only as visual inspiration. This project is not affiliated with Microsoft, Eagle Dynamics, or ATMOS-X.

See [LICENSE](LICENSE) for the repository license.
