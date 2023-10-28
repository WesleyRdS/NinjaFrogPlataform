extends Area2D



func _on_fallzone_body_entered(body: Node):
	Global.player_health -= 1
	Global.fall = true
	Global.scene = get_tree().current_scene.name
	if Global.player_health < 1:
		get_tree().change_scene("res://Prefabs/GameOver.tscn")

	else:
		if get_tree().change_scene("res://Levels/"+Global.scene+".tscn") != OK:
			print("Algo deu errado!")
	


func _on_fallzone_body_exited(body):
	Global.fall = false
