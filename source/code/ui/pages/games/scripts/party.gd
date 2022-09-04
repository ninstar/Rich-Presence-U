extends VBoxContainer

onready var node_size: = get_node("Options/Size")
onready var node_max: = get_node("Options/Max")
onready var node_toggle: = get_node("Options/Toggle")

func _ready() -> void:
	
	# Connect signals
	Main.connect("game_changed", self, "_on_Game_changed")
	
	# Locale keys
	$Title.set_text("PARTY_TITLE")
	$Options/Of.set_text("PARTY_OF")
	$Options/Toggle.set_tooltip("PARTY_HINT_VISIBILITY")

# Signals
func _on_Game_changed() -> void:
	
	# Update configurations on UI
	node_size.value = float(Main.data_game["party_size"])
	node_max.value = float(Main.data_game["party_max"])
	node_toggle.pressed = Main.data_game["party"]

func _on_Toggle_toggled(button_pressed: bool) -> void:
	
	Main.data_game["party"] = button_pressed
	Main.emit_signal("status_changed")

func _on_Size_value_changed(value: float) -> void:
	
	# Clamp values
	if value > node_max.value:
		node_max.value = value
	
	# Sync values
	Main.data_game["party_size"] = int(value)
	Main.data_game["party_max"] = int(node_max.value)
	
	Main.emit_signal("status_changed")

func _on_Max_value_changed(value: float) -> void:
	
	# Clamp values
	if value < node_size.value:
		node_size.value = value
	
	# Sync values
	Main.data_game["party_size"] = int(node_size.value)
	Main.data_game["party_max"] = int(value)
	
	Main.emit_signal("status_changed")
