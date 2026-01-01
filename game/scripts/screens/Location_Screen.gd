# scripts/screens/LocationScreen.gd
extends Control

@onready var location_title: Label = %LocationTitle
@onready var location_description: Label = %LocationSubtitle
@onready var back_button: Button = %BackButton

func _ready() -> void:
	var default_info := {"title": "Unknown Location", "desc": "Description not available."}
	var info: Dictionary = GameState.LOCATIONS.get(GameState.selected_location, default_info)
	location_title.text = info.get("title")
	location_description.text = info.get("desc")
	back_button.pressed.connect(Callable(self, "_on_back_pressed"))

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/MapScreen.tscn")
