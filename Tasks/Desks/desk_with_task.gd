extends Node2D
class_name DeskWithTask

@onready var white = $VariantWhite
@onready var black = $VariantBlack
@onready var task_area = $Task
var _task: Task

func _ready() -> void:
	randomize()
	var isBlack = (randi() % 100) > GameManager.mental_health
	
	black.visible = isBlack
	white.visible = !isBlack
	
	task_area.task_completed.connect(_on_task_completed)

func set_task(task: Task):
	var taskArea = $Task as TaskArea
	taskArea.from_task(task)
	_task = task

func _on_task_completed(_mental_damage):
	TaskManager.tasks.erase(_task.id)
	_task.complete()
	task_area.queue_free()
