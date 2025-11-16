extends Powerable
class_name Turret

# ---------------------------------
# STATES
# ---------------------------------
enum States { 
	IDLE, 
	SEARCHING, 
	AIMING 
}

# ---------------------------------
# EXPORTED PROPERTIES
# ---------------------------------
@export var detection_area: Area2D
@export var rotation_speed := 2.0

# SEARCH SWEEP SETTINGS
@export var search_left_limit := deg_to_rad(-90)
@export var search_right_limit := deg_to_rad(90)
@export var search_speed := 1.2

# BULLET SETTINGS
@export var bullet_scene: PackedScene
@export var bullet_speed := 1000.0
@export var muzzle: Node2D

# ---------------------------------
# INTERNAL STATE
# ---------------------------------
var current_state: States = States.IDLE
var target: Node2D = null
var search_direction := 1   # 1 = right, -1 = left

# ---------------------------------
# READY
# ---------------------------------
func personal_ready() -> void:
	
	if detection_area:
		detection_area.body_entered.connect(_on_body_entered)
		detection_area.body_exited.connect(_on_body_exited)

# ---------------------------------
# PROCESS LOOP
# ---------------------------------
func personal_process(delta: float) -> void:
	super(delta)
	$barrel_pivot/barrel.position = $barrel_pivot/barrel.position.lerp(Vector2(10, 0), delta * 2)
	
	match current_state:
		States.IDLE:
			_state_idle(delta)

		States.SEARCHING:
			_state_searching(delta)

		States.AIMING:
			_state_aiming(delta)

# ---------------------------------
# POWER SYSTEM
# ---------------------------------
func given_power():
	current_state = States.SEARCHING

func removed_power():
	current_state = States.IDLE
	target = null

# ---------------------------------
# STATE LOGIC
# ---------------------------------
func _state_idle(delta):
	# No rotation, no target
	pass

func _state_searching(delta):
	# If a target is present → switch to Aiming
	if target:
		current_state = States.AIMING
		return

	# Back-and-forth scanning
	$barrel_pivot.rotation += search_speed * search_direction * delta

	if $barrel_pivot.rotation > search_right_limit:
		$barrel_pivot.rotation = search_right_limit
		search_direction = -1
	elif $barrel_pivot.rotation < search_left_limit:
		$barrel_pivot.rotation = search_left_limit
		search_direction = 1

func _state_aiming(delta):
	if not target:
		current_state = States.SEARCHING
		return

	# Rotate smoothly toward player
	var desired_angle := global_position.direction_to(target.global_position).angle() - rotation
	$barrel_pivot.rotation = lerp_angle($barrel_pivot.rotation, desired_angle, rotation_speed * delta * 3)
	
	# Fire if lined up
	_fire_if_on_target(desired_angle)

# ---------------------------------
# SIGNAL HANDLERS
# ---------------------------------
func _on_body_entered(body: Node):
	if body.is_in_group("players"):
		target = body

func _on_body_exited(body: Node):
	if body == target:
		target = null
		if current_state != States.IDLE:
			current_state = States.SEARCHING

# ---------------------------------
# FIRING SYSTEM
# ---------------------------------
var fire_cooldown := 0.0
@export var fire_rate := 0.25  # seconds between shots

func _fire_if_on_target(desired_angle):
	# Must be aimed within a cone
	if abs(wrapf(desired_angle - $barrel_pivot.rotation, -PI, PI)) < deg_to_rad(10):
		if fire_cooldown <= 0:
			_fire_bullet()
			fire_cooldown = fire_rate

	# Update cooldown timer
	fire_cooldown -= get_process_delta_time()

func _fire_bullet():
	if bullet_scene == null:
		push_warning("Turret has no bullet_scene assigned.")
		return

	if muzzle == null:
		push_warning("Turret has no muzzle node assigned.")
		return
		
	$barrel_pivot/barrel.position
	
	var bullet := bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	# Place bullet at muzzle
	bullet.global_position = muzzle.global_position

	# Turret forward direction (assumes sprite faces RIGHT)
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation).rotated($barrel_pivot.rotation)

	# Apply velocity for CharacterBody2D bullet
	if bullet is CharacterBody2D:
		bullet.velocity = direction * bullet_speed
	else:
		# fallback if bullet uses custom movement
		bullet.set("velocity", direction * bullet_speed)
