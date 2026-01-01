extends Node


# Keep it simple: store selected location as a string for now.
var selected_location: String = ""

# Centralized location identifiers
const LOCATION_EQUIPMENT := "EQUIPMENT_FLOOR"
const LOCATION_PLC := "PLC_ROOM"
const LOCATION_DRIVE := "DRIVE_ROOM"
const LOCATION_PULPIT := "OPERATOR_PULPIT"

# Centralized location data: title + description
const LOCATIONS := {
	LOCATION_EQUIPMENT: {"title": "Equipment Floor", "desc": "The main area housing all critical machinery."},
	LOCATION_PLC: {"title": "PLC Room", "desc": "Where the programmable logic controllers are maintained."},
	LOCATION_DRIVE: {"title": "Drive Room", "desc": "Contains the motor drives and control systems."},
	LOCATION_PULPIT: {"title": "Operator Pulpit", "desc": "The central control station for operators."}
}