extends Control

var fading: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("full_screen"):
		var is_window: bool = DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ref: Color = get_modulate()
	if fading:
		if ref.a > 0:
			ref.a = move_toward(ref.a,0,delta*6)
			set_modulate(ref)
		if ref.a <= 0:
			queue_free()


func _on_button_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Main_Scenes/MainMenu.tscn")
	


func _on_button_resume_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	fading = true
	get_tree().paused = false
