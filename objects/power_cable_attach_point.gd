extends Powerable

func interact(node_interacting_with_me : Node2D):
	
	if node_interacting_with_me is Player:
		for input in power_inputs:
			if input is PowerCable:
				input.interact(node_interacting_with_me)
	
