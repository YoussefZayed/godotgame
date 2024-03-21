extends Node2D

@onready var player = $Player
@onready var projectiles = $Projectiles

# Called when the node enters the scene tree for the first time.
func _ready():
	player.player_shot_projectile.connect(projectiles.handleProjectiles)

