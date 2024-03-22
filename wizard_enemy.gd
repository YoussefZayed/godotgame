extends CharacterBody2D

@export var speed = 75
@export var knockbackForce = 25
var player_chase = false
var player = null
var health = 30
var spawned1Coin = false
var spawned2Coin = false
var isDieing = false
@export var coin = preload("res://coin.tscn")
@export var projectile = preload("res://projectile.tscn")
@onready var shoot_position = $ShootPosition
@onready var healthbar = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	healthbar.init_health(health)

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
	healthbar.health = health
	$EnemyHurt.play()

func death():
	$ShootProjectile.stop()
	$EnemyDeath.play()
	player_chase = false
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	get_node("AnimatedSprite2D").play("death")
	await get_node("AnimatedSprite2D").animation_finished
	spawnCoin()
	spawnCoin()
	self.queue_free()

func spawnCoin():
	if !spawned1Coin or !spawned2Coin:
		if spawned1Coin:
			spawned2Coin = true
		spawned1Coin = true
		var newCoin = coin.instantiate()
		newCoin.position = self.position
		get_parent().add_child(newCoin)

func _on_detection_area_body_entered(body):
	if body is Player:
		player = body
		player_chase = true
		$ShootProjectile.start()

func knockedBack():
	var knockbackDirection = player.position.direction_to(self.position)
	var knockback = knockbackDirection * knockbackForce
	global_position += knockback
	move_and_slide()

func _on_hurt_box_area_entered(area):
	if area.name == "Ruler" && player:
		self.enemyHit(player.rulerDamage)
		print("Enemy health: ", health)
		knockedBack()
		
	if area.name == "PowerPointAbility" && player:
		self.enemyHit(player.ult_damage)
		print("Enemy health: ", health)
		knockedBack()
	
func _on_shoot_projectile_timeout():
	shoot()

func shoot():
	var projectile_instance = projectile.instantiate()
	projectile_instance.global_position = shoot_position.global_position
	
	var target = player.global_position
	var direction_to_target = projectile_instance.global_position.direction_to(target).normalized()
	projectile_instance.set_direction(direction_to_target)
	projectile_instance.playFireball()
	projectile_instance.enemyAttack(true)
	projectile_instance.look_at(target)
	get_tree().get_current_scene().add_child(projectile_instance)
