extends CanvasLayer


func _ready():
	pass


func _on_BtnRetry_pressed():
	
	get_tree().change_scene("res://Levels/"+Global.scene+".tscn")
