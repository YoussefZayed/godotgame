extends CharacterBody2D


@export var speed = 300.0
var direction = Vector2.ZERO
#const JUMP_VELOCITY = -400.0

func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		direction = Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		direction = Vector2.LEFT
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		direction = Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		direction = Vector2.UP
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
