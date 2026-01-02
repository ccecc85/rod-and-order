extends CharacterBody2D

@export var move_speed: float = 250.0

@onready var navigation_agent_2d: NavigationAgent2D = $navigation_agent_2d

var has_click_target: bool = false

func set_move_target(target_global_pos: Vector2) -> void:
	has_click_target = true
	navigation_agent_2d.target_position = target_global_pos

func clear_move_target() -> void:
	has_click_target = false
	navigation_agent_2d.target_position = global_position

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
