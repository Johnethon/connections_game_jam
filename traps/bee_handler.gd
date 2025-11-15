extends Node2D

@export var move_speed := 110.0
@export var acceleration := 6.0   # smoothing factor

@onready var bees = get_children()
@onready var target : Node2D = $".."

var fake_global_position : Vector2

var velocity := Vector2.ZERO

func _ready() -> void:
	fake_global_position = global_position

func _process(delta):
	_follow_target(delta)

func _follow_target(delta):
	if not target:
		return

	# direction toward target
	var direction := fake_global_position.direction_to(target.global_position)

	# desired velocity
	var desired_velocity := direction * move_speed

	# smooth the movement using lerp (acceleration-damped)
	velocity = velocity.lerp(desired_velocity, acceleration * delta)

	# apply movement
	fake_global_position += velocity * delta

# SIGNALS
func _on_aggro_activator_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		target = body

func _on_aggro_deactivator_body_exited(body: Node2D) -> void:
	if body == target:
		target = $".."
