extends CharacterBody2D


const SPEED = 300.0

func _physics_process(delta):
	
	var direction = Input.get_vector("move_left", "move_right","move_up", "move_down").normalized()
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
