extends CharacterBody2D

const SPEED = 50.0  # Velocidade reduzida para movimento devagar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var alive = true
var move_direction = Vector2.ZERO  # Direção de movimento
var moving = false  # Define se o slime está se movendo

func _ready():
	randomize()
	toggle_movement()  # Alterna entre parado e movimento

# Alterna entre ficar parado e se mover
func toggle_movement():
	moving = !moving  # Alterna entre verdadeiro e falso

	if moving:
		set_random_direction()  # Define uma nova direção para andar
		await get_tree().create_timer(randf_range(2.0, 4.0)).timeout  # Move por 2 a 4 segundos
	else:
		move_direction = Vector2.ZERO  # Para de se mover
		await get_tree().create_timer(randf_range(1.5, 3.0)).timeout  # Fica parado de 1.5 a 3 segundos

	toggle_movement()  # Chama novamente para continuar alternando

# Define uma direção aleatória para o slime andar
func set_random_direction():
	var x = randf_range(-1.0, 1.0)
	var y = randf_range(-1.0, 1.0)
	move_direction = Vector2(x, y).normalized()

# Função de atualização contínua
func _physics_process(delta: float) -> void:
	if !alive:
		return

	velocity = move_direction * SPEED
	move_and_slide()

	# Alterna entre animação de caminhada e idle
	if move_direction.length() > 0:
		if move_direction.x > 0:
			animated_sprite_2d.flip_h = false
		elif move_direction.x < 0:
			animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("slime_walk")
	else:
		animated_sprite_2d.play("slime_stand")

func die():
	print("Slime está morrendo...")
	alive = false
	animated_sprite_2d.play("slime_death")  
	await get_tree().create_timer(1.0).timeout  
	queue_free()
