extends Resource
class_name Task

var id: String
var name: String
var working_msg: String # displayed text when doing task
var mental_damage: float # use negative value for restoring sanity
var duration: float
var completed: bool
var next: Task

signal task_completed(task: Task)

static func init(id: String, name: String, working: String, mental_damage: float = 10.0, duration: float = 2.0, next: Task = null) -> Task:
	var new = Task.new()
	new.id = id
	new.name = name
	new.working_msg = working
	new.mental_damage = mental_damage
	new.duration = duration
	new.next = next
	new.completed = false
	return new

func complete() -> void:
	print(name + " completed in Task")
	completed = true
	task_completed.emit(self)
