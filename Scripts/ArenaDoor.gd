extends StaticBody2D

signal DoorClose

func _ready():
	pass


func _on_Trigger_PlayerEntered():
	$anim.play("active")
	emit_signal("DoorClose")


func _on_Boss_BossDead():
	$anim.play("inactive")
