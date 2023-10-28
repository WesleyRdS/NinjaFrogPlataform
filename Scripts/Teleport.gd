extends Area2D

export var positionX = 0
export var positionY = 0
export var pay = 0
func _ready():
	$text.visible = false
	$anim.play("offf")


func _on_Teleport_body_entered(body: Node) -> void:
	if body.has_method("playerTeleport"):
		Global.permissionMove = false
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
			Global.permissionMove = true
			
		


func _on_Teleport_body_exited(body: Node) -> void:
	Global.permissionMove = true
	$text.visible = false
	$texture.modulate = "ffffff"
	$anim.play("offf")


func _on_Boss_BossDead():
	get_node("collision").set_deferred("disabled", false)
	$texture.visible = true


func _on_ArenaDoor_DoorClose():
	get_node("collision").set_deferred("disabled", true)
	$texture.visible = false
