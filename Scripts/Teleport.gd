extends Area2D

export var positionX = 0
export var positionY = 0
export var pay = 0
func _ready():
	$text.visible = false
	$anim.play("offf")


func _on_Teleport_body_entered(body: Node) -> void:
	if body.has_method("playerTeleport"):
		$anim.play("onn")
		yield(get_tree().create_timer(2),"timeout")
		if Global.fruits >= pay:
			$text.text = "Offer accepted. Teleporting"
			$text.visible = true
			Global.fruits = 0
			yield(get_tree().create_timer(0.5),"timeout")
			body.playerTeleport(positionX, positionY)
		else:
			$texture.modulate = "9dff0000"
			$text.text = "Do you dare to offer such a small offering? \n Blasphemy, I will take the offering and also your life"
			$text.visible = true
			if body.has_method("playerDamageUp"):
				body.playerDamageUp()
			Global.fruits = 0
		


func _on_Teleport_body_exited(body):
	$text.visible = false
	$texture.modulate = "ffffff"
	$anim.play("offf")
