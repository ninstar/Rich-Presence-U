extends Control

var tween_pages_target
var tween_pages: float = 0
var tween_menus: float = 0

onready var node_bar: = get_node("Main/T/Bar")
onready var node_menus: = get_node("Main/B/Menus")
onready var node_pages: = get_node("Main/B/Menus/L/Pages")
onready var node_tabs: = get_node("Main/B/Menus/L/T/Tabs")
onready var node_settings: = get_node("Main/B/Menus/R/Settings")

func _ready() -> void:
	
	# Connect signals
	get_node("/root").connect("size_changed", self, "_on_Window_resize")
	Main.connect("scaling_changed", self, "_on_Scaling_changed")
	Main.connect("theme_changed", self, "_on_Theme_changed")
	Main.connect("dialog_added", self, "_on_Dialog_added")
	Main.connect("metadata_imported", self, "_on_Metadata_imported")
	node_tabs.get_node("A").connect("pressed", self, "_on_Tab_pressed", ["A"])
	node_tabs.get_node("B").connect("pressed", self, "_on_Tab_pressed", ["B"])
	node_tabs.get_node("C").connect("pressed", self, "_on_Tab_pressed", ["C"])
	
	# Update configurations on UI
	Main.emit_signal("language_changed", Main.settings["language"])
	Main.emit_signal("theme_changed", Main.settings["ui_theme"])
	Main.emit_signal("scaling_changed", Main.settings["ui_scale"])
	Main.emit_signal("system_changed")
	Main.emit_signal("game_changed")
	Main.emit_signal("games_imported")
	
	# Toggle tabs
	_on_Window_resize()

func _input(event: InputEvent) -> void:
	
	if event.is_action("ui_cancel"):
		
		grab_focus()
		release_focus()

func _notification(what: int) -> void:
	
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		
		grab_focus()
		release_focus()

# Signals
func _on_Window_resize() -> void:
	
	var _show_all = OS.get_real_window_size().x > (320 * Main.settings["ui_scale"]) * 3
	
	for i in ["A", "B", "C"]:
		
		# Show one or all pages
		node_pages.get_node(i).visible = ( _show_all or Main.settings["ui_tab"] == i)
		
		# Togge tabs
		node_tabs.get_node(i).disabled = _show_all
		node_tabs.get_node(i).flat = _show_all

func _on_Metadata_imported() -> void:
	
	# Show new version
	node_bar.get_node("Update").visible = Main.metadata["bin"]["latest"] > Main.BUILD

func _on_Scaling_changed(new_scaling: float) -> void:
	
	# Toggle pages
	_on_Window_resize()

func _on_Theme_changed(new_theme: String) -> void:
	
	# Change theme
	theme = load("res://code/ui/themes/"+new_theme+".tres")
	
	# Get styleboxes for current theme
	for i in theme.get_stylebox_list("Button"):
		
		if i != "normal":
			
			# Duplicate stylebox
			var _stylebox: StyleBox = theme.get_stylebox(i, "Button").duplicate() 
			
			# Remove margins
			_stylebox.content_margin_left = 0
			_stylebox.content_margin_right = 0
			_stylebox.content_margin_top = 0
			_stylebox.content_margin_bottom = 0
			
			# Override styles
			node_bar.get_node("Update").add_stylebox_override(i, _stylebox)
			node_bar.get_node("About").add_stylebox_override(i, _stylebox)
			node_bar.get_node("Settings").add_stylebox_override(i, _stylebox)
	
	# Change icons
	node_bar.get_node("Update/Icon").texture = load("res://assets/ui/themes/"+new_theme+"/update.svg")
	node_bar.get_node("About/Icon").texture = load("res://assets/ui/themes/"+new_theme+"/about.svg")
	node_bar.get_node("Settings/Icon").texture = load("res://assets/ui/themes/"+new_theme+"/settings.svg")

func _on_Dialog_added(path: String) -> void:
	
	# Add dialog pop-up
	var _object: = load(path)
	var _instance = _object.instance()
	$Dialogs.add_child(_instance)

func _on_Tab_pressed(tab_name: String) -> void:
	
	if Main.settings["ui_tab"] != tab_name:
		
		# Select current page as a target
		tween_pages_target = node_pages.get_node(Main.settings["ui_tab"]+"/Box")
		
		# Remeber the newly selected tab
		Main.settings["ui_tab"] = tab_name
		
		# Tween page being close
		node_pages.get_node("Tween").interpolate_property(self, "tween_pages", tween_pages,
				1, 0.4, Tween.TRANS_EXPO, Tween. EASE_IN)
		node_pages.get_node("Tween").start()

func _on_Settings_toggled(button_pressed: bool) -> void:
	
	# Toggle settings page
	var _open: float = 1 if button_pressed == true else 0 
	
	# Tween transition
	node_menus.get_node("Tween").interpolate_property(self, "tween_menus", tween_menus,
			_open, 0.6, Tween.TRANS_EXPO, Tween. EASE_IN_OUT)
	node_menus.get_node("Tween").start()

func _on_About_pressed() -> void:
	Main.emit_signal("dialog_added", "res://code/ui/dialogs/popups/about.tscn")

func _on_Update_pressed() -> void:
	Main.emit_signal("dialog_added", "res://code/ui/dialogs/popups/new_version.tscn")

func _on_Menus_tween_step(_object: Object, _key: NodePath, _elapsed: float, _value: Object) -> void:
	
	# Move menus horizontally
	node_menus.anchor_left = -tween_menus
	node_menus.anchor_right = 2.0 - tween_menus
	
	# Make settings page visible first
	node_settings.visible = tween_menus > 0

func _on_Pages_tween_step(_object: Object, _key: NodePath, _elapsed: float, _value: Object) -> void:
	
	# Fade page
	tween_pages_target.modulate.a = 1.0 - tween_pages
	tween_pages_target.rect_scale.x = 1.0 - (0.15 * tween_pages)
	tween_pages_target.rect_scale.y = 1.0 - (0.15 * tween_pages)
	tween_pages_target.rect_pivot_offset = tween_pages_target.rect_size / 2

func _on_Pages_tween_completed(_object: Object, _key: NodePath) -> void:
	
	# Reset previous page animation
	tween_pages_target.modulate.a = 1.0
	
	# After page is closed
	if tween_pages > 0:
		
		# Change page according to the selected tab
		node_pages.get_node("A").visible = Main.settings["ui_tab"] == "A"
		node_pages.get_node("B").visible = Main.settings["ui_tab"] == "B"
		node_pages.get_node("C").visible = Main.settings["ui_tab"] == "C"
		
		# Select new page as a target
		tween_pages_target = node_pages.get_node(Main.settings["ui_tab"]+"/Box")
		
		# Make new target invisible
		tween_pages_target.modulate.a = 0
		
		# Animate page being open
		node_pages.get_node("Tween").interpolate_property(self, "tween_pages", tween_pages,
				0, 0.4, Tween.TRANS_EXPO, Tween. EASE_OUT)
		node_pages.get_node("Tween").start()
