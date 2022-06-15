extends Node

onready var node_slider: = get_node("Value/Slider")
onready var node_apply: = get_node("Apply")

func _ready() -> void:
	
	# Find previously set configurations
	node_slider.value = Main.settings["ui_scale"]
	node_apply.disabled = node_slider.value == Main.settings["ui_scale"]

# Signals
func _on_Slider_value_changed(value: float) -> void:
	node_apply.disabled = value == Main.settings["ui_scale"]

func _on_Apply_pressed() -> void:
	Main.settings["ui_scale"] = node_slider.value
	Main.emit_signal("scaling_changed", Main.settings["ui_scale"])
	node_apply.disabled = true
