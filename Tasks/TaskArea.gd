extends Area2D

@export var task_name: String = "Work"
@export var mental_damage: float = 10.0
@export var work_time: float = 2.0
@export var can_be_done_multiple_times: bool = false

signal task_completed(damage)

var player_in_range = false
var working = false
var completed = false

@onready var interact_label: Label = $InteractLabel

func _ready():
	update_label_text()
	interact_label.visible = false

func _on_body_entered(body):
	print(body.name)
	if body.name == "Player":
		player_in_range = true
		interact_label.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		interact_label.visible = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not working:
		start_task()

func update_label_text():
	interact_label.text = "[E] " + task_name

func start_task():
	working = true
	interact_label.text = "Working..."
	await get_tree().create_timer(work_time).timeout
	emit_signal("task_completed", mental_damage)
	update_label_text()
	working = false
