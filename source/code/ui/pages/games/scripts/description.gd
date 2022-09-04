extends VBoxContainer

onready var node_input: = get_node("Options/Input")
onready var node_list: = get_node("Options/List")

func _ready() -> void:
	
	# Connect signals
	Main.connect("game_changed", self, "_on_Game_changed")
	Main.connect("history_changed", self, "_on_History_changed")
	node_list.get_popup().connect("id_pressed", self, "_on_History_selected")
	
	# Locale keys
	$Title.set_text("DESCRIPTION_TITLE")
	$Hint.set_text("DESCRIPTION_HINT")
	$Options/List.set_tooltip("DESCRIPTION_HINT_RECENT")

# Methods
func update_history() -> void:
	
	# Fill list
	var _list: PopupMenu = node_list.get_popup()
	_list.clear()
	
	for i in Main.data_game["history"]:
		
		# Shorten long texts
		var _text: String = i
		if _text.length() > 32:
			_text = _text.substr(0, 32)+"…"
		
		# Add to list
		_list.add_item(_text)
		_list.set_item_metadata(_list.get_item_count()-1, i)
	
	# Toggle button
	var _icon: TextureRect = node_list.get_node("Icon")
	if _list.get_item_count() > 0:
		
		node_list.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		node_list.disabled = false
		_icon.modulate.a = 1.0
	else:
		
		node_list.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
		node_list.disabled = true
		_icon.modulate.a = 0.25

# Signals
func _on_Game_changed() -> void:
	
	# Update configurations on UI
	node_input.text = Main.data_game["description"]
	update_history()

func _on_History_changed() -> void:
	update_history()

func _on_History_selected(id: int) -> void:
	
	var _list: PopupMenu = node_list.get_popup()
	
	# Load full text from list selection
	Main.data_game["description"] = _list.get_item_metadata(id)
	Main.emit_signal("status_changed")
	
	# Update configurations on UI
	node_input.text = _list.get_item_metadata(id) 

func _on_Input_text_changed(new_text: String) -> void:
	
	Main.data_game["description"] = new_text
	Main.emit_signal("status_changed")
