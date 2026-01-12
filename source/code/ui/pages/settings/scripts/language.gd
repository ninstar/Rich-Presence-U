extends VBoxContainer

onready var node_list: = get_node("List")

func _ready() -> void:
	
	# Locale keys
	$Title.set_text("LANGUAGE_TITLE")
	
	# Fill list
	node_list.clear()
	node_list.add_item("LANGUAGE_AUTO", 0)
	node_list.set_item_metadata(0, "")
	
	var translated_names: Dictionary = {
		"de": "Deutsch",
		"en": "English",
		"es": "Español",
		"fr": "Français",
		"hu": "Magyar",
		"nl": "Nederlands",
		"pt": "Português",
	}
	
	var loaded_locales: Array = TranslationServer.get_loaded_locales()
	loaded_locales.sort()
	for locale in loaded_locales:
		var index: int = node_list.get_item_count()
		var locale_name: String = TranslationServer.get_locale_name(locale)
		if translated_names.has(locale):
			locale_name = translated_names[locale]
		
		node_list.add_item(locale_name, index)
		node_list.set_item_metadata(index, locale)

	# Find previously selected option
	for i in node_list.get_item_count():
		
		if node_list.get_item_metadata(i) == Main.settings["language"]:
			
			node_list.selected = i
			break

# Signals
func _on_List_item_selected(index: int) -> void:
	Main.settings["language"] = node_list.get_item_metadata(index)
	Main.emit_signal("language_changed", Main.settings["language"])
