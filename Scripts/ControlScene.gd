extends Control


func _ready():
	$Return.grab_focus()


func _on_Return_pressed():
	queue_free()
	Global.controlloff = false
