# Code Overview

This document summarizes the main scripts, exported values, and functions in the project to help you learn how the pieces fit together.

## Autoload / Global State
`game/scripts/autoload/gamestate.gd`

- Purpose: single source of truth for locations and alarms; accessible globally via the autoload `GameState`.
- Key data:
  - `LOCATIONS` — Dictionary mapping location IDs to metadata (`title`, `desc`).
  - `LOCATION_ID_BY_KEY` / `enum LocationKey` — numeric dropdown keys mapped to string IDs.
  - `alarms` — Array of alarm dictionaries with keys: `id`, `title`, `severity`, `location_id`, `symptom`, `hint`, `ack`, `active`.
  - `selected_location` — runtime-selected location id.

- Functions:
  - `get_alarm_by_id(alarm_id: String) -> Dictionary`  
    Returns the alarm dict with the given ID or an empty dict.
  - `set_alarm_ack(alarm_id: String, ack: bool) -> void`  
    Sets the `ack` flag on an alarm (if found).
  - `get_active_alarm_count() -> int`  
    Counts alarms with `active == true`.
  - `get_active_alarm_count_by_location(location_id: String) -> int`  
    Counts active alarms filtered by `location_id`.
  - `severity_label(sev: int) -> String`  
    Maps numeric severity to a label (`"HIGH"`, `"MED"`, `"LOW"`).
  - `location_id_from_key(key: int) -> String`  
    Converts numeric enum key to the canonical string location ID.
  - `location_key_from_id(id: String) -> int`  
    Finds the enum index for a given location ID (returns -1 if not found).
  - `get_location_info(location_id: String) -> Dictionary`  
    Returns a location metadata dict or a default.
  - `set_selected_location(location_id: String) -> void`  
    Sets `selected_location` if valid; issues a warning otherwise.
  - `is_valid_location_id(id: String) -> bool`  
    Returns whether the ID exists in `LOCATIONS`.

## UI / Screens

### Map Screen
`game/scripts/screens/map_screen.gd`

- Purpose: show the map and allow selecting hotspots or opening alarms.
- Key variables: `_bindings` (cleanup of connected signals), `alarms_button`.
- Functions:
  - `_ready()` — populates hotspot button bindings, sets alarm button label (`Alarms (N)`), connects callbacks.
  - `_go_to_location(location_id: String)` — sets `GameState.selected_location` and changes to `location_screen`.
  - `_exit_tree()` — disconnects bound callables to avoid dangling connections.

### Location Screen
`game/scripts/screens/location_screen.gd`

- Purpose: display the currently selected location's title and description.
- Functions:
  - `_ready()` — reads `GameState.selected_location`, looks up info in `GameState.LOCATIONS`, writes `location_title` and `location_description`.
  - `_on_back_pressed()` — returns to the map screen.

### Alarm Screen
`game/scripts/screens/alarm_screen.gd`

- Purpose: list active alarms, show details, ack alarms, and jump to location.
- Functions:
  - `_ready()` — connects UI signals and initializes the list.
  - `_refresh_list()` — rebuilds the active alarm list, uses `GameState.severity_label()` and `get_location_info()`.
  - `_select_first()` — selects the first list item or shows empty state.
  - `_show_empty()` — clears UI when no alarms.
  - `_on_alarm_selected(index: int)` — displays details for selected alarm and enables buttons.
  - `_on_ack_pressed()` — toggles ack via `GameState.set_alarm_ack()` and refreshes selection.
  - `_on_go_pressed()` — sets `GameState.selected_location` and goes to the location screen.
  - `_on_back_pressed()` — returns to the map screen.

## Player & World

### Player Controller
`game/scripts/player/player_controller.gd`

- Purpose: handles player movement (WASD and click-to-move), interactions with `LocationZone`s, and prompts.
- Key variables: `move_speed`, `navigation_agent_2d`, `interact_prompt`, `interaction_area`, `current_zone`, `has_click_target`.
- Functions:
  - `_ready()` — connects area enter/exit signals and hides prompt.
  - `_on_area_entered(area: Area2D)` / `_on_area_exited(area: Area2D)` — manage `current_zone` and prompt visibility.
  - `_set_prompt_visible(visible: bool)` — show/hide the interact prompt label.
  - `set_move_target(target_global_pos: Vector2)` — sets click-to-move target on the navigation agent.
  - `clear_move_target()` — clears click target.
  - `_try_interact()` — when interacting, validates `current_zone`, sets `GameState.selected_location`, and (optionally) opens the location screen.
  - `_physics_process(_delta: float)` — handles input movement, interaction key, and navigation agent following.

### World Main
`game/scripts/world/world_main.gd`

- Purpose: top-level world node that spawns the player and handles click-to-move input.
- Functions:
  - `_ready()` — places player at spawn and optionally sets nav outline.
  - `_unhandled_input(event: InputEvent)` — on left-click, calls `player.set_move_target()` with mouse position.
  - `_set_navigation_outline(outline: PackedVector2Array)` — helper to create a navigation polygon for a `NavigationRegion2D`.

### LocationZone (world) and LocationHotspot (UI)
`game/scripts/world/location_zone.gd` and `game/scripts/ui/location_hotspot.gd`

- Purpose: represent interactable areas and map hotspots that map a numeric `location_key` (enum) to a location id.
- Common functions:
  - `get_location_id() -> String` — maps the exported `location_key` to a string ID via `GameState.location_id_from_key()`.
  - `is_valid() -> bool` — checks `GameState.is_valid_location_id()`; useful to validate editor-time setup.
  - `_ready()` — in tool mode, warns in editor when misconfigured.

## Resources
`game/scripts/resources/location_data.gd` and `location_collection.gd`

- `LocationData` — Resource class with exported `id`, `title`, `desc`.
- `LocationCollection` — Resource containing `items: Array` (list of `LocationData` or simple dicts). Useful to author locations in the editor.

## Debug / Utilities

### Debug Floor
`game/scripts/world/debug_floor.gd`

- Purpose: draws a grid for level design and debugging.
- Functions:
  - `_draw()` — draws vertical and horizontal grid lines.
  - `_ready()` — queues a redraw.

### Tools
`tools/check_godot_case.py` (duplicate also at `game/tools/`)  
- Purpose: Python helper to find missing or case-mismatched `res://` references (useful on case-insensitive OSs).

## Learning Notes & Tips
- Autoload vs `class_name`:
  - The autoload `GameState` is registered in `game/project.godot`. Don't use `class_name GameState` in the same script (it will conflict). Either remove `class_name` (keep autoload global) or use a different `class_name` (e.g., `GameStateType`) and keep the autoload name `GameState`.
- Type hints referencing `GameState` (e.g., `GameState.LocationKey`) only work if `class_name GameState` exists; after removing `class_name`, change those type hints to `int` or to use a separate named type.
- Editor vs runtime:
  - Methods like `_ready()` run both in editor tool mode (if `@tool` is used) and at runtime; be careful with calls to `get_tree().current_scene` during editor runs.
- Signal cleanup:
  - Screens like `map_screen.gd` store bound `Callable`s and disconnect them in `_exit_tree()` to avoid double-connections when scenes reload.

## Where to look next
- `game/scripts/autoload/gamestate.gd` — study alarm lifecycle and location mapping.
- `game/scripts/player/player_controller.gd` — movement and interaction flow.
- `game/scenes/` — inspect scene nodes that match export variables (e.g., `%AlarmList`, `%AlarmsButton`).
 - Detailed function summaries: see `docs/CodeDetails.md` for expanded function bodies, code snippets, and diagrams.
