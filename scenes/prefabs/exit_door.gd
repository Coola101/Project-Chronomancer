extends Area3D

func do_interaction():
	var player = get_tree().get_root().get_child(0).get_node("PlayerCharacter")
	get_tree().change_scene_to_file("res://scenes/Main_Scenes/MainGameScene.tscn")
	collision_layer = 0
	queue_free()
