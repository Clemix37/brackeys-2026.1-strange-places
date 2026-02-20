extends Node2D

signal room_name_changed(room_name: String)

@onready var room_container: Node2D = %RoomContainer
@onready var hud: CanvasLayer = %HUD
@onready var game_over: CanvasLayer = %GameOver
@onready var random_task_manager: Node = %RandomTaskManager
@onready var popup_random_task: CanvasLayer = %PopupRandomTask

var current_room: Node = null
var is_transitioning = false

func _ready() -> void:
	# Loading office by default
	load_room("uid://srpdj5vapkv3")
	GameManager.mental_health_changed.connect(check_for_game_over)
	random_task_manager.random_task_triggered.connect(display_random_event_task)
	
func change_room(path: String, room_name: String):
	if is_transitioning: return
	is_transitioning = true
	await GameManager.fade_in()
	load_room(path)
	await GameManager.fade_out()
	is_transitioning = false
	hud.change_room_name(room_name)
	room_name_changed.emit(room_name)

func load_room(path: String):
	if current_room: current_room.queue_free()
	var room_scene = load(path) as PackedScene
	current_room = room_scene.instantiate()
	room_container.add_child(current_room)

func check_for_game_over(mental_health: float) -> void:
	if mental_health > 0.0: return
	GameManager.set_is_game_over()
	game_over.visible = true
	hud.visible = false

func display_random_event_task(task: Task) -> void:
	popup_random_task.display_as_task(task)
