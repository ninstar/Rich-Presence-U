extends VBoxContainer

onready var node_input: = get_node("Options/Input")
onready var node_list: = get_node("Options/List")

func _ready() -> void:
	
	# Connect signals
	Main.connect("game_changed", self, "_on_Game_changed")
	Main.connect("system_region_changed", self, "_on_Region_changed")
	
	# Locale keys
	$Title.set_text("RENAME_TITLE")
	$Hint.set_text("RENAME_HINT")
	$Options/Input.set_tooltip("RENAME_HINT_INPUT")
	$Options/List.set_tooltip("RENAME_HINT_REGION")
	
	# Fill list
	node_list.clear()
	node_list.add_item("RENAME_DEFAULT", 0)
	node_list.add_item("REGION_US", 1)
	node_list.add_item("REGION_EU", 2)
	node_list.add_item("REGION_JP", 3)
	node_list.set_item_metadata(0, "")
	node_list.set_item_metadata(1, "US")
	node_list.set_item_metadata(2, "EU")
	node_list.set_item_metadata(3, "JP")

# Methods
func check_regions() -> void:
	
	# Import information about selected game
	var _info: Dictionary = Main.get_game_info(Main.data_system["game"])
	if _info.size() > 1:
		
		visible = true
		
		# Check which regions are available for this game
		for i in ["US", "EU", "JP"]:
			
			# Find relevant region key
			for o in node_list.get_item_count():
				
				if node_list.get_item_metadata(o) == i:
					
					node_list.set_item_disabled(o, not _info.has(i.to_lower() + "_title"))
					break
		
		# Bsae ttle
		var _region: String = Main.data_game["region"]
		if Main.data_game["region"].empty():
			_region = Main.data_system["region"]
		node_input.placeholder_text = Main.get_game_title(_info, _region)
		
	else:
		visible = false

# Signals
func _on_Game_changed() -> void:
	
	# Find previously selected option
	for i in node_list.get_item_count():
		
		if node_list.get_item_metadata(i) == Main.data_game["region"]:
			
			node_list.selected = i
			break
	
	# Update configurations on UI
	node_input.text = Main.data_game["rename"]
	check_regions()

func _on_Region_changed() -> void:
	
	check_regions()
	Main.emit_signal("status_changed")

func _on_Input_text_changed(new_text: String) -> void:
	
	Main.data_game["rename"] = new_text
	Main.emit_signal("status_changed")

func _on_List_item_selected(index: int) -> void:
	
	Main.data_game["region"] = node_list.get_item_metadata(index)
	check_regions()
	Main.emit_signal("status_changed")
