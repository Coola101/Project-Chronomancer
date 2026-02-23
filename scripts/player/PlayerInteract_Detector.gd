extends RayCast3D

@onready var interactLabel = get_tree().get_root().get_child(0).get_node("CanvasLayer").get_node("InteractionAlert")
@onready var generator = get_tree().get_root().get_child(0).get_node("GeneratorDeposit")
@onready var enemy = get_tree().get_root().get_child(0).get_node("EnemyBody")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if interactLabel.get_parent().get_child_count() <= 2:
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
						interactLabel.text = "The generator is full. Leave."
					else:
						interactLabel.text = "You have no fuel."
			if get_collider().is_in_group("readable_note"):
				if enemy.currentState == enemy.EnemyState.Chasing || enemy.currentState == enemy.EnemyState.Ending:
					interactLabel.text = "NOT A GOOD TIME"
				else:
					interactLabel.text = "[E] - Read note"
					if Input.is_action_just_released("interact"):
						get_collider().do_interaction()
			if get_collider().is_in_group("exit_door"):
				if (generator.fuel < 4):
					interactLabel.text = "The generator still needs fuel"
				else:
					interactLabel.text = "[E] - Escape"
					if Input.is_action_just_released("interact"):
						get_collider().do_interaction()
		else:
			interactLabel.text = ""
	else:
		interactLabel.text = ""
			
		#
				#get_collider.db.activate()
		
	
		
