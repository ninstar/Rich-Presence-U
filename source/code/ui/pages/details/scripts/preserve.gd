extends "res://code/ui/common/buttons/toggle.gd"

func _ready() -> void:
	
	# Connect signals
	Main.connect("system_changed", self, "_on_System_changed")

# Signals
func _on_System_changed() -> void:
	
	# Update configurations on UI
	set_check(Main.data_system["time_preserve"])

func _on_Preserve_toggled(button_pressed: bool) -> void:
	
	Main.data_system["time_preserve"] = button_pressed
	Main.emit_signal("status_changed")
