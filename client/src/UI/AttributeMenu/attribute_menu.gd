extends Control


onready var INT_label =$GridContainer/int/HBoxContainer/attribute_sym/CenterContainer/stat_label
onready var STR_label =$GridContainer/str/HBoxContainer/attribute_sym/CenterContainer/stat_label
onready var DEX_label =$GridContainer/dex/HBoxContainer/attribute_sym/CenterContainer/stat_label
onready var CON_label =$GridContainer/con/HBoxContainer/attribute_sym/CenterContainer/stat_label
onready var SPR_label =$GridContainer/spr/HBoxContainer/attribute_sym/CenterContainer/stat_label
onready var LCK_label =$GridContainer/lck/HBoxContainer/attribute_sym/CenterContainer/stat_label
onready var points_label = $points


func _ready():
	pass

func LoadPlayerStats(stats):
	INT_label.set_text(str(stats.INT))
	STR_label.set_text(str(stats.STR))
	DEX_label.set_text(str(stats.DEX))
	CON_label.set_text(str(stats.CON))
	SPR_label.set_text(str(stats.SPR))
	LCK_label.set_text(str(stats.LCK))
	pass
