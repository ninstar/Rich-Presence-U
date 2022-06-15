extends "res://code/ui/common/buttons/button.gd"

# Signals
func _on_Theme_changed(new_theme: String) -> void:
	
	# Run parent method
	._on_Theme_changed(new_theme)
	
	# Change theme
	$Icon.texture = load("res://assets/ui/themes/"+new_theme+"/recent.svg")
