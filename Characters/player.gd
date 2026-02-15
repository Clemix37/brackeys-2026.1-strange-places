extends CharacterBody2D

const SPEED = 300.0

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
