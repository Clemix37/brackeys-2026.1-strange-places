extends CanvasLayer

@onready var try_again_btn: Button = %TryAgainBtn
@onready var menu_btn: Button = %MenuBtn
@onready var hud: CanvasLayer = %HUD

func _ready() -> void:
	menu_btn.pressed.connect(go_to_menu)
	try_again_btn.pressed.connect(play_again)

func reset() -> void:
	TaskManager.reset_tasks()
	GameManager.reset_game()

func go_to_menu() -> void:
	reset()
	# Menu scene
	GameManager.change_scene("uid://ctev7e6c6tvyt", "")

func play_again() -> void:
	reset()
	# Main scene
	GameManager.change_scene("uid://vnucto88mppj", "")
