extends RayCast3D

@onready var interactLabel = get_tree().get_root().get_child(0).get_node("CanvasLayer").get_node("InteractionAlert")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_colliding():
		if get_collider() == null:
			pass
		if get_collider().is_in_group("generator_fuel"):
				if get_parent().get_parent().get_parent().carrying_generator_fuel:
					interactLabel.text = "You are already carrying fuel."
				else:
					interactLabel.text = "[E] - Pick up fuel"
					if Input.is_action_just_released("interact"):
						get_collider().do_interaction()
		if get_collider().is_in_group("generator_deposit"):
				if get_parent().get_parent().get_parent().carrying_generator_fuel:
					interactLabel.text = "[E] - Deposit fuel"
					if Input.is_action_just_released("interact"):
						get_collider().do_interaction()
				elif get_collider().fuel >= 4:
					interactLabel.text = "The generator is full. Seek Shelter."
				else:
					interactLabel.text = "You have no fuel."
		if get_collider().is_in_group("readable_note"):
				interactLabel.text = "[E] - Read note"
				if Input.is_action_just_released("interact"):
					get_collider().do_interaction()
					
		#
				#get_collider.db.activate()
		
	else:
		interactLabel.text = ""
		
