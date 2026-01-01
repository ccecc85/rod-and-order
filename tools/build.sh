#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GAME_PATH="$REPO_ROOT/game"
GODOT_EXEC="${GODOT_EXEC:-godot}"

if ! command -v "$GODOT_EXEC" >/dev/null 2>&1; then
  echo "Godot executable not found. Install Godot or set GODOT_EXEC to the CLI path." >&2
  exit 1
fi

BUILD_DIR="$REPO_ROOT/build"
mkdir -p "$BUILD_DIR"

echo "Building exports (requires export presets configured in Godot)..."

# Edit preset names to match your export presets
WINDOWS_PRESET="Windows Desktop"
LINUX_PRESET="Linux/X11"
MAC_PRESET="Mac OSX"

WINDOWS_OUT="$BUILD_DIR/rod-and-order-windows.exe"
echo "Exporting Windows → $WINDOWS_OUT"
"$GODOT_EXEC" --path "$GAME_PATH" --export "$WINDOWS_PRESET" "$WINDOWS_OUT"

LINUX_OUT="$BUILD_DIR/rod-and-order-linux"
echo "Exporting Linux → $LINUX_OUT"
"$GODOT_EXEC" --path "$GAME_PATH" --export "$LINUX_PRESET" "$LINUX_OUT"

MAC_OUT="$BUILD_DIR/rod-and-order-mac.zip"
echo "Exporting macOS → $MAC_OUT"
"$GODOT_EXEC" --path "$GAME_PATH" --export "$MAC_PRESET" "$MAC_OUT"

echo "Build scripts finished. Check the build folder for outputs."
