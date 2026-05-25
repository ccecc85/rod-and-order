# scripts/screens/alarm_screen.gd
extends Control

signal request_close
signal request_go_to_location(location_id: String)

@export var overlay_mode: bool = true

@onready var back_button: Button = %BackButton
@onready var alarm_list: ItemList = %AlarmList

@onready var alarm_title: Label = %AlarmTitle
@onready var alarm_symptom: Label = %AlarmSymptom
@onready var alarm_hint: Label = %AlarmHint

@onready var ack_button: Button = %AckButton
@onready var go_button: Button = %GoButton

var _selected_alarm_id: String = ""

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	ack_button.pressed.connect(_on_ack_pressed)
	go_button.pressed.connect(_on_go_pressed)

	alarm_list.item_selected.connect(_on_alarm_selected)

	refresh()

func refresh() -> void:
	_refresh_list()
	_select_first()

func _refresh_list() -> void:
	alarm_list.clear()
	_selected_alarm_id = ""

	var any := false

	for a in GameState.alarms:
		if not bool(a.get("active", false)):
			continue

		any = true

		var alarm_id: String = str(a.get("id", ""))
		var title: String = str(a.get("title", ""))
		var severity: int = int(a.get("severity", 1))
		var ack: bool = bool(a.get("ack", false))

		var loc_id: String = str(a.get("location_id", ""))
		var loc_info: Dictionary = GameState.get_location_info(loc_id)
		var loc_title: String = str(loc_info.get("title", loc_id))

		var sev_label := GameState.severity_label(severity)
		var ack_label := " [ACK]" if ack else ""

		var row_text := "%s: %s (%s)%s" % [sev_label, title, loc_title, ack_label]
		var idx := alarm_list.add_item(row_text)
		alarm_list.set_item_metadata(idx, alarm_id)

	if not any:
		_show_empty()

func _select_first() -> void:
	if alarm_list.item_count <= 0:
		return
	alarm_list.select(0)
	_on_alarm_selected(0)

func _show_empty() -> void:
	alarm_title.text = "No active alarms"
	alarm_symptom.text = ""
	alarm_hint.text = ""
	ack_button.disabled = true
	go_button.disabled = true

func _on_alarm_selected(index: int) -> void:
	var alarm_id := str(alarm_list.get_item_metadata(index))
	_selected_alarm_id = alarm_id

	var a := GameState.get_alarm_by_id(_selected_alarm_id)
	if a.is_empty():
		_show_empty()
		return

	alarm_title.text = str(a.get("title", "Alarm"))
	alarm_symptom.text = str(a.get("symptom", ""))
	alarm_hint.text = str(a.get("hint", ""))

	var ack: bool = bool(a.get("ack", false))
	ack_button.text = "Unack" if ack else "Ack"
	ack_button.disabled = false
	go_button.disabled = false

func _on_ack_pressed() -> void:
	if _selected_alarm_id.is_empty():
		return

	var a := GameState.get_alarm_by_id(_selected_alarm_id)
	if a.is_empty():
		return

	var new_ack := not bool(a.get("ack", false))
	GameState.set_alarm_ack(_selected_alarm_id, new_ack)

	# refresh, then reselect the same alarm if it still exists
	var keep_id := _selected_alarm_id
	_refresh_list()

	for i in range(alarm_list.item_count):
		if str(alarm_list.get_item_metadata(i)) == keep_id:
			alarm_list.select(i)
			_on_alarm_selected(i)
			return

	_select_first()

func _on_go_pressed() -> void:
	if _selected_alarm_id.is_empty():
		return

	var a := GameState.get_alarm_by_id(_selected_alarm_id)
	if a.is_empty():
		return

	var loc_id: String = str(a.get("location_id", ""))
	GameState.set_selected_location(loc_id)

	if overlay_mode:
		request_go_to_location.emit(loc_id)
		request_close.emit()
	else:
		get_tree().change_scene_to_file("res://scenes/screens/location_screen.tscn")

func _on_back_pressed() -> void:
	if overlay_mode:
		request_close.emit()
	else:
		get_tree().change_scene_to_file("res://scenes/screens/map_screen.tscn")
