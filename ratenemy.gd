extends RigidBody2D

@export var speed = 150
@export var knockbackForce = 50
var player_chase = false
@onready var player = get_tree().get_nodes_in_group("characters")[get_tree().get_nodes_in_group("characters").size() - 1]
var health = 3
var spawnedCoin = false
var isDieing = false
var loopMult = 1
@export var damage = 2
@export var coin = preload("res://coin.tscn")
@onready var healthbar = $HealthBar

func _ready():
	loopMult = pow(1.5, get_tree().root.get_node("/root/Main").loopNum)
	health = health *loopMult
	speed = speed * loopMult
	damage = damage * loopMult
	$AnimatedSprite2D.play("default")
	healthbar.init_health(health)

func _physics_process(delta):
	if player_chase and !isDieing:
		get_node("AnimatedSprite2D").play("default")
		var distance = player.position - position
		var direction = distance.normalized()
		position += direction * speed * delta
		if (player.position.x - position.x) <0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	
	if self.health <= 0 && !isDieing:
		isDieing = true
		self.death()

func enemyHit(amount):
	print("RAT HIT")
	health -= amount
	healthbar.health = health
	$EnemyHurt.play()
	
func spawnCoin():
	if !spawnedCoin :
		spawnedCoin = true
		var newCoin = coin.instantiate()
		newCoin.position = self.position
		get_parent().add_child(newCoin)
		

func death():
	$EnemyDeath.play()
	player_chase = false
	print("DEAD")
	player.kills += 1
	set_physics_process(false)
	linear_velocity = Vector2.ZERO
	set_sleeping(true)
	sleeping = true
	self.freeze = true
	$CollisionShape2D.set_deferred("disabled", true)
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	get_node("AnimatedSprite2D").play("death")
	await get_node("AnimatedSprite2D").animation_finished
	spawnCoin()
	self.queue_free()
	

func _on_detection_area_body_entered(body):
	if body is Player:
		player = body
		player_chase = true
	

#func _on_detection_area_body_exited(_body):
	#player = null
	#player_chase = false

func knockedBack():
	var knockBack = (player.position - position).normalized()
	apply_central_force(-knockBack * knockbackForce * 100)

func _on_body_entered(body):
	if body is Player:
		knockedBack()
		body.playerHit(damage)
		print("Player HIT Player health is: ")
		print(body.health)


func _on_hurt_box_area_entered(area):
	if area.name == "Ruler" && !isDieing && player:
		self.enemyHit(player.rulerDamage)
		print("Enemy health: ", health)
		knockedBack()
		
	if area.name == "PowerPointAbility" && player:
		self.enemyHit(player.ult_damage)
		print("Enemy health: ", health)
		knockedBack()
		
	if area.name == "Projectile":
		self.enemyHit(area.damageDone)
		print("Enemy health: ", health)
		#knockedBack()

