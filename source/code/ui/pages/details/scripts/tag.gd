extends Node

onready var node_fc: = get_node("Options/FC")
onready var node_nnid: = get_node("Options/NNID")
onready var node_toggle: = get_node("Options/Toggle")

func _ready() -> void:
	
	# Connect signals
	Main.connect("system_changed", self, "_on_System_changed")

# Signals
func _on_System_changed() -> void:
	
	# Update configurations on UI
	node_toggle.pressed = Main.data_system["tag"]
	node_nnid.visible = ( Main.settings["system"] == "WUP" )
	node_fc.visible = ( Main.settings["system"] != "WUP" )
	node_fc.get_node("Prefix").visible = ( Main.settings["system"] == "HAC" )
	
	# Change tag format
	if Main.settings["system"] == "WUP":
		$Title.text = "Nintendo Network ID"
		node_nnid.text = Main.data_system["tag_id"]
	else:
		$Title.text = "Friend Code"
		node_fc.get_node("A").text = Main.data_system["tag_fc"][0]
		node_fc.get_node("B").text = Main.data_system["tag_fc"][1]
		node_fc.get_node("C").text = Main.data_system["tag_fc"][2]

func _on_Toggle_toggled(button_pressed: bool) -> void:
	
	Main.data_system["tag"] = button_pressed
	Main.emit_signal("status_changed")

func _on_NNID_text_changed(new_text: String) -> void:
	
	Main.data_system["tag_id"] = new_text
	Main.emit_signal("status_changed")

func _on_FC_A_changed(new_text: String) -> void:
	
	Main.data_system["tag_fc"][0] = new_text
	Main.emit_signal("status_changed")

func _on_FC_B_changed(new_text: String) -> void:
	
	Main.data_system["tag_fc"][1] = new_text
	Main.emit_signal("status_changed")

func _on_FC_C_changed(new_text: String) -> void:
	
	Main.data_system["tag_fc"][2] = new_text
	Main.emit_signal("status_changed")
