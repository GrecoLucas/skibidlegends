extends CharacterBody2D

const SPEED = 200.0

@onready var animated_sprite = $Sprite2D  # Certifique-se do nome correto

var last_direction = "stand_down"

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Aplica a velocidade ao personagem
	velocity = direction * SPEED

	# Determina qual animação tocar
	if direction != Vector2.ZERO:
		if direction.x > 0:
			animated_sprite.flip_h = false
			animated_sprite.play("walk_right")
			last_direction = "stand_right"
		elif direction.x < 0:
			animated_sprite.flip_h = true
			animated_sprite.play("walk_left")
			last_direction = "stand_right"  
		elif direction.y > 0:
			animated_sprite.play("walk_down")
			last_direction = "stand_down"
		elif direction.y < 0:
			animated_sprite.play("walk_up")
			last_direction = "stand_up"
	else:
		animated_sprite.play(last_direction)  


	move_and_slide()
