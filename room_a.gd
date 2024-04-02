extends Node2D
class_name RoomA

@onready var barrier = $Barrier
@onready var barrierCollision = $Barrier/CollisionShape2D
@onready var music = $BackgroundMusic

# Called when the node enters the scene tree for the first time.
func _ready():
	$BossRoomRat.spawnDoor.connect(self._on_boss_room_rat_spawn_barrier)
	barrier.hide()
	barrierCollision.set_deferred("disabled", true)
	music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_boss_room_rat_spawn_barrier():
	music.stop()
	barrier.show()
	barrierCollision.set_deferred("disabled", false)
	music.stop()
