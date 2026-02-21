extends Node2D
class_name DeskWithTask

@onready var white = $VariantWhite
@onready var black = $VariantBlack
@onready var task_area = $Task
@onready var typing_normally_sfx: AudioStreamPlayer2D = %TypingNormallySfx
@onready var typing_fast_sfx: AudioStreamPlayer2D = %TypingFastSfx
var _task: Task
var current_stream_player: AudioStreamPlayer2D

func _ready() -> void:
	randomize()
	var isBlack = (randi() % 100) > GameManager.mental_health
	
	black.visible = isBlack
	white.visible = !isBlack
	
	task_area.starting_task.connect(play_sound_task)
	task_area.task_completed.connect(_on_task_completed)

func set_task(task: Task):
	var taskArea = $Task as TaskArea
	taskArea.from_task(task)
	_task = task

func _on_task_completed(_mental_damage):
	TaskManager.tasks.erase(_task.id)
	_task.complete()
	task_area.queue_free()
	if not current_stream_player: return
	current_stream_player.stop()

func play_sound_task() -> void:
	var stream_player: AudioStreamPlayer2D = typing_normally_sfx if GameManager.mental_health > 50 else typing_fast_sfx
	stream_player.play()
	current_stream_player = stream_player
