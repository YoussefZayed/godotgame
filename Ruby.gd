extends Area2D

@export var value = 100
var player:Player


func _on_body_entered(body):
	if body is Player:
		player = body
		
		player.collectMoney(value)
		queue_free()
		$CollisionShape2D.queue_free()
