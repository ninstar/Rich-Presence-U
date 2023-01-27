extends "res://code/ui/common/popup.gd"

func _ready() -> void:
	
	# Locale keys
	set_title("ABOUT_TITLE")
	set_button_cancel("ABOUT_CLOSE")
	set_button_confirm("ABOUT_HELP")

func confirmation_action() -> void:
	
	var _locale: String = Main.settings["language"]
	var _link: String = Main.metadata["url"]["help"]
	
	# Get current language
	if _locale.empty():
		_locale = OS.get_locale_language()
	
	# Get link for current language
	if Main.metadata["url"].has("help_"+_locale):
		if not Main.metadata["url"]["help_"+_locale].empty():
			_link = Main.metadata["url"]["help_"+_locale]
	
	OS.shell_open(_link)
