extends Label





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "Coin amount: " + str(get_parent().get_parent().money)
