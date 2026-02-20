extends OmniLight3D

@export var variance: float = 0
@export var flicker_speed: float = 1.0
var negative: bool = false # While TRUE, the range will decrease.

var rng = RandomNumberGenerator.new()

var base_range: float
func _init() -> void:
	base_range = omni_range

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target: float
	if negative:
		target = base_range - variance
	else:
		target = base_range + variance
	
	omni_range = move_toward(omni_range, target, (delta+rng.randf_range(-0.0125,0.0125))*flicker_speed)
	if negative:
		if omni_range <= target:
			negative = false
	else:
		if omni_range >= target:
			negative = true
