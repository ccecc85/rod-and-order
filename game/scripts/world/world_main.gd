extends Node2D

@onready var player: CharacterBody2D = $player # reference to the player node
@onready var player_spawn: Marker2D = $player_spawn # reference to the player spawn point
@onready var navigation_region_2d: NavigationRegion2D = $navigation_region_2d # reference to the navigation region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_navigation_outline(PackedVector2Array([
		Vector2(-1200, -800),
		Vector2(1200, -800),
		Vector2(1200, 800),
		Vector2(-1200, 800),
	]))
	player.global_position = player_spawn.global_position # set player position to spawn point
	print("loaded scene:", get_tree().current_scene.scene_file_path) # debug print


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var target := get_global_mouse_position()
		player.set_move_target(target)

# Sets the navigation outline for the NavigationRegion2D
func _set_navigation_outline(outline: PackedVector2Array) -> void:
	var nav_poly := NavigationPolygon.new()
	nav_poly.add_outline(outline)
	nav_poly.make_polygons_from_outlines()
	navigation_region_2d.navigation_polygon = nav_poly
