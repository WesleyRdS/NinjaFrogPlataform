extends Control



func _process(delta: float) -> void:
	if Global.seconds >= 10:
		$seconds.set_text(":" + str(Global.seconds))
	else:
		$seconds.set_text(":0" + str(Global.seconds))
	
	if Global.minutes >= 10:
		$minutes.set_text(str(Global.minutes))
	else:
		$minutes.set_text("0" + str(Global.minutes))

	if Global.seconds == 60:
		Global.minutes +=1
		Global.seconds = 0
func _on_timer_timeout():
	Global.seconds += 1
