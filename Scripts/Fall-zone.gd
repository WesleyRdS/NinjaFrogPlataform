extends Area2D


func _on_fallzone_body_entered(body: Node):
	Global.scene = get_tree().current_scene.name
	if get_tree().change_scene("res://Prefabs/GameOver.tscn") != OK:
		print("Algo deu errado!")
