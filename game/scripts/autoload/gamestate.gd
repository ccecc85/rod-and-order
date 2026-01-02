extends Node
class_name gamestate

const LOCATION_EQUIPMENT_FLOOR := "EQUIPMENT_FLOOR"
const LOCATION_PLC_ROOM := "PLC_ROOM"
const LOCATION_DRIVE_ROOM := "DRIVE_ROOM"
const LOCATION_OPERATOR_PULPIT := "OPERATOR_PULPIT"


# Dropdown keys (used by the editor)
enum LocationKey {
	EQUIPMENT_FLOOR,
	PLC_ROOM,
	DRIVE_ROOM,
	OPERATOR_PULPIT,
}

# Canonical string IDs (used by LOCATIONS + the rest of your code)
const LOCATION_ID_BY_KEY := {
	LocationKey.EQUIPMENT_FLOOR: LOCATION_EQUIPMENT_FLOOR,
	LocationKey.PLC_ROOM: LOCATION_PLC_ROOM,
	LocationKey.DRIVE_ROOM: LOCATION_DRIVE_ROOM,
	LocationKey.OPERATOR_PULPIT: LOCATION_OPERATOR_PULPIT,
}

const LOCATIONS := {
	LOCATION_EQUIPMENT_FLOOR: {"title": "Equipment Floor", "desc": "This is the equipment floor of the facility."},
	LOCATION_PLC_ROOM: {"title": "PLC Room", "desc": "This room houses the programmable logic controllers."},
	LOCATION_DRIVE_ROOM: {"title": "Drive Room", "desc": "This room contains the motor drives."},
	LOCATION_OPERATOR_PULPIT: {"title": "Operator Pulpit", "desc": "This is where the operator controls the system."},
}

# --- Alarms (v0.1) ---------------------------------------------------------

var alarms: Array[Dictionary] = [
	{
		"id": "ALM_RUN_PERMIT",
		"title": "Run Permit Dropped",
		"severity": 2, # 1=low, 2=med, 3=high
		"location_id": LOCATION_PLC_ROOM,
		"symptom": "Motor start blocked: permissive chain not made.",
		"hint": "Check the permissive rung and any interlocks/timers.",
		"ack": false,
		"active": true,
	},
	{
		"id": "ALM_SENSOR_STUCK",
		"title": "Photoeye Stuck ON",
		"severity": 3,
		"location_id": LOCATION_EQUIPMENT_FLOOR,
		"symptom": "PE-101 reads ON with no product present.",
		"hint": "Check lens/alignment and verify the input bit changes.",
		"ack": false,
		"active": true,
	},
	{
		"id": "ALM_RECIPE_PARAM",
		"title": "Bad Recipe Parameter",
		"severity": 1,
		"location_id": LOCATION_OPERATOR_PULPIT,
		"symptom": "Speed limit out of range for current product.",
		"hint": "Compare parameters against the golden recipe.",
		"ack": false,
		"active": true,
	},
]

func get_alarm_by_id(alarm_id: String) -> Dictionary:
	for a in alarms:
		if str(a.get("id", "")) == alarm_id:
			return a
	return {}

func set_alarm_ack(alarm_id: String, ack: bool) -> void:
	for i in range(alarms.size()):
		if str(alarms[i].get("id", "")) == alarm_id:
			alarms[i]["ack"] = ack
			return

func get_active_alarm_count() -> int:
	var n := 0
	for a in alarms:
		if bool(a.get("active", false)):
			n += 1
	return n

func get_active_alarm_count_by_location(location_id: String) -> int:
	var n := 0
	for a in alarms:
		if bool(a.get("active", false)) and str(a.get("location_id", "")) == location_id:
			n += 1
	return n

func severity_label(sev: int) -> String:
	match sev:
		3: return "HIGH"
		2: return "MED"
		_: return "LOW"


var selected_location: String = "EQUIPMENT_FLOOR"

func location_id_from_key(key: int) -> String:
	return LOCATION_ID_BY_KEY.get(key, "")


func get_location_info(location_id: String) -> Dictionary:
	var default_info := {"title": "Unknown Location", "desc": "Description not available."}
	return LOCATIONS.get(location_id, default_info)

func set_selected_location(location_id: String) -> void:
	# Optional validation so you never land in Unknown Location again
	if LOCATIONS.has(location_id):
		selected_location = location_id
	else:
		push_warning("Invalid location_id passed to set_selected_location: %s" % location_id)
		selected_location = location_id # or keep the old value if you prefer


func is_valid_location_id(id: String) -> bool:
	return LOCATIONS.has(id)
