extends Node

var checkpoint_pos_x = 0
var checkpoint_pos_y = 0
func _ready():
	if Global.player_health < 1:
		Global.fruits = 0

func _process(delta):
	if Global.player_health < 1:
		Global.fruits = 0

func _on_Trigger_PlayerEntered_Camera():
	$BossCamera.current = true


func _on_Boss_BossDead():
	$BossCamera.current = false


func _on_Close_pressed():
	get_tree().change_scene("res://Scenes/StartScreen.tscn")
