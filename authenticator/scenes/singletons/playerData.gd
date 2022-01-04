extends Node

var PlayerIDs

func _ready():
	var PlayerIDs_file = File.new()
	PlayerIDs_file.open("res://data/PlayerIDs.json",File.READ)
	var PlayerIDs_json = JSON.parse(PlayerIDs_file.get_as_text())
	PlayerIDs_file.close()
	PlayerIDs = PlayerIDs_json.result
	pass 
