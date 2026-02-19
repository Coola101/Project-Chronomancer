extends CanvasLayer

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("full_screen"):
		var is_window: bool = DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)

func _on_button_start_pressed() -> void:
	
	get_tree().change_scene_to_file("res://scenes/testRooms/NavTests.tscn")


func _on_button_exit_pressed() -> void:
	get_tree().quit()
