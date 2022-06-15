extends Node

func _ready() -> void:
	
	# Connect signals
	Main.connect("system_changed", self, "_on_System_changed")
	Main.connect("theme_changed", self, "_on_Theme_changed")
	
# Signals
func _on_System_changed() -> void:
	
	var _icon_path = "res://assets/ui/tabs/" + Main.settings["system"].to_lower()
	var _delay: float = 0
	for i in ["A", "B", "C"]:
		
		# Change icon
		var _icon: TextureRect = get_node(i+"/Icon")
		_icon.texture = load(_icon_path+"_"+i.to_lower()+".svg")
		_icon.modulate.a = 0
		
		# Animate
		var _tween: Tween = get_node(i+"/Icon/Tween")
		_tween.stop_all()
		_tween.interpolate_property(_icon, "modulate:a", 0, 1.0, 2.0,
				Tween.TRANS_QUINT, Tween.EASE_OUT, _delay)
		_tween.start()
	
		_delay += 0.15

func _on_Theme_changed(new_theme: String) -> void:
	
	var _theme: Theme = load("res://code/ui/themes/"+new_theme+".tres")
	
	# Change icon colors
	for i in ["A", "B", "C"]:
		get_node(i+"/Icon").self_modulate = _theme.get_color("font_color", "Button")
