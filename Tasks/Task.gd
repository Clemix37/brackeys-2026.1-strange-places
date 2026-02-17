extends Resource
class_name Task

var id: String
var name: String
var mental_damage: float
var mental_restore: float
var duration: float
var completed: bool

static func init(new_id: String, new_name: String, new_mental_damage: float = 10.0, new_mental_restore: float = 0.0, new_duration: float = 2.0, is_completed: bool = false) -> Task:
	var new = Task.new()
	new.id = new_id
	new.name = new_name
	new.mental_damage = new_mental_damage
	new.mental_restore = new_mental_restore
	new.duration = new_duration
	new.completed = is_completed
	return new

func set_as_complete() -> void:
	completed = true

func affect_mental_health() -> void:
	GameManager.set_mental_health(GameManager.mental_health - mental_damage + mental_restore)
