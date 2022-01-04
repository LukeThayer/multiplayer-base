extends Control



export(String) var stat_name 
signal decrement_s(stat)
signal increment_s(stat)

func _ready():
	$"HBoxContainer/decrement".connect("pressed", self, "decrement")
	$"HBoxContainer/increment".connect("pressed", self, "increment")
	pass 

func decrement():
	emit_signal("decrement_s",stat_name)
	pass

func increment():
	emit_signal("increment_s",stat_name)
	pass
