extends Area2D

@export var speed = 5.0
var direction := Vector2.ZERO
var damageDone = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("fireball")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction

func _on_body_entered(body):
	if body.has_method("playerHit"):
		self.hide()
		body.playerHit(damageDone)
		self.queue_free()
