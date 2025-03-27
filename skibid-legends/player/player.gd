extends CharacterBody2D

const SPEED = 200.0

@onready var animated_sprite: AnimatedSprite2D = $Sprite2D
@onready var attack_area: Area2D = $Area2D
var last_direction = "down"
var attacking = false  

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()

	if attacking:
		if direction != Vector2.ZERO:
			attacking = false  
		else:
			return  

	if direction != Vector2.ZERO:
		if direction.x > 0:
			animated_sprite.flip_h = false
			animated_sprite.play("walk_right")
			last_direction = "right"
		elif direction.x < 0:
			animated_sprite.flip_h = true
			animated_sprite.play("walk_left")
			last_direction = "left"
		elif direction.y > 0:
			animated_sprite.play("walk_down")
			last_direction = "down"
		elif direction.y < 0:
			animated_sprite.play("walk_up")
			last_direction = "up"
	else:
		if last_direction == "left":
			animated_sprite.flip_h = true
			animated_sprite.play("stand_" + "right")
		else:
			animated_sprite.play("stand_" + last_direction)

	if Input.is_action_just_pressed("ui_accept"):
		attack()

func attack() -> void:
	if attacking:
		return  

	attacking = true
	print("Player started attacking")

	attack_area.check_attack()

	if last_direction == "left":
		animated_sprite.flip_h = true
		animated_sprite.play("attack_right")  # Usa a animação para a direita com flip
	else:
		animated_sprite.flip_h = false
		animated_sprite.play("attack_" + last_direction)

	await animated_sprite.animation_finished
	attacking = false
