extends Interactable
class_name Powerable

@export var power_source : bool = true
@export var can_have_power_cable_attached : bool = false

var has_power : bool = false

@export var power_inputs : Array[Powerable] = []

@export var can_take_inputs : bool = false

func _process(delta: float):
	
	var prev_power = has_power
	
	has_power = false
	
	for power_input in power_inputs:
		if power_input.has_power or power_input.power_source:
			has_power = true
			break
	
	if prev_power != has_power:
		pass

	

func connect_input(input_to_add : Powerable):
	if not can_take_inputs:
		return
	power_inputs.append(input_to_add)

func remove_input(input_to_remove : Powerable):
	power_inputs.erase(input_to_remove)
