extends Node

@onready var player = $PlayerCharacter
@onready var enemy = $EnemyBody
@onready var soundTimer = $SoundTimer
@onready var moon = $Moon
@onready var moonTimer = $MoonTimer
var ending: bool = false

var spawnPoints: Array[Node3D]

func _ready():
	get_tree().call_group("Enemy", "update_target_location", player.global_transform.origin)
	get_tree().call_group("Enemy", "set_player", player)
	loadSpawnPoints()
	get_tree().call_group("Enemy", "initalize_spawn_points", spawnPoints)

func _physics_process(_delta):
	get_tree().call_group("Enemy", "update_target_location", player.global_transform.origin)

func loadSpawnPoints():
	for poi in $SpawnPointHolder.get_children():
		spawnPoints.append(poi)


func _on_sound_timer_timeout() -> void:
	if(player.get_sound_level() > 0):
		get_tree().call_group("Enemy", "_sound_call", player.get_sound_level())

func sound_event(sound: float):
	get_tree().call_group("Enemy", "_sound_call", sound)

func _on_moon_timer_timeout() -> void:
	moon.global_position.y -= 1
	if(moon.global_position.y <= 0):
		ending = true
		get_tree().call_group("Enemy", "_initate_endgame", true)
