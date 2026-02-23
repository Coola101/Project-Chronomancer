extends ColorRect

@onready var enemy = get_tree().get_root().get_child(0).get_node("EnemyBody")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("full_screen"):
		var is_window: bool = DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	color.a = 0.4*(1.0-(enemy.playerHealth/enemy.MAX_HEALTH))
