extends Node
class_name Player_State

var change_state
var animation
var persistent_state
var initial_parameter

func setup(persistent_state, param):
	self.persistent_state = persistent_state
	initial_parameter = param

### Code called when exiting a state
func exit():
	return 0


#func get_horizontal_direction():
#	return Input.get_axis("Gameplay_Left", "Gameplay_Right")
#func get_vertical_direction():
#	return Input.get_axis("Gameplay_Down", "Gameplay_Up")

#signal transitioned # Called whenever we leave a state
#
### Code called when entering a state
#func enter():
	#pass
#
### Code called each frame while the state is active
#func update(delta: float):
	#pass
#
### Code called every physics update while the state is active
#func physics_update(delta: float):
	#pass*/
