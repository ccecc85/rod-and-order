@tool
extends Area2D
class_name LocationZone

@export var location_key: GameState.LocationKey = GameState.LocationKey.EQUIPMENT_FLOOR

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
