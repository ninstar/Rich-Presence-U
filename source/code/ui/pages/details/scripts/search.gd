extends "res://code/ui/common/buttons/toggle.gd"

func _ready() -> void:
	
	# Connect signals
	Main.connect("system_changed", self, "_on_System_changed")
	
	# Locale keys
	set_title("SEARCH_BUTTON_TITLE")
	set_hint("SEARCH_BUTTON_HINT")

# Signals
func _on_System_changed() -> void:
	
	# Update configurations on UI
	set_check(Main.data_system["extra_button"])

func _on_Search_toggled(button_pressed: bool) -> void:
	
	Main.data_system["extra_button"] = button_pressed
	Main.emit_signal("status_changed")
