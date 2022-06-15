tool
extends VBoxContainer

signal button_toggled(button_pressed)

export(bool) var check = false setget set_check
export(String) var title = "Title" setget set_title
export(String, MULTILINE) var description = "Hint." setget set_hint

onready var node_toggle: = get_node("Button/Box/Toggle")
onready var node_title: = get_node("Button/Box/Title")
onready var node_hint: = get_node("Hint")

# Methods
func button_toggle() -> void:
	
	if not Engine.editor_hint:
		
		# Toggle animation
		var _toggle: = node_toggle.get_node("Animation")
		if check:
			_toggle.play("Toggle")
		else:
			_toggle.play_backwards("Toggle")

# Setters
func set_check(new_value) -> void:
	
	check = new_value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	# OFF / ON
	if $Button.pressed != check:
		button_toggle()
	$Button.pressed = check

func set_title(new_value) -> void:
	
	# Translate text
	title = new_value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	# Display new text
	node_title.text = title

func set_hint(new_value) -> void:
	
	# Translate text
	description = new_value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	# Display new text
	node_hint.text = description
	node_hint.visible = not description.empty()

# Signals
func _on_Button_toggled(button_pressed: bool) -> void:
	
	if not Engine.editor_hint:
		
		# Toggle when pressed
		check = button_pressed
		$Button.pressed = check
		button_toggle()
		
		# Trigger signal
		emit_signal("button_toggled", button_pressed)
