extends Area2D

var player = null



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
