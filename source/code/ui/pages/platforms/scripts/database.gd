extends VBoxContainer

var tween_value: float = 0

func _ready() -> void:
	
	# Connect signals
	Main.connect("games_imported", self, "_on_Games_imported")
	Main.connect("theme_changed", self, "_on_Theme_changed")
	
	# Locale keys
	$All/Name/Label.set_text("VERIFIED_TITLE")
	$US/Name.set_text("REGION_US")
	$EU/Name.set_text("REGION_EU")
	$JP/Name.set_text("REGION_JP")
	set_tooltip("VERIFIED_HINT")

# Signals
func _on_Games_imported() -> void:
	
	# Animate
	$Tween.stop_all()
	$Tween.interpolate_property(self, "tween_value", 0, 1.0, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()

func _on_Theme_changed(new_theme: String) -> void:
	
	# Change theme
	var _icon: TextureRect = get_node("All/Name/Seal/Icon")
	_icon.texture = load("res://assets/ui/themes/"+new_theme+"/game_verified.svg")

func _on_Tween_step(_object: Object, _key: NodePath, _elapsed: float, _value: Object) -> void:
	
	# Display total
	var _total: int = 0
	for i in ["US", "EU", "JP"]:
		
		get_node(i+"/Total").text = str(round(Main.games_total[i] * tween_value))
		_total += Main.games_total[i]
	
	get_node("All/Total").text = str(round(_total * tween_value))
