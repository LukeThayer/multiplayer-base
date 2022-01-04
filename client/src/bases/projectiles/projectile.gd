extends movement_controller
class_name projectile



export var skill_name = ""

onready var sprite = $sprite
onready var hitbox = $HitBox
onready var time_out = $time_out
onready var death_timer = $death_timer
var original = false

var knockback = 100
export(float) var lifetime = .5

var dir:Vector2 

func _ready():
	GameServer.FetchSkillDamage(skill_name, get_instance_id())
	time_out.wait_time = lifetime
	time_out.start()


var DMG = {
	magic_DMG = 0,
	physical_DMG = 0,
	DEF_PEN = 0,
	crit = false,
	status = []
}

func _process(delta):
	update_move_direction(dir, delta)

func set_DMG(_DMG):
	DMG.magic_DMG = _DMG

