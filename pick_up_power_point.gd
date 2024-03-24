extends Area2D

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Player:  
		'''and $PickUp.is_playing() == false'''
		player = body
		player.ultAbilityActive(true)
		self.hide()
		$PickUp.play()
		#await $PickUp.play()
		get_tree().root.get_child(0).newRound()
		self.queue_free()
