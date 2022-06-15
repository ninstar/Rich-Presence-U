extends "res://code/ui/common/buttons/toggle.gd"

func _ready() -> void:
	
	# Update configurations on UI
	set_check(Main.settings["auto_connect"])

# Signals
func _on_Debug_toggled(button_pressed: bool) -> void:
	Main.settings["auto_connect"] = button_pressed
