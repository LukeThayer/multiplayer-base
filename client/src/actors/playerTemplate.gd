extends KinematicBody2D

var fireball = "res://src/instances/fireball/fireball.tscn"
var attack_dict = {} #{"Position" : position, "Facing" : facing}
var state = "Idle"

onready var sprite = get_node("AnimatedSprite")



func _physics_process(delta):
	if attack_dict != {}:
		Attack()
	
	pass


func UpdatePlayer(newPosition,animation,facing):
	UpdatePosition(newPosition)
	UpdateAnimation(animation)
	UpdateFacing(facing)
	pass

func UpdatePosition(newPosition):
	set_position(newPosition)

func UpdateAnimation(animation):
	sprite.set_animation(animation)

func UpdateFacing(facing):
	if facing.x >=0:
		sprite.set_scale(Vector2(1,1))
	else:
		sprite.set_scale(Vector2(-1,1))


func despawn():
	yield(get_tree().create_timer(.2), "timeout")
	queue_free()

func Attack():
	for attack in attack_dict.keys():
		if attack <= GameServer.client_clock:
			UpdatePosition(attack_dict[attack]["Position"])
			
			get_node("projectile_spawner").spawn_projectile(fireball, attack_dict[attack]["Facing"])
			attack_dict.erase(attack)
