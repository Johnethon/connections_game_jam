extends Powerable

@export var disable_collision : bool = false


func personal_ready():
	if disable_collision:
		$StaticBody2D/CollisionShape2D.disabled = disable_collision
	
func interact(node_interacting_with_me : Node2D):
	
	if node_interacting_with_me is Player:
		for input in power_inputs:
			if input is PowerCable:
				input.interact(node_interacting_with_me)
	
