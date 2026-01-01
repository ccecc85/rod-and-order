# scripts/screens/LocationScreen.gd
extends Control

@onready var location_title: Label = %LocationTitle
@onready var location_description: Label = %LocationSubtitle
@onready var back_button: Button = %BackButton

func _ready() -> void:
	var info: Dictionary = GameState.get_selected_info(GameState.selected_location)
	location_title.text = info.get("title")
	location_description.text = info.get("desc")
	back_button.pressed.connect(Callable(self, "_on_back_pressed"))

	# React to location changes while this screen is active
	if not GameState.is_connected("selected_location_changed", Callable(self, "_on_selected_location_changed")):
		GameState.connect("selected_location_changed", Callable(self, "_on_selected_location_changed"))

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/MapScreen.tscn")

func _on_selected_location_changed(new_location: String) -> void:
	var info: Dictionary = GameState.get_selected_info(new_location)
	location_title.text = info.get("title")
	location_description.text = info.get("desc")

func _exit_tree() -> void:
	# Disconnect GameState signal if connected
	if GameState.is_connected("selected_location_changed", Callable(self, "_on_selected_location_changed")):
		GameState.disconnect("selected_location_changed", Callable(self, "_on_selected_location_changed"))
	# Disconnect back button handler if connected
	if back_button and back_button.pressed.is_connected(Callable(self, "_on_back_pressed")):
		back_button.pressed.disconnect(Callable(self, "_on_back_pressed"))