extends Node2D

var player_spawn = preload("res://src/actors/playerTemplate.tscn")
var enemy_spawn = preload("res://src/actors/dummy.tscn")

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100


func SpawnNewPlayer(player_id,spawn_position):
	if get_tree().get_network_unique_id() == player_id:
		pass
	else:
		if not get_node("YSort/otherPlayers").has_node(str(player_id)):
			var new_player = player_spawn.instance()
			new_player.position = spawn_position
			new_player.name = str(player_id)
			get_node("YSort/otherPlayers").add_child(new_player)

func DespawnPlayer(player_id):
	var to_delete = get_node("YSort/otherPlayers/"+str(player_id))
	to_delete.despawn()

func UpdateWorldState(world_state):
	if world_state["T"] >  last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)

func _physics_process(delta):
	var render_time = GameServer.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]["T"])/float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
			for player in world_state_buffer[2].keys():
				if str(player) == "T":
					continue
				if str(player) == "Enemies":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if not world_state_buffer[1].has(player):
					continue
				if get_node("YSort/otherPlayers").has_node(str(player)):
					var new_position = lerp(world_state_buffer[1][player]["P"],world_state_buffer[2][player]["P"], interpolation_factor)
					var animation = world_state_buffer[2][player]["A"]
					var facing = world_state_buffer[2][player]["F"]
					get_node("YSort/otherPlayers/" + str(player)).UpdatePlayer(new_position,animation,facing)
				else:
					SpawnNewPlayer(player,world_state_buffer[2][player]["P"])
			for enemy in world_state_buffer[2]["Enemies"].keys():
				if not world_state_buffer[1]["Enemies"].has(enemy):
					continue
				if get_node("YSort/enemies").has_node(str(enemy)):
					var new_position = lerp(world_state_buffer[1]["Enemies"][enemy]["EnemyLocation"],world_state_buffer[2]["Enemies"][enemy]["EnemyLocation"], interpolation_factor)
					get_node("YSort/enemies/"+str(enemy)).MoveEnemy(new_position)
					get_node("YSort/enemies/"+str(enemy)).Health(world_state_buffer[1]["Enemies"][enemy]["EnemyHealth"])
				else:
					SpawnNewEnemy(enemy,world_state_buffer[2]["Enemies"][enemy])
		elif render_time > world_state_buffer[1].T:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"])/float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]-1.00)
			for player in world_state_buffer[1].keys():
				if str(player) == "T":
					continue
				if str(player) == "Enemies":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if not world_state_buffer[0].has(player):
					continue
				if get_node("YSort/otherPlayers").has_node(str(player)):
					var position_delta = (world_state_buffer[1][player]["P"]- world_state_buffer[0][player]["P"])
					var new_position = world_state_buffer[1][player]["P"] + (position_delta * extrapolation_factor)
					var animation = world_state_buffer[1][player]["A"]
					var facing = world_state_buffer[1][player]["F"]
					get_node("YSort/otherPlayers/" + str(player)).UpdatePlayer(new_position,animation,facing)



func SpawnNewEnemy(enemy_id, enemy_dict):
	var new_enemy = enemy_spawn.instance()
	new_enemy.position = enemy_dict["EnemyLocation"]
	new_enemy.max_hp = enemy_dict["EnemyMaxHealth"]
	new_enemy.current_hp = enemy_dict["EnemyHealth"]
	new_enemy.type = enemy_dict["EnemyType"]
	new_enemy.state = enemy_dict["EnemyState"]
	new_enemy.name = str(enemy_id)
	get_node("YSort/enemies").add_child(new_enemy,true)
	pass
