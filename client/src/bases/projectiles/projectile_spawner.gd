extends Node
class_name projectile_spawner




func spawn_projectile(projectile_directory, dir, original = true, x = 0 , y = 0):
	
	##verifies the projectile has a direction
	if dir.x !=0 || dir.y != 0:
		
		## spawns the projectile
		var projectile= load(projectile_directory).instance()
		get_tree().get_root().add_child(projectile)
		
		## moves the projecttile to the location of spawaner + offset
		var pos:Vector2
		pos.x = self.global_position.x + x
		pos.y = self.global_position.y + y
		projectile.set_position(pos)
		
		## sets the angle of the projectile,
		projectile.dir = dir
		projectile.rotation = dir.angle()
		
		## defines if the original player casted
		projectile.original = original
		
		if dir.x <0:
			projectile.sprite.flip_v = true


