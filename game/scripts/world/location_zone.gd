@tool
extends Area2D
class_name LocationZone

@export var location_key: GameState.LocationKey = GameState.LocationKey.EQUIPMENT_FLOOR:
	set(value):
		location_key = value
		queue_redraw()

@onready var label_offset: Vector2 = Vector2(8,6)

func get_location_id() -> String:
	return GameState.location_id_from_key(int(location_key))

func is_valid() -> bool:
	var id := get_location_id()
	return not id.is_empty() and GameState.is_valid_location_id(id)

func _ready() -> void:
	# In tool mode, _ready can run in the editor too.
	var id := get_location_id()
	if id.is_empty():
		push_warning("LocationZone '%s' has empty mapped location id." % name)
		return

	if not GameState.is_valid_location_id(id):
		push_warning("LocationZone '%s' invalid mapped location id '%s'." % [name, id])

func _draw() -> void:
	#var key_name : String = GameState.LocationKey.keys()[int(location_key)]
	var key_name := get_location_id()
	var font := ThemeDB.fallback_font
	var font_size := ThemeDB.fallback_font_size

	if font:
		draw_string(
			font,
			label_offset,
			key_name,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			font_size,
			Color.WHITE
		)
