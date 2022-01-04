extends KinematicBody2D

var current_hp
var max_hp
var state
var type

onready var health_bar = get_node("health_bar")

func _ready():
	
	health_bar.max_value = max_hp
	health_bar.value = current_hp
	if state == "Dead":
		OnDeath()
	pass 


func MoveEnemy(position):
	set_position(position)
	pass

func Health(new_hp):
	current_hp = new_hp
	health_bar.value = current_hp
	if current_hp<= 0:
		OnDeath()
	pass


func OnHit(damage):
	GameServer.NPCHit(int(get_name()),damage)

func OnDeath():
	get_node("CollisionShape2D").set_deferred("disabled",true)
	get_node("HitBox/CollisionShape2D").set_deferred("disabled",true)
	health_bar.hide()

