extends Node2D

@onready var white: TileMapLayer = %White
@onready var green: TileMapLayer = %Green
@onready var blue: TileMapLayer = %Blue
@onready var purple: TileMapLayer = %Purple

func _ready() -> void:
	change_sofas()

func change_sofas() -> void:
	reset_visibility_sofas()
	var sofas: Array[Node] = get_children()
	var health = GameManager.mental_health
	var percentage_chance = 1 - (health / 100.0)
	var random_chance = randf_range(0.0, 1.0)
	if percentage_chance < random_chance:
		toggle_activation_sofa(white, true)
		return
	var random_sofa: TileMapLayer = sofas.pick_random()
	toggle_activation_sofa(random_sofa, true)

func reset_visibility_sofas() -> void:
	toggle_activation_sofa(white, false)
	toggle_activation_sofa(green, false)
	toggle_activation_sofa(blue, false)
	toggle_activation_sofa(purple, false)

func toggle_activation_sofa(sofa_layer: TileMapLayer, activate: bool = true) -> void:
	sofa_layer.collision_enabled = activate 
	sofa_layer.visible = activate
