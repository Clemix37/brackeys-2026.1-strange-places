extends Node2D

@onready var task = $PickupDocsTask

func _ready() -> void:
	TaskManager.updated_tasks.connect(_update_visibility)
	_update_visibility()
	task.task_completed.connect(_on_complete_task)

func _update_visibility():
	$PickupDocsTask.visible = TaskManager.visible_tasks.has(TaskManager.TasksIds.PICKUP_PRINTED_DOCS)

func _on_complete_task(damage):
	var task = TaskManager.tasks[TaskManager.TasksIds.PICKUP_PRINTED_DOCS]
	if task: task.complete()
