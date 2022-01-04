extends Node

func _ready():
	var newLevel
	newLevel = load("res://src/levels/test_level.tscn").instance()
	add_child(newLevel)
	pass 
