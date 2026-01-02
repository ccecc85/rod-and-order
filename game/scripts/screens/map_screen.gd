# scripts/screens/map_screen.gd
extends Control

var _bindings: Array = []

@onready var alarms_button: Button = %AlarmsButton

func _ready() -> void:

	alarms_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/screens/alarm_screen.tscn")
	)
	alarms_button.text = "Alarms (" + str(GameState.get_active_alarm_count()) + ")"

	for n in get_tree().get_nodes_in_group("location_hotspot"):
		var b := n as LocationHotspot
		if b == null:
			continue
		if b.get_location_id().is_empty():
			push_error("LocationHotspot missing location_id: %s" % b.name)
			continue

		var c := Callable(self, "_go_to_location").bind(b.get_location_id())

		b.pressed.connect(c)
		_bindings.append({"button": b, "callable": c})


func _go_to_location(location_id: String) -> void:
	GameState.selected_location = location_id
	get_tree().change_scene_to_file("res://scenes/screens/location_screen.tscn")
	print("Map -> going to location_id:", location_id)


func _exit_tree() -> void:
	for binding in _bindings:
		var b = binding.get("button")
		var c = binding.get("callable")
		if b and c and b.pressed.is_connected(c):
			b.pressed.disconnect(c)
	_bindings.clear()
