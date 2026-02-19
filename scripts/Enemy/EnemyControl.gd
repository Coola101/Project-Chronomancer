extends CharacterBody3D

enum EnemyState { 
	Idling, Stalking,
	Chasing, Stunned,
	Cooldown
}

@onready var navigation = $NavigationAgent3D
@onready var rayCast = $RayCast3D
@onready var currentState = EnemyState.Idling
@onready var aggression: float = 0
var Player: CollisionObject3D
var stunCheck: bool
var coolCheck: bool
var chaseCheck: bool
@onready var player_safe_zone: bool = false
var spawnPoints: Array[Node3D]

func _ready() -> void:
	rayCast.exclude_parent = true;
	await get_tree().create_timer(5).timeout
	changeState(EnemyState.Stalking)

var playerLocation: Vector3
var rng = RandomNumberGenerator.new()
var currentLocation: Vector3
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
const stalkRadius: float = 10
const difficulty: float = 1
const threshold: float = 100
const MAX_DISTANCE: float = 20
const STUN_TIME: float = 2.5
const COOLDOWN_TIME: float = 10
const CHASE_TIME: float = 180
const AGGRESSION_INTERVAL: float = 0.5
const SPAWN_DISTANCE: float = 30

var aggressionTimer: float

func _physics_process(delta):
	currentLocation = global_transform.origin
	match currentState:
		EnemyState.Stalking:
			if(navigation.is_target_reached() || !navigation.is_target_reachable()):
				navigation.target_position = getNewStalkTarget()
				#$Target.position = navigation.target_position
			var nextLocation = navigation.get_next_path_position()
			var newVelocity = (nextLocation-currentLocation).normalized() * stalkSpeed
			velocity = velocity.move_toward(newVelocity, 0.25)
			move_and_slide()
			
			#Look for player
			var EnemyToPlayer = playerLocation - currentLocation
			if(abs(EnemyToPlayer.length()) <= MAX_DISTANCE):
				rayCast.target_position = EnemyToPlayer
				rayCast.force_raycast_update()
				if(!rayCast.is_colliding()):
					changeState(EnemyState.Chasing)
				#Reduce aggression per interval until aggression is at 1/4
				else:
					aggressionTimer += delta
					if(aggressionTimer >= AGGRESSION_INTERVAL):
						aggressionTimer -= AGGRESSION_INTERVAL
						aggression -= 1
						if(aggression <= threshold/4):
							changeState(EnemyState.Cooldown)
		EnemyState.Chasing:
			navigation.target_position = playerLocation
			var nextLocation = navigation.get_next_path_position()
			var newVelocity = (nextLocation-currentLocation).normalized() * chaseSpeed
			velocity = velocity.move_toward(newVelocity, 0.25)
			move_and_slide()
			if(!chaseCheck):
				chaseTimer()
			if(player_safe_zone):
				changeState(EnemyState.Cooldown)
			#Check if safe zone
		EnemyState.Stunned:
			velocity = Vector3(0,0,0)
			if(!stunCheck):
				stunDelay()
		EnemyState.Cooldown:
			if(!coolCheck):
				coolDelay()
		EnemyState.Idling:
			aggressionTimer += delta
			if(aggressionTimer >= AGGRESSION_INTERVAL):
				aggressionTimer -= AGGRESSION_INTERVAL
				_sound_call(1)
	#Check collision w/ player
	#Deal damage

func chaseTimer():
	chaseCheck = true;
	await get_tree().create_timer(CHASE_TIME).timeout
	if(currentState == EnemyState.Chasing || currentState == EnemyState.Stunned): changeState(EnemyState.Cooldown)

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
	var x_pos = randf_range(playerLocation.x - stalkRadius, playerLocation.x + stalkRadius)
	var z_pos = randf_range(playerLocation.z - stalkRadius, playerLocation.z + stalkRadius)
	var target = Vector3(x_pos, playerLocation.y, z_pos)
	return target
	
func changeState(newState: EnemyState):
	match newState:
		EnemyState.Stalking:
			#emerge
			findSpawnPoint(1)
			spawnAtPoint()
			aggressionTimer = 0
			navigation.target_position = getNewStalkTarget()
		EnemyState.Chasing:
			velocity = Vector3(0,0,0)
			await get_tree().create_timer(0.5).timeout
			#if(currentState == EnemyState.Stalking):
				#Roar
			#if(currentState == EnemyState.Stunned):
				#Snarl
		EnemyState.Stunned:
			#Stun sound & animation
			stunCheck = false
		EnemyState.Cooldown:
			#retreat into wall
			coolCheck = false
		EnemyState.Idling:
			aggressionTimer = 0
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
			return
	else:
		var rand = rng.randi_range(0, viablePoints.size()-1)
		activeSpawnPoint = spawnPoints[rand]

func spawnAtPoint():
	var newPos = activeSpawnPoint.global_position
	newPos.y = currentLocation.y
	global_position = newPos

func _sound_call(sound: float):
	aggression += (sound * difficulty)
	if(aggression >= threshold && currentState == EnemyState.Idling):
		changeState(EnemyState.Stalking)
