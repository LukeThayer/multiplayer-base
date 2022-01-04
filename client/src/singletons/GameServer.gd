extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909

var token

var decimal_collector : float = 0
var latency_array = []
var latency = 0
var client_clock = 0
var delta_latency = 0

func _ready():
	#ConnectToServer()
	pass 

func _physics_process(delta):
	client_clock += int(delta*1000) + delta_latency
	delta_latency = 0
	decimal_collector += (delta*1000) - int(delta*1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00

func ConnectToServer():
	network.create_client(ip,port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed",self, "_OnConnectionFailed")
	network.connect("connection_succeeded",self, "_OnConnectionSucceeded")

func _OnConnectionFailed():
	print("connection failed")

func _OnConnectionSucceeded():
	print("connection succeeded")
	rpc_id(1,"FetchServerTime",OS.get_system_time_msecs())
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout",self, "DetermineLatency")
	self.add_child(timer)

remote func ReturnServerTime(server_time, client_time):
	latency = (OS.get_system_time_msecs() - client_time)/2
	client_clock = server_time + latency

func DetermineLatency():
	rpc_id(1, "DetermineLatency", OS.get_system_time_msecs())

remote func ReturnLatency(client_time):
	latency_array.append((OS.get_system_time_msecs() - client_time)/2)
	if latency_array.size() == 9:
		var total_latency = 0 
		latency_array.sort()
		var mid_point = latency_array[4]
		for i in range(latency_array.size()-1,-1,-1):
			if latency_array[i] > (2*mid_point) and latency_array[i] > 20:
				latency_array.remove(i)
			else:
				total_latency += latency_array[i]
		delta_latency = (total_latency / latency_array.size()) - latency
		latency = total_latency / latency_array.size()
		latency_array.clear()

func FetchPlayerStats():
	rpc_id(1,"FetchPlayerStats")

remote func ReturnPlayerStats(stats):
	get_node("/root/SceneHandler/Map/GUI/AttributeMenu").LoadPlayerStats(stats)

func FetchSkillDamage(skillname, requestor):
	rpc_id(1, "FetchSkillDamage",skillname, requestor)

remote func ReturnSkillDamage(_dmg,requestor):
	instance_from_id(requestor).set_DMG(_dmg)

remote func ReturnTokenVerificationResults(result):
	if result == true:
		get_node("../SceneHandler/Map/GUI/LoginScreen").queue_free()
		get_node("../SceneHandler/Map/YSort/player").set_physics_process(true)
		print("token Verified")
	else:
		print("login failed")
		get_node("../SceneHandler/Map/GUI/LoginScreen").login_button.disable = false
		FetchPlayerStats()
	pass

remote func FetchToken():
	rpc_id(1, "ReturnToken", token)

remote func SpawnNewPlayer(player_id, spawn_position):
	get_node("../SceneHandler/Map").SpawnNewPlayer(player_id,spawn_position)
	pass

remote func DespawnPlayer(player_id):
	get_node("../SceneHandler/Map").DespawnPlayer(player_id)
	pass

func SendPlayerState(player_stats):
	rpc_unreliable_id(1,"ReceivePlayerState",player_stats)

remote func ReceiveWorldState(world_state):
	get_node("../SceneHandler/Map").UpdateWorldState(world_state)

func NPCHit(enemy_id,damage):
	rpc_id(1,"SendNPCHit",enemy_id,damage)

func SendAttack(position,facing):
	rpc_id(1, "Attack", position, facing, client_clock)

remote func ReceiveAttack(position, facing, spawn_time, player_id):
	if player_id ==  get_tree().get_network_unique_id():
		pass
	else:
		get_node("../SceneHandler/Map/YSort/otherPlayers/" + str(player_id)).attack_dict[spawn_time] = {"Position" : position, "Facing" : facing}
