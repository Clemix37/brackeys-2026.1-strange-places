extends CharacterBody2D

const DEFAULT_SPEED = 300.0
var lastDir = Vector2.ZERO

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	if !GameManager.player_can_move: return
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
	
	# Speed increasing by taking coffee
	velocity = dir.normalized() * (DEFAULT_SPEED + GameManager.nb_coffee_taken * GameManager.SPEED_INCREASE_PER_COFFEE)
	
	# Player is NOT moving
	if dir.length() == 0:
		if lastDir.x == 1:
			animated_sprite.play("idle_right")
		elif lastDir.x == -1:
			animated_sprite.play("idle_left")
		elif lastDir.y == -1:
			animated_sprite.play("idle_up")
		elif lastDir.y == 1:
			animated_sprite.play("idle_down")
		else:
			animated_sprite.play("idle_down")
	# Player is moving
	else:
		lastDir = dir
		if dir.x == 1:
			animated_sprite.play("run_right")
		elif dir.x == -1:
			animated_sprite.play("run_left")
		elif dir.y == -1:
			animated_sprite.play("run_up")
		elif dir.y == 1:
			animated_sprite.play("run_down")
	
	move_and_slide()
