extends CanvasLayer

@onready var mental_health_bar: ProgressBar = %MentalHealthBar
@onready var current_room_label: Label = %CurrentRoomLabel
@onready var tasks_lists: RichTextLabel = %TasksLists
@onready var stress_mat: ShaderMaterial = get_tree().get_current_scene().get_node("CanvasLayer/ColorRect").material

func _ready() -> void:
	GameManager.mental_health_changed.connect(_update_mental_health_hud)
	GameManager.room_name_changed.connect(change_room_name)
	update_tasks_lists()
	TaskManager.updated_tasks.connect(update_tasks_lists)

func _update_mental_health_hud(mental_health: int) -> void:
	mental_health_bar.value = mental_health
	_update_mental_health_fill_color()
	stress_mat.set_shader_parameter("radius", shader_radius())

var processed = 0.0
func _process(delta: float) -> void:
	processed += delta / (shader_radius() - 0.1)
	stress_mat.set_shader_parameter("processed", processed)

## Updates the mental_health_bar fill color
## TODO see if transition between values can be fluidified 
func _update_mental_health_fill_color() -> void:
	var mental_health: int = GameManager.mental_health
	var fill_style = mental_health_bar.get_theme_stylebox("fill").duplicate()
	if mental_health > 70:
		# 5EDC8A
		fill_style.bg_color = Color("5EDC8A")
		pass
	elif mental_health > 40:
		# F2C94C
		fill_style.bg_color = Color("F2C94C")
		pass
	elif mental_health > 15:
		# F2994A
		fill_style.bg_color = Color("F2994A")
		pass
	elif mental_health > 0:
		# EB5757
		fill_style.bg_color = Color("EB5757")
		pass
	else:
		# 6C3EB8
		fill_style.bg_color = Color("6C3EB8")
		pass
	mental_health_bar.add_theme_stylebox_override("fill", fill_style)

func shader_radius() -> float:
	return 0.2 + mental_health_bar.value / 100.

func change_room_name(room_name: String) -> void:
	print(room_name)
	current_room_label.text = room_name
	current_room_label.visible = true
	await get_tree().create_timer(4.0).timeout
	current_room_label.visible = false

func update_tasks_lists() -> void:
	var content := "[b][i]Tasks[/i][/b]"

	for task_key in TaskManager.tasks.keys():
		var task: Task = TaskManager.tasks[task_key]
		content += "\n- " + task.name

	tasks_lists.text = content
