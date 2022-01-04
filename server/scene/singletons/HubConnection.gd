extends Node

var network = NetworkedMultiplayerENet.new()
var serverhub_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 1912

onready var gameserver = get_node("/root/GameServer")

func _ready():
	ConnectToServer()
	pass 

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func ConnectToServer():
	network.create_client(ip,port)
	set_custom_multiplayer(serverhub_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_failed",self, "_OnConnectionFailed")
	network.connect("connection_succeeded",self, "_OnConnectionSucceeded")

func _OnConnectionFailed():
	print("failed to connect to server hub")


func _OnConnectionSucceeded():
	print("connected to server hub")

remote func ReceiveLoginToken(token):
	gameserver.expected_tokens.append(token)


