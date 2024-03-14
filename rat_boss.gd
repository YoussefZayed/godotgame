extends Node2D

var player = null
var health = 300
var bossBattle = false
var isDead = false
signal spawnRats(player)

@export var timer_secs = 6

func _ready():
	get_node("AnimatedSprite2D").play("default")
	
func _process(delta):
	if (health <= 0 && !isDead):
		die()

func die():
	isDead = true
	$EnemyDeath.play()
	get_node("AnimatedSprite2D").play("death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
	print("Queue freed")

func _on_hurt_area_entered(area):
	if area.name == "Ruler":
		$EnemyHurt.play()
		health -= 10
		print("Boss health: ", health)
		


func _on_spawn_rats_timeout():
	if (!isDead):
		$spawnRats.start(timer_secs * (health/300) + 1.75)
		emit_signal("spawnRats", player)


func _on_detection_area_body_entered(body):
	if body is Player:
		player = body
		if (!bossBattle):
			print("Battle Rats")
			$spawnRats.start(timer_secs)
			emit_signal("spawnRats",player)
			bossBattle = true
		
