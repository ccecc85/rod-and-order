extends Node2D

@onready var player: CharacterBody2D = $player # reference to the player node
@onready var player_spawn: Marker2D = $player_spawn # reference to the player spawn point

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.global_position = player_spawn.global_position # set player position to spawn point
	print("loaded scene:", get_tree().current_scene.scene_file_path) # debug print
