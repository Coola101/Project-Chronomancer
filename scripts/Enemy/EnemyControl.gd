extends CharacterBody3D

enum EnemyState { 
	Idling, Stalking,
	Chasing, Stunned,
	Cooldown
}

@onready var navigation = $NavigationAgent3D
@onready var currentState = EnemyState.Idling
@onready var aggression: float = 0

func _ready() -> void:
	changeState(EnemyState.Stalking)

var playerLocation: Vector3
var playerRID: RID
var rng = RandomNumberGenerator.new()

func update_target_location(location):
	playerLocation = location

func set_player_RID(pl):
	playerRID = pl

const chaseSpeed: float = 7.5
const stalkSpeed: float = 2.5
const stalkRadius: float = 15
const difficulty: float = 1
const threshold: float = 100


func _physics_process(_delta):
	var currentLocation = global_transform.origin
	match currentState:
		EnemyState.Stalking:
			if(navigation.target_reached || !navigation.is_target_reachable()):
				navigation.target_position = getNewStalkTarget()
			var nextLocation = navigation.get_next_path_position()
			var newVelocity = (nextLocation-currentLocation).normalized() * stalkSpeed
			velocity = velocity.move_toward(newVelocity, 0.25)
			move_and_slide()
			
			#Look for player
			var space_state = get_world_3d().direct_space_state
			var queery = PhysicsRayQueryParameters3D.create(currentLocation, playerLocation)
			queery.exclude = [self, playerRID]
			var result = space_state.intersect_ray(queery)
			if(result.is_empty()):
				print("Success")
				changeState(EnemyState.Chasing)
			else:
				print(result.keys())
				#aggression -= 1/difficulty
				#if(aggression <= 0):
					#changeState(EnemyState.Cooldown)
		EnemyState.Chasing:
			navigation.target_position = playerLocation
			var nextLocation = navigation.get_next_path_position()
			var newVelocity = (nextLocation-currentLocation).normalized() * chaseSpeed
			velocity = velocity.move_toward(newVelocity, 0.25)
			move_and_slide()
			#Current implemented AI
		EnemyState.Stunned:
			velocity = Vector3(0,0,0)
			#recover time

func getNewStalkTarget() -> Vector3:
	var x_pos = randf_range(playerLocation.x - stalkRadius, playerLocation.x + stalkRadius)
	var z_pos = randf_range(playerLocation.z - stalkRadius, playerLocation.z + stalkRadius)
	var target = Vector3(x_pos, playerLocation.y, z_pos)
	return target
	
func changeState(newState: EnemyState):
	match newState:
		EnemyState.Stalking:
			#emerge
			getNewStalkTarget()
		EnemyState.Chasing:
			velocity = Vector3(0,0,0)
			#play sound
			#delay
	currentState = newState

func _sound_call(sound: float):
	aggression += (sound * difficulty)
	if(aggression >= threshold && currentState == EnemyState.Idling):
		changeState(EnemyState.Stalking)
