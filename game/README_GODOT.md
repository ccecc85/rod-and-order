Getting started with the Godot project

1. Open Godot and choose "Import" or "Open" and select this `game` folder.
2. Create your main scene (e.g. `main.tscn`) and set it as the main scene in Project Settings → Application → Run → Main Scene.
3. Configure export presets in Project → Export (add Desktop presets for Windows/Linux/macOS). Save presets so `export_presets.cfg` appears in the project folder.
4. Use the scripts in `tools/` to automate builds once Godot is installed.

Notes:

## GameState (autoload)

The project exposes a `GameState` autoload singleton that centralizes location IDs and metadata.

- `GameState.LOCATION_*` constants: identifiers for locations (e.g. `GameState.LOCATION_PLC`).
- `GameState.selected_location`: property; assign to change the selected location. Assignments emit the `selected_location_changed(new_location: String)` signal.
- `GameState.LOCATIONS`: runtime dictionary mapping location IDs to `{title, desc}`.
- `GameState.get_selected_info(location_id)`: returns the `{title, desc}` dictionary for a location, with a safe default.

### Adding or editing locations

Locations are stored in `res://data/locations.tres` as `LocationData` resources. To add or change locations:

1. Open `res://data/locations.tres` in the Godot editor (it lists each location as a sub-resource).
2. Edit `id`, `title`, and `desc` fields, or add new `LocationData` sub-resources.
3. Save the resource; `GameState` will load it at runtime and populate `GameState.LOCATIONS`.

If you prefer data in code, you can also edit `scripts/autoload/gamestate.gd` directly where `LOCATIONS` is populated.
