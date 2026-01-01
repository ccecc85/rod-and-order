extends Node


# Keep it simple: store selected location as a string for now.
# Use a property so assignments emit a signal.
signal selected_location_changed(new_location: String)
var _selected_location: String = ""

var selected_location: String:
	get:
		return _selected_location
	set(value):
		_selected_location = value
		emit_signal("selected_location_changed", value)

# Centralized location identifiers
const LOCATION_EQUIPMENT := "EQUIPMENT_FLOOR"
const LOCATION_PLC := "PLC_ROOM"
const LOCATION_DRIVE := "DRIVE_ROOM"
const LOCATION_PULPIT := "OPERATOR_PULPIT"

# Runtime locations dictionary (built from a Resource file)
var LOCATIONS: Dictionary = {}

# Load the resource at runtime to avoid parse-time dependency issues
var LOCATION_RESOURCE: Resource = null

func _ready() -> void:
	LOCATION_RESOURCE = load("res://data/locations.tres")
	_load_locations_from_resource()

func _load_locations_from_resource() -> void:
	var res := LOCATION_RESOURCE
	if res == null:
		# attempt to load at runtime if not already loaded
		res = load("res://data/locations.tres")
		LOCATION_RESOURCE = res
	if res == null:
		push_error("Missing locations resource: res://data/locations.tres")
		# Fall back to built-in defaults
		_populate_default_locations()
		return
	if not res.items:
		# Fall back to defaults if resource has no items
		_populate_default_locations()
		return
	for item in res.items:
		if item and item.id != "":
			LOCATIONS[item.id] = {"title": item.title, "desc": item.desc}

	# If resource failed to populate, fallback to defaults
	if LOCATIONS.size() == 0:
		_populate_default_locations()

func _populate_default_locations() -> void:
	LOCATIONS = {
		LOCATION_EQUIPMENT: {"title":"Equipment Floor","desc":"The main area housing all critical machinery."},
		LOCATION_PLC: {"title":"PLC Room","desc":"Where the programmable logic controllers are maintained."},
		LOCATION_DRIVE: {"title":"Drive Room","desc":"Contains the motor drives and control systems."},
		LOCATION_PULPIT: {"title":"Operator Pulpit","desc":"The central control station for operators."}
	}

func get_selected_info(loc := _selected_location) -> Dictionary:
	var default := {"title":"Unknown Location","desc":"Description not available."}
	if LOCATIONS.size() == 0:
		_load_locations_from_resource()
	return LOCATIONS.get(loc, default)