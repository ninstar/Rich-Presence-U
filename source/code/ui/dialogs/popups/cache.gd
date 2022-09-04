extends "res://code/ui/common/popup.gd"

func _ready() -> void:
	
	# Locale keys
	set_title("RESET_CACHE_TITLE")
	set_hint("RESET_CACHE_HINT")
	set_button_cancel("RESET_CACHE_CANCEL")
	set_button_confirm("RESET_CACHE_CONFIRM")

func confirmation_action() -> void:
	Main.clear_data(true)
