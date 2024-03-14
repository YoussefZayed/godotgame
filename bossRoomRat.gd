extends Node2D

@export var ratEnemy: PackedScene



func _on_rat_boss_spawn_rats(player):
	print("Spwaning Rats")
	spawnRat(player)
	spawnRat(player)
	

	
func spawnRat(player):
	var spawnCounts = $ratSpawnLocations.get_child_count()
	var spawns = $ratSpawnLocations.get_children()
	var spawnLocation = spawns[randi_range(0,spawnCounts-1)]
	var newRat = ratEnemy.instantiate()
	newRat.player = player
	newRat.player_chase = true
	newRat.position = spawnLocation.position
	get_parent().call_deferred("add_child",newRat)
	
