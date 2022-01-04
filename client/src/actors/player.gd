extends movement_controller

onready var sprite = get_node("AnimatedSprite")

var player_state
onready var dir:Vector2
var animation = "idle"
var facing :Vector2 = Vector2(1,0)


func _ready():
	set_physics_process(false)
	pass

func _physics_process(delta):
	update_movement(delta)
	update_anim()
	update_facing()
	definePlayerState()

	pass

func update_facing():
	facing = get_local_mouse_position().normalized()
	if facing.x >=0:
		sprite.set_scale(Vector2(1,1))
	else:
		sprite.set_scale(Vector2(-1,1))

func update_anim():
	if dir.x == 0:
		animation = "idle"
	else:
		animation = "run"
	sprite.set_animation(animation)
	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_Q:
			Attack()

func update_movement(delta):
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	update_move_direction(dir, delta)
	

func definePlayerState():
	player_state = {"T":GameServer.client_clock, "P": get_position(), "F": facing, "A": animation}
	GameServer.SendPlayerState(player_state)
	

func Attack():
	GameServer.SendAttack(position,facing)
	get_node("projectile_spawner").spawn_projectile("res://src/instances/fireball/fireball.tscn", get_local_mouse_position())
