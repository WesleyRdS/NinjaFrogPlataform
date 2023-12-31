extends KinematicBody2D

var cont = 0
signal BossDead
export var speed = 64
export var health = 1
var velocity = Vector2.ZERO
var move_direction = -1
var gravity = 1200	
var hitted = false
var permission_atack = false

func _ready():
	get_node("walk/wall").set_deferred("disabled", true)
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	if $texture/ground.is_colliding():
		$Attack/Flip.set_deferred("Enabled", true)
	else: 
		$Attack/Flip.set_deferred("Enabled", false)
	move_and_slide(velocity)
	boss_set_animation()

func apply_gravity(delta):
	if cont == 0:
		$ray_wall.enabled = true
		velocity.x = speed * (move_direction)
		velocity.y += gravity * delta
		if $Attack/Flip.is_colliding():
			$ray_wall.scale.x *= -1
			$Attack/Flip.scale.x *= -1
			yield(get_tree().create_timer(0.2),"timeout")
			$texture.scale.x *= -1
			velocity.x = speed * (move_direction) * $texture.scale.x 
			cont =3
		if permission_atack and $texture/ground.is_colliding():
			$Attack/AttackFx.set_emitting(true)
			get_node("Attack/AT").set_deferred("disabled", false)
			yield(get_tree().create_timer(0.5),"timeout")
			get_node("Attack/AT").set_deferred("disabled", true)
			permission_atack = false
		yield(get_tree().create_timer(1),"timeout")#impedir que o boss comece andando
		if $ray_wall.is_colliding():
			$texture.rotation_degrees = 90
			$ray_wall.enabled = false
			$ray_wall.rotation_degrees = 90
			$collision.rotation_degrees = 90
			get_node("walk/wall").set_deferred("disabled", false) # sumindo com a colisão
			cont = 1
	elif cont == 1:
		$ray_wall.enabled = true
		velocity.x -= gravity * delta
		velocity.y = speed * move_direction
		if $ray_wall.is_colliding():
			$texture.rotation_degrees = 90
			$ray_wall.enabled = false
			$ray_wall.rotation_degrees = 90
			$collision.rotation_degrees = 90
			cont = 2
	elif cont == 2:
		$ray_wall.enabled = true
		velocity.x = -speed * move_direction
		velocity.y -= gravity * delta
		if $ray_wall.is_colliding(): 
			$texture.rotation_degrees = 0
			$ray_wall.enabled = false
			$ray_wall.rotation_degrees = 0
			$collision.rotation_degrees = 0
			get_node("walk/wall").set_deferred("disabled", true)
			permission_atack = true
			cont = 3
			$texture.scale.x = -1
			$ray_wall.scale.x = -1
			$Attack/Flip.scale.x *= -1
	
	elif cont == 3:
		$ray_wall.enabled = true
		velocity.y += gravity * delta
		if $Attack/Flip.is_colliding():
			$ray_wall.scale.x *= -1
			$Attack/Flip.scale.x *= -1
			yield(get_tree().create_timer(0.2),"timeout")
			$texture.scale.x *= -1
			velocity.x = speed * (move_direction) * $texture.scale.x
			cont = 0
		if permission_atack and $texture/ground.is_colliding():
			$Attack/AttackFx.set_emitting(true)
			get_node("Attack/AT").set_deferred("disabled", false)
			yield(get_tree().create_timer(0.5),"timeout")
			get_node("Attack/AT").set_deferred("disabled", true)
			permission_atack = false
		if $ray_wall.is_colliding():
			$texture.rotation_degrees = -90
			$ray_wall.enabled = false
			$ray_wall.rotation_degrees = -90
			$collision.rotation_degrees = -90
			get_node("walk/wall").set_deferred("disabled", false)
			cont = 4
	
	elif cont == 4:
		$ray_wall.enabled = true
		velocity.x += gravity * delta
		velocity.y = speed * move_direction
		if $ray_wall.is_colliding():
			$texture.rotation_degrees = -90
			$ray_wall.enabled = false
			$ray_wall.rotation_degrees = -90
			$collision.rotation_degrees = -90

			cont = 5
	
	elif cont == 5:
		$ray_wall.enabled = true
		velocity.x = speed * move_direction
		if $texture/ground.is_colliding():
			velocity.y -= gravity * delta
		else: 
			get_node("walk/wall").set_deferred("disabled", true)
			permission_atack = true
			$texture.rotation_degrees = 0
			$ray_wall.enabled = false
			$ray_wall.rotation_degrees = 0
			$texture.scale.x = 1
			$ray_wall.scale.x = 1
			$collision.rotation_degrees = 0
			$Attack/Flip.scale.x *= -1

			cont = 0
			

	
	
			
			
	
	
		
		
		
func _on_hitbox_body_entered(body: Node) -> void:
	hitted = true
	health -= 1
	$invecible.start()
	get_node("hitbox/collision").set_deferred("disabled", true)
	if speed < 100:
			speed += 9
	body.velocity.y = body.jump_force/2
	yield(get_tree().create_timer(0.2), "timeout")
	hitted = false
	if health < 1:
		get_node("hitbox/collision").set_deferred("disabled", true) # sumindo com a colisão
		set_physics_process(false)
		get_node("collision").set_deferred("disabled", true)
		yield(get_tree().create_timer(1), "timeout")
		queue_free()


func boss_set_animation():
	var anim = 'run'

	if $ray_wall.is_colliding():
		anim = 'idle'
	elif velocity.x != 0 and health > 5:
		anim = 'run'
		$hitFx.stop()
	elif velocity.x != 0 and health <=5:
		anim = 'angryRun'
		$hitFx.stop()
		speed = 120
	
	
	if health < 1:
		anim = "die"
		emit_signal("BossDead")
	elif hitted:
		$hitFx.play()
		anim = 'hit'
		
	if $anim.assigned_animation != anim:
		$anim.play(anim) 
	
	
func _on_ArenaDoor2_DoorClose():
	set_physics_process(true)


func _on_invecible_timeout():
	get_node("hitbox/collision").set_deferred("disabled", false)




