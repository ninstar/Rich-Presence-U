extends VBoxContainer

onready var node_list: = get_node("List")

func _ready() -> void:
	
	# Locale keys
	$Title.set_text("SYSTEM_TITLE")
	
	# Fill list
	node_list.clear()
	node_list.add_item("SYSTEM_WUP", 0)
	node_list.add_item("SYSTEM_HAC", 1)
	node_list.add_item("SYSTEM_CTR", 2)
	node_list.set_item_metadata(0, "WUP")
	node_list.set_item_metadata(1, "HAC")
	node_list.set_item_metadata(2, "CTR")
	
	# Find previously selected option
	for i in node_list.get_item_count():
		
		if node_list.get_item_metadata(i) == Main.settings["system"]:
			
			node_list.selected = i
			break

# Signals
func _on_List_item_selected(index: int) -> void:
	Main.change_system(node_list.get_item_metadata(index))
