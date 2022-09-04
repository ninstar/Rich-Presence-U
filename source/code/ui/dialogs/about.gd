extends TabContainer

func _ready() -> void:
	
	# Connect signals
	Main.connect("theme_changed", self, "_on_Theme_changed")
	
	# Locale keys
	set_tab_title(0, "ABOUT_CREDITS")
	set_tab_title(1, "ABOUT_LICENSE")
	$Credits/Info/L/Version/Text.set_text("ABOUT_VERSION")
	$Credits/Home.set_tooltip("ABOUT_PAGE")
	$Credits/Info/Contact.set_tooltip("ABOUT_CONTACT")
	
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

func _on_Changelog_pressed() -> void:
	
	var _binary_path: String = OS.get_executable_path().get_base_dir()
	OS.shell_open(_binary_path+"/Changelog.pdf")

func _on_Group_pressed() -> void:
	OS.shell_open(Main.metadata["url"]["group"])

func _on_Credits_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))

func _on_License_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))
