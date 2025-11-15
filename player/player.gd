extends CharacterBody2D
class_name Player

@export var positive : bool = true

@onready var magnet_range : Area2D = $magnet_range
@onready var interact_range : Area2D = $interact_range

var move_speed = 200.0

var pulling : bool = false

var held_object : Interactable = null

var last_move_dir : Vector2 = Vector2.UP

@onready var main : Main = get_tree().get_first_node_in_group("main")

func _input(_event: InputEvent) -> void:
	
	if main.in_cutscene:
		return
	
	#print(Input.is_action_just_pressed("positive_interact"))
	if positive:
		if Input.is_action_just_pressed("positive_interact"):
			interaction_code()
		if Input.is_action_just_pressed("positive_toggle_magnet"):
			pulling = not pulling
	else:
		if Input.is_action_just_pressed("negative_interact"):
			interaction_code()
		if Input.is_action_just_pressed("negative_toggle_magnet"):
			pulling = not pulling
		
		if Input.is_action_just_pressed("pause"):
			main.pause_game()
		
		if Input.is_action_just_pressed("reset"):
			main.reset_cur_level()
		elif not Input.is_action_just_released("reset"):
			main.resets_in_a_row = 0

func interaction_code():
	var potential_things_to_interact_with : Array[Interactable] = []
			
	for area in interact_range.get_overlapping_areas():
		#print(area)
		if area.get_parent() is Interactable:
			if not area.get_parent() == held_object:
				potential_things_to_interact_with.append(area.get_parent())
	
	if len(potential_things_to_interact_with) > 0:
		for thing in potential_things_to_interact_with:
			if held_object:
				if thing is Powerable and held_object is PowerCable:
					
					#Check if the target is able to take inputs
					if not thing.can_take_new_inputs or not thing.can_have_power_cable_attached:
						continue
					
					#Check if target already has a cable plugged in
					var already_has_cable_input = false
					for input in thing.power_inputs:
						if input is PowerCable:
							already_has_cable_input = true
							break
					if already_has_cable_input:
						continue
					
					#Check if target's parent is the held_object's parent
					#this is to avoid plugging a power pole into itself
					if held_object.get_parent() == thing.get_parent():
						continue
					
					thing.connect_input(held_object)
					
					held_object.attached = true
					held_object.node_i_am_attached_to = thing
					held_object = null
			else:
				thing.interact(self)
	else:
		if held_object:
			if held_object is PowerCable:
				held_object.attached = false
				held_object.node_i_am_attached_to = null
				held_object = null
	

func _process(delta: float) -> void:
	
	if main.in_cutscene:
		return
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Vector2.ZERO
	if positive:
		input_dir = Input.get_vector("positive_move_left", "positive_move_right", "positive_move_up", "positive_move_down")
		
	else:
		input_dir = Input.get_vector("negative_move_left", "negative_move_right", "negative_move_up", "negative_move_down")
	input_dir = input_dir.normalized()
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir:
		
		last_move_dir = input_dir
		
	velocity.x = move_toward(velocity.x, input_dir.x * move_speed, move_speed * delta * 5)
	velocity.y = move_toward(velocity.y, input_dir.y * move_speed, move_speed * delta * 5)
	
	if pulling:
		for body in magnet_range.get_overlapping_bodies():
			if body is MagneticObject:
				#print("do")
				var dir_to = global_position.direction_to(body.global_position).normalized()
				var dist_to = global_position.distance_to(body.global_position)
				var toward_or_away = ( 1 - 2 * int(body.positive == not positive) )
				var power = clamp(100/dist_to * 300, 100, 300)
				#print(power)
				if not body.player_close:
					body.apply_central_force( dir_to * toward_or_away * power)
				
	move_and_slide()
