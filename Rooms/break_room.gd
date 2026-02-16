extends Node2D
@onready var send_mail_task: Area2D = %SendMailTask

func _ready() -> void:
	send_mail_task.task_completed.connect(_on_task_completed)
	
func _on_task_completed(damage: int):
	GameManager.set_mental_health(GameManager.mental_health - damage)
