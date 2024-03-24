extends CharacterBody2D
class_name Player
signal player_shot_projectile(projectile_instance)

@export var speed = 200.0
@export var money = 0
@export var maxHealth = 100
@export var health = 100
@export var damage = 10
@export var rulerDamage = 9.1
@export var rulerSpeed = 0.75
@export var rulerSize = 1.0
var dir = Vector2.ZERO
@onready var anim = $AnimatedSprite2D
@onready var weapAnim = $AnimationPlayer
@onready var weapon = $Weapon
@onready var weaponCollision = $Weapon/Ruler/CollisionShape2D
@onready var healthbar = $CanvasLayer/HealthBar
var ult_ability_active = false
var ult_ability = preload("res://power_point_ability.tscn")
@export var projectile = preload("res://projectile.tscn")
@onready var shoot_position = $ShootPosition
var ult_cooldown = true
var ult_damage = 50
var proj_damage = 2

signal enemy_hit(damage, body)

func upgradeRuler():
	rulerDamage *= 1.1
	rulerSpeed *= 1.025
	rulerSize *= 1.1
	weapAnim.speed_scale = rulerSpeed
	weapon.scale.x = rulerSize
	weapon.scale.y = rulerSize
	
func upgradeSpeed():
	speed *= 1.1
	


func playerHit(amount): 
	health -= amount
	$PlayerHurt.play()
	if health <= 0:
		self.death()
		
	healthbar.health = health

func heal():
	health = maxHealth
	healthbar.health = health
	
func collectMoney(amount):
	$PickupCoin.play()
	money += amount
	return money

func death():
	get_tree().change_scene_to_file("res://game_over.tscn")

func _ready():
	weapon.visible = false
	weaponCollision.set_deferred("disabled", true)
	healthbar.init_health(health)
	weapAnim.speed_scale = rulerSpeed


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
	
	
	if Input.is_action_just_pressed("use_ult") and ult_cooldown and ult_ability_active:
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
			
	if Input.is_action_just_pressed("attack_distance"):
		shoot()
	
	await weapAnim.animation_finished
	weapon.visible = false
	weaponCollision.set_deferred("disabled", true)
	
func shoot():
	var projectile_instance = projectile.instantiate()
	projectile_instance.global_position = shoot_position.global_position
	
	var target = get_global_mouse_position()
	var direction_to_target = projectile_instance.global_position.direction_to(target).normalized()
	projectile_instance.set_direction(direction_to_target)
	projectile_instance.playEraser()
	projectile_instance.enemyAttack(false)
	projectile_instance.look_at(target)
	player_shot_projectile.emit(projectile_instance)

func ultAbilityActive(isActive):
	ult_ability_active = isActive
