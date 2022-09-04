extends HBoxContainer

var alert_status: bool = false

onready var node_button: = get_node("Button")
onready var node_toggle: = get_node("Toggle")

func _ready() -> void:
	
	# Connect signals
	Main.connect("status_changed", self, "_on_Status_changed")
	Main.connect("discord_connected", self, "_on_Discord_connected")
	Main.connect("discord_disconnected", self, "_on_Discord_disconnect")
	
	# Locale keys
	node_button.set_text("STATUS_CONNECT")
	$Toggle.set_tooltip("STATUS_VISIBLITY")
	
	# Update configurations on UI
	get_node("Toggle").pressed = Main.settings["activity"]
	
	button_mode()

# Method
func button_mode() -> void:
	
	var _icon: TextureRect = node_toggle.get_node("Icon")
	if Main.discord_connected:
		
		# Disable button if there is no actual change to status
		var _changed_status: int = Main.data_game.hash() + Main.data_system.hash()
		node_button.disabled = Main.status_current == _changed_status
		if node_button.disabled:
			node_button.set_text("STATUS_APPLIED")
		else:
			node_button.set_text("STATUS_APPLY")
		node_button.button_color = node_button.ButtonColor.BURPLE
		
		# Enable toggle
		node_toggle.disabled = false
		node_toggle.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		_icon.modulate.a = 1.0
		
	else:
		
		# Enable button
		node_button.disabled = false
		node_button.set_text("STATUS_CONNECT")
		node_button.button_color = node_button.ButtonColor.GREEN
		
		# Disable toggle
		node_toggle.disabled = true
		node_toggle.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
		_icon.modulate.a = 0.25

# Signals
func _on_Status_changed() -> void:
	
	if not Main.discord_connecting:
		button_mode()

func _on_Discord_connected(_user: Dictionary) -> void:
	button_mode()

func _on_Discord_disconnect() -> void:
	button_mode()

func _on_Toggle_pressed() -> void:
	
	Main.settings["activity"] = node_toggle.pressed
	Main.activity_toggle()

func _on_Button_pressed() -> void:
	
	# Disable button
	node_button.disabled = true
	
	if Main.discord_connected:
		
		# Apply status
		Main.activity_change()
		
		# Warn about invisible status
		if not get_node("Toggle").pressed and not alert_status:
			
			alert_status = true
			Main.emit_signal("dialog_added", "res://code/ui/dialogs/popups/visibility.tscn")
		
	else:
		
		# Connect to Discord
		Main.discord_connect()
		Main.status_current = 0
