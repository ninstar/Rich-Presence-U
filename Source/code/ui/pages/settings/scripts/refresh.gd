extends Node

onready var node_list: = get_node("Options/List")

func _ready() -> void:
	
	# Fill list
	node_list.clear()
	node_list.add_item("Every 12 hours", 0)
	node_list.add_item("Every day", 1)
	node_list.add_item("Every week", 2)
	node_list.add_item("Never", 3)
	node_list.set_item_metadata(0, 43200)
	node_list.set_item_metadata(1, 86400)
	node_list.set_item_metadata(2, 604800)
	node_list.set_item_metadata(3, -1)
	
	# Find previously selected option
	for i in node_list.get_item_count():
		
		if node_list.get_item_metadata(i) == Main.settings["refresh"]:
			
			node_list.selected = i
			break

# Signals
func _on_List_item_selected(index: int) -> void:
	Main.settings["refresh"] = node_list.get_item_metadata(index)

func _on_Button_pressed() -> void:
	Main.emit_signal("dialog_added", "res://code/ui/components/updater.tscn")
