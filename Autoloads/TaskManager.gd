extends Node

var TasksIds = {
	SEND_MAIL = "send-mail",
	SEND_REPORT = "send-report",
	SCAN_DOC = "scan-doc",
	FIX_BUG = "fix-bug",
	ORDER_DOCS = "order-docs",
	SOCIALIZE = "socialize",
	DRINK_COFFEE = "drink-coffee",
}
var tasks = {}

func _ready() -> void:
	create_tasks()

## Creates tasks for the player
func create_tasks() -> void:
	var sendMailTask: Task = Task.init(TasksIds.SEND_MAIL, "Send email", 40.0, 0.0, 5.0)
	tasks[TasksIds.SEND_MAIL] = sendMailTask
	var scanDocTask: Task = Task.init(TasksIds.SCAN_DOC, "Scan document", 10.0, 0.0, 2.0)
	tasks[TasksIds.SCAN_DOC] = scanDocTask
	var drinkCoffeeTask: Task = Task.init(TasksIds.DRINK_COFFEE, "Drink coffee", 10.0, 0.0, 2.0)
	tasks[TasksIds.DRINK_COFFEE] = drinkCoffeeTask
