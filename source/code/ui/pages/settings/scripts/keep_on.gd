extends "res://code/ui/common/buttons/toggle.gd"

func _ready() -> void:
	
	# Locale keys
	set_title("KEEPON_TITLE")
	set_hint("KEEPON_HINT")
	
	# Update configurations on UI
	set_check(Main.settings["keep_on"])

# Signals
func _on_KeepOn_toggled(button_pressed: bool) -> void:
	Main.settings["keep_on"] = button_pressed
	Main.update_screensaver()
