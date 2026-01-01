# scripts/screens/MapScreen.gd
extends Control

@onready var grid: GridContainer = %LocationGrid
var _bindings: Array = []

func _ready() -> void:
	# Find buttons by name and connect signals
	_bind("EquipmentButton", GameState.LOCATION_EQUIPMENT)
	_bind("PlcButton", GameState.LOCATION_PLC)
	_bind("DriveButton", GameState.LOCATION_DRIVE)
	_bind("PulpitButton", GameState.LOCATION_PULPIT)

func _bind(buttonName: String, location_id: String) -> void:
	var b := grid.get_node_or_null(buttonName) as Button
	if b == null:
		push_error("Missing button: %s" % buttonName)
		return
	var c := Callable(self, "_go_to_location").bind(location_id)
	b.pressed.connect(c)
	_bindings.append({"button": b, "callable": c})

func _go_to_location(location_id: String) -> void:
	GameState.selected_location = location_id
	var info = GameState.get_selected_info(location_id)
	get_tree().change_scene_to_file("res://scenes/screens/LocationScreen.tscn")

func _exit_tree() -> void:
	for binding in _bindings:
		var b = binding.get("button")
		var c = binding.get("callable")
		if b and c:
			if b.pressed.is_connected(c):
				b.pressed.disconnect(c)
	_bindings.clear()
