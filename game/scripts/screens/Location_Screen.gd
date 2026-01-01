# scripts/screens/LocationScreen.gd
extends Control

@onready var location_title: Label = %LocationTitle
@onready var back_button: Button = %BackButton

func _ready() -> void:
	location_title.text = _pretty_location_name(GameState.selected_location)

	back_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/screens/MapScreen.tscn")
	)

func _pretty_location_name(location_id: String) -> String:
	match location_id:
		"EQUIPMENT_FLOOR": return "Equipment Floor"
		"PLC_ROOM": return "PLC Room"
		"DRIVE_ROOM": return "Drive Room"
		"OPERATOR_PULPIT": return "Operator Pulpit"
		_: return "Unknown Location"
