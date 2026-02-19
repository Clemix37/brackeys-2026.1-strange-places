extends Node2D

signal room_name_changed(room_name: String)

@onready var room_container := $RoomContainer
@onready var hud := $HUD

var current_room: Node = null
var is_transitioning = false

func _ready() -> void:
	load_room("res://Rooms/Office.tscn")
	
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
