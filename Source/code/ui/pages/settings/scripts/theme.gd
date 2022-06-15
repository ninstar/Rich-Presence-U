extends Node

onready var node_list: = get_node("List")

func _ready() -> void:
	
	# Fill list
	node_list.clear()
	node_list.add_item("Dark", 0)
	node_list.add_item("Light", 1)
	node_list.set_item_metadata(0, "dark")
	node_list.set_item_metadata(1, "light")
	
	# Find previously selected option
	for i in node_list.get_item_count():
		
		if node_list.get_item_metadata(i) == Main.settings["ui_theme"]:
			
			node_list.selected = i
			break

# Signals
func _on_List_item_selected(index: int) -> void:
	Main.settings["ui_theme"] = node_list.get_item_metadata(index)
	Main.emit_signal("theme_changed", Main.settings["ui_theme"])
