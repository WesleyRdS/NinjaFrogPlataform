extends Node

var fruits = 0

var checkpoint_pos_x = 0
var checkpoint_pos_y = 0
var scene = 'Level_01'
var player
var player_health = 3
var controlloff = false
var is_dead = false
var fall = false
var minutes = 0
var seconds = 0
var Rminutes = 100
var Rseconds = 0
var permissionMove = true
var ihtrap = false
var obs = 0
func _ready():
	pass


func salvar():
	var dic_salvar = {
		"minutes": minutes,
		"seconds": seconds
	}
	return dic_salvar
	
func salvar_jogo():
	var jogo_salvo = File.new()
	jogo_salvo.open_encrypted_with_pass("user://jogosalvo.save", File.WRITE, "cript")
	jogo_salvo.store_line(to_json(salvar()))
	jogo_salvo.close()
	
func carregar_jogo():
	var jogo_salvo = File.new()
	if not jogo_salvo.file_exists("user://jogosalvo.save"):
		print("Erro ao carregar o arquivo")
		return
	
	jogo_salvo.open_encrypted_with_pass("user://jogosalvo.save", File.READ, "cript")
	var linha_atual = parse_json(jogo_salvo.get_line())
	Rminutes = linha_atual["minutes"]
	Rseconds = linha_atual["seconds"]
	jogo_salvo.close()
	
