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
@export var resetCount = 0
var dir = Vector2.ZERO
@onready var anim = $AnimatedSprite2D
@onready var weapAnim = $AnimationPlayer
@onready var weapon = $Weapon
@onready var weaponCollision = $Weapon/Ruler/CollisionShape2D
@onready var healthbar = $CanvasLayer/HealthBar
@onready var eraserIcon1 = $CanvasLayer/EraserIcon1
@onready var eraserIcon2 = $CanvasLayer/EraserIcon2
@onready var eraserIcon3 = $CanvasLayer/EraserIcon3
@onready var abilityCharge = $CanvasLayer/AbilityCharge
@onready var pointerIcon = $CanvasLayer/PointerIcon
@onready var rKey = $CanvasLayer/RKey
var ult_ability_active = false
var ult_ability = preload("res://power_point_ability.tscn")
@export var projectile = preload("res://projectile.tscn")
@onready var shoot_position = $ShootPosition
var ult_charged = false
var ult_damage = 150
var proj_damage = 2
var projAvailable = 3
var kills = 0


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
	health += 35
	if health > maxHealth:
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
	

func _process(_delta):
	ResetsSingleton.resets = resetCount
	
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
		if !$Walking.is_playing():
			$Walking.play()
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
		$Walking.stop()
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
			
	# Projectile Replenish UI
	if projAvailable >= 3:
		eraserIcon1.show()
		eraserIcon2.show()
		eraserIcon3.show()
	elif projAvailable == 2:
		eraserIcon1.show()
		eraserIcon2.show()
		eraserIcon3.hide()
	elif projAvailable == 1:
		eraserIcon1.show()
		eraserIcon2.hide()
		eraserIcon3.hide()
	else:
		eraserIcon1.hide()
		eraserIcon2.hide()
		eraserIcon3.hide()
	

	
	if ult_ability_active:
		abilityCharge.set_visible(true)
		pointerIcon.set_visible(true)
		rKey.set_visible(true)
		if (kills < 10):
			pointerIcon.modulate.a = 0.5
			ult_charged = false
		else:
			kills = 10
			ult_charged = true
			pointerIcon.modulate.a = 1
	else:
		kills = 0
			
	
	if Input.is_action_just_pressed("use_ult") and ult_charged and ult_ability_active:
		$UltAbility.play()
		kills = 0
		var ult_instance = ult_ability.instantiate()
		ult_instance.rotation = $Marker2D.rotation
		ult_instance.global_position = $Marker2D.global_position
		add_child(ult_instance)
	
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
		if projAvailable > 0:
			shoot()
			$LoopTimer.stop()
			$ReplenishTimer.start(2)
	
	await weapAnim.animation_finished
	weapon.visible = false
	weaponCollision.set_deferred("disabled", true)
	
func shoot():
	projAvailable -= 1
	
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


func _on_replenish_timer_timeout():
	$LoopTimer.start()


func _on_loop_timer_timeout():
	if projAvailable < 3:
		projAvailable += 1
	else:
		$LoopTimer.stop()
