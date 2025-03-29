extends CharacterBody2D

const SPEED = 200.0
@onready var animated_sprite: AnimatedSprite2D = $Sprite2D
@onready var attack_area: Area2D = $Area2D

var last_direction = "down"
var attacking = false
var attack_animation_played = false
var alive = true  # Novo: controla se o jogador está vivo

func _physics_process(delta: float) -> void:
	# Se o jogador estiver morto, não processe movimentos
	if not alive:
		return
		
	# Obter direção de entrada
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Aplicar movimento mesmo durante o ataque
	velocity = direction * SPEED
	move_and_slide()
	
	# Gerenciar ataque
	if Input.is_action_just_pressed("ui_accept") and not attacking:
		attack()
	
	# Gerenciar animações
	if attacking:
		# Se a animação de ataque não foi reproduzida ainda, reproduza-a
		if not attack_animation_played:
			if last_direction == "left":
				animated_sprite.flip_h = true
				animated_sprite.play("attack_right")
			else:
				animated_sprite.flip_h = false
				animated_sprite.play("attack_" + last_direction)
			attack_animation_played = true
		
		# Não atualizar a animação de movimento durante o ataque
		# mas ainda atualizar a direção
		if direction != Vector2.ZERO:
			if direction.x > 0:
				last_direction = "right"
			elif direction.x < 0:
				last_direction = "left"
			elif direction.y > 0:
				last_direction = "down"
			elif direction.y < 0:
				last_direction = "up"
	else:
		# Animações normais quando não está atacando
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

func attack() -> void:
	attacking = true
	attack_animation_played = false
	print("Player started attacking")
	attack_area.check_attack()
	
	# Configurar um timer para encerrar o ataque
	var attack_timer = get_tree().create_timer(0.5)  # Ajuste este valor para combinar com a duração da sua animação
	await attack_timer.timeout
	
	attacking = false

# Nova função para quando o jogador morre
func die() -> void:
	if not alive:
		return  # Evita morte dupla
		
	print("Player died")
	alive = false
	attacking = false
	velocity = Vector2.ZERO
	
	animated_sprite.play("die")  # Supondo que você tenha uma animação "die_right"
	
	# Espera a animação terminar antes de reiniciar
	await animated_sprite.animation_finished
	
	# Reinicia a cena atual
	await get_tree().create_timer(1.0).timeout  # Adiciona um pequeno atraso antes de reiniciar
	get_tree().reload_current_scene()
