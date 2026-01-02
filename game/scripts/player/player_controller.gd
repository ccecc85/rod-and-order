extends CharacterBody2D

@export var move_speed: float = 250.0

func _physics_process(_delta: float) -> void:
	var input_dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if input_dir.length_squared() > 0.0:
		print("Input direction:", input_dir)
		input_dir = input_dir.normalized()
		#Print the player's new position for debugging
		print("Player position before move:", global_position)

	velocity = input_dir * move_speed
	move_and_slide()