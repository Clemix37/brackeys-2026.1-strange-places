extends Node2D

const COFFEE_POURING = preload("uid://7j0olqlsetee")
const NOISE_BG = preload("uid://qsohrodwff3s")

@onready var office_door_area: Area2D = %OfficeDoorArea
@onready var enter_office_label: Label = %EnterOfficeLabel
# Tasks
@onready var drink_coffee_task: TaskArea = %DrinkCoffeeTask
@onready var scan_doc_task: TaskArea = $ScanDocTask
@onready var socialize_task: TaskArea = %SocializeTask
@onready var sofas: Node2D = %Sofas
@onready var audio_player: AudioStreamPlayer2D = %AudioPlayer
var player_in_range_door_office: bool = false

func _ready() -> void:
	sofas.change_sofas()
	toggle_enter_office_label_visibility(false)
	office_door_area.body_entered.connect(_on_body_entered_office_door)
	office_door_area.body_exited.connect(_on_body_exited_office_door)
	scan_doc_task.task_completed.connect(set_scan_doc_complete)
	# Socialize
	socialize_task.task_completed.connect(end_socializing)
	socialize_task.starting_task.connect(start_socializing)
	# Drink coffee
	drink_coffee_task.starting_task.connect(start_coffee)
	drink_coffee_task.task_completed.connect(take_coffee)

## Changes the visibility of the label to enter the office
func toggle_enter_office_label_visibility(to_be_visible: bool = true) -> void:
	enter_office_label.visible = to_be_visible

## When a body enters the office doors
func _on_body_entered_office_door(body: Node2D) -> void:
	if body.name != "Player": return
	player_in_range_door_office = true
	toggle_enter_office_label_visibility(true)

## When a body exits the office doors
func _on_body_exited_office_door(body: Node2D) -> void:
	if body.name != "Player": return
	player_in_range_door_office = false
	toggle_enter_office_label_visibility(false)

func _process(_delta: float) -> void:
	if player_in_range_door_office and Input.is_action_pressed("interact"):
		var main_node = get_tree().current_scene
		# Office room
		main_node.change_room("uid://srpdj5vapkv3", GameManager.RoomNames.OPEN_SPACE)

func set_scan_doc_complete(_damage: float) -> void:
	var task = TaskManager.get_task_by_id(TaskManager.TasksIds.SCAN_DOC)
	if task: task.complete()

func start_coffee() -> void:
	audio_player.stream = COFFEE_POURING
	audio_player.play()

func take_coffee(_damage: float) -> void:
	GameManager.add_taken_coffee()
	audio_player.stop()

func end_socializing(_damage: float) -> void:
	audio_player.stop()
	var task = TaskManager.get_task_by_id(TaskManager.TasksIds.RANDOM_SOCIALIZE)
	if task: task.complete()

func start_socializing() -> void:
	audio_player.stream = NOISE_BG
	audio_player.play()
