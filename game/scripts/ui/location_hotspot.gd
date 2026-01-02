@tool
extends BaseButton
class_name LocationHotspot

@export var location_key: GameState.LocationKey = GameState.LocationKey.EQUIPMENT_FLOOR

func get_location_id() -> String:
	return GameState.location_id_from_key(int(location_key))

func _ready() -> void:
	var id := get_location_id()
	if id.is_empty():
		push_warning("LocationHotspot '%s' has empty mapped location id." % name)
		return

	if not GameState.is_valid_location_id(id):
		push_warning("LocationHotspot '%s' invalid mapped location id '%s'." % [name, id])
