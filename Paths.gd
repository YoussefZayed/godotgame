extends Node2D

@onready var bossFollower : PathFollow2D = $BossPath/BossFollower
@export var bossSpeed = 150
var activate = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if activate == true:
		bossFollower.progress += bossSpeed * delta
