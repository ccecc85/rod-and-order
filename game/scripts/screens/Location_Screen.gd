# scripts/screens/LocationScreen.gd
extends Control

@onready var location_title: Label = %LocationTitle
@onready var location_description: Label = %LocationSubtitle
@onready var back_button: Button = %BackButton

func _ready() -> void:
	var default_info := {"title": "Unknown Location", "desc": "Description not available."}
	var info: Dictionary = GameState.LOCATIONS.get(GameState.selected_location, default_info)

	location_title.text = str(info.get("title", default_info["title"]))

	# Accept either key name to avoid drift
	var desc: String = str(info.get("desc", info.get("description", default_info["desc"])))
	location_description.text = desc

	back_button.pressed.connect(Callable(self, "_on_back_pressed"))

	print("LocationScreen -> selected_location:", GameState.selected_location)
	print("LocationScreen -> info:", info)
	print("LocationScreen -> desc:", location_description.text)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/map_screen.tscn")
