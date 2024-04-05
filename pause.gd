extends Control

func _ready():
	hide()
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	hide()
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	show()
	$AnimationPlayer.play("blur")
	
func esc():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()


func _on_resume_pressed():
	resume()


func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()


func _on_quit_to_main_pressed():
	get_tree().quit()



func _process(_delta):
	esc()


func _on_main_menu_pressed():
	resume()
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_options_pressed():
	pass # Replace with function body.
