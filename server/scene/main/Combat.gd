extends Node

func FetchSkillDamage(skill_name, player_id):
	var damage = ServerData.skill_data[skill_name].damage * .1 * get_node("../"+str(player_id)).player_stats.INT * rand_range(.5,1.5)
	return damage
