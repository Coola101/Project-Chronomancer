extends Node3D

@onready var cameraPivot = get_parent().get_node("CameraPivot")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	rotation.y = lerp_angle(rotation.y, cameraPivot.rotation.y, delta*3)
	rotation.x = lerp_angle(rotation.x, cameraPivot.get_child(0).rotation.x/3, delta)
	

@export var variance: float = 0
@export var flicker_speed: float = 1.0
var negative: bool = false # While TRUE, the range will decrease.

var base_pos: float
func _init() -> void:
	base_pos = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target: float
	if negative:
		target = base_pos - variance
	else:
		target = base_pos + variance
	
	position.y = move_toward(position.y, target, (delta)*flicker_speed)
	if negative:
		if position.y <= target:
			negative = false
	else:
		if position.y >= target:
			negative = true
