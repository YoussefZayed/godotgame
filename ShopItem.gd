extends Node2D

class_name ShopItem
var player: Player
var isDisabled = false
@export var cost = 100
@export var costIncreaseMultiplier = 1.5
@export var numberOfTimesBought = 0
@export var maxNumberOfTimesBought = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkIsDisabled(false)
	
func checkIsDisabled(shouldDisable):
	if !player || numberOfTimesBought >= maxNumberOfTimesBought ||  player.money < cost || shouldDisable:
		isDisabled = true
	else:
		isDisabled = false


	
func buyItem(callback:Callable):
	if  !isDisabled:
		player.money -= cost
		cost *=  costIncreaseMultiplier
		cost = roundi(cost)
		numberOfTimesBought += 1
		callback.call()
	else:
		print("Can not Buy Item")