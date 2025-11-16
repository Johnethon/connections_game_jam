extends Node2D

@export var move_speed := 110.0

@export var chase_accel := 3.0
@export var patrol_accel := 6.0

@onready var acceleration := patrol_accel

@onready var bees = get_children()
@export var home_target : Node2D = null

@onready var cur_target : Node2D = home_target
var fake_global_position : Vector2

var velocity := Vector2.ZERO

var active : bool = true
func _ready() -> void:
	fake_global_position = global_position

func _process(delta):
	
	_follow_target(delta)

func _follow_target(delta):
	if not cur_target:
		return
	
	active = get_parent().has_power or get_parent().power_source
	
	# direction toward target
	var direction := fake_global_position.direction_to(cur_target.global_position)
	
	# desired velocity
	var desired_velocity := direction * move_speed

	# smooth the movement using lerp (acceleration-damped)
	velocity = velocity.lerp(desired_velocity, acceleration * delta)
	
	# apply movement
	fake_global_position += velocity * delta

# SIGNALS
func _on_aggro_activator_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		acceleration = chase_accel
		cur_target = body

func _on_aggro_deactivator_body_exited(body: Node2D) -> void:
	if body == cur_target:
		acceleration = patrol_accel
		cur_target = home_target
