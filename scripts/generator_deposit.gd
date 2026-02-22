extends Area3D

var fuel: int = 0

func do_interaction():
	var player = get_tree().get_root().get_child(0).get_node("PlayerCharacter")
	player.carrying_generator_fuel = false
	get_tree().get_root().get_child(0).sound_event(10)
	fuel += 1
	get_child(1).animation = str(fuel)
	if(fuel >= 1):
		get_tree().get_root().get_child(0).get_node("EnemyBody")._initate_endgame(false)
