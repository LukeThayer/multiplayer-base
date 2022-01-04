extends Node

var network = NetworkedMultiplayerENet.new()
var serverhub_api = MultiplayerAPI.new()
var port = 1912
var max_players = 100

var gameserverlist = {}

func _ready():
	StartServer()

func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func StartServer():
	network.create_server(port, max_players)
	set_custom_multiplayer(serverhub_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("GameServerHub Started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")

func _Peer_Connected(gameserver_id):
	print("Game Server" + str(gameserver_id) + "connected")
	
	gameserverlist["gameserver1"] = gameserver_id
	print(gameserverlist)

func _Peer_Disconnected(gameserver_id):
	print("Game Server" + str(gameserver_id) + "disconnected")
	

func DistributeLoginToken(token, gameserver):
	print(gameserverlist)
	var gameserver_peer_id = gameserverlist[gameserver]
	rpc_id(gameserver_peer_id, "ReceiveLoginToken", token)
	
	pass
