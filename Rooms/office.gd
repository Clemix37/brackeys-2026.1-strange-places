extends Node2D

# On ready variables
@onready var break_room_door_area: Area2D = %BreakRoomDoorArea
@onready var enter_break_room_label: Label = %EnterBreakRoomLabel

# Variables
var player_face_door_break_room: bool = false

func _ready() -> void:
	toggle_enter_break_room_label_visibility(false)
	break_room_door_area.body_entered.connect(_on_body_entered_break_room_door)
	break_room_door_area.body_exited.connect(_on_body_exited_break_room_door)

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

func _process(delta: float) -> void:
	if player_face_door_break_room and Input.is_action_pressed("interact"):
		var main_node = get_tree().current_scene
		main_node.change_room("res://Rooms/BreakRoom.tscn", "Break Room")
