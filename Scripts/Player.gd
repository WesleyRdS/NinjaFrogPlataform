extends KinematicBody2D

var UP = Vector2.UP
var velocity = Vector2.ZERO #movimentação no eixo X e Y setada como zero
var move_speed = 480 #velocidade de movimento
var gravity = 1200 #variavel que seta gravidade pois kinematic body não tem gravidade por padrão
var jump_force = -720 #força de pulo que se opõe a gravidade
var is_grounded #verifica se o player esta no chão

#var player_health = 3
var max_health = 3

var hurted = false

var is_pushing = false

var knockback_dir = 1
var knockback_int = 1000

onready var raycasts = $raycasts #colisão para o salto
var climRock = false #colisão para escalada

signal change_life(player_health)

func _ready():
	Global.set("player",self)
	connect("change_life", get_parent().get_node("HUD/HBoxContainer/Holder"), "on_change_life")
	emit_signal("change_life",max_health)
	position.x = Global.checkpoint_pos_x
	position.y = Global.checkpoint_pos_y -10

func _physics_process(delta: float) -> void:
	#Definindo Gravidade
	velocity.y += gravity * delta #delta é um valor trazido na fisica
	if !Input.is_action_pressed("jump") and climRock:
		velocity.y = gravity * 0.05
		if !is_grounded:
			$climb_fx.set_emitting(true)
			$climb_fx.visible = true
		
	velocity.x = 0
	if !hurted:
		_get_input() # inputs de movimento
	
	if $pushRight.is_colliding(): #condição para empurrar blocos
		var object = $pushRight.get_collider()
		object.move_and_slide(Vector2(30,0) * move_speed * delta)
		is_pushing = true
	elif $pushLeft.is_colliding(): #condição para empurrar blocos
		var object = $pushLeft.get_collider()
		object.move_and_slide(Vector2(-30,0) * move_speed * delta)
		is_pushing = true
	else:
		is_pushing = false
		
		
	#No caso, o KinematicBody precisa de uma função ativa chamada move_and_slide
	#Ela recebe a variavel de deslocamento. De outra forma não se movera.
	velocity = move_and_slide(velocity, UP)
	climb_like_rockman()
	_set_animation()
	
	is_grounded = check_is_grounded() #função que verifica se player toca o chão
	if is_grounded:
		$Shadow.visible = true
	else:
		$Shadow.visible = false
	
	for plataforms in get_slide_count():
		var collision = get_slide_collision(plataforms)
		if collision.collider.has_method("collide_with"):
			collision.collider.collide_with(collision, self)
	
func _get_input():
	velocity.x = 0
	#comparação de valores para verificar a direção de movimento
	var move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	#pegando o valor negativo ou podistivo do movimento e multiplicando pela velocidade de deslocamento para o personagem andar
	#uso da interpolação para diminuir a velocidade do movimento
	if climRock and Input.is_action_just_pressed("impulso") and !is_grounded:
		velocity.x =  lerp(velocity.x, move_speed * -$texture.scale.x, 12)
		
	else: 
		velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2) 
	if move_direction != 0: #checa se o personagem ta andando para direita ou esquerda
		$texture.scale.x = move_direction
		$climb.scale.x = move_direction
		$steps_fx.scale.x = move_direction
		if climRock:
			$climb_fx.visible = false
			$climb_fx.position.x = move_direction*16
		
	if velocity.x > 1:
		$pushRight.set_enabled(true)
	elif velocity.x < -1:
		$pushLeft.set_enabled(true)
	else:
		$pushRight.set_enabled(false)
		$pushLeft.set_enabled(false)
		

	knockback_dir = $texture.scale.x

func _input(event: InputEvent) -> void: #função que habilita o pulo quando o player toca o chão
	if (event.is_action_pressed("jump") and is_grounded) or (event.is_action_pressed("jump") and climRock):
		velocity.y = jump_force/2
		$jumpFx.play()

func climb_like_rockman():
	if $climb.is_colliding() and hurted != true:
		climRock = true
	else:
		climRock = false
		
func check_is_grounded(): #verifica se raycast do player colide com o chão
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
			
	return false
	
func _set_animation():
	var anim = 'idle'
	
	if !is_grounded:
		anim = 'jump'
	elif velocity.x != 0 or is_pushing:
		anim = 'run'
		$steps_fx.set_emitting(true)
	else:
		anim = 'idle'
	
	if velocity.y > 0 and climRock and !is_grounded:
		anim = 'climb'
		
	elif velocity.y > 0 and !is_grounded:
		anim = 'fall'
		
	
	if hurted:
		anim = 'hit'
		
	
	if $anim.assigned_animation != anim:
		$anim.play(anim) 

func knockback():
	if $right.is_colliding():
		velocity.x = -knockback_dir * knockback_int * $texture.scale.x
	if $left.is_colliding():
		velocity.x = knockback_dir * knockback_int * $texture.scale.x
	print("int: "+str(knockback_int))
	print("dir: "+str(knockback_dir))
	print("x: "+str($texture.scale))
	velocity = move_and_slide(velocity)
	
func _on_hurtbox_body_entered(body: Node) -> void:
	$hurtFx.play()
	playerDamage()
	

func hit_checkpoint():
	Global.checkpoint_pos_x = position.x
	Global.checkpoint_pos_y = position.y


func _on_headCollider_body_entered(body: Node) -> void:
	if body.has_method("destroy"):
		body.destroy()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	playerDamage()
	


func gameOver() -> void:
	if Global.player_health < 1:
		Global.is_dead = true
		Global.scene = get_tree().current_scene.name
		queue_free()
		if get_tree().change_scene("res://Prefabs/GameOver.tscn") != OK:
			print("Algo deu errado")


func playerDamage():
	Global.player_health -= 1
	hurted = true
	$invencible.start()
	emit_signal("change_life", Global.player_health)
	knockback()
	get_node("hurtbox/collision").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.5),"timeout")
	hurted = false
	gameOver()
	
func playerDamageUp():
	Global.player_health -= 1
	$invencible.start()
	$hurtbox/collision.disabled = true
	hurted = true
	emit_signal("change_life", Global.player_health)
	velocity.y = jump_force/2
	velocity.x = -800 * $texture.scale.x
	get_node("hurtbox/collision").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.5),"timeout")
	hurted = false
	gameOver()

func playerTeleport(positionX, positionY):
	position.x = positionX
	position.y = positionY


func _on_Trigger_PlayerEntered():
	$camera.current = false


func _on_Boss_BossDead():
	$camera.current = true


func _on_invencible_timeout():
	get_node("hurtbox/collision").set_deferred("disabled", false)
