extends ColorRect

@onready var enemy = get_tree().get_root().get_child(0).get_node("EnemyBody")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	color.a = 0.4*(1.0-(enemy.playerHealth/enemy.MAX_HEALTH))
