extends Area3D


func do_interaction():
	var player = get_tree().get_root().get_child(0).get_node("PlayerCharacter")
	player.playPickup()
	player.carrying_generator_fuel = true
	get_tree().get_root().get_child(0).sound_event(10)
	collision_layer = 0
	player.get_node("LanternPivot").get_child(1).visible = true
	queue_free()
