param(
    [string]$GodotExec = $env:GODOT_EXEC
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = Resolve-Path (Join-Path $scriptDir "..")
$gamePath = Join-Path $repoRoot "game"

# Prefer user-provided GODOT_EXEC. If unset, prefer a common local install path if present.
$defaultPath = 'D:\Tools\Godot\Godot_v4.5.1-stable_win64.exe'
if (-not $GodotExec) {
    if (Test-Path $defaultPath) { $GodotExec = $defaultPath } else { $GodotExec = 'godot' }
}

# Accept either an executable on PATH or an absolute path to the Godot exe.
if (-not (Get-Command $GodotExec -ErrorAction SilentlyContinue) -and -not (Test-Path $GodotExec)) {
    Write-Error "Godot executable not found. Install Godot or set the GODOT_EXEC environment variable to the Godot CLI path."
    exit 1
}

$buildDir = Join-Path $repoRoot "build"
New-Item -ItemType Directory -Path $buildDir -Force | Out-Null

Write-Output "Building exports (requires export presets configured in Godot)..."

# Example: adjust preset names to match your export presets in Godot
$windowsPreset = "Windows Desktop"
$linuxPreset = "Linux/X11"
$macPreset = "Mac OSX"

$windowsOut = Join-Path $buildDir "rod-and-order-windows.exe"
Write-Output "Exporting Windows → $windowsOut"
& $GodotExec --path $gamePath --export $windowsPreset $windowsOut

# Linux example (creates a zipped export or binary depending on preset)
$linuxOut = Join-Path $buildDir "rod-and-order-linux"
Write-Output "Exporting Linux → $linuxOut"
& $GodotExec --path $gamePath --export $linuxPreset $linuxOut

# macOS example
$macOut = Join-Path $buildDir "rod-and-order-mac.zip"
Write-Output "Exporting macOS → $macOut"
& $GodotExec --path $gamePath --export $macPreset $macOut

Write-Output "Build scripts finished. Check the `build` folder for outputs."
