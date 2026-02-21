extends Control

@onready var try_again_btn: Button = %TryAgainBtn
@onready var main_menu_btn: Button = %MainMenuBtn
@onready var win_sfx: AudioStreamPlayer2D = %WinSfx

func _ready() -> void:
	try_again_btn.pressed.connect(_on_try_again_pressed)
	main_menu_btn.pressed.connect(_on_menu_pressed)
	win_sfx.play()

func _on_try_again_pressed() -> void:
	GameManager.try_again()

func _on_menu_pressed() -> void:
	GameManager.reset_tasks_and_game()
	GameManager.go_to_menu()
