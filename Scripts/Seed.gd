extends Area2D

var velocity = Vector2.ZERO
var shoot_speed = -100
var direction = 1

func _physics_process(delta: float) -> void:
	velocity.x = shoot_speed * delta * direction
	
	translate(velocity)


func _on_clearNode_screen_exited():
	queue_free()


func _on_seed_body_entered(body):
	$anim.play("broken")
	shoot_speed = 0
	velocity.y = 1
	$collision.queue_free()
	yield(get_tree().create_timer(0.4),"timeout")
	queue_free()
	shoot_speed = -100
