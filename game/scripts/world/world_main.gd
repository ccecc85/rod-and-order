extends Node2D

@onready var player: CharacterBody2D = $player # reference to the player node
@onready var player_spawn: Marker2D = $player_spawn # reference to the player spawn point
@onready var navigation_region_2d: NavigationRegion2D = $navigation_region_2d # reference to the navigation region
@onready var alarm_overlay: Control = $ui_layer/alarm_overlay
@onready var alarm_screen: Control = $ui_layer/alarm_overlay/alarm_container/alarm_screen

var alarms_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	alarm_overlay.visible = false
	
	# put the alarm screen into overlay mode + connect signals
	alarm_screen.overlay_mode = true
	alarm_screen.request_close.connect(_close_alarms)
	alarm_screen.request_go_to_location.connect(_on_alarm_go_to_location)
	
	player.global_position = player_spawn.global_position # set player position to spawn point
	print("loaded scene:", get_tree().current_scene.scene_file_path) # debug print


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var target := get_global_mouse_position()
		player.set_move_target(target)
	if Input.is_action_just_pressed("toggle_alarms"):
		if alarms_open:
			_close_alarms()
		else:
			_open_alarms()
		get_viewport().set_input_as_handled()
		return
	# If alarms are open, swallow world input (no click-to-move).
	if alarms_open:
		return
	# your existing click-to-move handling here (left click -> set_move_target)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		player.set_move_target(get_global_mouse_position())
	
		
# Sets the navigation outline for the NavigationRegion2D
func _set_navigation_outline(outline: PackedVector2Array) -> void:
	var nav_poly := NavigationPolygon.new()
	nav_poly.add_outline(outline)
	nav_poly.make_polygons_from_outlines()
	navigation_region_2d.navigation_polygon = nav_poly

func _open_alarms() -> void:
	alarms_open = true
	alarm_overlay.visible = true

	# disable player input while UI is open
	if player.has_method("set_input_enabled"):
		player.set_input_enabled(false)

	# refresh list every time you open
	if alarm_screen.has_method("refresh"):
		alarm_screen.refresh()

func _close_alarms() -> void:
	alarms_open = false
	alarm_overlay.visible = false

	if player.has_method("set_input_enabled"):
		player.set_input_enabled(true)

func _on_alarm_go_to_location(location_id: String) -> void:
	# GameState.selected_location is already set by alarm_screen.
	print("alarm go_to_location:", location_id)
	# Later: set a waypoint / auto-path to a LocationZone.
