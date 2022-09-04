extends "res://code/ui/common/buttons/toggle.gd"

func _ready() -> void:
	
	# Connect signals
	Main.connect("system_changed", self, "_on_System_changed")
	
	# Locale keys
	set_title("TAG_ICON_TITLE")
	set_hint("TAG_ICON_HINT")

# Signals
func _on_System_changed() -> void:
	
	# Update configurations on UI
	set_check(Main.data_system["tag_icon"])

func _on_Icon_toggled(button_pressed: bool) -> void:
	
	Main.data_system["tag_icon"] = button_pressed
	Main.emit_signal("status_changed")
