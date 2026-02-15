extends Area2D

@export var mental_damage: int = 10

signal task_completed(damage)

func _on_body_entered(body) -> void:
	if body.name != "Player": return
	# do something with the task
	task_completed.emit(mental_damage)
