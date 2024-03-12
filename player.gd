extends RigidBody2D
class_name Player

@export var speed = 200.0
@export var maxHealth = 100
@export var money = 0
@export var health = 100
var direction = Vector2.ZERO
@onready var anim = $AnimatedSprite2D
@onready var weapAnim = $AnimationPlayer
@onready var weapon = $Weapon
@onready var weaponCollision = $Weapon/Ruler/CollisionShape2D
signal enemy_hit(damage, body)

func playerHit(amount): 
	health -= amount
	
func collectMoney(amount):
	money += amount
	return money

func _ready():
	weapon.visible = false
	weaponCollision.set_deferred("disabled", true)

func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		direction = Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		direction = Vector2.LEFT
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		direction = Vector2.UP
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		direction = Vector2.DOWN
	
	# Dictate all the animations
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if direction == Vector2.UP:
			anim.play("walk_back")
		elif direction == Vector2.DOWN:
			anim.play("walk_front")
		elif direction == Vector2.LEFT:
			anim.play("walk_side");
			anim.flip_h = true
		else:
			anim.play("walk_side");
			anim.flip_h = false
	else:
		if direction == Vector2.RIGHT:
			anim.play("idle_side");
			anim.flip_h = false
		elif direction == Vector2.LEFT:
			anim.play("idle_side");
			anim.flip_h = true
		elif direction == Vector2.UP:
			anim.play("idle_back")
		else:
			anim.play("idle_front")
	
	if velocity != Vector2.ZERO:
		position += velocity * delta
	
	if Input.is_action_just_pressed("attack_melee"):
		weapon.visible = true
		weaponCollision.set_deferred("disabled", false)
		if direction == Vector2.RIGHT:
			weapAnim.play("ruler_attack_right");
		elif direction == Vector2.LEFT:
			weapAnim.play("ruler_attack_left");
		elif direction == Vector2.UP:
			weapAnim.play("ruler_attack_back")
		else:
			weapAnim.play("ruler_attack_front")
		
	await weapAnim.animation_finished
	weapon.visible = false
	weaponCollision.set_deferred("disabled", true)
