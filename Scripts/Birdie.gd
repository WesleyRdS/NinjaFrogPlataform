extends enemyBase


func _process(delta: float) -> void:
	velocity.y = 0 #gravidade sempre zerada
	if $ray_wall.is_colliding():
		$ray_wall.scale.x *= -1
		move_direction *= -1
		$anim.play("run")	
