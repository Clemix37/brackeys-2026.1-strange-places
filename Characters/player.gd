extends CharacterBody2D

@onready var tile_map_layer_ground_objects: TileMapLayer = $"../Tiles/TileMapLayerGroundObjects"
@onready var highlight_rect: ColorRect = $HighlightRect

@export var interact_distance: float = 32.0
const SPEED = 300.0
var current_cell: Vector2i = Vector2i.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	
	var isGoingRight: bool = Input.is_action_pressed("move_right")
	var isGoingLeft: bool = Input.is_action_pressed("move_left")
	var isGoingUp: bool = Input.is_action_pressed("move_up")
	var isGoingDown: bool = Input.is_action_pressed("move_down")
	
	
	if isGoingRight:
		dir.x += 1
	if isGoingLeft:
		dir.x -= 1
	if isGoingUp:
		dir.y -= 1
	if isGoingDown:
		dir.y += 1
	
	velocity = dir.normalized() * SPEED
	move_and_slide()
	check_interaction()

func check_interaction():
	var local_pos = tile_map_layer_ground_objects.to_local(global_position)
	var cell = tile_map_layer_ground_objects.local_to_map(local_pos)
	
	var tile_data = tile_map_layer_ground_objects.get_cell_tile_data(cell)
	if tile_data:
		highlight_tile(cell)
		current_cell = cell
	else:
		remove_highlight()


func highlight_tile(cell):
	highlight_rect.visible = true
	highlight_rect.global_position = tile_map_layer_ground_objects.map_to_local(cell)

func remove_highlight():
	highlight_rect.visible = false
