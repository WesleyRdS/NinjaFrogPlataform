extends Control

var life_size = 32

func on_change_life(player_health):
	$life.rect_size.x = Global.player_health * life_size