extends ShopItem


func _process(delta):
	checkIsDisabled(false)
	if (!isDisabled):
		$Button.visible = true
	else:
		$Button.visible = false
	$CostLabel.text = "Cost: " + str(cost)
	$useLabel.text = "# Left: " + str(maxNumberOfTimesBought-numberOfTimesBought)



func upgradeRuler():
	player.upgradeRuler()

func _on_area_2d_body_entered(body):
	if body is Player:
		player = body
		
func _on_area_2d_body_exited(body):
	if body is Player:
		player = null
		
func _on_button_pressed():
	buyItem(upgradeRuler)
