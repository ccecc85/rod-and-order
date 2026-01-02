extends Control

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
	alarm_list.item_selected.connect(_on_alarm_selected)
	ack_button.pressed.connect(_on_ack_pressed)
	go_button.pressed.connect(_on_go_pressed)

	_refresh_list()
	_select_first()

func _refresh_list() -> void:
	alarm_list.clear()

	for a in GameState.alarms:
		if not bool(a.get("active", false)):
			continue

		var sev := int(a.get("severity", 1))
		var sev_text := GameState.severity_label(sev)
		var title := str(a.get("title", "Alarm"))
		var loc_id := str(a.get("location_id", ""))

		var loc_title := str(GameState.get_location_info(loc_id).get("title", loc_id))
		var line := "[%s] %s  •  %s" % [sev_text, title, loc_title]

		alarm_list.add_item(line)
		alarm_list.set_item_metadata(alarm_list.item_count - 1, str(a.get("id", "")))

func _select_first() -> void:
	if alarm_list.item_count <= 0:
		_show_empty()
		return
	alarm_list.select(0)
	_on_alarm_selected(0)

func _show_empty() -> void:
	_selected_alarm_id = ""
	alarm_title.text = "No active alarms"
	alarm_symptom.text = ""
	alarm_hint.text = ""
	ack_button.disabled = true
	go_button.disabled = true

func _on_alarm_selected(index: int) -> void:
	var alarm_id := str(alarm_list.get_item_metadata(index))
	_selected_alarm_id = alarm_id

	var a := GameState.get_alarm_by_id(alarm_id)
	if a.is_empty():
		_show_empty()
		return

	alarm_title.text = str(a.get("title", "Alarm"))
	alarm_symptom.text = "Symptom: " + str(a.get("symptom", ""))
	alarm_hint.text = "Hint: " + str(a.get("hint", ""))

	var ack := bool(a.get("ack", false))
	ack_button.text = "ACK" if not ack else "ACKED"

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

	# Refresh selected display without rebuilding the whole list
	_on_alarm_selected(alarm_list.get_selected_items()[0])

func _on_go_pressed() -> void:
	if _selected_alarm_id.is_empty():
		return

	var a := GameState.get_alarm_by_id(_selected_alarm_id)
	if a.is_empty():
		return

	var loc_id := str(a.get("location_id", ""))
	GameState.set_selected_location(loc_id)
	get_tree().change_scene_to_file("res://scenes/screens/location_screen.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/map_screen.tscn")
