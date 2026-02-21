extends Node

# Signals
signal mental_health_changed(mental_health_value: float)
signal room_name_changed(room_name: String)
signal is_game_over_called

# Variables
var mental_health: float = 100.0
var current_scene: Node
var current_room: String
# Game state variables
var is_paused: bool = false
var is_game_over: bool = false
var player_can_move: bool = true
# Transition variables
var is_transitioning: bool = false
var fade_layer: CanvasLayer
var fade_rect: ColorRect
var tween: Tween

const RoomNames = {
	BREAK_ROOM = "Break Room",
	OPEN_SPACE = "Open Space"
}

## Au chargement du script
func _ready() -> void:
	reset_game()
	_create_fade_layer() # seront utilisées plus tard pour les transitions

# Mental health
func set_mental_health(value: float) -> void:
	# Not less than 0 (died), not more than 100 (full heal)
	mental_health = clamp(value, 0, 100)
	mental_health_changed.emit(mental_health)

# Scene transitions

## Transitions de scènes
func change_scene(path: String, room_name: String) -> void:
	if is_transitioning: return
	is_transitioning = true
	# transition vers fondu noir
	await fade_in()
	# change la scène
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame # juste avant que la première frame se lance
	current_scene = get_tree().current_scene
	current_room = room_name
	# fondu au noir vers la scène que nous venons d'ajouter
	await fade_out()
	is_transitioning = false
	room_name_changed.emit(current_room)

## Crée un canvas layer sur la scène actuelle
## Puis un color_rect qui permettront d'avoir une couleur unie de transition plus tard
func _create_fade_layer():
	fade_layer = CanvasLayer.new()
	fade_layer.layer = 100 # sommes sûrs qu'il est au-dessus du reste
	add_child(fade_layer)
	
	fade_rect = ColorRect.new()
	fade_rect.color = Color.BLACK
	fade_rect.size = get_viewport().get_visible_rect().size
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE # Ignorer la souris
	fade_rect.modulate.a = 0.0 # Actuellement transparent
	
	fade_layer.add_child(fade_rect)

## Crée le tween qui supprimera la transparence du fade_rect
func fade_in(duration: float = 0.4) -> void:
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, duration)
	await tween.finished

## Crée le tween qui ajoutera la transparence du fade_rect
func fade_out(duration: float = 0.4) -> void:
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, duration)
	await tween.finished

# Game state

## Mets le jeu en pause
func pause_game() -> void:
	# variable globale à Godot
	if is_paused: return
	is_paused = true
	get_tree().paused = true

## Reprends le jeu qui avait été mis en pause
func resume_game() -> void:
	# variable globale à Godot
	if not is_paused: return
	is_paused = false
	get_tree().paused = false

## Ferme le jeu
func quit_game() -> void:
	get_tree().quit()

## Resets the game values
func reset_game() -> void:
	current_scene = get_tree().current_scene
	current_room = ""
	player_can_move = true
	set_mental_health(100.0) # Will reset the shader if connected
	resume_game()

func set_is_game_over() -> void:
	is_game_over = true
	is_game_over_called.emit()
	pause_game()
