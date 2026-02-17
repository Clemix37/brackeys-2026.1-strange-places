extends Area2D

# Export variables
@export var task_name: String = "Work"
@export var doing_task: String = "Working..."
@export var mental_damage: float = 10.0 # damage mental health
@export var mental_restore: float = 0.0 # restores mental health
@export var work_time: float = 2.0
@export var can_be_done_multiple_times: bool = false
@export var collision_radius: int = 15


# On ready variables
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interact_label: Label = $InteractLabel

# Signals
signal task_completed(damage)

# Variables
var player_in_range = false
var working = false
var completed = false

## When script is loaded
func _ready():
	reset_interaction_label()
	toggle_interaction_label_visibility(false)
	# Changes the radius depending on the radius we gave
	var circle_shape: CircleShape2D = collision_shape_2d.shape
	circle_shape.radius = collision_radius

## When a body enters the area 
func _on_body_entered(body):
	print(body.name)
	if body.name == "Player":
		player_in_range = true
		toggle_interaction_label_visibility(true)

## When a body exits the area
func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		toggle_interaction_label_visibility(false)

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not working:
		start_task()

## Display the command + task_name on the interaction label
func reset_interaction_label():
	interact_label.text = "[E] " + task_name

## Changes the visibility property of the interaction label
func toggle_interaction_label_visibility(visible: bool = true) -> void:
	interact_label.visible = visible

func start_task():
	working = true
	interact_label.text = doing_task
	await get_tree().create_timer(work_time).timeout
	GameManager.set_mental_health(GameManager.mental_health - mental_damage + mental_restore)
	emit_signal("task_completed", mental_damage)
	reset_interaction_label()
	working = false
