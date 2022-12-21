extends HBoxContainer

var alert_status: bool = false

onready var node_button: = get_node("Button")
onready var node_toggle: = get_node("Toggle")
onready var node_timer: = get_node("Timer")
onready var node_timer_icon: = get_node("Timer/Icon")

func _ready() -> void:
	
	# Connect signals
	Main.connect("status_changed", self, "_on_Status_changed")
	Main.connect("timer_changed", self, "_on_Timer_changed")
	Main.connect("timer_ended", self, "_on_Timer_ended")
	Main.connect("discord_connected", self, "_on_Discord_connected")
	Main.connect("discord_disconnected", self, "_on_Discord_disconnect")
	Main.connect("theme_changed", self, "_on_Theme_changed")
	
	# Locale keys
	node_button.set_text("STATUS_CONNECT")
	node_toggle.set_tooltip("STATUS_VISIBLITY")
	node_timer.set_tooltip("TIMER_TITLE")
	
	# Update configurations on UI
	get_node("Toggle").pressed = Main.settings["activity"]
	
	button_mode()
	display_time(Main.settings["timer"])

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
		node_button.button_color = node_button.ButtonColor.BLURPLE
		
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

func display_time(value) -> void:
	
	if value > 0:
		
		# Crop hour digits if it is set to 0
		var _time: = Time.get_time_string_from_unix_time(value)
		if _time.begins_with("0"):
			_time = _time.lstrip("0")
			_time = _time.lstrip(":")
		
		node_timer.text = _time
		node_timer.rect_min_size.x = 112.0
		node_timer_icon.stretch_mode = 5
		
	else:
		
		node_timer.text = ""
		node_timer.rect_min_size.x = node_timer.rect_min_size.y
		node_timer_icon.stretch_mode = 6

# Signals
func _on_Discord_connected(_user: Dictionary) -> void:
	button_mode()

func _on_Discord_disconnect() -> void:
	button_mode()

func _on_Status_changed() -> void:
	
	if not Main.discord_connecting:
		button_mode()

func _on_Timer_changed(new_time) -> void:
	
	display_time(new_time)
	
	if new_time > 0:
		if Main.status_running:
			node_timer.get_node("Tics").start(1.0)
	else:
		node_timer.get_node("Tics").stop()

func _on_Timer_ended() -> void:
	
	# Hide status visibility
	node_toggle.pressed = false
	Main.settings["activity"] = false
	Main.activity_toggle()

func _on_Toggle_pressed() -> void:
	
	# Toggle status visibility
	Main.settings["activity"] = node_toggle.pressed
	Main.activity_toggle()

func _on_Timer_pressed() -> void:
	Main.emit_signal("dialog_added", "res://code/ui/dialogs/popups/timer.tscn")

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

func _on_Tics_timeout() -> void:
	
	# Update display time every second
	display_time(Main.status_timer.time_left+1)

func _on_Theme_changed(new_theme: String) -> void:
	
	# Change theme
	node_timer_icon.texture = load("res://assets/ui/themes/"+new_theme+"/timer.svg")
