extends Node 

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 1910

var username
var password

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func ConnectToServer(_username,_password):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	username = _username
	password = _password
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded",self, "_OnConnectionSucceeded")
	
	network.create_client(ip,port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)


func _OnConnectionFailed():
	print("failed to connect to login server")
	print("pop-up server offline or something")
	get_node("../SceneHandler/test_level/GUI/LoginScreen").login_button.disabled = false


func _OnConnectionSucceeded():
	print("Succesfully logged into server")
	RequestLogin()


func RequestLogin():
	print("Requesting login")
	rpc_id(1, "LoginRequest", username, password)
	username = ""
	password = ""


remote func ReturnLoginRequest(results,token):
	print("result recieved")
	if results == true:
		GameServer.token = token
		GameServer.ConnectToServer()
	else:
		print("please provide correct username and password")
		get_node("../SceneHandler/Map/GUI/LoginScreen").login_button.disabled = false
	network.disconnect("connection_failed", self, "_OnConnectionFailed")
	network.disconnect("connection_succeeded",self, "_OnConnectionSucceeded")
	pass
