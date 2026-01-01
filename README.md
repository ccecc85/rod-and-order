# Rod and Order — Godot workspace

This repository contains a workspace scaffold to develop the "Rod and Order" game using Godot.

Prerequisites
- Install Godot 4 and ensure the Godot CLI is available in your PATH or set `GODOT_EXEC` to its executable path.

Quick build (Windows PowerShell):

```powershell
cd tools
./build.ps1
```

Quick build (Unix / WSL / macOS):

```bash
cd tools
./build.sh
```

Notes
- Configure export presets in the Godot editor (Project → Export) and save them to `game/export_presets.cfg` before running the automated build scripts.
- The scripts expect preset names like `Windows Desktop`, `Linux/X11`, and `Mac OSX`. Edit `tools/build.*` to match your presets.

Godot executable
- If Godot is not on your PATH, set the `GODOT_EXEC` environment variable to the Godot executable path. Example (PowerShell):

```powershell
$env:GODOT_EXEC = 'D:\Tools\Godot\Godot_v4.5.1-stable_win64.exe'
```

- The build scripts will also auto-detect `D:\Tools\Godot\Godot_v4.5.1-stable_win64.exe` on Windows or `/mnt/d/Tools/Godot/Godot_v4.5.1-stable_win64.exe` under WSL. If you prefer a different location, set `GODOT_EXEC`.
