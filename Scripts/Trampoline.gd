extends Area2D


func _ready():
	pass


func _on_trampoline_body_entered(body: Node) -> void:
	body.velocity.y = body.jump_force
	$anim.play("jump")
