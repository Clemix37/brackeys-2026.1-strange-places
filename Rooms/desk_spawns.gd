extends Node2D

@onready var spawn_points = self.get_children()

var desk_scene = preload("res://Tasks/Desk.tscn")
var desk_with_task_scene = preload("res://Tasks/DeskWithTask.tscn")

func _ready():
	var deskTasks = []
	for task in TaskManager.tasks:
		if TaskManager.DeskTasks.has(task):
			deskTasks.push_back(TaskManager.tasks[task])
			
	var desks = []
	desks.resize(spawn_points.size())
	var indices = pick_k_indices(spawn_points.size(), deskTasks.size())
	for i in deskTasks.size():
		desks[indices[i]] = deskTasks[i]
	
	for i in spawn_points.size():
		if desks[i]:
			var desk: DeskWithTask = desk_with_task_scene.instantiate()
			desk.position = spawn_points[i].position
			desk.set_task(desks[i])
			add_child(desk)
		else:
			var desk = desk_scene.instantiate()
			desk.position = spawn_points[i].position
			add_child(desk)

func pick_k_indices(outOf: int, picked: int) -> Array[int]:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var indices: Array[int] = []
	for i in range(outOf):
		indices.append(i)

	indices.shuffle()
	return indices.slice(0, picked)
