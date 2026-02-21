extends Node2D

# On ready variables
@onready var break_room_door_area: Area2D = %BreakRoomDoorArea
@onready var enter_break_room_label: Label = %EnterBreakRoomLabel
@onready var phone_call_task: TaskArea = %PhoneCallTask
@onready var meeting_task: TaskArea = %MeetingTask
@onready var desk_spawns: Node2D = $DeskSpawns

# Variables
var player_face_door_break_room: bool = false

func _ready() -> void:
	toggle_enter_break_room_label_visibility(false)
	TaskManager.random_task_picked.connect(_on_pick_random_task)
	break_room_door_area.body_entered.connect(_on_body_entered_break_room_door)
	break_room_door_area.body_exited.connect(_on_body_exited_break_room_door)
	# Random tasks
	phone_call_task.task_completed.connect(set_client_call_complete)
	meeting_task.task_completed.connect(set_meeting_complete)

func toggle_enter_break_room_label_visibility(to_be_visible: bool = true) -> void:
	enter_break_room_label.visible = to_be_visible

func _on_body_entered_break_room_door(body: Node2D) -> void:
	if body.name != "Player": return
	player_face_door_break_room = true
	toggle_enter_break_room_label_visibility(true)

func _on_body_exited_break_room_door(body: Node2D) -> void:
	if body.name != "Player": return
	player_face_door_break_room = false
	toggle_enter_break_room_label_visibility(false)

func _process(_delta: float) -> void:
	if player_face_door_break_room and Input.is_action_pressed("interact"):
		var main_node = get_tree().current_scene
		main_node.change_room("uid://dqq81165hq83l", GameManager.RoomNames.BREAK_ROOM)

func _on_pick_random_task(random_task: Task) -> void:
	phone_call_task.visible = random_task.id == TaskManager.TasksIds.RANDOM_CLIENT_CALL
	meeting_task.visible = random_task.id == TaskManager.TasksIds.RANDOM_MEETING

func set_meeting_complete(_damage: float) -> void:
	var task: Task = TaskManager.get_task_by_id(TaskManager.TasksIds.RANDOM_MEETING)
	if not task: return
	task.complete()

func set_client_call_complete(_damage: float) -> void:
	var task: Task = TaskManager.get_task_by_id(TaskManager.TasksIds.RANDOM_CLIENT_CALL)
	if not task: return
	task.complete()
