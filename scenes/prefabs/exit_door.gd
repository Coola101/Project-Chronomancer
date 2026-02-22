extends Area3D

func do_interaction():
	get_tree().change_scene_to_file("res://scenes/Main_Scenes/EndScreen.tscn")
	collision_layer = 0
	queue_free()
