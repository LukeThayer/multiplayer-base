extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100

var player_state_collection = {}

var expected_tokens = []

onready var player_verification_process = get_node("PlayerVerification")
onready var combat_functions = get_node("Combat")

func _ready():
	StartServer()

func StartServer():
	network.create_server(port,max_players)
	get_tree().set_network_peer(network)
	print("server started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	pass

remote func FetchServerTime(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnServerTime", OS.get_system_time_msecs(), client_time)

remote func DetermineLatency(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnLatency", client_time)

func _Peer_Connected(player_id):
	print("User" + str(player_id) + "Connected")
	player_verification_process.start(player_id)
	pass

func _Peer_Disconnected(player_id):
	print("User" + str(player_id) + "Disconnected")
	
	if has_node(str(player_id)):
		get_node(str(player_id)).queue_free()
		rpc_id(0,"DespawnPlayer", player_id)
		player_state_collection.erase(player_id)
	
	
	
	pass

remote func FetchPlayerStats():
	var player_id = get_tree().get_rpc_sender_id()
	var player_stats = get_node(str(player_id)).player_stats
	rpc_id(player_id, "ReturnPlayerStats", player_stats)
	pass

remote func FetchSkillDamage(skillName, requester):
	var player_id = get_tree().get_rpc_sender_id()
	var damage =  combat_functions.FetchSkillDamage(skillName,player_id)
	rpc_id(player_id,"ReturnSkillDamage", damage, requester)

func _on_TokenExpiration_timeout():
	var current_time = OS.get_unix_time()
	var token_time
	if expected_tokens == []:
		pass
	
	for i in range(expected_tokens.size() -1, -1, -1):
		token_time = int(expected_tokens[i].right(64))
		if current_time - token_time >= 30:
			expected_tokens.remove(i)
	pass 

func FetchToken(player_id):
	rpc_id(player_id, "FetchToken")

remote func ReturnToken(Token):
	var player_id = get_tree().get_rpc_sender_id()
	player_verification_process.Verify(player_id,Token)
	pass

func ReturnTokenVerificationResults(player_id, result):
	rpc_id(player_id,"ReturnTokenVerificationResults", result)
	
	if result == true:
		rpc_id(0,"SpawnNewPlayer", player_id, Vector2(0,0))

remote func ReceivePlayerState(player_state):
	var player_id = get_tree().get_rpc_sender_id()
	if player_state.has(player_id):
		if player_state_collection[player_id]["T"] < player_state["T"]:
			player_state_collection[player_id]  = player_state
	else:
		player_state_collection[player_id] = player_state

func SendWorldState(world_state):
	rpc_unreliable_id(0, "ReceiveWorldState", world_state)
	pass

remote func SendNPCHit(enemy_id,damage):
	get_node("Map").NPCHit(enemy_id,damage)

remote func Attack(position, facing,spawn_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(0,"ReceiveAttack",position, facing, spawn_time,player_id)
