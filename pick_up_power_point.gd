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
		player.health = player.maxHealth
		player.healthbar.health = player.health
		player.resetCount += 1
		player.projAvailable = 3
		get_tree().root.get_node("/root/Main").newRound()
		self.queue_free()
