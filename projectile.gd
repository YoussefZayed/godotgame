extends Area2D

@export var speed = 5.0
var direction := Vector2.ZERO
var damageDone = 7
var playerDamage = 2
var enemy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Length.start()
	var loopMult = pow(1.5, get_tree().root.get_node("/root/Main").loopNum)
	damageDone = damageDone * loopMult
	speed = speed * loopMult

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction

func _on_body_entered(body):
	if enemy:
		if body.has_method("playerHit"):
			self.hide()
			body.playerHit(damageDone)
			self.queue_free()
		elif body.is_in_group("walls"):
			self.hide()
			self.queue_free()
	else:
		if body.has_method("enemyHit"):
			self.hide()
			body.enemyHit(playerDamage)
			self.queue_free()
		elif body.is_in_group("walls") or body.name == "RatBoss":
			self.hide()
			self.queue_free()

func playFireball():
	$AnimatedSprite2D.play("fireball")

func playEraser():
	$AnimatedSprite2D.play("eraser")

func enemyAttack(attack):
	enemy = attack


func _on_length_timeout():
	self.hide()
	self.queue_free()
