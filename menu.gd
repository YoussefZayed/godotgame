extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://cutscene.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://options.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
