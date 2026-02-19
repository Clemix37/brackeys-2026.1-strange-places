extends Node

signal updated_tasks

const TasksIds = {
	SEND_MAIL = "send-mail",
	SEND_REPORT = "send-report",
	SCAN_DOC = "scan-doc",
	FIX_BUG = "fix-bug",
	ORDER_DOCS = "order-docs",
	SOCIALIZE = "socialize",
	DRINK_COFFEE = "drink-coffee",
	
	PRINT_DOCS = "print-docs",
	PICKUP_PRINTED_DOCS = "pickup-printed-docs"
}
const DeskTasks = [TasksIds.SEND_MAIL, TasksIds.SEND_REPORT, TasksIds.FIX_BUG, TasksIds.PRINT_DOCS]
var tasks: Dictionary[String, Task] = {}

func _ready() -> void:
	create_tasks()

## Creates tasks for the player
func create_tasks() -> void:
	var sendMailTask: Task = Task.init(TasksIds.SEND_MAIL, "Send email", "Sending...", 40.0, 5.0)
	add_task(sendMailTask)
	var scanDocTask: Task = Task.init(TasksIds.SCAN_DOC, "Scan document", "Scanning...", 10.0, 2.0)
	add_task(scanDocTask)
	var drinkCoffeeTask: Task = Task.init(TasksIds.DRINK_COFFEE, "Drink coffee", "Drinking...", -10.0, 2.0)
	add_task(drinkCoffeeTask)
	
	var pickupPrintedDocsTask = Task.init(TasksIds.PICKUP_PRINTED_DOCS, "Pick up printed docs", "Picking up...", 5.0, 1.0)
	var printDocsTask = Task.init(TasksIds.PRINT_DOCS, "Print documents", "Printing...", 10.0, 2.0, pickupPrintedDocsTask)
	add_task(printDocsTask)

func add_task(task: Task):
	tasks[task.id] = task
	task.task_completed.connect(_on_task_completed)
	
func _on_task_completed(task: Task):
	tasks.erase(task.id)
	if task.next:
		tasks[task.next.id] = task.next
	updated_tasks.emit()
	
	
