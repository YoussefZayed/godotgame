extends Area2D

var speed = 100

func _ready():
	set_as_top_level(true)

func _process(delta):
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta

