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

static func init(task_id: String, task_name: String, working: String, task_mental_damage: float = 10.0, task_duration: float = 2.0, next_task: Task = null) -> Task:
	var new = Task.new()
	new.id = task_id
	new.name = task_name
	new.working_msg = working
	new.mental_damage = task_mental_damage
	new.duration = task_duration
	new.next = next_task
	new.completed = false
	return new

func complete() -> void:
	print(name + " completed in Task")
	completed = true
	task_completed.emit(self)
