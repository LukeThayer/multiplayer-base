extends projectile


func _ready():
	pass 


func destroy():
	queue_free()


func _on_HurtBox_area_entered(area):
	if original:
		area.get_parent().OnHit(DMG.magic_DMG)
	
	pass 


func _on_time_out_timeout():
	destroy()
	pass 
