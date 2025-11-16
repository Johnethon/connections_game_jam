extends Interactable
class_name Powerable

@export var power_source : bool = true
@export var can_have_power_cable_attached : bool = false

var has_power : bool = false

@export var power_inputs : Array[Powerable] = []
@export var ground_cable_shift : int = 0.0
var ground_cable_scene = preload("res://objects/ground_input_cable.tscn")
var ground_cables_and_their_inputs = {}

@export var can_take_new_inputs : bool = false

@export var power_indicator_on : Sprite2D = null
@export var power_indicator_off : Sprite2D = null

@export var reverse : bool = false

func _ready():
	var main : Main = get_tree().get_first_node_in_group("main")
	for input in power_inputs:
		if input is PowerCable:
			continue
			
		var new_cable = preload("res://objects/ground_input_cable.tscn").instantiate()
		add_child(new_cable)
		new_cable.position = Vector2.ZERO + Vector2(0, ground_cable_shift)
		
		var dist_to = new_cable.global_position.distance_to(input.global_position)
		var dir_to = new_cable.global_position.direction_to(input.global_position)

		new_cable.get_child(0).global_position = new_cable.global_position + dir_to * dist_to / 2
		new_cable.get_child(0).look_at(input.global_position)
		
		ground_cables_and_their_inputs[new_cable] = input
		
		new_cable.get_child(0).scale.x = dist_to / 8 #px size of player sprite
		
		#print("do")
	if reverse or power_source:
		given_power()
	
	personal_ready()

func personal_ready():
	pass

func _process(delta: float):
	
	var prev_power = has_power
	
	has_power = false
	
	for power_input in power_inputs:
		
		if power_input.has_power or power_input.power_source:
			has_power = true
			break
	
	for cable in ground_cables_and_their_inputs:
		cable.get_child(0).get_child(0).visible = ground_cables_and_their_inputs[cable].has_power or ground_cables_and_their_inputs[cable].power_source
	
	if not reverse:
		if prev_power != has_power:
			if has_power:
				given_power()
			else:
				removed_power()
		
		if power_indicator_on != null:
			power_indicator_on.visible = (has_power or power_source)

	else:
		if prev_power != has_power:
			if has_power:
				removed_power()
			else:
				given_power()
	
		if power_indicator_on != null:
			power_indicator_on.visible = not has_power

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
