extends Label


func _physics_process(delta: float) -> void:
	if Global.fruits < 10:
		text = "000"+String(Global.fruits)
	elif  Global.fruits >= 10 and Global.fruits <= 99: 
		text = "00"+String(Global.fruits)
	elif  Global.fruits >= 100 and Global.fruits <= 999:
		text = "0"+String(Global.fruits)
	else:
		text = String(Global.fruits)
