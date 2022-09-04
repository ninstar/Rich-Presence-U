extends Node

func _ready() -> void:
	
	# Locale keys
	$Title.set_text("DATA_TITLE")
	$Options/Cache.set_text("RESET_CACHE_TITLE")
	$Options/Data.set_text("RESET_ALL_TITLE")
	$Hint.set_text("DATA_HINT")

# Signals
func _on_Cache_pressed() -> void:
	Main.emit_signal("dialog_added", "res://code/ui/dialogs/popups/cache.tscn")

func _on_Data_pressed() -> void:
	Main.emit_signal("dialog_added", "res://code/ui/dialogs/popups/reset.tscn")
