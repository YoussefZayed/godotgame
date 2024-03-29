extends Node2D

@export var ghostEnemy = preload("res://enemy.tscn")
@export var ratEnemy = preload("res://ratenemy.tscn")
@export var wizardEnemy = preload("res://wizard_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawns = $RandomEnemyLocations.get_children()
	var spawnCounts = $RandomEnemyLocations.get_child_count()
	
	while spawnCounts > 0:
		var newEnemy
		var num = randi_range(0,spawnCounts-1)
		var spawnLocations = spawns[num]
		
		if spawnCounts > 19:
			newEnemy = wizardEnemy.instantiate()
		elif spawnCounts > 10:
			newEnemy = ghostEnemy.instantiate()
		else:
			newEnemy = ratEnemy.instantiate()
		
		spawns.remove_at(num)
		spawnCounts -= 1
		
		newEnemy.position = spawnLocations.position
		get_parent().call_deferred("add_child", newEnemy)

