extends Button

enum ButtonColor {DEFAULT, BLURPLE, GREEN, RED}

var color_normal: = [Color("3e4249"), Color("5865f2"), Color("3ba55d"), Color("ed4245")]
var color_hover: = [Color("2f3136"), Color("4752c4"), Color("2d7d46"), Color("c03537")]
var color_press: = [Color("202225"), Color("3c45a5"), Color("236136"), Color("a12d2f")]

export(ButtonColor) var button_color = ButtonColor.DEFAULT setget set_button_color

var color_current: = Color.black

func _ready() -> void:
	
	# Connect signals
	connect("button_down", self, "_on_press")
	connect("button_up", self, "_on_hover")
	connect("focus_entered", self, "_on_hover")
	connect("focus_exited", self, "_on_exited")
	connect("mouse_entered", self, "_on_hover")
	connect("mouse_exited", self, "_on_exited")
	Main.connect("theme_changed", self, "_on_Theme_changed")
	
	# Make styleboxes unique for this instance
	generate_styleboxes()
	
	# Change button color
	set_button_color(button_color)
	_on_Theme_changed(Main.settings["ui_theme"])

# Methods
func color_change(new_color: Color) -> void:
	
	var _tween: Tween = get_node("Tween")
	if _tween != null:
		
		_tween.interpolate_property(self, "color_current", color_current, new_color, 
				0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		_tween.start()

func  generate_styleboxes() -> void:
	
	if get_stylebox("normal") is StyleBoxFlat:
		
		var _override = get_stylebox("normal").duplicate()
		add_stylebox_override("hover", _override)
		add_stylebox_override("pressed", _override)
		add_stylebox_override("normal", _override)

# Setters
func set_button_color(new_value) -> void:
	
	button_color = new_value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	# Change button color
	color_current = color_normal[button_color]
	color_change(color_current)

# Signals
func _on_press() -> void:
	color_change(color_press[button_color])

func _on_hover() -> void:
	color_change(color_hover[button_color])

func _on_exited() -> void:
	color_change(color_normal[button_color])

func _on_tween_step(_object: Object, _key: NodePath, _elapsed: float, _value: Object) -> void:
	
	if get_stylebox("normal") is StyleBoxFlat:
		get_stylebox("normal").bg_color = color_current

func _on_Theme_changed(new_theme: String) -> void:
	
	# Make styleboxes unique for this instance
	generate_styleboxes()
	
	# Switch to light / dark theme
	if new_theme == "light":
		
		color_normal[0] = Color("f2f3f5")
		color_hover[0] = Color("ccd0d5")
		color_press[0] = Color("cccccc")
		
	else:
		
		color_normal[0] = Color("3e4249")
		color_hover[0] = Color("2f3136")
		color_press[0] = Color("202225")
	
	# Change base theme to follow font colors
	if button_color == ButtonColor.DEFAULT:
		theme = load("res://code/ui/themes/"+new_theme+".tres")
	else:
		theme = load("res://code/ui/themes/dark.tres")
	
	# Change button color
	color_current = color_normal[button_color]
	color_change(color_current)
