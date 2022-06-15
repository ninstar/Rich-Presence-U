tool
extends ColorRect

var open: bool = false
var closing: bool = false
var confirmed: bool = false
var tween: float = 0

export(String) var title = "Title" setget set_title
export(String, MULTILINE) var hint = "Description." setget set_hint
export(String) var button_cancel = "Cancel" setget set_button_cancel
export(String) var button_confirm = "OK" setget set_button_confirm

onready var node_title: = get_node("Panel/Margin/Box/Labels/Title")
onready var node_hint: = get_node("Panel/Margin/Box/Labels/Hint")
onready var node_cancel: = get_node("Panel/Margin/Box/Buttons/Cancel")
onready var node_confirm: = get_node("Panel/Margin/Box/Buttons/Confirm")

onready var node_window = get_node("Panel")

func _ready() -> void:
	
	if not Engine.editor_hint:
		
		# Connect signal
		get_node("/root").connect("size_changed", self, "_on_Window_resize")
		
		# Open
		open = true
		
		# Start modal
		mouse_filter = MOUSE_FILTER_PASS
		visible = true
		
		# Disable focus
		grab_focus()
		release_focus()
		
		# Tween
		$Tween.interpolate_property(self, "tween", tween, 1, 0.5, Tween.TRANS_QUINT, Tween. EASE_IN_OUT)
		$Tween.start()	
func _input(event: InputEvent) -> void:
	
	# Close when clicking outside window
	if not Engine.editor_hint and event is InputEventKey:
		
		if event.is_action("ui_cancel"):
			window_close()

# Methods
func window_close() -> void:
	
	if not closing:
		
		open = false
		
		# Tween
		$Tween.interpolate_property(self, "tween", tween, 0, 0.5, Tween.TRANS_QUINT, Tween. EASE_IN_OUT)
		$Tween.start()
		
		closing = true
func confirmation_action() -> void:
	pass

# Setters
func set_title(new_value) -> void:
	
	# Translate text
	title = new_value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	# Display new text
	node_title.text = title
func set_hint(new_value) -> void:
	
	# Translate text
	hint = new_value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	# Display new text
	node_hint.text = hint
	node_hint.visible = not hint.empty()
func set_button_cancel(new_value) -> void:
	
	# Translate text
	button_cancel = new_value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	# Display new text
	node_cancel.text = button_cancel
	node_cancel.visible = not button_cancel.empty()
func set_button_confirm(new_value) -> void:
	
	# Translate text
	button_confirm = new_value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	# Display new text
	node_confirm.text = button_confirm
	node_confirm.visible = not button_confirm.empty()

# Signals
func _on_Confirm_pressed() -> void:
	
	if not Engine.editor_hint:
		
		if not closing:
			confirmed = true
		window_close()
func _on_Cancel_pressed() -> void:
	
	if not Engine.editor_hint:
		window_close()
func _on_gui_input(event: InputEvent) -> void:
	
	# Close when clicking outside window
	if not Engine.editor_hint and event is InputEventMouseButton:
		
		if event.button_index == BUTTON_LEFT:
			window_close()
func _on_tween_step(_object: Object, _key: NodePath, _elapsed: float, _value: Object) -> void:
	
	# Fade window
	modulate.a = tween
	node_window.rect_scale.x = 0.85 + (0.15 * tween)
	node_window.rect_scale.y = 0.85 + (0.15 * tween)
	node_window.rect_pivot_offset = node_window.rect_size / 2
func _on_tween_all_completed() -> void:
	
	# Round values
	modulate.a = round(modulate.a)
	node_window.rect_scale = node_window.rect_scale.round()
	node_window.rect_pivot_offset = node_window.rect_size / 2
	
	if not open:
		
		closing = false
		
		# End modal
		mouse_filter = MOUSE_FILTER_IGNORE
		visible = false
		
		# Execute confirmation action
		if confirmed:
			
			confirmation_action()
			confirmed = false
		
		# Free
		queue_free()
func _on_Window_resize() -> void:
	
	# Center window
	if not Engine.editor_hint:
		node_window.rect_pivot_offset = node_window.rect_size / 2
