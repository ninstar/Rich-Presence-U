extends "res://code/ui/common/popup.gd"

func _ready() -> void:
	
	# Locale keys
	set_title("UPDATE_TITLE")
	set_hint("UPDATE_HINT")
	set_button_cancel("UPDATE_CANCEL")
	set_button_confirm("UPDATE_CONFIRM")

func confirmation_action() -> void:
	OS.shell_open(Main.metadata["bin"]["url"])
