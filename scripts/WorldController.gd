extends Node

@onready var player = $PlayerCharacter

var spawnPoints: Array[Node3D]

func _ready():
	get_tree().call_group("Enemy", "update_target_location", player.global_transform.origin)
	get_tree().call_group("Enemy", "set_player", player)
	loadSpawnPoints()
	get_tree().call_group("Enemy", "initalize_spawn_points", spawnPoints)

func _physics_process(delta):
	get_tree().call_group("Enemy", "update_target_location", player.global_transform.origin)

func loadSpawnPoints():
	for poi in $SpawnPointHolder.get_children():
		spawnPoints.append(poi)
