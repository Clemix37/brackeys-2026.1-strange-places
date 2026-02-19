extends CharacterBody2D

const SPEED = 300.0

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

var lastDir = Vector2.ZERO

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
