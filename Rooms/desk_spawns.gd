extends Node2D

@onready var spawn_points = self.get_children()

var desk_scene = preload("res://Tasks/Desk.tscn")
var desk_with_task_scene = preload("res://Tasks/DeskWithTask.tscn")

func _ready():
	randomize()
	var chosen = randi() % spawn_points.size()
	for i in spawn_points.size():
		var desk = desk_with_task_scene.instantiate() if i == chosen else desk_scene.instantiate()
		desk.position = spawn_points[i].position
		add_child(desk)
