extends Node

@onready var player = $PlayerCharacter

func _physics_process(delta):
	get_tree().call_group("Enemy", "update_target_location", player.global_transform.origin)
