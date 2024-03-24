extends Node2D

var player = null
var health = 300
var bossBattle = false
var spawnedRuby = false
var spawnedPickUp = false
var isDead = false
signal spawnRats(player)

@export var ruby = preload("res://ruby.tscn")
@export var pick_up = preload("res://pick_up_power_point.tscn")
@export var timer_secs = 6
@onready var healthbar = $CanvasLayer/HealthBar
@onready var bossName = $CanvasLayer/Name

func _ready():
	get_node("AnimatedSprite2D").play("default")
	healthbar.init_health(health)
	
func _process(delta):
	if (health <= 0 && !isDead):
		self.die()
	
	
	

func spawnRuby():
	if !spawnedRuby :
		spawnedRuby = true
		var newRuby = ruby.instantiate()
		newRuby.position = self.position
		get_parent().add_child(newRuby)

func spawnPickUp():
	if !spawnedPickUp:
		spawnedPickUp = true
		var newPickUp = pick_up.instantiate()
		newPickUp.position = self.position
		newPickUp.position.y -= 200
		get_parent().add_child(newPickUp)

func die():
	isDead = true
	$EnemyDeath.play()
	$CollisionShape2D.set_deferred("disabled", true)
	#$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	get_node("AnimatedSprite2D").play("death")
	await get_node("AnimatedSprite2D").animation_finished
	spawnRuby()
	spawnPickUp()
	self.queue_free()
	print("Queue freed")

func _on_hurt_area_entered(area):
	if area.name == "Ruler" && player:
		health -= player.rulerDamage
		$EnemyHurt.play()
		print("Boss health: ", health)
	
	if area.name == "PowerPointAbility" && player:
		health -= player.ult_damage
		$EnemyHurt.play()
		print("Boss health: ", health)
		
	if area.name == "Projectile" && player:
		health -= player.proj_damage
		$EnemyHurt.play()
		print("Boss health: ", health)
	
	healthbar.health = health


func _on_spawn_rats_timeout():
	if (!isDead):
		$spawnRats.start(timer_secs * (health/300) + 1.75)
		emit_signal("spawnRats", player)


func _on_detection_area_body_entered(body):
	if body is Player:
		player = body
		if (!bossBattle):
			healthbar.set_visible(true)
			bossName.set_visible(true)
			print("Battle Rats")
			$spawnRats.start(timer_secs)
			emit_signal("spawnRats",player)
			bossBattle = true
			
	
