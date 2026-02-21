extends CanvasLayer

@onready var title_task: Label = %TitleTask
@onready var description_label: Label = %DescriptionLabel
@onready var okay_btn: Button = %OkayBtn
@onready var notif_alert_sfx: AudioStreamPlayer2D = %NotifAlertSfx

var current_task: Task = null

func _ready() -> void:
	current_task = null
	reset_labels()
	okay_btn.pressed.connect(accept_task)

func display_as_task(task: Task) -> void:
	current_task = task
	title_task.text = task.name
	description_label.text = TaskManager.get_description_of_task_by_id(task.id)
	open_popup()

func open_popup() -> void:
	notif_alert_sfx.play()
	visible = true
	scale = Vector2.ZERO
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.2)

func close_popup() -> void:
	scale = Vector2.ONE
	create_tween().tween_property(self, "scale", Vector2.ZERO, 0.2)
	visible = false

func reset_labels() -> void:
	title_task.text = ""
	description_label.text = ""

func accept_task() -> void:
	TaskManager.add_random_task(current_task)
	close_popup()
