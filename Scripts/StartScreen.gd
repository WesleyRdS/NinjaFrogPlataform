extends Control


func _ready():
	$controls/startBtn.grab_focus()

func _physics_process(delta: float) ->void:
	if Global.controlloff == false:
		$controls/startBtn.grab_focus()
		Global.controlloff = true
func _on_startBtn_pressed():
	get_tree().change_scene("res://Levels/Level_01.tscn")


func _on_quitBtn_pressed():
	get_tree().quit()


func _on_crtlBtn_pressed():
	var controlScreen = load("res://Scenes/ControlScene.tscn").instance() #instanciando uma cena por cima da outra
	get_tree().current_scene.add_child(controlScreen)
