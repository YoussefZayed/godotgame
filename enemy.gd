extends RigidBody2D

@export var speed = 75
@export var knockbackForce =20
var player_chase = false
var player = null


func _physics_process(delta):
	if player_chase:
		var distance = player.position - position
		var direction = (distance).normalized()
		apply_impulse(direction * speed * delta)
		position += (player.position - position)/speed
		if (player.position.x - position.x) <0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false



func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	

#func _on_detection_area_body_exited(_body):
	#player = null
	#player_chase = false


func _on_body_entered(body):
	if body is Player:
		print("Player HIT Player health is: ")
		print(body.health)
		var knockBack = (player.position - position).normalized()
		apply_impulse(-knockBack * knockbackForce)
		body.playerHit(5)



