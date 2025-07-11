extends VBoxContainer

var hovering_results: bool = false
var bee_indicator: Texture = null

onready var node_input: = get_node("Options/Input")
onready var node_list: = get_node("Options/List")
onready var node_results: = get_node("Options/Input/Results")
onready var node_hint: = get_node("Hint")
onready var node_icon: = get_node("Options/Input/Icon")
onready var icon_verified: Texture = node_icon.texture
onready var icon_custom: Texture = node_icon.texture
onready var icon_search: Texture = node_icon.texture

func _ready() -> void:
	
	# Connect signals
	Main.connect("system_changed", self, "_on_System_changed")
	Main.connect("system_region_changed", self, "_on_Region_changed")
	Main.connect("theme_changed", self, "_on_Theme_changed")
	Main.connect("history_changed", self, "_on_History_changed")
	node_list.get_popup().connect("id_pressed", self, "_on_History_selected")
	
	# Locale keys
	$Title.set_text("GAME_TITLE")
	node_input.set_placeholder("GAME_HINT_TYPE")
	node_hint.set_text("GAME_HINT_NONE")
	node_list.set_tooltip("GAME_HINT_RECENT")
	
	node_results.get_parent().remove_child(node_results)
	get_tree().current_scene.call_deferred("add_child", node_results)
	
	set_process(false)

func _process(_delta) -> void:
	node_results.set_global_position(node_input.get_global_rect().position)
	node_results.rect_position.y += node_input.rect_size.y

func _input(event: InputEvent) -> void:
	
	if event.is_action("ui_cancel"):
		close_results()

# Methods
func close_results() -> void:
	
	# Close search results
	node_results.clear()
	node_results.visible = false
	
	if is_processing():
		set_process(false)

func check_game(auto_set_title: bool) -> void:
	
	# Import information about selected game
	var _info: Dictionary = Main.get_game_info(Main.data_system["game"])
	if _info.size() > 1:
		
		# Verified
		Main.game_verified = true
		
		# Set display title for current region
		if auto_set_title:
			node_input.text = Main.get_game_title(_info, Main.data_system["region"])
		
		# Hint
		node_icon.texture = icon_verified
		node_hint.text = ""
		
	else:
		
		# Custom
		Main.game_verified = false
		
		if not Main.data_system["game"].empty():
			
			# Use ID as title
			if auto_set_title:
				node_input.text = _info["id"]
			
			# Set icon
			node_icon.texture = icon_custom
			node_hint.set_text("GAME_HINT_CUSTOM")
			
		else:
			
			# Remove title
			_info["id"] = ""
			if auto_set_title:
				node_input.text = ""
			
			# Hint
			node_icon.texture = icon_search
			node_hint.set_text("GAME_HINT_NONE")
	
	# Toggle hint
	node_hint.visible = not node_hint.text.empty()

func update_history() -> void:
	
	# Fill list
	var _list: PopupMenu = node_list.get_popup()
	_list.clear()
	
	for i in Main.data_system["history"]:
		
		# Import information about game and get title
		var _info: Dictionary = Main.get_game_info(i)
		var _title: String = ""
		if _info.size() > 1:
			_title = Main.get_game_title(_info, Main.data_system["region"])
		else:
			_title = _info["id"]
		
		# Shorten long titles
		if _title.length() > 72:
			_title = _title.substr(0, 72)+"…"
		
		# Add to list
		_list.add_icon_item(bee_indicator if Main.settings["system"] == "BEE"
				and not _info["id"].begins_with("hac::") else null, _title)
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
func _on_System_changed() -> void:
	check_game(true)
	update_history()

func _on_Region_changed() -> void:
	check_game(true)

func _on_Theme_changed(new_theme: String) -> void:
	
	# Change theme
	icon_verified = load("res://assets/ui/themes/"+new_theme+"/game_verified.svg")
	icon_custom = load("res://assets/ui/themes/"+new_theme+"/game_custom.svg")
	icon_search = load("res://assets/ui/themes/"+new_theme+"/search.svg")
	bee_indicator = load("res://assets/ui/themes/"+new_theme+"/bee_indicator.svg")
	
	update_history()

func _on_History_changed() -> void:
	update_history()

func _on_History_selected(id: int) -> void:
	
	var _list: PopupMenu = node_list.get_popup()
	
	Main.debug_log("Changing games ("+Main.data_system["game"]+" -> "+_list.get_item_metadata(id)+")")
	
	# Save user data for current game
	Main.user_data_game(true)
	
	# Select new game
	Main.data_system["game"] = _list.get_item_metadata(id)
	check_game(true)
	
	# Load user data for newly selected game
	Main.user_data_game(false)
	
	# Update UI information
	Main.emit_signal("game_changed")
	
	# Close search results
	close_results()
	
	Main.emit_signal("status_changed")

func _on_Input_text_changed(new_text: String) -> void:

	var _is_match: bool = false
	
	# Save user data for current game
	Main.user_data_game(true)
	
	# Change game title to newly typed text
	Main.data_system["game"] = new_text
	
	# Clear search results
	node_results.clear()
	
	# Search inside database
	for i in Main.games_title.size():
		
		# Up to 5 results
		#if node_results.get_item_count() >= 5:
		#	break
		
		# Import information about game
		var _info: Dictionary = Main.games_title[i]
		
		# Get display title for current region
		var _title: String = Main.get_game_title(_info, Main.data_system["region"])
		
		# Search for match (all regions)
		for o in ["US", "EU", "JP"]:
			
			# Title for this region
			var _region_title: String = _info.get(o.to_lower() + "_title", "").to_lower()
			var _typed_title: String = new_text.to_lower()
			
			# Exact match
			if _typed_title == _region_title:
				Main.data_system["game"] = _info.get("id", "")
				_is_match = true
			else:
				
				# If display title matches any letter being typed
				if _region_title.find(_typed_title, 0) > -1:
					
					# Add option to results and remember game ID
					node_results.add_item(_title, bee_indicator if Main.settings["system"] == "BEE"
							and not _info["id"].begins_with("hac::") else null)
					node_results.set_item_metadata(node_results.get_item_count()-1, _info.get("id", ""))
					
					break
	
	node_results.sort_items_by_text()
	node_results.get_v_scroll().value = 0.0
	node_results.rect_size.x = node_input.rect_size.x
	node_results.rect_min_size.y = 36.0 * float(min(node_results.get_item_count(), 7)) + 8.0
	node_results.set_deferred("rect_size", Vector2(node_results.rect_size.x, node_results.rect_min_size.y))
	
	if not is_processing():
		set_process(true)
	
	# Toggle list
	node_results.visible = node_results.get_item_count() > 0
	
	# No game
	if new_text.empty():
		Main.data_system["game"] = ""
	
	# Check game without changing currently typed title
	check_game(false)
	
	# Load user data for selected game
	Main.user_data_game(false)
	
	# Update configurations on UI
	Main.emit_signal("game_changed")
	
	Main.emit_signal("status_changed")

func _on_Input_focus_exited() -> void:
	
	if(
		not hovering_results and 
		not Input.is_key_pressed(KEY_DOWN) and
		not Input.is_key_pressed(KEY_TAB)
	):
		close_results()

func _on_Input_text_entered(_new_text: String) -> void:
	
	if node_results.visible:
		
		Main.debug_log("Changing games ("+Main.data_system["game"]+" -> "+node_results.get_item_metadata(0)+")")
		
		# Save user data for current game
		Main.user_data_game(true)
		
		# Select first result
		Main.data_system["game"] = node_results.get_item_metadata(0)
		check_game(true)
		
		# Load user data for newly selected game
		Main.user_data_game(false)
		
		# Update UI information
		Main.emit_signal("game_changed")
		
		# Close search results
		close_results()
		
		Main.emit_signal("status_changed")
		
		# Put the carret at the end
		node_input.caret_position = node_input.text.length()

func _on_Results_item_activated(index: int) -> void:
	
	Main.debug_log("Changing games ("+Main.data_system["game"]+" -> "+node_results.get_item_metadata(index)+")")
	
	# Save user data for current game
	Main.user_data_game(true)
	
	# Select new game
	Main.data_system["game"] = node_results.get_item_metadata(index)
	check_game(true)
	
	# Load user data for newly selected game
	Main.user_data_game(false)
	
	# Update UI information
	Main.emit_signal("game_changed")
	
	# Close search results
	close_results()
	
	Main.emit_signal("status_changed")

func _on_Results_focus_entered():
	node_results.select(0)
	node_results.ensure_current_is_visible()

func _on_Results_focus_exited() -> void:
	close_results()

func _on_Results_mouse_entered() -> void:
	hovering_results = true

func _on_Results_mouse_exited() -> void:
	hovering_results = false
