extends Label


func _ready():
	Global.carregar_jogo()
	text ="Thanks for playing \n  Your best time: " + String(Global.Rminutes) +":"+ String(Global.Rseconds)


func _process(delta: float) -> void:
	if Global.minutes < Global.Rminutes:
		Global.Rminutes = Global.minutes
		Global.Rseconds = Global.seconds
	elif Global.minutes == 0:
		if Global.seconds < Global.Rseconds:
			Global.Rminutes = Global.minutes
			Global.Rseconds = Global.seconds
