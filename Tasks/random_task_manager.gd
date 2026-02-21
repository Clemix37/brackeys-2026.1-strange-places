extends Node

signal random_task_triggered(task: Task)

@export var min_time: float = 5.0
@export var max_time: float = 20.0

var running = true

func _ready():
	TaskManager.random_task_deleted.connect(get_other_random_task)
	GameManager.is_game_over_called.connect(cancel_random_events)
	if TaskManager.current_random_task: 
		running = false
		return
	start_random_timer()

func start_random_timer():
	if not running:
		return
		
	var wait_time = randf_range(min_time, max_time)
	await get_tree().create_timer(wait_time).timeout
	# Running can be changed by canceling it after it has been started
	if not running: return
	trigger_random_task()
	running = false

func trigger_random_task() -> void:
	# Pick only the ones not already completed
	var random_tasks: Array[Task] = TaskManager.random_event_tasks.values().filter(func(t: Task): return not t.completed)
	var random_task: Task = random_tasks.pick_random()
	random_task_triggered.emit(random_task)

func cancel_random_events() -> void:
	running = false

func get_other_random_task() -> void:
	running = true
	start_random_timer()
