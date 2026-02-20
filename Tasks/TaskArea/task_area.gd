extends Area2D
class_name TaskArea

# Export variables
@export var task_id: String
@export var collision_radius: int = 15

# On ready variables
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interact_label: Label = $InteractLabel

# Signals
signal task_completed(damage: float)

# Variables
var player_in_range = false
var working = false
var task: Task

## When script is loaded
func _ready():
	print(task_id)
	task = TaskManager.get_task_by_id(task_id)
	if !task: printerr("No task with this id")
	
	reset_interaction_label()
	toggle_interaction_label_visibility(false)
	# Changes the radius depending on the radius we gave
	var circle_shape: CircleShape2D = collision_shape_2d.shape
	circle_shape.radius = collision_radius

## When a body enters the area 
func _on_body_entered(body):
	if body.name == "Player" && task:
		player_in_range = true
		toggle_interaction_label_visibility(true)

## When a body exits the area
func _on_body_exited(body):
	if body.name == "Player" && task:
		player_in_range = false
		toggle_interaction_label_visibility(false)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not working and !task.completed:
		start_task()

## Display the command + task_name on the interaction label
func reset_interaction_label():
	if !task: return
	interact_label.text = "[E] " + task.name

## Changes the visibility property of the interaction label
func toggle_interaction_label_visibility(is_label_visible: bool = true) -> void:
	interact_label.visible = is_label_visible

func start_task():
	GameManager.player_can_move = false
	working = true
	interact_label.text = task.working_msg
	
	var duration = task.duration
	var tick_rate = 0.1
	var elapsed = 0.0
	
	var damage_per_tick: float = task.mental_damage * tick_rate / duration
	while elapsed < duration:
		await get_tree().create_timer(tick_rate).timeout
		GameManager.set_mental_health(GameManager.mental_health - damage_per_tick)
		elapsed += tick_rate
	
	task_completed.emit(task.mental_damage)
	reset_interaction_label()
	working = false
	GameManager.player_can_move = true

## Only for desks
func from_task(from_this_task: Task):
	task_id = from_this_task.id
	task = from_this_task
