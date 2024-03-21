extends CharacterBody2D
class_name Player

@export var speed = 200.0
@export var maxHealth = 100
@export var money = 0
@export var health = 100
@export var damage = 10
var dir = Vector2.ZERO
@onready var anim = $AnimatedSprite2D
@onready var weapAnim = $AnimationPlayer
@onready var weapon = $Weapon
@onready var weaponCollision = $Weapon/Ruler/CollisionShape2D
var ult_ability = preload("res://power_point_ability.tscn")
var ult_cooldown = true
var ult_damage = 50

signal enemy_hit(damage, body)

func playerHit(amount): 
	health -= amount
	$PlayerHurt.play()
	if health <= 0:
		self.death()
	
func collectMoney(amount):
	$PickupCoin.play()
	money += amount
	return money

func death():
	get_tree().change_scene_to_file("res://game_over.tscn")

func _ready():
	weapon.visible = false
	weaponCollision.set_deferred("disabled", true)

func use_ult_ability():
	ult_ability
	

func _process(delta):
	var direction = Input.get_vector("move_left", "move_right","move_up", "move_down").normalized()
	
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_pressed("move_right"):
		dir = Vector2.RIGHT
		
	if Input.is_action_pressed("move_left"):
		dir = Vector2.LEFT
		
	if Input.is_action_pressed("move_up"):
		dir = Vector2.UP
		
	if Input.is_action_pressed("move_down"):
		dir = Vector2.DOWN
	#
	# Dictate all the animations
	if velocity.length() > 0:
		if dir == Vector2.UP:
			anim.play("walk_back")
		elif dir == Vector2.DOWN:
			anim.play("walk_front")
		elif dir == Vector2.LEFT:
			anim.play("walk_side");
			anim.flip_h = true
		else:
			anim.play("walk_side");
			anim.flip_h = false
	else:
		if dir == Vector2.RIGHT:
			anim.play("idle_side");
			anim.flip_h = false
		elif dir == Vector2.LEFT:
			anim.play("idle_side");
			anim.flip_h = true
		elif dir == Vector2.UP:
			anim.play("idle_back")
		else:
			anim.play("idle_front")
	
	
	if Input.is_action_just_pressed("use_ult") and ult_cooldown:
		$UltAbility.play()
		ult_cooldown = false
		var ult_instance = ult_ability.instantiate()
		ult_instance.rotation = $Marker2D.rotation
		ult_instance.global_position = $Marker2D.global_position
		add_child(ult_instance)
		
		await get_tree().create_timer(5).timeout
		ult_cooldown = true
	
	if Input.is_action_just_pressed("attack_melee"):
		weapon.visible = true
		weaponCollision.set_deferred("disabled", false)
		if dir == Vector2.RIGHT:
			weapAnim.play("ruler_attack_right");
		elif dir == Vector2.LEFT:
			weapAnim.play("ruler_attack_left");
		elif dir == Vector2.UP:
			weapAnim.play("ruler_attack_back")
		else:
			weapAnim.play("ruler_attack_front")
		
	await weapAnim.animation_finished
	weapon.visible = false
	weaponCollision.set_deferred("disabled", true)
	

