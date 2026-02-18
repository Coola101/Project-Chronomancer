extends Node

@onready var player = $PlayerCharacter

func _ready():
	get_tree().call_group("Enemy", "update_target_location", player.global_transform.origin)
	get_tree().call_group("Enemy", "set_player", player)

func _physics_process(delta):
	get_tree().call_group("Enemy", "update_target_location", player.global_transform.origin)
