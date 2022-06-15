extends TabContainer

func _ready() -> void:
	set_tab_title(0, Main.metadata["bin"]["version"])
	$Text.bbcode_text = Main.metadata["bin"]["changes"]
