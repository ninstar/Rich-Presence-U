extends Node

onready var node_list: = get_node("List")

func _ready() -> void:
	
	# Connect signals
	Main.connect("system_changed", self, "_on_System_changed")
	
	# Fill list
	node_list.clear()
	node_list.add_item("Americas", 0)
	node_list.add_item("Europe", 1)
	node_list.add_item("Japan", 2)
	node_list.set_item_metadata(0, "US")
	node_list.set_item_metadata(1, "EU")
	node_list.set_item_metadata(2, "JP")

# Signals
func _on_System_changed() -> void:
	
	# Find previously selected option
	for i in node_list.get_item_count():
		
		if node_list.get_item_metadata(i) == Main.default_system["region"]:
			
			node_list.selected = i
			break

func _on_List_item_selected(index: int) -> void:
	Main.data_system["region"] = node_list.get_item_metadata(index)
	Main.emit_signal("system_region_changed")
