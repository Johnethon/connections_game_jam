extends CharacterBody3D
class_name Player

@export var positive : bool = true

@onready var magnet_range : Area3D = $Area3D
var move_speed = 5.0

var pulling : bool = false

func _input(_event: InputEvent) -> void:
	#print(_event)
	if positive:
		if Input.is_action_just_pressed("positive_interact"):
			pass
		if Input.is_action_just_pressed("positive_toggle_magnet"):
			pulling = not pulling
	else:
		if Input.is_action_just_pressed("negative_interact"):
			pass
		if Input.is_action_just_pressed("negative_toggle_magnet"):
			pulling = not pulling

func _process(_delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Vector2.ZERO
	if positive:
		input_dir = Input.get_vector("positive_move_left", "positive_move_right", "positive_move_up", "positive_move_down")
	else:
		input_dir = Input.get_vector("negative_move_left", "negative_move_right", "negative_move_up", "negative_move_down")
	
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir:
		velocity.x = input_dir.x * move_speed
		velocity.z = input_dir.y * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
	
	$MeshInstance3D.mesh.material.rim = int(pulling)
	if pulling:
		for body in magnet_range.get_overlapping_bodies():
			if body is MagneticObject:
				var dir_to = global_position.direction_to(body.global_position).normalized()
				var dist_to = global_position.distance_to(body.global_position)
				var toward_or_away = ( 1 - 2 * int(body.positive == not positive) )
				var power = 30/dist_to
				
				body.apply_central_force( dir_to * toward_or_away * power)

	move_and_slide()
