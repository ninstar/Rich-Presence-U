extends "res://code/ui/common/buttons/toggle.gd"

func _ready() -> void:
	
	# Locale keys
	set_title("DEBUG_TITLE")
	set_hint("DEBUG_HINT")
	
	# Update configurations on UI
	set_check(Main.settings["debug_log"])

# Signals
func _on_Debug_toggled(button_pressed: bool) -> void:
	Main.settings["debug_log"] = button_pressed
