extends Node

signal updated_tasks

const TasksIds = {
	SEND_MAIL = "send-mail",
	SEND_SCANNED_REPORT = "send-scanned-report",
	SCAN_DOC = "scan-doc",
	FIX_BUG = "fix-bug",
	ORDER_DOCS = "order-docs",
	SOCIALIZE = "socialize",
	DRINK_COFFEE = "drink-coffee", # should not be written on task list
	
	PRINT_DOCS = "print-docs",
	PICKUP_PRINTED_DOCS = "pickup-printed-docs"
}
const DeskTasks = [TasksIds.SEND_MAIL, TasksIds.FIX_BUG, TasksIds.PRINT_DOCS, TasksIds.SEND_SCANNED_REPORT]
var tasks: Dictionary[String, Task] = {}
var visible_tasks: Dictionary[String, Task] = {}

func _ready() -> void:
	create_tasks()

## Creates tasks for the player
func create_tasks() -> void:
	var sendMailTask: Task = Task.init(TasksIds.SEND_MAIL, "Send email", "Sending...", 40.0, 5.0)
	add_task(sendMailTask)
	var sendScanDoc: Task = Task.init(TasksIds.SEND_SCANNED_REPORT, "Send scanned report", "Sending...", 20.0, 3.0)
	var scanDocTask: Task = Task.init(TasksIds.SCAN_DOC, "Scan document", "Scanning...", 10.0, 2.0, sendScanDoc)
	add_task(scanDocTask)
	var drinkCoffeeTask: Task = Task.init(TasksIds.DRINK_COFFEE, "Drink coffee", "Drinking...", -10.0, 2.0)
	add_task(drinkCoffeeTask, false)
	
	var pickupPrintedDocsTask = Task.init(TasksIds.PICKUP_PRINTED_DOCS, "Pick up printed docs", "Picking up...", 5.0, 1.0)
	add_task(pickupPrintedDocsTask, false)
	var printDocsTask = Task.init(TasksIds.PRINT_DOCS, "Print documents", "Printing...", 10.0, 2.0, pickupPrintedDocsTask)
	add_task(printDocsTask)

func add_task(task: Task, visible: bool = true):
	tasks[task.id] = task
	task.task_completed.connect(_on_task_completed)
	if visible: 
		visible_tasks[task.id] = task
	
func _on_task_completed(task: Task):
	tasks.erase(task.id)
	if visible_tasks.has(task.id):
		visible_tasks.erase(task.id)
	if task.next:
		add_task(task.next)
	updated_tasks.emit()

func get_task_by_id(id_task: String) -> Task:
	if !tasks.has(id_task): return null
	return tasks.get(id_task)

## Resets the current tasks
func reset_tasks() -> void:
	tasks = {}
	visible_tasks = {}
	create_tasks()
