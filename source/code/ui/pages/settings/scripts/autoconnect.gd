extends "res://code/ui/common/buttons/toggle.gd"

func _ready() -> void:
	
	# Locale keys
	set_title("AUTOCONNECT_TITLE")
	set_hint("AUTOCONNECT_HINT")
	
	# Update configurations on UI
	set_check(Main.settings["auto_connect"])

# Signals
func _on_AutoConnect_toggled(button_pressed: bool) -> void:
	Main.settings["auto_connect"] = button_pressed
