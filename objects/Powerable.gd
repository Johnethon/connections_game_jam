extends Interactable
class_name Powerable

@export var power_source : bool = true
@export var can_have_power_cable_attached : bool = false

var has_power : bool = false

@export var power_inputs : Array[Powerable] = []

@export var can_take_new_inputs : bool = false

@export var power_indicator_on : Sprite2D = null
@export var power_indicator_off : Sprite2D = null

func _process(delta: float):
	
	var prev_power = has_power
	
	has_power = false
	
	for power_input in power_inputs:
		if power_input.has_power or power_input.power_source:
			has_power = true
			break
	
	if prev_power != has_power:
		if has_power:
			given_power()
		else:
			removed_power()
	
	if power_indicator_on != null:
		power_indicator_on.visible = has_power

	personal_process(delta)

func personal_process(delta : float):
	pass

func connect_input(input_to_add : Powerable):
	if not can_take_new_inputs:
		return
	
	if input_to_add is PowerCable and not can_have_power_cable_attached:
		return
	
	power_inputs.append(input_to_add)

func remove_input(input_to_remove : Powerable):
	power_inputs.erase(input_to_remove)

func given_power():
	pass

func removed_power():
	pass
