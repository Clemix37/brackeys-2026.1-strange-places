extends CanvasLayer

@onready var try_again_btn: Button = %TryAgainBtn
@onready var menu_btn: Button = %MenuBtn
@onready var hud: CanvasLayer = %HUD

func _ready() -> void:
	menu_btn.pressed.connect(go_to_menu)
	try_again_btn.pressed.connect(play_again)

func go_to_menu() -> void:
	GameManager.reset_tasks_and_game()
	# Menu scene
	GameManager.go_to_menu()

func play_again() -> void:
	GameManager.try_again()
