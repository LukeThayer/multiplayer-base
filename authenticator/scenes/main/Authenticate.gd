extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1911
var max_servers= 5

func _ready():
	StartServer()
	

func StartServer():
	network.create_server(port,max_servers)
	get_tree().set_network_peer(network)
	print("authentication server started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	pass


func _Peer_Connected(gateway_id):
	print("Gateway" + str(gateway_id) + "Connected")
	pass

func _Peer_Disconnected(gateway_id):
	print("Gateway" + str(gateway_id) + "Disconnected")
	
	pass


remote func AuthenticatePlayer(username, password, player_id):
	print("authenication request received")
	var token
	var gateway_id = get_tree().get_rpc_sender_id()
	var result
	print("starting authentication")
	if not PlayerData.PlayerIDs.has(username):
		print("user not recognized")
		result = false
	elif not PlayerData.PlayerIDs[username].Password == password:
		print("incorrect password")
		result = false
	else:
		print("succesful authentication")
		result = true
		
		randomize()
		var random_number = randi()
		var hashed = str(random_number).sha256_text()
		var timestamp = str(OS.get_unix_time())
		token = hashed + timestamp
		var gameserver = "gameserver1"
		GameServers.DistributeLoginToken(token,gameserver)
		
	print("authentication result sent to gateway server")
	rpc_id(gateway_id,"AuthenticationResults", result, player_id, token)
	pass
