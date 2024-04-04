extends Control

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://menu.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_controls_pressed():
	get_tree().change_scene_to_file("res://input_settings.tscn")


func _on_volume_pressed():
	get_tree().change_scene_to_file("res://volume.tscn")

