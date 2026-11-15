# Fluffy Clouds for DCS

An experimental, all-in-one weather and cloud overhaul for **DCS World**, built on and ATMOS-X presets with a visual style inspired by Microsoft Flight Simulator.

The current package combines the cloud presets, volumetric rendering adjustments, cirrus detail, sky shaders, effect textures, Mission Editor integration, and renderer files into a **single OvGME mod**. Only one activation is required.

> **Important:** this mod replaces DCS installation files while enabled. Use a mod manager such as OvGME so every change can be reverted safely. DCS updates may require the mod to be disabled, reviewed, and re-enabled. Multiplayer integrity-check compatibility is not guaranteed.

[Download the complete package](https://github.com/luizcstr/DCS-Fluffy-Clouds/releases/latest) · [Quick instructions](LEIA-ME.txt) · [License](LICENSE)

## Download

Download `Weather_MSFS_Realista_Completo-*.zip` from the [latest GitHub Release](https://github.com/luizcstr/DCS-Fluffy-Clouds/releases/latest).

Do **not** use **Code → Download ZIP** as the installable package. The repository branch contains the source and documentation, but GitHub's per-file size limit prevents the complete runtime package from being stored directly in the branch. The Release archive includes every required file, including `EffectTextures.zip` and the compiled `fxo.edcz` cache.

## What the current package does

- Installs a complete set of reworked ATMOS-X cloud presets through `Config/Effects/clouds.lua`.
- Uses `cloudsMap01.png` to provide smoother, less repetitive cloud coverage.
- Adjusts volumetric cloud density, thickness, coverage, top variation, detail scale, and lobe definition.
- Adds a detailed cirrus shader with pattern variation and refined distance behavior.
- Includes Moon, star, and lightning shaders as part of the unified visual package.
- Includes effect textures for clouds, cirrus, the Moon, stars, rain, snow, and related atmospheric effects.
- Installs `enlight.dll` for both the standard and multithreaded DCS executables.
- Integrates the presets with the DCS Mission Editor weather interface.

The package is designed as one consistent set. Mixing individual files with other weather, cloud, or shader mods can produce visual errors, shader compilation failures, or repeated cache rebuilding.

## Package structure

After extraction, the mod folder should look like this:

```text
Weather_MSFS_Realista_Completo/
├── Bazar/
│   ├── Effects/
│   └── shaders/
├── bin/
├── bin-mt/
├── Config/
├── MissionEditor/
└── LEIA-ME.txt
```

These folders must be installed directly into the **DCS World installation root** by OvGME. Do not point the mod at `Saved Games`.

## Installation with OvGME

1. Close DCS World.
2. Download the complete ZIP from the [Releases page](https://github.com/luizcstr/DCS-Fluffy-Clouds/releases).
3. Extract `Weather_MSFS_Realista_Completo` into the Mods folder used by your OvGME profile.
4. In OvGME, confirm that the profile's **Root Folder** is the DCS World installation directory, for example `C:\Program Files\Eagle Dynamics\DCS World` or your custom DCS installation path.
5. Disable other cloud, weather, or shader mods that overwrite files under `Bazar`, `Config`, `MissionEditor`, `bin`, or `bin-mt`.
6. The unrelated **Offline Terrain** mod can remain enabled if it does not report a file conflict.
7. Enable only `Weather_MSFS_Realista_Completo` for the cloud and weather overhaul.
8. Start DCS and allow the first launch to finish rebuilding shaders.

If OvGME reports file conflicts, cancel the activation and disable the conflicting mod before continuing.

## First launch and shader cache

The first DCS launch after enabling the mod can take longer than normal. DCS must compile and rebuild shader data for the newly installed files.

During this first launch, clouds may briefly disappear and reload. This is expected while the shader cache is being created. Complete a flight, close DCS normally, and launch it again without changing the active mod set.

Later launches should reuse the cache. Repeatedly enabling, disabling, or exchanging shader mods invalidates the cache and can cause the cloud pop-in to return.

## Using the mod

1. Open the DCS Mission Editor.
2. Create or edit a mission.
3. Open the weather panel and select one of the included cloud presets.
4. Set the cloud base, visibility, precipitation, wind, time of day, and other mission conditions as needed.
5. Save the mission and test it in-game.

Cloud appearance depends on the selected preset, altitude, lighting, time of day, camera position, and DCS graphics settings. For comparisons, keep the mission and graphics settings unchanged.

## Troubleshooting

### Clouds disappear and reload

Allow the first shader compilation to complete. Launch DCS a second time without changing any mods.

If the problem continues after two launches with the same mod set:

1. Close DCS.
2. Open the appropriate DCS folder under `Saved Games`.
3. Delete the `fxo` and `metashaders2` cache folders.
4. Start DCS and wait for a clean shader rebuild.

DCS recreates both cache folders automatically.

### DCS does not start

1. Close DCS and its updater.
2. Disable `Weather_MSFS_Realista_Completo` in OvGME.
3. Confirm that OvGME restored the original files.
4. Start DCS without the mod.
5. Check whether a recent DCS update changed the files used by the package before enabling it again.

### Visual artifacts or compilation errors

- Make sure no other cloud or shader mod is active.
- Confirm that the entire Release package was extracted without errors.
- Verify that OvGME targets the DCS installation root rather than `Saved Games`.
- Rebuild the shader cache only after resolving mod conflicts.

## Updating DCS World

Before running a DCS repair or major update:

1. Close DCS.
2. Disable the mod in OvGME.
3. Update or repair DCS.
4. Confirm that the simulator starts normally.
5. Re-enable the mod only after confirming that it is compatible with the installed DCS build.

## Uninstallation

1. Close DCS World.
2. Disable `Weather_MSFS_Realista_Completo` in OvGME.
3. Allow OvGME to restore the original DCS files.
4. Start DCS and let it rebuild shaders if necessary.

Do not delete or overwrite the OvGME backup data while the mod is enabled.

## Credits and license

This project uses work from **DCS Fluffy Clouds** and **ATMOS-X**. Microsoft Flight Simulator is referenced only as a visual inspiration. This project is not affiliated with Microsoft, Eagle Dynamics, or ATMOS-X.

See [LICENSE](LICENSE) for the repository license.
