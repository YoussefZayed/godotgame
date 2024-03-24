extends Node2D

@onready var player = $Player
@onready var projectiles = $Projectiles
@export var level: PackedScene
var playerPos
@export var loopNum = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player.player_shot_projectile.connect(projectiles.handleProjectiles)
	playerPos = player.position

	
func newRound():
	loopNum += 1
	player.position = playerPos
	self.get_children()[0].queue_free()
	var newLevel = level.instantiate()
	self.add_child(newLevel)
	move_child(newLevel,0)
