extends Control

var reading: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ref: Color = get_modulate()
	if reading:
		if ref.a < 255:
			ref.a = move_toward(ref.a,255,delta*2)
			set_modulate(ref)
		if position.y > (get_viewport().get_visible_rect().size.y/5):
			position.y = move_toward(position.y,get_viewport_rect().size.y/5,delta*550)
		
		if Input.is_action_just_pressed("interact"):
			reading = false
			get_tree().paused = false
	else:
		if ref.a > 0:
			ref.a = move_toward(ref.a,0,delta*6)
			set_modulate(ref)
		if position.y < (get_viewport().get_visible_rect().size.y*2):
			position.y = move_toward(position.y,get_viewport_rect().size.y*4,delta*550)
		if ref.a <= 0:
			queue_free()
