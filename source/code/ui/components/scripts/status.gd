extends HBoxContainer

onready var node_avatar: = get_node("Picture")
onready var node_name: = get_node("Text/Name")
onready var node_status: = get_node("Text/Connnection")

func _ready() -> void:
	
	# Connect signals
	Main.connect("discord_connected", self, "_on_Discord_connect")
	Main.connect("discord_disconnected", self, "_on_Discord_disconnect")
	
	# Locale keys
	node_status.set_text("USER_DISCONNECTED")

# Sginals
func _on_Discord_connect(user: Dictionary) -> void:
	
	if user["username"] == "disconnected":
		
		# Disconnected
		node_avatar.modulate.a = 0.75
		node_status.set_text("USER_DISCONNECTED")
		
	else:
		
		# Display username
		node_name.text = user["username"]
		node_name.visible = true
		
		# Connected
		node_avatar.modulate.a = 1.0
		node_status.set_text("USER_CONNECTED")
		
		# Download avatar
		$HTTP.request("https://cdn.discordapp.com/avatars/"+user["id"]+"/"+user["avatar"]+".jpeg?size=128")
		$Picture/Loading/Animation.play("Loop")

func _on_Discord_disconnect() -> void:
	
	# Disconnected
	node_avatar.modulate.a = 0.75
	node_status.set_text("USER_DISCONNECTED")

func _on_HTTP_request_completed(_result: int, _response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	
	$Picture/Loading/Animation.play("RESET")
	
	# Create image from data
	var _image = Image.new()
	var _error = _image.load_jpg_from_buffer(body)
	
	# User default avatar
	if _error != OK:
		node_avatar.texture = preload("res://assets/ui/avatar.svg")
	else:
		
		# Load image as a texture
		var _texture = ImageTexture.new()
		_texture.create_from_image(_image)
		
		# Set texture as avatar
		node_avatar.texture = _texture
