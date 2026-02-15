extends Control

# Variables
@onready var play_btn: Button = %PlayBtn
@onready var quit_btn: Button = %QuitBtn

# Au chargement du script
func _ready() -> void:
	quit_btn.pressed.connect(GameManager.quit_game)
	play_btn.pressed.connect(play_game)

## Transitionne vers la scène de jeu
func play_game() -> void:
	GameManager.change_scene("res://Rooms/BreakRoom.tscn")
