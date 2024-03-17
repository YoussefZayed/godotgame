extends CharacterBody2D

@export var speed = 50
@export var knockbackForce = 100
var player_chase = false
var player = null
var health = 30
var spawnedCoin = false
var isDieing = false
@export var coin = preload("res://coin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_chase and !isDieing:
		var distance = player.position - position
		var direction = (distance).normalized()
		if position.distance_to(player.position) <= 150:
			direction = -direction
		
		velocity = direction * speed#
		move_and_slide()#
		
		if (player.position.x - position.x) <0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	
	if self.health <= 0 && !isDieing:
		isDieing = true
		self.death()

func enemyHit(damage):
	health -= damage
	$EnemyHurt.play()

func death():
	$EnemyDeath.play()
	player_chase = false
	#set_sleeping(true)
	velocity = Vector2.ZERO
	get_node("AnimatedSprite2D").play("death")
	await get_node("AnimatedSprite2D").animation_finished
	spawnCoin()
	self.queue_free()

func spawnCoin():
	if !spawnedCoin:
		spawnedCoin = true
		var newCoin = coin.instantiate()
		newCoin.position = self.position
		get_parent().add_child(newCoin)

func _on_detection_area_body_entered(body):
	if body is Player:
		player = body
		player_chase = true

func knockedBack():
	var knockBack = (player.position - position).normalized()
	#apply_impulse(-knockBack * knockbackForce)

func _on_hurt_box_area_entered(area):
	if area.name == "Ruler" && player:
		self.enemyHit(player.damage)
		print("Enemy health: ", health)
		knockedBack()
