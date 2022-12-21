extends "res://code/ui/common/popup.gd"

onready var node_hours: = get_node("Panel/Margin/Box/Labels/Box/H")
onready var node_minutes: = get_node("Panel/Margin/Box/Labels/Box/M")
onready var node_seconds: = get_node("Panel/Margin/Box/Labels/Box/S")
onready var expiration: = Time.get_time_dict_from_unix_time(Main.settings["timer"])

func _ready() -> void:
	
	# Locale keys
	set_title("TIMER_TITLE")
	set_hint("TIMER_HINT")
	set_button_cancel("TIMER_CANCEL")
	set_button_confirm("TIMER_CONFIRM")
	node_hours.set_tooltip("TIMER_HOURS")
	node_minutes.set_tooltip("TIMER_MINUTES")
	node_seconds.set_tooltip("TIMER_SECONDS")
	
	# Saved time
	node_hours.value = expiration["hour"]
	node_minutes.value = expiration["minute"]
	node_seconds.value = expiration["second"]


func confirmation_action() -> void:
	Main.settings["timer"] = Time.get_unix_time_from_datetime_dict(expiration)
	Main.set_timer()


func _on_H_value_changed(value: float) -> void:
	value = wrapf(value, node_hours.min_value+1.0, node_hours.max_value)
	node_hours.value = value
	expiration["hour"] = value

func _on_M_value_changed(value: float) -> void:
	value = wrapf(value, node_minutes.min_value+1.0, node_minutes.max_value)
	node_minutes.value = value
	expiration["minute"] = value

func _on_S_value_changed(value: float) -> void:
	value = wrapf(value, node_seconds.min_value+1.0, node_seconds.max_value)
	node_seconds.value = value
	expiration["second"] = value
