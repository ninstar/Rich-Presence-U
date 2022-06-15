extends TabContainer

func _ready() -> void:
	
	# Connect signals
	Main.connect("theme_changed", self, "_on_Theme_changed")
	
	# Version number
	get_node("Credits/Info/L/Version/Number").text = Main.VERSION
	
	# Change assets according to theme
	get_node("Credits/Home").texture_normal = load("res://assets/ui/themes/"+Main.settings["ui_theme"]+"/logo.svg")
	get_node("Credits/Info/Contact").texture_normal = load("res://assets/ui/themes/"+Main.settings["ui_theme"]+"/logo_dev.svg")

# Signals
func _on_Home_pressed() -> void:
	OS.shell_open(Main.metadata["url"]["home"])

func _on_Contact_pressed() -> void:
	OS.shell_open(Main.metadata["url"]["contact"])

func _on_Code_pressed() -> void:
	OS.shell_open(Main.metadata["url"]["code"])

func _on_Group_pressed() -> void:
	OS.shell_open(Main.metadata["url"]["group"])

func _on_Credits_meta_clicked(_meta) -> void:
	OS.shell_open(str(_meta))
