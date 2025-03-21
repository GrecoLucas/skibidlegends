extends CharacterBody2D

const SPEED = 50.0  # Velocidade reduzida para movimento devagar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var alive = true
var move_direction = Vector2.ZERO  # Direção de movimento

func _ready():
	# Começa o movimento aleatório
	randomize()
	set_random_direction()  # Define uma direção aleatória

# Define uma direção aleatória para o slime andar
func set_random_direction():
	var x = randf_range(-1.0, 1.0)  # Aleatório entre -1 e 1
	var y = randf_range(-1.0, 1.0)  # Aleatório entre -1 e 1
	move_direction = Vector2(x, y).normalized()  # Normaliza para garantir que a direção tenha magnitude 1

# Função de atualização contínua
func _physics_process(delta: float) -> void:
	# Muda a direção aleatória periodicamente (uma vez a cada 60 quadros, por exemplo)
	if randf() < 0.01:  # Há uma chance pequena de mudar a direção em cada quadro
		set_random_direction()

	# Movimenta o slime
	velocity = move_direction * SPEED
	move_and_slide()  # A função agora usa a variável velocity diretamente, sem passar o parâmetro

	# Executa a animação de caminhada
	if velocity.length() > 0:
		animated_sprite_2d.play("slime_walk")
	else:
		animated_sprite_2d.play("slime_idle")
