extends CanvasLayer

var showControls: bool = false
@onready var controls_note = get_node("ControlsNote")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("full_screen"):
		var is_window: bool = DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
	if Input.is_action_just_pressed("interact"):
		showControls = !showControls
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(controls_note != null):
		var ref: Color = controls_note.get_modulate()
		if showControls:
			if ref.a < 255:
				ref.a = move_toward(ref.a,255,delta*2)
				controls_note.set_modulate(ref)
			if controls_note.position.y > 15*(get_viewport().get_visible_rect().size.y/16):
				controls_note.position.y = move_toward(controls_note.position.y,controls_note.get_viewport_rect().size.y/5,delta*550)
		else:
			if ref.a > 0:
				ref.a = move_toward(ref.a,0,delta*4)
				controls_note.set_modulate(ref)
			if controls_note.position.y < (get_viewport().get_visible_rect().size.y*1.5):
				controls_note.position.y = move_toward(controls_note.position.y,controls_note.get_viewport_rect().size.y*2,delta*550)

func _on_button_start_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/Main_Scenes/MainGameScene.tscn")


func _on_button_exit_pressed() -> void:
	get_tree().quit()


func _on_button_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main_Scenes/MainMenu.tscn")
