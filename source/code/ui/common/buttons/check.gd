extends "res://code/ui/common/buttons/button.gd"

export(Texture) var texture_off
export(Texture) var texture_on

func _ready() -> void:
	
	# Connect signals
	connect("toggled", self, "toggle_icon")
	
	# Update UI information
	toggle_icon(pressed)

# Methods
func toggle_icon(button_pressed: bool) -> void:
	
	# ON / OFF
	if button_pressed:
		$Icon.texture = texture_on
	else:
		$Icon.texture = texture_off

# Signals
func _on_Theme_changed(new_theme: String) -> void:
	
	# Run parent method
	._on_Theme_changed(new_theme)
	
	# Change theme
	texture_off = load("res://assets/ui/themes/"+new_theme+"/invisible.svg")
	texture_on = load("res://assets/ui/themes/"+new_theme+"/visible.svg")
	
	# Apply changes
	toggle_icon(pressed)
