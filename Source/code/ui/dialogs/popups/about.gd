extends "res://code/ui/common/popup.gd"

func confirmation_action() -> void:
	OS.shell_open(Main.metadata["url"]["help"])
