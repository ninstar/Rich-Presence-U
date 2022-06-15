class_name DiscordRPC extends Node

# warning-ignore-all:unused_signal
# warning-ignore-all:return_value_discarded

# Emitted when successfully established connection to Discord RPC
# `user` is a `Dictionary` of this structure: https://discord.com/developers/docs/resources/user#user-object
signal rpc_ready(user)

# Emitted when successfully authorized Discord client with the current application
# `code` is the OAuth2 authorization code as a string
signal authorized(code)

# Emitted when successfully authenticated Discord client with the current application
# `application` a `Dictionary` of this structure: https://discord.com/developers/docs/resources/application#application-object
# `expires` ISO-8601 string representing the expiration date of OAuth2 token
signal authenticated(application, expires)

# emitted when a subscribed server's state changes
# reference: https://discord.com/developers/docs/topics/rpc#guildstatus
signal guild_status(id, name, icon_url)

# Emitted when a guild is created/joined on the client
# reference: https://discord.com/developers/docs/topics/rpc#guildcreate
signal guild_create(id, name)

# Emitted when a channel is created/joined on the client
# reference: https://discord.com/developers/docs/topics/rpc#channelcreate
signal channel_create(id, name, type)

# Emitted when the client joins a voice channel
# reference: https://discord.com/developers/docs/topics/rpc#voicechannelselect
signal voice_channel_select(channel_id, guild_id)

# Emitted when a user joins a subscribed voice channel
# reference: https://discord.com/developers/docs/topics/rpc#voicestatecreatevoicestateupdatevoicestatedelete
signal voice_state_create(voice_state)

# Emitted when a user's voice state changes in a subscribed voice channel (mute, volume, etc.)
# reference: https://discord.com/developers/docs/topics/rpc#voicestatecreatevoicestateupdatevoicestatedelete
signal voice_state_update(voice_state)

# Emitted when a user parts a subscribed voice channel
# reference: https://discord.com/developers/docs/topics/rpc#voicestatecreatevoicestateupdatevoicestatedelete
signal voice_state_delete(voice_state)

# Emitted when the client's voice settings update
# reference: https://discord.com/developers/docs/topics/rpc#voicesettingsupdate
signal voice_settings_update(voice_settings)

# Emitted when the client's voice connection status changes
# reference: https://discord.com/developers/docs/topics/rpc#voiceconnectionstatus
signal voice_connection_status(state, hostname, pings, average_ping, last_ping)

# Emitted when a user in a subscribed voice channel speaks
# reference: https://discord.com/developers/docs/topics/rpc#speakingstartspeakingstop
signal speaking_start(channel_id, user_id)

# Emitted when a user in a subscribed voice channel stops speaking
# reference: https://discord.com/developers/docs/topics/rpc#speakingstartspeakingstop
signal speaking_stop()

# Emitted when a message is created in a subscribed text channel
# reference: https://discord.com/developers/docs/topics/rpc#messagecreatemessageupdatemessagedelete
signal message_create(message)

# Emitted when a message is updated in a subscribed text channel
# reference: https://discord.com/developers/docs/topics/rpc#messagecreatemessageupdatemessagedelete
signal message_update(message)

# Emitted when a message is deleted in a subscribed text channel
# reference: https://discord.com/developers/docs/topics/rpc#messagecreatemessageupdatemessagedelete
signal message_delete(message)

# Emitted when the client receives a notification (mention or new message in eligible channels)
# This event requires the `rpc.notifications.read` OAuth2 scope
# reference: https://discord.com/developers/docs/topics/rpc#notificationcreate
signal notification_create(channel_id, message, icon_url, title, body)

# Emitted when the user clicks a Rich Presence join invite in chat to join a game
# reference: https://discord.com/developers/docs/topics/rpc#activityjoin
signal activity_join(secret)

# Emitted when the user clicks a Rich Presence spectate invite in chat to spectate a game
# reference: https://discord.com/developers/docs/topics/rpc#activityspectate
signal activity_spectate(secret)

# Emitted when the user receives a Rich Presence Ask to Join request
# reference: https://discord.com/developers/docs/topics/rpc#activityjoinrequest
signal activity_join_request(user)

signal raw_data(data)

# Emitted when Discord RPC connection is closed either manually or after Discord client closes
signal rpc_closed()

# Emitted when Discord RPC face a connection error
# possible errors are `ERR_UNCONFIGURED`, `DiscordRPC.ERR_UNSUPPORTED`, `DiscordRPC.ERR_HANDSHAKE` and `DiscordRPC.ERR_CLIENT_NOT_FOUND`
signal rpc_error(error)

# Connection states
enum {
	DISCONNECTED,
	CONNECTING,
	CONNECTED,
	DISCONNECTING
}

# Error codes
enum {
	ERR_UNSUPPORTED = 49,
	ERR_HANDSHAKE,
	ERR_CLIENT_NOT_FOUND
}

const PING_INTERVAL_MS: int = 5_000
const PING_TIMEOUT_MS: int = 10_000


# Discord RPC version
const VERSION: int = 1

const DISCORD_API_ENDPOINT: String = "https://discord.com/api/%s"

var _ipc: IPC setget __set
var _modules: Dictionary setget __set
var _next_ping: int setget __set
var _last_ping: int setget __set
var _sent_ping: bool setget __set
var _recieved_pong: bool setget __set
var _ping_nonce: String setget __set

# Current status of DiscordRPC instance
var status: int = DISCONNECTED setget __set

# Discord application id
var client_id: int setget __set

# Current authorized scopes
var scopes: PoolStringArray setget __set

func _init() -> void:
	_ipc = IPC.new()
	_ipc.connect("data_recieved", self, "_on_data")
	install_module(RichPresenceModule.new())

func _ready() -> void:
	set_process(false)

# Attempt to connect to a Discord client instance
# emits `rpc_ready` on success, otherwise `rpc_error`
func establish_connection(_client_id: int) -> void:
	if is_connected_to_client():
		push_error("This DiscordRPC instance is already in an active connection")
		return
	
	if not is_supported():
		push_error("DiscordRPC unsuported platform")
		emit_signal("rpc_error", ERR_UNSUPPORTED)
		return
	
	if not is_inside_tree():
		push_error("DiscordRPC isn't inside a scene tree")
		emit_signal("rpc_error", ERR_UNCONFIGURED)
		return
	
	client_id = _client_id
	status = CONNECTING
	set_process(true)
	for i in range(10):
		var path = IPC.get_pipe_path(i)
		if _ipc.open(path) == OK:
			_ipc.setup()
			_handshake()
			return
		self._ipc.close()
	set_process(false)
	emit_signal("rpc_error", ERR_CLIENT_NOT_FOUND)
	shutdown()

# Whether to connected to a Discord client or not
func is_connected_to_client() -> bool:
	return _ipc.is_open() and status != DISCONNECTED

# Used to authenticate a new client with your app
# By default this pops up a modal in-app that asks the user to authorize access to your app
# `scopes` a PoolSringArray of OAuth2 scopes: https://discord.com/developers/docs/topics/oauth2#shared-resources-oauth2-scopes
# `secret` OAuth2 client's sceret code
func authorize(_scopes: PoolStringArray, secret: String) -> void:
	if not is_connected_to_client():
		push_error("DiscordRPC can not authorize while not connected")
		return
		
	var request: IPCPayload = IPCUtil.AuthorizePayload.new(self.client_id, _scopes)
	var response: IPCPayload = yield(self._ipc.send(request), "completed")
	if not response.is_error():
		var code: String = response.data["code"]
		var auth_token: String = yield(self.get_auth_token(code, secret), "completed")
		if not auth_token.empty():
			emit_signal("authorized", auth_token)
			authenticate(auth_token)

# Used to authenticate an existing client with your app
func authenticate(access_token: String) -> void:
	if not is_connected_to_client():
		push_error("DiscordRPC can not authenticate while not connected")
		return
		
	var request: IPCPayload = IPCUtil.AuthenticatePayload.new(access_token)
	var response: IPCPayload = yield(self._ipc.send(request), "completed")
	if not response.is_error():
		scopes = response.data["scopes"]
		emit_signal("authenticated", response.data["application"], response.data["expires"])

func get_auth_token(authorize_code: String, secret: String, redirect_uri: String = "http://127.0.0.1") -> String:
	var http_request: HTTPRequest = HTTPRequest.new()
	http_request.use_threads = OS.can_use_threads()
	var url: String = DISCORD_API_ENDPOINT % "oauth2/token"
	var headers: PoolStringArray = ["Content-Type: application/x-www-form-urlencoded"]
	var data: Dictionary = {
		client_id = self.client_id,
		client_secret = secret,
		grant_type = "authorization_code",
		code = authorize_code,
		redirect_uri = redirect_uri
	}
	
	self.add_child(http_request)
	http_request.request(
		url,
		headers,
		true,
		HTTPClient.METHOD_POST,
		URLUtil.dict_to_url_encoded(data)
	)
	var response: Array = yield(http_request, "request_completed")
	var _result: int = response[0]
	var _code: int = response[1]
	var body: PoolByteArray = response[3]
	
	http_request.queue_free()

	return parse_json(body.get_string_from_utf8()).get("access_token", "")

# Used to subscribe to events in order for some signals to be emitted
# `event` is the event name to subscribe to in UPPER_CASE
# `arguments` a Dictionary of name|value pair of arguments needed by certain events
# reference: https://discord.com/developers/docs/topics/rpc#subscribe
func subscribe(event: String, arguments: Dictionary = {}) -> void:
	self._ipc.send(IPCUtil.SubscribePayload.new(event, arguments))

# Used to unsubscribe from events
# `event` is the event name that was subscribe to in UPPER_CASE
# `arguments` a Dictionary of name|value pair of arguments of the previously subscribed event
func unsubscribe(event: String, arguments: Dictionary = {}) -> void:
	self._ipc.send(IPCUtil.UnsubscribePayload.new(event, arguments))

# Closes the current connection to the discord client
func shutdown() -> void:
	if status != DISCONNECTED:
		set_process(false)
		status = DISCONNECTING
		_ipc.close()
		status = DISCONNECTED
		_next_ping = 0
		_last_ping = 0
		_sent_ping = false
		_recieved_pong = false
		_ping_nonce = ""
		client_id = 0
		scopes = []
		emit_signal("rpc_closed")

func install_module(module: IPCModule) -> void:
	if not _modules.has(module.name):
		module.initilize(self._ipc)
		_modules[module.name] = module

func get_module(name: String) -> IPCModule:
	return self._modules.get(name)

func uninstall_module(name: String) -> void:
	self._modules.erase(name)

func ipc_call(function: String, arguments: Array = []):
	for module in self._modules.values():
		if (function in module.get_functions()):
			return module.callv(function, arguments)
	push_error("Calling non-existant function \"%s\" via ipc_call" % function)
	return null

func _handshake() -> void:
	if self.status == CONNECTED:
		push_error("Already sent a handshake !")
		return
		
	var request: IPCPayload = IPCUtil.HandshakePayload.new(VERSION, self.client_id)
	var response: IPCPayload = yield(self._ipc.send(request), "completed")
	if response.op_code != IPCPayload.OpCodes.CLOSE and not response.is_error():
		status = CONNECTED
		_next_ping = OS.get_ticks_msec() + PING_INTERVAL_MS
		emit_signal("rpc_ready", response.data["user"])
		return
	emit_signal("rpc_error", ERR_HANDSHAKE)
	shutdown()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			shutdown()

func _process(_delta: float) -> void:
	_ipc.poll()
	if not _ipc.is_open():
		shutdown()
		return
	
	if status != CONNECTED:
		return
	
	var current_ticks: int = OS.get_ticks_msec()
	if not _sent_ping and _next_ping <= current_ticks:
		var payload: IPCPayload = IPCPayload.new()
		payload.op_code = IPCPayload.OpCodes.PING
		_ping_nonce = payload.nonce
		_ipc.send(payload)
		_sent_ping = true
		_last_ping = current_ticks
	
	elif _sent_ping:
		if not _recieved_pong and _last_ping + PING_TIMEOUT_MS <= current_ticks:
			shutdown()
		elif _recieved_pong:
			_sent_ping = false
			_recieved_pong = false
			_next_ping = current_ticks + PING_INTERVAL_MS

func _on_data(payload: IPCPayload) -> void:
	if payload.is_error():
		push_error("IPC: Recieved error code: %d: %s" % [payload.get_error_code(), payload.get_error_messsage()])
	
	emit_signal("raw_data", payload)
	
	match payload.op_code:
		IPCPayload.OpCodes.CLOSE:
			shutdown()
		IPCPayload.OpCodes.PING:
			var reply: IPCPayload = IPCPayload.new()
			reply.op_code = IPCPayload.OpCodes.PONG
			_ipc.send(reply)
		IPCPayload.OpCodes.PONG:
			_recieved_pong = payload.nonce == _ping_nonce
	
	var signal_name = payload.event.to_lower()
	if payload.command == DiscordRPCUtil.Commands.DISPATCH and has_signal(signal_name):
		callv("emit_signal", [signal_name] + payload.data.values())


func _to_string() -> String:
	return "[DiscordRPC:%d]" % self.get_instance_id()

func __set(_value) -> void:
	pass

static func is_supported() -> bool:
	return not IPC.get_pipe() == null
