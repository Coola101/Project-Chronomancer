extends Area3D


func do_interaction():
	var player = get_tree().get_root().get_child(0).get_node("PlayerCharacter")
	player.carrying_generator_fuel = true
	collision_layer = 0
	queue_free()
