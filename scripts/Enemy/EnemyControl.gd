extends CharacterBody3D

enum EnemyState { 
	Idling, Stalking,
	Chasing, Stunned,
	Cooldown
}

@onready var navigation = $NavigationAgent3D
@onready var rayCast = $RayCast3D
@onready var currentState = EnemyState.Idling
@onready var stalkAggression: float = 0
@onready var chaseAggression: float = 0
@onready var timer: Timer = $Timer
var Player: CollisionObject3D
var stunCheck: bool
var coolCheck: bool
var chaseCheck: bool
@onready var player_safe_zone: bool = false
var spawnPoints: Array[Node3D]

func _ready() -> void:
	timer.autostart = false
	timer.wait_time = 0.5
	rayCast.exclude_parent = true;
	currentLocation = global_transform.origin
	idlePoint = currentLocation
	await get_tree().create_timer(5).timeout
	changeState(EnemyState.Stalking)

var playerLocation: Vector3
var currentLocation: Vector3
var idlePoint: Vector3

var rng = RandomNumberGenerator.new()

var activeSpawnPoint: Node3D
var defaultSpawnPoint: Node3D

func update_target_location(location):
	playerLocation = location

func set_player(pl):
	Player = pl
	rayCast.add_exception(Player)

func initalize_spawn_points(allPoints: Array[Node3D]):
	defaultSpawnPoint = allPoints[0]
	spawnPoints = allPoints

const chaseSpeed: float = 7.5
const stalkSpeed: float = 2.5
const STALK_RADIUS: float = 10
const difficulty: float = 3
const STALK_THRESHOLD: float = 100
const CHASE_THRESHOLD: float = 20
const MAX_DISTANCE: float = 20
const STUN_TIME: float = 2.5
const COOLDOWN_TIME: float = 10
const CHASE_TIME: float = 180
const AGGRESSION_INTERVAL: float = 60
const SPAWN_DISTANCE: float = 30

func _physics_process(delta):
	currentLocation = global_transform.origin
	match currentState:
		EnemyState.Stalking:
			if(navigation.is_target_reached() || !navigation.is_target_reachable()):
				navigation.target_position = getNewStalkTarget()
				$Target.position = navigation.target_position
			var nextLocation = navigation.get_next_path_position()
			var distance = navigation.distance_to_target()
			#print(distance)
			var newVelocity = (nextLocation-currentLocation).normalized() * stalkSpeed
			velocity = velocity.move_toward(newVelocity, 0.25)
			move_and_slide()
		EnemyState.Chasing:
			navigation.target_position = playerLocation
			var nextLocation = navigation.get_next_path_position()
			var newVelocity = (nextLocation-currentLocation).normalized() * chaseSpeed
			velocity = velocity.move_toward(newVelocity, 0.25)
			move_and_slide()
			
			if(player_safe_zone):
				changeState(EnemyState.Cooldown)
		EnemyState.Stunned:
			velocity = Vector3(0,0,0)
			if(!stunCheck):
				stunDelay()
		EnemyState.Cooldown:
			global_position = idlePoint
			stalkAggression = 0
			if(currentState == EnemyState.Chasing):
				var a = 0
				#play sound A
			else:
				var a = 0
				#Play sound B
			if(!coolCheck):
				coolDelay()
		EnemyState.Idling:
			if(stalkAggression >= STALK_THRESHOLD):
				changeState(EnemyState.Stalking)
				
	
	#Check collision w/ player
	#Deal damage

func stunDelay():
	stunCheck = true
	await get_tree().create_timer(STUN_TIME).timeout
	if(currentState == EnemyState.Stunned): (EnemyState.Chasing)

func coolDelay():
	coolCheck = false
	await get_tree().create_timer(COOLDOWN_TIME).timeout
	if(currentState == EnemyState.Cooldown): 
		changeState(EnemyState.Idling)

func getNewStalkTarget() -> Vector3:
	var stalkDist = STALK_RADIUS / chaseAggression
	var x_pos = randf_range(playerLocation.x - stalkDist, playerLocation.x + stalkDist)
	var z_pos = randf_range(playerLocation.z - stalkDist, playerLocation.z + stalkDist)
	var target = Vector3(x_pos, playerLocation.y, z_pos)
	return target

func checkVisibility() -> bool:
	var EnemyToPlayer = playerLocation - currentLocation
	if(abs(EnemyToPlayer.length()) <= MAX_DISTANCE):
		rayCast.target_position = EnemyToPlayer
		rayCast.force_raycast_update()
		return !rayCast.is_colliding()
	return false

func changeState(newState: EnemyState):
	match newState:
		EnemyState.Stalking:
			#emerge
			timer.start()
			stalkAggression = 100 * difficulty
			findSpawnPoint(1)
			spawnAtPoint()
			navigation.target_position = getNewStalkTarget()
		EnemyState.Chasing:
			timer.start()
			chaseAggression = 20 * difficulty
			velocity = Vector3(0,0,0)
			#if(currentState == EnemyState.Stalking):
				#Roar
			#if(currentState == EnemyState.Stunned):
				#Snarl
		EnemyState.Stunned:
			#Stun sound & animation
			timer.stop()
			stunCheck = false
		EnemyState.Cooldown:
			#retreat into wall
			timer.stop()
			coolCheck = false
		EnemyState.Idling:
			timer.start()
	currentState = newState

func findSpawnPoint(mult: int):
	var viablePoints: Array[Node3D]
	for point in spawnPoints:
		var EnemyToPoint = point.global_transform.origin - playerLocation
		if(EnemyToPoint.length() <= SPAWN_DISTANCE * mult):
			viablePoints.append(point)
	if(viablePoints.size() == 0): 
		findSpawnPoint(mult+1)
		if(mult >= 10): 
			activeSpawnPoint = defaultSpawnPoint
	else:
		var rand = rng.randi_range(0, viablePoints.size()-1)
		activeSpawnPoint = spawnPoints[rand]

func spawnAtPoint():
	var newPos = activeSpawnPoint.global_position
	newPos.y = currentLocation.y
	global_position = newPos

func _sound_call(sound: float):
	match(currentState):
		EnemyState.Idling:
			stalkAggression += (sound * difficulty)
			if(stalkAggression >= STALK_THRESHOLD):
				changeState(EnemyState.Stalking)
		EnemyState.Stalking:
			if(chaseAggression <= CHASE_THRESHOLD/2):
				chaseAggression += (sound * difficulty)/2
			if(sound >= 30/difficulty):
				navigation.target_position = playerLocation

func _on_timer_timeout():
	print("Stalk: ", stalkAggression, " Chase: ", chaseAggression)
	match(currentState):
		EnemyState.Idling:
			stalkAggression = stalkAggression + (difficulty)
			if(stalkAggression >= STALK_THRESHOLD):
				changeState(EnemyState.Stalking)
		EnemyState.Stalking:
			if(checkVisibility()):
				chaseAggression = chaseAggression + (2*difficulty)
			else:
				stalkAggression = stalkAggression - snappedf(1/difficulty, 0.1)
				if(stalkAggression <= STALK_THRESHOLD/4):
					changeState(EnemyState.Cooldown)
			if(chaseAggression >= CHASE_THRESHOLD):
				changeState(EnemyState.Chasing)
		EnemyState.Chasing:
			if(!checkVisibility()):
				chaseAggression = chaseAggression - snappedf(2/difficulty, 0.1)
			else:
				chaseAggression = chaseAggression - snappedf(1/difficulty, 0.1)
			if(chaseAggression <= 0):
				chaseAggression = 0
				changeState(EnemyState.Cooldown)
