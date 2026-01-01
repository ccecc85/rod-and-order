# scripts/screens/MapScreen.gd
extends Control

@onready var grid: GridContainer = %LocationGrid

func _ready() -> void:
	#Find buttons by name and connect signals
	_bind("EquipmentButton", GameState.LOCATION_EQUIPMENT)
	_bind("PlcButton", GameState.LOCATION_PLC)
	_bind("DriveButton", GameState.LOCATION_DRIVE)
	_bind("PulpitButton", GameState.LOCATION_PULPIT)

func _bind(buttonName: String, location_id: String) -> void:
	var b := grid.get_node(buttonName) as Button
	if b == null:
		push_error("Missing button: %s" % buttonName)
		return
	b.pressed.connect(func(): _go_to_location(location_id))

func _go_to_location(location_id: String) -> void:
	GameState.selected_location = location_id
	get_tree().change_scene_to_file("res://scenes/screens/LocationScreen.tscn")
