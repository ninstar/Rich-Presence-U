extends "res://code/ui/common/popup.gd"

func _ready() -> void:
	
	# Locale keys
	set_title("RESET_ALL_TITLE")
	set_hint("RESET_ALL_HINT")
	set_button_cancel("RESET_ALL_CANCEL")
	set_button_confirm("RESET_ALL_CONFIRM")

func confirmation_action() -> void:
	Main.clear_data(false)
