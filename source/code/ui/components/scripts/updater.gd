extends TextureRect

var queue: Array
var queue_position: int = -1
var database: Dictionary

onready var node_label = get_node("Margin/Box/Label")
onready var node_progress = get_node("Margin/Box/Progress")
onready var node_progress_tween = get_node("Margin/Box/Progress/Tween")

func _ready() -> void:
	
	# Change theme
	var new_theme: String = Main.settings["ui_theme"]
	
	texture = load("res://assets/ui/themes/"+new_theme+"/background.png")
	
	get_node("Margin/Box/Room").texture = load("res://assets/ui/themes/"+new_theme+"/monita_room.png")
	get_node("Margin/Box/Room/Shadow").texture = load("res://assets/ui/themes/"+new_theme+"/monita_shadow.png")
	
	var anim_tex: AnimatedTexture = get_node("Margin/Box/Room/Monita").texture
	for i in anim_tex.get_frames():
		anim_tex.set_frame_texture(i, load("res://assets/ui/themes/"+new_theme+"/monita_"+str(i+1)+".png"))
	
	var _directory: = Directory.new()
	if not _directory.file_exists("user://cache/metadata.cfg"):
		
		# Download metadata first
		Main.download_metadata()
		Main.connect("metadata_imported", self, "queue_download_start")
		
		# Progress bar
		node_label.set_text("REFRESHING_INIT")
		node_progress.value = 0
	else:
		queue_download_start()
	
	# Show animation
	$Tween.interpolate_property(self, "modulate:a", 0, 1.0, 0.75, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()

# Methods
func queue_download_start() -> void:
	
	# Create directories for downloads
	var _directory: = Directory.new()
	var _error: int = _directory.open("user://")
	Main.debug_log("Opening directory /: "+str(_error))
	if _error == OK:
		_error = _directory.make_dir_recursive("cache/titles")
		Main.debug_log("Making recursive directory /cache/titles: "+str(_error))
	
	# Fill download queue
	for i in ["WUP", "HAC", "CTR"]:
		
		queue.append({
				
				"url": Main.metadata["dlc"][i.to_lower()+"_titles"],
				"path": "user://cache/titles/"+i.to_lower()+".csv"
			})
	
	# Start download
	queue_download_next()
	
	# Progress bar
	node_label.set_text("REFRESHING_STEP_1")
	node_progress.value = 0
	node_progress.max_value = queue.size()-1

func queue_download_next() -> void:
	
	if queue_position < queue.size()-1:
		
		# Advance position in queue
		queue_position += 1
		
		# Create HTTP request
		var _request: = HTTPRequest.new()
		add_child(_request)
		_request.connect("request_completed", self, "_on_Queue_download_completed")
		
		# Get file from URL
		_request.set_download_file(queue[queue_position]["path"])
		var _error: int = _request.request(queue[queue_position]["url"])
		
		var _queue: String = str(queue_position+1)+"/"+str(queue.size())
		Main.debug_log("Starting HTTP request "+_queue+" ("+queue[queue_position]["url"]+"): "+str(_error))
		
		if ( float(queue_position) / queue.size() ) >= 0.70:
			node_label.set_text("REFRESHING_STEP_2")
		
	else:
		
		queue_position = -1
		node_label.set_text("REFRESHING_DONE")
		OS.request_attention()
		
		# Re-import games
		Main.import_games()
		
		# Save timestamp
		Main.settings["refresh_last"] = OS.get_unix_time()
		
		# Close
		$Tween.interpolate_property(self, "modulate:a", 1.0, 0, 0.75, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 1.0)
		$Tween.start()

# Signals
func _on_Queue_download_completed(result, response_code, _headers, _body) -> void:
	
	# Download result
	var _queue: String = str(queue_position+1)+"/"+str(queue.size())
	Main.debug_log("HTTP request completed "+_queue+": "+str(result)+" ("+str(response_code)+")")
	
	# Progress bar
	node_progress_tween.interpolate_property(node_progress, "value", node_progress.value, queue_position+1, 0.75, Tween.TRANS_EXPO, Tween. EASE_IN_OUT)
	node_progress_tween.start()
	
	# Next download
	queue_download_next()

func _on_Tween_all_completed() -> void:
	
	# Close
	if modulate.a <= 0:
		queue_free()
