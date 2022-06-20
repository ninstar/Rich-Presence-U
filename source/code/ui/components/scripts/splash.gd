extends ColorRect

func _ready() -> void:
	
	# Connect signals
	Main.connect("metadata_imported", self, "_on_Metadata_imported")
	
	# Splash
	visible = true

# Signals
func _on_Metadata_imported() -> void:
	
	# Animation
	var _rng = RandomNumberGenerator.new()
	_rng.randomize()
	var _anim: Array = [
		["anchor_top", 0, 1.0],
		["anchor_left", 0, 1.0],
		["anchor_bottom", 1.0, 0],
		["anchor_right", 1.0, 0]
	]
	var _i: int = _rng.randi() % ( _anim.size()-1 )
	
	# Panel slide (random direction)
	$Tween.interpolate_property(self, _anim[_i][0], _anim[_i][1], _anim[_i][2], 1.0,
			Tween.TRANS_EXPO, Tween.EASE_IN_OUT, 1.0)
	$Tween.start()
	
	# Logo fade-out
	$Logo/Tween.interpolate_property($Logo, "modulate:a", 1.0, 0, 0.25,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.5)
	$Logo/TweenS.interpolate_property($Logo, "rect_scale", Vector2.ONE,
			Vector2.ONE * 0.85, 0.5, Tween.TRANS_BACK, Tween.EASE_IN, 0.25)
	$Logo/Tween.start()
	$Logo/TweenS.start()
	
	# Enable interaction
	mouse_filter = MOUSE_FILTER_IGNORE

func _on_Tween_all_completed() -> void:
	queue_free()

func _on_Tween_tween_started(_object: Object, _key: NodePath) -> void:
	
	# Check last refresh
	if( 
		Main.settings["refresh"] != -1 and 
		OS.get_unix_time()-Main.settings["refresh_last"] > Main.settings["refresh"]
	):
		Main.emit_signal("dialog_added", "res://code/ui/components/updater.tscn")
