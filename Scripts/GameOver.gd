extends CanvasLayer


func _ready():
	pass


func _on_BtnRetry_pressed():
	
	if Global.is_dead:
		Global.player_health = 3
		Global.fruits = 0
	if Global.fall:
		Global.player_health = 3
		Global.fruits = 0
	if get_tree().change_scene("res://Levels/"+Global.scene+".tscn") != OK:
		print("Algo deu errado!")
	


func _on_Menu_pressed():

	Global.player_health = 3
	Global.fruits = 0
	Global.seconds = 0
	Global.minutes = 0
	Global.checkpoint_pos_x = 0
	Global.checkpoint_pos_y = 0
	get_tree().change_scene("res://Scenes/StartScreen.tscn")
