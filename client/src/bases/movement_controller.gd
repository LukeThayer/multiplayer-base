extends KinematicBody2D
class_name movement_controller

export var base_max_speed = 120
export var base_friction = 1000
export var base_acceleration = 2500

onready var max_speed = base_max_speed
onready var friction = base_friction
onready var acceleration = base_acceleration
onready var velocity = Vector2.ZERO

func update_move_direction(dir:Vector2 , delta: float):
	dir = dir.normalized()
	
	if(dir  == Vector2.ZERO):
		velocity = velocity.move_toward(Vector2.ZERO,friction * delta)
	else:
		velocity = velocity.move_toward(dir * max_speed, acceleration * delta)
	velocity = move_and_slide(velocity)
