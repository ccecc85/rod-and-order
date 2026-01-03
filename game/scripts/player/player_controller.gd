extends CharacterBody2D

@export var move_speed: float = 250.0

@onready var navigation_agent_2d: NavigationAgent2D = $navigation_agent_2d
@onready var interact_prompt: Label = get_tree().current_scene.get_node("ui_layer/interact_prompt")
@onready var interaction_area: Area2D = $interaction_area

var has_click_target: bool = false
var current_zone: LocationZone = null

func _ready() -> void:
	interaction_area.area_entered.connect(_on_area_entered)
	interaction_area.area_exited.connect(_on_area_exited)
	_set_prompt_visible(false)

func _on_area_entered(area: Area2D) -> void:
	if area is LocationZone:
		current_zone = area
		_set_prompt_visible(true)

func _on_area_exited(area: Area2D) -> void:
	if area == current_zone:
		current_zone = null
		_set_prompt_visible(false)

func _set_prompt_visible(visible: bool) -> void:
	if interact_prompt:
		interact_prompt.visible = visible


func set_move_target(target_global_pos: Vector2) -> void:
	has_click_target = true
	navigation_agent_2d.target_position = target_global_pos

func clear_move_target() -> void:
	has_click_target = false
	navigation_agent_2d.target_position = global_position

func _try_interact() -> void:
	if current_zone == null or not current_zone.is_valid():
		return

	var loc_id : String = current_zone.get_location_id()

	# Set target location for the rest of the game logic
	GameState.selected_location = loc_id

	# For now: print + open a stub screen.
	print("interact location_id:", loc_id)

	# Temporary: you can open your existing location_screen or a stub panel
	# get_tree().change_scene_to_file("res://scenes/screens/location_screen.tscn")


func _physics_process(_delta: float) -> void:
	var input_dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	# If the player uses WASD, it overrides click-to-move.
	if input_dir.length_squared() > 0.0:
		clear_move_target()
		input_dir = input_dir.normalized()
		velocity = input_dir * move_speed
		move_and_slide()
		return
	
	if Input.is_action_just_pressed("interact"):
		_try_interact()

	
	# Otherwise, follow the navigation path if we have a target.
	if has_click_target and not navigation_agent_2d.is_navigation_finished():
		var next_pos := navigation_agent_2d.get_next_path_position()
		var to_next := next_pos - global_position

		if to_next.length() > 1.0:
			velocity = to_next.normalized() * move_speed
		else:
			velocity = Vector2.ZERO

		move_and_slide()
	else:
		velocity = Vector2.ZERO
