extends Control

# Variables
@onready var play_btn: Button = %PlayBtn
@onready var quit_btn: Button = %QuitBtn
@onready var office_lvl_btn: Button = %OfficeLvlBtn
@onready var break_room_lvl_btn: Button = %BreakRoomLvlBtn

# Au chargement du script
func _ready() -> void:
	quit_btn.pressed.connect(GameManager.quit_game)
	play_btn.pressed.connect(play_game)
	office_lvl_btn.pressed.connect(play_office)
	break_room_lvl_btn.pressed.connect(play_break_room)

## Transitionne vers la scène de jeu
func play_game() -> void:
	GameManager.change_scene("res://Rooms/BreakRoom.tscn")

# TO DELETE AFTER PUBLISH 

func play_office() -> void:
	GameManager.change_scene("res://Rooms/Office.tscn")
	
func play_break_room() -> void:
	GameManager.change_scene("res://Rooms/BreakRoom.tscn")
