extends Area2D

@onready var player: CharacterBody2D = $".."

func check_attack() -> void:
	for area in get_overlapping_areas():
		print("slime entered")  # Apenas no momento certo
		
		var parent = area.get_parent()  # Obtém o nó pai da área
		print(parent)
		if player.attacking and parent.has_method("die"):
			print("player hit", parent.name)  # Exibe o nome do pai para depuração
			parent.die()  # Chama o método die() do Slime
