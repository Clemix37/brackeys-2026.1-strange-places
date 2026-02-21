extends Node2D

signal room_name_changed(room_name: String)

const FAIL = preload("uid://dlomp2alppfx5")

@onready var bg_music: AudioStreamPlayer2D = %BgMusic
@onready var room_container: Node2D = %RoomContainer
@onready var hud: CanvasLayer = %HUD
@onready var game_over: CanvasLayer = %GameOver
@onready var random_task_manager: Node = %RandomTaskManager
@onready var popup_random_task: CanvasLayer = %PopupRandomTask
@onready var audio_player: AudioStreamPlayer2D = %AudioPlayer

var current_room: Node = null
var is_transitioning = false

func _ready() -> void:
	# Loading office by default
	load_room("uid://srpdj5vapkv3")
	GameManager.mental_health_changed.connect(mental_health_changed)
	GameManager.is_game_over_called.connect(stop_bg_music)
	random_task_manager.random_task_triggered.connect(display_random_event_task)
	
func change_room(path: String, room_name: String):
	if is_transitioning: return
	is_transitioning = true
	await GameManager.fade_in()
	load_room(path)
	check_for_room_container_skew()
	await GameManager.fade_out()
	is_transitioning = false
	hud.change_room_name(room_name)
	room_name_changed.emit(room_name)

func load_room(path: String):
	if current_room: current_room.queue_free()
	var room_scene = load(path) as PackedScene
	current_room = room_scene.instantiate()
	room_container.add_child(current_room)

func mental_health_changed(mental_health: float) -> void:
	check_for_game_over(mental_health)

func check_for_game_over(mental_health: float) -> void:
	if mental_health > 0.0: return
	audio_player.stream = FAIL
	audio_player.play()
	GameManager.set_is_game_over()
	game_over.visible = true
	hud.visible = false

func check_for_room_container_skew() -> void:
	room_container.skew = 0.0 # resets the skew of container
	var health = GameManager.mental_health
	var percentage_of_skew = 1 - (health / 100.0)
	var random_chance = randf_range(0.0, 1.0)
	if percentage_of_skew < random_chance: return
	var skew_degrees = clamp(100.0 - health, 0.0, 40.0)
	room_container.skew = deg_to_rad(skew_degrees)

func display_random_event_task(task: Task) -> void:
	popup_random_task.display_as_task(task)

func stop_bg_music() -> void:
	bg_music.stop()
