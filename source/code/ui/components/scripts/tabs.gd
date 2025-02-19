extends HBoxContainer

func _ready() -> void:
	
	# Connect signals
	Main.connect("system_changed", self, "_on_System_changed")
	Main.connect("theme_changed", self, "_on_Theme_changed")
	
	# Locale keys
	$B.set_text("TAB_DETAILS")
	$C.set_text("TAB_GAMES")

# Signals
func _on_System_changed() -> void:
	$A/Icon.texture = load("res://assets/ui/tabs/"+Main.settings["system"].to_lower()+"_a.svg")

func _on_Theme_changed(new_theme: String) -> void:
	
	var _theme: Theme = load("res://code/ui/themes/"+new_theme+".tres")
	
	# Change icon color
	$A/Icon.self_modulate = _theme.get_color("font_color", "Button")
