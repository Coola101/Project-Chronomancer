extends Player_State
class_name GroundPlayerState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Put transitions to other states here
	
func _physics_process(delta: float) -> void:
	var player = get_parent()
	
	player.move(player.ACCELERATION)
