extends CharacterBody3D
class_name PlayerCharacter


const ACCELERATION: float = 0.5 # Speed which the player acccelerates
const MAX_SPEED: float = 6 # Top walking speed for the player
const SPRINT_SPEED: float = 8.5
const SPRINT_ACCELERATION: float = 0.75
#const JUMP_VELOCITY = 4.5

var carrying_generator_fuel: bool = false # Tracks whether or not the player is carrying fuel

@onready var pivot := $CameraPivot
@onready var player_camera := $CameraPivot/Camera3D
@onready var footStep := $FootstepPlayer

var state # Current state of the player
var states # Library of all states the player can be in

var moving: bool
var currentSound: float = 0
func get_sound_level() -> float:
	return currentSound

func _init() -> void:
	states = {
		"ground": GroundPlayerState
		#"sprint": SprintPlayerState
	}
	change_state("ground")

### Verifies a State exists and returns the State
func get_state(state_name):
	if states.has(state_name):
		return states.get(state_name)

func change_state(new_state: String):
	var param = 0 # Parameter to be passed between states if needed
	if state != null:
		param = state.exit()
		state.queue_free()
	state = get_state(new_state).new()
	state.setup(self, param)
	state.name = "current_state"
	add_child(state)

func _unhandled_input(event: InputEvent) -> void:
	# This lets us "click" into the application during gameplay.
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# This is the code that actually adjusts the camera
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			pivot.rotate_y(-event.relative.x * 0.0025)
			player_camera.rotate_x(-event.relative.y * 0.0025)
			player_camera.rotation.x = clamp(player_camera.rotation.x, deg_to_rad(-55), deg_to_rad(60))
			

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	
	move(ACCELERATION)

	move_and_slide()

func move(speed: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		moving = true
		velocity.x += direction.x * speed
		velocity.z += direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	#Temporarily, checking if the player is sprinting is also here.
	var speed_cap: float
	if Input.is_action_pressed("sprint"):
		speed_cap = SPRINT_SPEED
		if(carrying_generator_fuel):
			currentSound = 10
		else:
			currentSound = 5	
		# TODO:  Add call to recognize sound from sprint once added
	else:
		if(carrying_generator_fuel):
			currentSound = 1
		else:
			currentSound = 0
		speed_cap = MAX_SPEED
	#if(moving && !footStep.playing):
		#footStepSound()
	#elif(!moving):
		#footStep.stop()
	
	#Temporarily, the speed capping is placed here. Later it will likely be tied to a grounded state.
	if ((velocity.x*velocity.x)+(velocity.z*velocity.z) > speed_cap):
		velocity.x = speed_cap * direction.x
		velocity.z = speed_cap * direction.z
		

func footStepSound():
	footStep.play()
	if(currentSound > 1):
		footStep.pitch_scale = 1.5
	else:
		footStep.pitch_scale = 0.75
