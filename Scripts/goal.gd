extends Area2D

onready var changer = get_parent().get_node("Transition_in")

export var path: String
var save = false
func _ready():
	pass


func _on_goal_body_entered(body: Node) ->void:
	if body.name == "Player":
		Global.permissionMove = false
		if save:
			Global.salvar_jogo()
		$victoryFx.play()
		$confetti.emitting = true
		changer.change_scene(path)
		Global.checkpoint_pos_x = 0
		Global.checkpoint_pos_y = 0
		if Global.player_health < 3:
			Global.player_health += 1


func _on_goal_body_exited(body):
	Global.permissionMove = true
	save = false


func _on_Boss_BossDead():
	save = true
