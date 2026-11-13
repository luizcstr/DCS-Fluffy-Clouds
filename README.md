# DCS Fluffy Clouds

An experimental cloud mod for **DCS World**, built on [ATMOS-X](https://www.atx4dcs.com/) and inspired by Microsoft Flight Simulator. The goal is to give clouds more volume, rounder shapes, and a wider range of cloud-top heights within the same weather layer.

[Download ZIP](https://github.com/luizcstr/DCS-Fluffy-Clouds/archive/refs/heads/main.zip) · [Installation](#installation) · [Uninstall](#uninstall) · [License](LICENSE)

## Project status

**In development.** The package was prepared for **DCS World 2.9.31.29434**. Adjusting `Preset3` produced slightly taller clouds in-game. Renderer-driven variation in cloud height is still experimental and needs in-game validation. Compatibility with other DCS builds is unverified.

## Installation

1. **Close DCS World.** Set up and activate ATMOS-X using the [official installation guide](https://www.atx4dcs.com/install-guide). Disable earlier versions of this mod before continuing.
2. **Download and extract the mod.** Use [Download ZIP](https://github.com/luizcstr/DCS-Fluffy-Clouds/archive/refs/heads/main.zip), or choose **Code → Download ZIP** on GitHub.
3. **Prepare the mod folder.** In your mod library, create a folder called `DCS-Fluffy-Clouds`. Copy the five folders below directly into it. Keep `README.md` and `LICENSE` in the downloaded copy.

   ```text
   DCS-Fluffy-Clouds/
   ├── Bazar/
   ├── Config/
   ├── MissionEditor/
   ├── bin/
   │   └── enlight.dll
   └── bin-mt/
       └── enlight.dll
   ```

4. **Enable the mod with one of these managers.**

   | Mod manager | How to enable |
   | --- | --- |
   | **ATMOS-X Mod Manager** | Add the `DCS-Fluffy-Clouds` folder and install it to the **DCS World installation folder**. Use **Custom Install** if you need to select the destination manually. [ATMOS-X Mod Manager documentation](https://www.atx4dcs.com/change-log) |
   | **Standalone OvGME** | Set the profile’s **Root Folder** to the DCS World installation folder (for example, `F:\DCS World`). Put `DCS-Fluffy-Clouds` inside that profile’s **Mods Folder**, then enable it. [OvGME manual](https://forum.dcs.world/applications/core/interface/file/attachment.php?id=87665) |

5. **Check file conflicts before applying the mod.** The package includes cloud configuration, Mission Editor files, and renderer DLLs. If the manager reports an overlap with ATMOS-X or another mod, review the files listed before proceeding.
6. **Test offline.** Launch DCS and load a mission with a cloud preset. To compare the effect, fly the same mission with ATMOS-X alone and then with this mod enabled. Use the same preset, time of day, camera position, and graphics settings.

## Uninstall

Close DCS and disable **DCS-Fluffy-Clouds** in the same manager you used to install it. To remove ATMOS-X as well, deactivate it after disabling this mod. If DCS fails to start after installation, disable this mod and try launching with ATMOS-X alone.
