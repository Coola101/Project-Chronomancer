extends CharacterBody3D

enum EnemyState { 
	Idling, Stalking,
	Chasing, Stunned,
	Cooldown
}

@onready var navigation = $NavigationAgent3D
@onready var currentState = EnemyState.Idling

func _ready() -> void:
	changeState(EnemyState.Idling)

var playerLocation
var rng = RandomNumberGenerator.new()

func update_target_location(location):
	playerLocation = location

var chaseSpeed = 7.5
var stalkSpeed = 5
var stalkRadius = 7.5

func _physics_process(_delta):
	var currentlocation = global_transform.origin
	match currentState:
		EnemyState.Stalking:
			if(navigation.target_reached):
				navigation.target_position = getNewStalkTarget()
			var nextLocation = navigation.get_next_path_position()
			var newVelocity = (nextLocation-currentlocation).normalized() * stalkSpeed
			velocity = velocity.move_toward(newVelocity, 0.25)
			move_and_slide()
			#do things
		EnemyState.Chasing:
			navigation.target_position = playerLocation
			var nextLocation = navigation.get_next_path_position()
			var newVelocity = (nextLocation-currentlocation).normalized() * chaseSpeed
			velocity = velocity.move_toward(newVelocity, 0.25)
			move_and_slide()
			#Current implemented AI

func getNewStalkTarget() -> Vector3:
	var x = randf_range(playerLocation.x - stalkRadius, playerLocation.x + stalkRadius)
	var z = randf_range(playerLocation.z - stalkRadius, playerLocation.z + stalkRadius)
	var target = Vector3(x, playerLocation.y, z)
	return target
	
func changeState(newState: EnemyState):
	currentState = newState
