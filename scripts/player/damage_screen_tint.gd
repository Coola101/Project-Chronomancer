extends ColorRect

@onready var enemy = get_tree().get_root().get_child(0).get_node("EnemyBody")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") && get_parent().get_child_count() <= 2:
		var pause_screen = load("res://scenes/prefabs/pause_menu.tscn")
		var instance = pause_screen.instantiate()
		get_parent().add_child.call_deferred(instance)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	color.a = 0.4*(1.0-(enemy.playerHealth/enemy.MAX_HEALTH))
