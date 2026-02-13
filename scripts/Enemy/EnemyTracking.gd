extends CharacterBody3D

@onready var navigation = $NavigationAgent3D

func update_target_location(location):
	navigation.target_location = location

var speed = 5

func _physics_process(_delta):
	var currentlocation = global_transform.origin
	var nextLocation = navigation.get_next_path_position()
	var newVelocity = (nextLocation-currentlocation).normalized() * speed
	
	velocity = velocity.move_toward(newVelocity, 0.25)
	move_and_slide()
