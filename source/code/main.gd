extends Node

signal discord_connecting()
signal discord_connected(user)
signal discord_disconnected()
signal metadata_imported()
signal games_imported()
signal game_changed()
signal system_changed()
signal system_region_changed()
signal language_changed(new_lang)
signal scaling_changed(new_scaling)
signal theme_changed(new_theme)
signal dialog_added(path)
signal history_changed()
signal status_changed()
signal timer_changed(new_time)
signal timer_ended()

const METADATA = "https://gist.github.com/ninstar/19c664a823d3a0312f47f5ac5e52a915/raw"
const CONFIG = "user://settings.cfg"
const VERSION = "1.5.0"
const BUILD = 1500
const CLIENT = 985449859299565649

var logger: Array
var metadata: Dictionary = {
	
	"bin":{
		
		"latest": BUILD,
		"minimal": BUILD,
		"version": "",
		"changes": "",
		"dlc": "",
		"url": "",
	},
	"dlc": {
		
		"wup_client": "1259966953573847130",
		"wup_titles": "https://github.com/ninstar/Rich-Presence-U-DB/raw/main/titles/wup.csv",
		"wup_assets": "https://github.com/ninstar/Rich-Presence-U-DB/raw/main/titles/wup/",
		"hac_client": "1259967215323840564",
		"hac_titles": "https://github.com/ninstar/Rich-Presence-U-DB/raw/main/titles/hac.csv",
		"hac_assets": "https://github.com/ninstar/Rich-Presence-U-DB/raw/main/titles/hac/",
		"ctr_client": "1259967368000569394",
		"ctr_titles": "https://github.com/ninstar/Rich-Presence-U-DB/raw/main/titles/ctr.csv",
		"ctr_assets": "https://github.com/ninstar/Rich-Presence-U-DB/raw/main/titles/ctr/",
		"bee_client": "1385689410502263016",
		"bee_titles": "https://github.com/ninstar/Rich-Presence-U-DB/raw/main/titles/bee.csv",
		"bee_assets": "https://github.com/ninstar/Rich-Presence-U-DB/raw/main/titles/bee/",
	},
	"url": {
		
		"home": "https://ninstars.blogspot.com/rpc",
		"contact": "https://ninstar.carrd.co",
		"group": "https://discord.gg/N9bMDEcrX4",
		"help": "https://discord.gg/N9bMDEcrX4",
	},
}
var settings: Dictionary = {
	
	"system": "HAC",
	"language": "",
	"refresh": 604800,
	"refresh_last": 0,
	"auto_connect": false,
	"keep_on": true,
	"debug_log": true,
	"activity": true,
	"timer": 0,
	"window_size": OS.window_size,
	"window_position": OS.window_position,
	"window_maximized": OS.window_maximized,
	"screen_count": OS.get_screen_count(),
	"ui_scale": 1.0,
	"ui_theme": "dark",
	"ui_tab": "A",
}
var default_system: Dictionary = {
	
	"game": "",
	"history": [],
	"region": "US",
	"time_preserve": false,
	"minimal_status": false,
	"tag": true,
	"tag_id": "",
	"tag_fc": ["", "", ""],
	"tag_icon": false,
	"library": {},
}
var default_game: Dictionary = {
	
	"description": "",
	"history": [],
	"party": false,
	"party_size": 1,
	"party_max": 1,
	"region": "",
	"rename": "",
}
var timestamp: int = -1
var previous_game: String = ""
var previous_system: String = ""
var game_verified: bool = false
var games_total: Dictionary
var games_title: Array
var discord_api: DiscordRPC
var discord_rpc: RichPresence
var discord_client: int = CLIENT
var discord_title: String = ""
var discord_connecting: bool = false
var discord_connected: bool = false
var discord_autopush: bool = false
var discord_user: Dictionary
var status_current: int = 0
var clearing_data: bool = false
var status_timer: Timer
var status_running: bool = false

onready var data_system: Dictionary = default_system.duplicate(true)
onready var data_game: Dictionary = default_game.duplicate(true)
onready var start_time: int = OS.get_unix_time()

func _enter_tree() -> void:
	OS.set_window_title("Rich Presence U")

func _ready() -> void:
	
	# Connect signals
	connect("language_changed", self, "_on_Language_changed")
	connect("scaling_changed", self, "_on_Scaling_changed")
	
	# Load app configurations
	var _cfg = ConfigFile.new()
	var _error: int = _cfg.load(CONFIG)
	debug_log("Loading config "+CONFIG+": "+str(_error))
	if _error == OK:
		
		for i in settings:
			settings[i] = _cfg.get_value("Settings", i, settings[i])

	# Setup window
	if OS.get_screen_count() == settings["screen_count"]:
		
		OS.window_size = settings["window_size"]
		OS.window_position = settings["window_position"]
		OS.window_maximized = settings["window_maximized"]
	
	# Impoprt games
	import_games()
	
	# Load user data
	user_data_system(false)
	user_data_game(false)
	
	# Download metadata
	download_metadata()
	
	# Status timer
	status_timer = Timer.new()
	status_timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(status_timer)
	
	# Discord API
	discord_api = DiscordRPC.new()
	discord_api.connect("rpc_ready", self, "_on_Discord_connected")
	discord_api.connect("rpc_closed", self, "_on_Discord_disconnected")
	add_child(discord_api)
	
	# Auto connect
	if settings["auto_connect"]:
		discord_connect()
func _notification(what: int) -> void:
	
	# Close application
	if what == MainLoop.NOTIFICATION_CRASH:
		debug_export()
		
	elif what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		
		if not clearing_data:
			
			if settings["debug_log"]:
				debug_export()
			
			# Remember window setup
			settings["window_maximized"] = OS.is_window_maximized()
			if not OS.is_window_maximized() and not OS.is_window_minimized():
				settings["window_position"] = OS.get_window_position()
				settings["window_size"] = OS.get_window_size()
				settings["screen_count"] = OS.get_screen_count()
			
			# Save user data
			user_data_game(true)
			user_data_system(true)
			
			# Save app configurations
			var _cfg = ConfigFile.new()
			for i in settings:
				_cfg.set_value("Settings", i, settings[i])
			_cfg.save(CONFIG)

# Methods
func download_metadata() -> void:
	
	# Create directory for downloads
	var _directory: = Directory.new()
	var _error: int = _directory.open("user://")
	debug_log("Opening directory /: "+str(_error))
	if _error == OK:
		_error = _directory.make_dir("cache")
		debug_log("Making directory /cache: "+str(_error))
	
	# Create HTTP request
	var _request: = HTTPRequest.new()
	add_child(_request)
	_request.connect("request_completed", self, "_on_Metadata_download_completed")
	
	# Get file from URL
	_request.set_download_file("user://cache/metadata.cfg")
	_error = _request.request(METADATA)
	debug_log("Starting HTTP request ("+METADATA+"): "+str(_error))
func import_metadata() -> void:
	
	# Hold method for a while before UI loads
	yield(get_tree().create_timer(0.05), "timeout")
	
	# Import metadata
	var _cfg = ConfigFile.new()
	var _error: int = _cfg.load("user://cache/metadata.cfg")
	debug_log("Loading config /cache/metadata.cfg: "+str(_error))
	if _error == OK:
		
		for s in _cfg.get_sections():
			
			for k in _cfg.get_section_keys(s):
				
				if _cfg.has_section_key(s, k):
					metadata[s][k] = _cfg.get_value(s, k)
	
	emit_signal("metadata_imported")
func import_games() -> void:
	
	var _error: int
	
	# Clear array
	games_title.clear()
	games_total.clear()
	
	# Reset total of games per region
	for i in ["US", "EU", "JP"]:
		games_total[i] = 0
	
	# Import titles
	var _paths: Array = [settings["system"].to_lower()]
	if settings["system"] == "BEE":
		_paths.append("hac")
	
	var _id_prefix: String = ""
	for _path in _paths:
		var _csv: = File.new()
		_error = _csv.open("user://cache/titles/"+_path+".csv", _csv.READ)
		debug_log("Reading file /cache/titles/"+_path+".csv: "+str(_error))
		if _error == OK:
			
			# Read lines
			var _index: int = 0
			while not _csv.eof_reached():
				
				
				# Read delimiters
				var _line: PoolStringArray = _csv.get_csv_line(",")
				if _index > 0 and _line.size() >= 7:
					
					# Read all data to this game
					var _game: Dictionary = {
						
						"id": _id_prefix+_line[0],
						"us_client": _line[1],
						"eu_client": _line[2],
						"jp_client": _line[3],
						"us_title": _line[4],
						"eu_title": _line[5],
						"jp_title": _line[6],
					}
					
					# Remove empty keys
					for i in _game.keys():
						
						if _game.has(i) and _game.get(i) == "":
							_game.erase(i) 
					
					# Add to total of games per region
					for i in ["US", "EU", "JP"]:
						
						if _game.has( i.to_lower() + "_title" ):
							games_total[i] += 1
					
					# Append information
					games_title.append(_game)
				
				# Next line
				_index += 1
			
			_csv.close()
		
		if settings["system"] == "BEE" and _id_prefix.empty():
			_id_prefix = "hac::"
	
	# Alert other nodes
	emit_signal("games_imported")
func change_system(system_id: String) -> void:
	debug_log("Changing systems ("+settings["system"]+" -> "+system_id+")")
	
	# Save current game and system
	user_data_game(true)
	user_data_system(true)
	
	# Select new system
	settings["system"] = system_id
	
	# Import games
	import_games()
	
	# Load newly selected system and game
	user_data_system(false)
	user_data_game(false)
	
	# Update UI information
	emit_signal("system_changed")
	emit_signal("game_changed")
	
	# Check status changes
	emit_signal("status_changed")
func user_data_system(save: bool = false) -> void:
	
	var _path: String = "user://platforms/"+ settings["system"].to_lower() + ".json"
	var _file = File.new()
	var _copy: Dictionary
	var _error: int
	
	if save:
		
		# Copy fields with values different from default
		for i in data_system:
			
			if data_system[i] is Dictionary:
				_copy[i] = data_system[i].duplicate(true)
			elif data_system[i] != default_system[i]:
				_copy[i] = data_system[i]
		
		# Create directory
		var _directory: = Directory.new()
		_error = _directory.open("user://")
		debug_log("Opening directory /: "+str(_error))
		if _error == OK:
			_error = _directory.make_dir("platforms")
			debug_log("Making directory /platforms: "+str(_error))
		
		# Save to JSON file
		_error = _file.open(_path, File.WRITE)
		debug_log("Writing file "+_path+": "+str(_error))
		if _error == OK:
			_file.store_string(var2str(_copy))
			_file.close()
		
	else:
		
		# Reset system dictioanry to default
		data_system.clear()
		data_system = default_system.duplicate(true)
		
		# Read dictionary from JSON file
		_error = _file.open(_path, File.READ)
		debug_log("Reading file "+_path+": "+str(_error))
		if _error == OK:
			_copy = str2var(_file.get_as_text())
			_file.close()
		
		# Load existing fields
		for i in _copy:
			
			if data_system.has(i):
				data_system[i] = _copy[i]
func user_data_game(save: bool = false) -> void:
	
	var _game_id: String = data_system["game"]
	var _copy: Dictionary
	
	if save:
		
		# Remove previosuly saved data
		data_system["library"].erase(_game_id)
		
		# Copy keys with values different from default
		for i in data_game:
			
			if data_game[i] != default_game[i]:
				_copy[i] = data_game[i]
		
		# Save to system dictionary if there is anything set
		if _copy.size() > 0:
			data_system["library"][_game_id] = _copy
		
	else:
		
		# Reset game dictioanry to default
		data_game.clear()
		data_game = default_game.duplicate(true)
		
		# Read from system dictionary
		_copy = data_system["library"].get(_game_id, {})
		
		# Load necessary existing keys
		for i in _copy:
			
			if data_game.has(i):
				data_game[i] = _copy[i]
func get_game_info(game_id: String) -> Dictionary:
	
	var _result: Dictionary = { "id": game_id }
	
	# Search for ID inside database
	for i in games_title.size():
			
		if games_title[i].get("id") == game_id:
			
			# Copy all information about current game
			_result = games_title[i]
			break
	
	return _result
func get_game_title(game_info: Dictionary, region: String) -> String:
	
	var _result: String = ""
	
	if game_info.size() > 0:
		
		# Get display title for current region
		if game_info.has(region.to_lower() + "_title"):
			_result = game_info.get(region.to_lower() + "_title", "")
		else:
			
			# Fallback to other regions
			for e in ["US", "EU", "JP"]:
				
				# Key for this region
				var _r: String = e.to_lower() + "_title"
				
				# From right to left (US <- EU <- JP)
				if game_info.has(_r) and game_info.get(_r) != "":
					_result = game_info.get(_r, "")
					break
	
	return _result
func get_game_current_icon() -> String:
	
	# Import information about selected game
	var _info: Dictionary = get_game_info(data_system["game"])
	
	# Find selected region
	var _region: String = data_game["region"]
	if data_game["region"].empty():
		_region = data_system["region"]
	
	# Find icon
	var _result: String = ""
	if _info.size() > 0:
		
		# Get icon for current region
		if _info.has(_region.to_lower() + "_client"):
			_result = _info["id"]+"."+_region.to_lower()
		else:
			
			# Fallback to other regions
			for e in ["US", "EU", "JP"]:
				
				# Key for this region
				var _r: String = e.to_lower() + "_client"
				
				# From right to left (US <- EU <- JP)
				if _info.has(_r) and _info.get(_r) != "":
					_result = _info["id"]+"."+e.to_lower()
					break
	
	if not _result.empty() and _result != "default":
		var _real_id: String = _result.trim_prefix("hac::") if settings["system"] == "BEE" else _result
		var _real_system: String = "hac" if settings["system"] == "BEE" and _result.begins_with("hac::") else settings["system"].to_lower()
		return metadata["dlc"][_real_system+"_assets"] + _real_id + ".jpg"
	else:
		return "default"
func discord_connect() -> void:
	
	# Alert other nodes about connection status
	if not discord_autopush:
		emit_signal("discord_connecting")
	
	debug_log("Establishing connection to Discord... (Autopush: "+str(discord_autopush)+")")
	
	discord_connecting = true
	discord_api.establish_connection(discord_client)
func set_timer() -> void:
	
	if status_running:
		
		if settings["timer"] > 0:
			if status_timer.paused:
				status_timer.start(settings["timer"]-1)
				status_timer.paused = true
			else:
				status_timer.start(settings["timer"])
			debug_log("[status_timer] Started")
		else:
			status_timer.stop()
			debug_log("[status_timer] Stopped")
		
		emit_signal("timer_changed", status_timer.time_left)
		debug_log("[status_timer] Time left: "+str(status_timer.time_left))
	else:
		emit_signal("timer_changed", settings["timer"])
		debug_log("[status_timer] Changed to "+str(settings["timer"]))
func update_screensaver() -> void:
	OS.keep_screen_on = settings["keep_on"] and settings["activity"] and discord_connected and status_running

func activity_change() -> void:
	# Select new client
	var new_client := int(metadata["dlc"][settings["system"].to_lower()+"_client"])
	if discord_client != new_client:
		
		# Change client
		discord_client = new_client
		
		# Push after connection is established
		discord_autopush = true
		
		# Disconnect from current client
		if discord_connected:
			discord_api.shutdown()
		
		# Establish new connection
		discord_connect()
	else:
		activity_push()
func activity_push() -> void:
	
	discord_autopush = false
	
	# Game icon
	var _game_icon: String = get_game_current_icon()
	
	# Game title
	var _title: String = ""
	if game_verified:
		
		if not data_game["rename"].empty():
			_title = data_game["rename"]
		else:
			
			# Select region
			var _region: String = data_game["region"]
			if _region.empty():
				_region = data_system["region"]
			
			# Get title for current game
			var _info: Dictionary = get_game_info(data_system["game"])
			_title = get_game_title(_info, _region)
	else:
		_title = data_system["game"]
		
	# Add minimum amount of characters
	if not _title.empty() and _title.length() < 2:
		_title = _title+"  "
	
	# Description
	var _description: String = data_game["description"]
	var _description_fixed: String = ""
	var _whitespaces_only: bool = true
	for i in _description:
		
		# Clear description if it is only composed of whitespaces
		if i != " ":
			_whitespaces_only = false
			break
	
	if _whitespaces_only:
		_description = ""
		
	# Add minimum amount of characters
	if not _description.empty() and _description.length() < 2:
		_description_fixed = _description+"  "
	else:
		_description_fixed = _description
	
	# Tag
	var _tag: String = ""
	if settings["system"] == "WUP":
		
		if not data_system["tag_id"].empty():
			_tag = "ID: "+data_system["tag_id"]
	else:
		
		if (data_system["tag_fc"][0]+data_system["tag_fc"][1]+data_system["tag_fc"][2]).length() >= 12:
			
			var _fc: String = data_system["tag_fc"][0]+"-"+data_system["tag_fc"][1]+"-"+data_system["tag_fc"][2]
			if settings["system"] == "HAC" or settings["system"] == "BEE":
				_tag = "SW-"+_fc
			else:
				_tag = "FC: "+_fc
	
	# Elapsed timestamp
	if(
		previous_system != settings["system"] or
		( previous_game != data_system["game"] and not data_system["time_preserve"] )
	):
		timestamp = OS.get_unix_time()
	previous_game = data_system["game"]
	previous_system = settings["system"]
	
	# Save status changes for later comparison
	status_current = data_game.hash() + data_system.hash()
	
	# Make a new activity
	discord_rpc = RichPresence.new()
	
	discord_rpc.start_timestamp = timestamp
	
	# Apply information to activity
	if data_system["minimal_status"]:
		
		discord_rpc.small_image_key = _game_icon
		discord_rpc.details = _title
		
		if not _description.empty():
			discord_rpc.small_image_text = _description_fixed
		else:
			
			if data_system["tag"] and not _tag.empty():
				discord_rpc.small_image_text = _tag
	else:
		
		discord_rpc.large_image_text = "Rich Presence U"
		discord_rpc.large_image_key = _game_icon
		discord_rpc.details = _title
		discord_rpc.state = _description_fixed
		
		if data_system["tag"] and not _tag.empty():
			
			if data_system["tag_icon"] or not _description.empty():
				discord_rpc.small_image_text = _tag
				discord_rpc.small_image_key = "id"
			else:
				discord_rpc.state = _tag
		
		if data_game["party"]:
			
			if discord_rpc.state == "":
				discord_rpc.state = "  "
			discord_rpc.party_max = int(data_game["party_max"])
			discord_rpc.party_size = int(data_game["party_size"])
	
	
	# Push new activity
	if settings["activity"]:
		discord_api.get_module("RichPresence").update_presence(discord_rpc)
		debug_log("Pushing Discord activity: "+str(discord_rpc))

	emit_signal("status_changed")
	update_screensaver()
	
	# Set the status as running
	if not status_running:
		
		status_running = true
		
		# Start timer for the first time
		debug_log("[status_timer] Initializing...")
		set_timer()
	else:
		# Resume timer
		if status_timer.paused:
			status_timer.paused = false
		
	
	var _entry: int = 0
	
	# Game history
	if not data_system["game"].empty():
		
		# Remove existing entry from history
		_entry = data_system["history"].find(data_system["game"], 0)
		if _entry > -1:
			data_system["history"].remove(_entry)
		
		# Add entry to the history
		data_system["history"].append(data_system["game"])
		
		# Remove last entry
		if data_system["history"].size() > 8:
			data_system["history"].pop_front()
	
	# Description history
	if not _description.empty():
		
		# Remove existing entry from history
		_entry = data_game["history"].find(_description, 0)
		if _entry > -1:
			data_game["history"].remove(_entry)
		
		# Add entry to the history
		data_game["history"].append(_description)
		
		# Remove last entry
		if data_game["history"].size() > 8:
			data_game["history"].pop_front()
	
	emit_signal("history_changed")
func activity_toggle() -> void:
	
	# Push new activity
	if settings["activity"]:
		discord_api.get_module("RichPresence").update_presence(discord_rpc)
		debug_log("Toggling Discord activity: "+str(discord_rpc))
	else:
		discord_api.get_module("RichPresence").update_presence(-1)
		debug_log("Toggling Discord activity: -1")
	update_screensaver()
func clear_data(temporary_data_only: bool) -> void:
	
	if temporary_data_only:
		
		# Remove temporary files
		remove_recursive("user://cache")
		
		# Refresh metadata
		emit_signal("dialog_added", "res://code/ui/components/updater.tscn")
		
	else:
		
		clearing_data = true
		
		# Remove all files
		remove_recursive("user://")
		
		# Quit application
		get_tree().quit()
func remove_recursive(path) -> void:
	
	var _directory = Directory.new()
	var _error = _directory.open(path)
	
	debug_log("Opening directory "+path+": "+str(_error))
	
	# Open directory
	if _error == OK:
		
		# List directory content
		_error = _directory.list_dir_begin(true)
		
		debug_log("Starting to list directory content: "+str(_error))
		
		# Look for all content listed
		var _filename = _directory.get_next()
		
		debug_log("Found content: "+_filename)
		
		while _filename != "":
			
			# Remove sub-directory or file
			if _directory.current_is_dir():
				remove_recursive(path + "/" + _filename)
			else:
				_error = _directory.remove(_filename)
				
				debug_log("Removing directory content '"+path+"': "+str(_error))
			
			# Next file
			_filename = _directory.get_next()
		
		# Remove current path
		_error = _directory.remove(path)
		
		debug_log("Removing directory: "+str(_error))
func debug_export() -> void:
	
	# Save debug log
	var _file = File.new()
	if _file.open("user://debug.log", File.WRITE) == OK:
		
		var _d: = OS.get_datetime()
		var _date: String = str(_d["year"])+"/"+str(_d["month"])+"/"+str(_d["day"])+" "+str(_d["hour"])+":"+str(_d["minute"])+":"+str(_d["second"])
		
		# Header
		_file.store_line("Rich Presence U - "+VERSION+" ("+str(BUILD)+")")
		_file.store_line(OS.get_name()+", "+OS.get_locale()+", Process: "+str(OS.get_process_id()))
		_file.store_line(str(_date))
		_file.store_line("")
		
		# Store log
		for i in logger.size():
			_file.store_line(logger[i])
		
		_file.close()
	
	# Make a copy to the executable directory
	if not OS.has_feature("AppImage") and not OS.has_feature("editor"):
		var _binary_path: String = OS.get_executable_path().get_base_dir()
		var _dir: = Directory.new()
		if _dir.open(_binary_path) == OK:
			_dir.copy("user://debug.log", _binary_path+"/debug.log")
func debug_log(message: String) -> void:
	
	var _t = OS.get_time()
	var _log: String = "["+str(_t["hour"])+":"+str(_t["minute"])+":"+str(_t["second"])+"] "+str(message)
	logger.append(_log)
	print(_log)

# Signals
func _on_Language_changed(new_lang: String) -> void:
	
	# Automatically get system language
	if new_lang.empty():
		new_lang = OS.get_locale_language()
	
	# Check if translation for selected language is available
	var _has_translations: bool = false
	for i in TranslationServer.get_loaded_locales():
		
		if i == new_lang:
			
			_has_translations = true
			break
	
	# Use default language if necessary
	if not _has_translations:
		new_lang = "en"
	
	TranslationServer.set_locale(new_lang)
func _on_Scaling_changed(new_scaling: float) -> void:
	
	# Minimal window size
	var _minimal: float = new_scaling if new_scaling < 1.0 else 1.0
	OS.min_window_size = Vector2.ONE * (512 * _minimal)
	
	# UI scale
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, 
			SceneTree.STRETCH_ASPECT_IGNORE, Vector2.ONE * 512, new_scaling)
func _on_Timer_timeout() -> void:
	debug_log("[status_timer] Timeout")
	status_timer.stop()
	emit_signal("timer_ended")
	emit_signal("timer_changed", 0)
	OS.request_attention()
	update_screensaver()
func _on_Metadata_download_completed(result, response_code, _headers, _body) -> void:
	
	debug_log("HTTP request completed: "+str(result)+" ("+str(response_code)+")")
	
	# Read downloaded metadata
	import_metadata()
	
	# Iterate through all children nodes
	for i in get_children():
		
		if i is HTTPRequest:
			
			# Remove inactive requests
			if i.get_http_client_status() == HTTPClient.STATUS_DISCONNECTED:
				i.queue_free()
func _on_Discord_connected(user: Dictionary) -> void:
	
	debug_log("Connection established with Discord: "+str(user))
	
	# Remember connection status
	discord_connected = true
	discord_connecting = false
	
	# Alert other nodes about connection status
	if not discord_autopush:
		emit_signal("discord_connected", user)
	else:
		
		# Apply delayed push
		activity_push()
func _on_Discord_disconnected() -> void:
	
	if discord_connected:
		debug_log("Disconnected from Discord")
	else:
		debug_log("Unable to establish connection to Discord")
	
	# Remember connection status
	discord_connected = false
	discord_connecting = false
	
	# Pause timer
	if status_running and not status_timer.paused:
		status_timer.paused = true
	
	# Alert other nodes about connection status
	if not discord_autopush:
		emit_signal("discord_disconnected")
		emit_signal("dialog_added", "res://code/ui/dialogs/popups/connection.tscn")
		OS.request_attention()
	
	update_screensaver()
