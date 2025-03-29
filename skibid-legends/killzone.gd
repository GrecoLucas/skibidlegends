extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		print("Calling die method on", body.name)
		body.die()
	else:
		print("Body doesn't have die method, restarting scene")
		timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
