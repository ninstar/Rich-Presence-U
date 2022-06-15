extends Node

# Signals
func _on_Cache_pressed() -> void:
	Main.emit_signal("dialog_added", "res://code/ui/dialogs/popups/cache.tscn")

func _on_Data_pressed() -> void:
	Main.emit_signal("dialog_added", "res://code/ui/dialogs/popups/reset.tscn")
