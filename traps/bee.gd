extends CharacterBody2D
class_name Bee

@export var speed: float = 100.0
@export var turn_speed: float = 5.0

# Distances in pixels
@export var separation_distance: float = 8.0
@export var alignment_distance: float = 32.0
@export var cohesion_distance: float = 32.0
@export var parent_attraction_distance: float = 64.0  # how far they are attracted to parent

@export var separation_weight: float = 1.5
@export var alignment_weight: float = 1.0
@export var cohesion_weight: float = 1.0
@export var parent_weight: float = 1.2
@export var jitter_strength: float = 0.2
@export var jitter_change_rate: float = 2.0

var jitter: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	
	if not get_parent():
		return
	
	# Update jitter
	jitter += Vector2(randf_range(-1, 1), randf_range(-1, 1)) * jitter_change_rate * delta
	jitter = jitter.normalized() * jitter_strength
	
	# Boids vectors
	var separation: Vector2 = Vector2.ZERO
	var alignment: Vector2 = Vector2.ZERO
	var cohesion: Vector2 = Vector2.ZERO
	var num_neighbors_alignment: int = 0
	var num_neighbors_cohesion: int = 0

	for other in get_parent().get_children():
		if other == self:
			continue

		var offset: Vector2 = other.global_position - global_position
		var dist: float = offset.length()

		# Separation
		if dist < separation_distance and dist > 0:
			separation -= offset.normalized() * ((separation_distance - dist) / separation_distance)

		# Alignment
		if dist < alignment_distance:
			alignment += other.velocity.normalized()
			num_neighbors_alignment += 1

		# Cohesion
		if dist < cohesion_distance:
			cohesion += other.global_position
			num_neighbors_cohesion += 1

	# Average alignment
	if num_neighbors_alignment > 0:
		alignment /= num_neighbors_alignment
		alignment = alignment.normalized()

	# Average cohesion (towards center of neighbors)
	if num_neighbors_cohesion > 0:
		cohesion /= num_neighbors_cohesion
		cohesion = (cohesion - global_position).normalized()

	# Attraction to parent
	var to_parent: Vector2 = Vector2.ZERO
	var dist_to_parent = (get_parent().fake_global_position - global_position).length()
	if dist_to_parent > 0:
		to_parent = (get_parent().fake_global_position - global_position).normalized()

	# Combine all behaviors
	var move_dir: Vector2 = (separation * separation_weight +
		alignment * alignment_weight +
		cohesion * cohesion_weight +
		to_parent * parent_weight +
		jitter).normalized()

	# Rotate smoothly
	if move_dir.length() > 0:
		rotation = lerp_angle(rotation, move_dir.angle(), turn_speed * delta)

	# Apply movement
	velocity = move_dir * speed
	move_and_slide()
