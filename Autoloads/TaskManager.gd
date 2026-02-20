extends Node

signal updated_tasks

const TasksIds = {
	SEND_MAIL = "send-mail",
	SEND_SCANNED_REPORT = "send-scanned-report",
	SCAN_DOC = "scan-doc",
	FIX_BUG = "fix-bug",
	ORDER_PAPER = "order-paper",
	SOCIALIZE = "socialize",
	DRINK_COFFEE = "drink-coffee", # should not be written on task list
	
	PRINT_DOCS = "print-docs",
	PICKUP_PRINTED_DOCS = "pickup-printed-docs",
	RANDOM_MEETING = "random-meeting",
	RANDOM_CLIENT_CALL = "random-client-call"
}
var tasks_descriptions: Dictionary[String, String] = {}
const DeskTasks = [TasksIds.SEND_MAIL, TasksIds.FIX_BUG, TasksIds.PRINT_DOCS, TasksIds.SEND_SCANNED_REPORT, TasksIds.ORDER_PAPER]
var tasks: Dictionary[String, Task] = {}
var visible_tasks: Dictionary[String, Task] = {}
var random_event_tasks: Dictionary[String, Task] = {}
var current_random_task: Task = null

func _ready() -> void:
	create_tasks()
	create_random_tasks()
	create_tasks_descriptions()

## Creates tasks for the player
func create_tasks() -> void:
	# Send mail
	var sendMailTask: Task = Task.init(TasksIds.SEND_MAIL, "Send email", "Sending...", 40.0, 5.0)
	add_task(sendMailTask)
	# Scan doc, send scanned report
	var sendScanDoc: Task = Task.init(TasksIds.SEND_SCANNED_REPORT, "Send scanned report", "Sending...", 20.0, 3.0)
	var scanDocTask: Task = Task.init(TasksIds.SCAN_DOC, "Scan document", "Scanning...", 10.0, 2.0, sendScanDoc)
	add_task(scanDocTask)
	# Drink coffee to restore life
	var drinkCoffeeTask: Task = Task.init(TasksIds.DRINK_COFFEE, "Drink coffee", "Drinking...", -10.0, 2.0)
	add_task(drinkCoffeeTask, false)
	# Fix bug
	var fixBugTask: Task = Task.init(TasksIds.FIX_BUG, "Fix bug", "Fixing it...", 15.0, 4.0)
	add_task(fixBugTask, false)
	# Print docs, pickup them, order paper
	var orderPaperTask: Task = Task.init(TasksIds.ORDER_PAPER, "Order paper", "Ordering...", 5, 3.0)
	var pickupPrintedDocsTask = Task.init(TasksIds.PICKUP_PRINTED_DOCS, "Pick up printed docs", "Picking up...", 5.0, 1.0, orderPaperTask)
	add_task(pickupPrintedDocsTask, false)
	var printDocsTask = Task.init(TasksIds.PRINT_DOCS, "Print documents", "Printing...", 10.0, 2.0, pickupPrintedDocsTask)
	add_task(printDocsTask)

## Create tasks that are random
func create_random_tasks() -> void:
	random_event_tasks[TasksIds.RANDOM_MEETING] = Task.init(TasksIds.RANDOM_MEETING, "Meeting", "Listening...", 30.0, 4.0)
	random_event_tasks[TasksIds.RANDOM_CLIENT_CALL] = Task.init(TasksIds.RANDOM_CLIENT_CALL, "Calling client", "Listening...", 10.0, 3.0)

## Create tasks descriptions
func create_tasks_descriptions() -> void:
	tasks_descriptions[TasksIds.RANDOM_MEETING] = "Hurry-up ! A useless meeting is starting !"
	tasks_descriptions[TasksIds.RANDOM_CLIENT_CALL] = "What can i hear ? Your phone is ringing, an important client is calling, go pick it up !"

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

## Gets the task by its id
func get_task_by_id(id_task: String) -> Task:
	if !tasks.has(id_task): return null
	return tasks.get(id_task)

## Gets the task description by its id
func get_description_of_task_by_id(id_task: String) -> String:
	if !tasks_descriptions.has(id_task): return ""
	return tasks_descriptions.get(id_task)

## Resets the current tasks
func reset_tasks() -> void:
	tasks = {}
	visible_tasks = {}
	create_tasks()

## Set a task that is not currently visible as visible
func set_task_visible(task_id: String) -> void:
	if !tasks.has(task_id) or visible_tasks.has(task_id): return
	var the_task: Task = tasks.get(task_id)
	visible_tasks[task_id] = the_task

func add_random_task(task: Task) -> void:
	current_random_task = task
	add_task(task)
	updated_tasks.emit()
