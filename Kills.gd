extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = str(get_parent().get_parent().kills) + "/10"

