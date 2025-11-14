extends RigidBody2D
class_name MagneticObject

@export var positive : bool = true
@export var both : bool = false

@export var lock_x : bool = false
@export var lock_y : bool = false

var base_x = 0
var base_y = 0

func _ready():
	
	if lock_x:
		base_x = global_position.x
		
	if lock_y:
		base_y = global_position.y
	
	##collides with wire
	collision_layer += 1 << 1
	collision_mask += 1 << 1
	
	##collides with object stoppers
	collision_layer += 1 << 3
	collision_mask += 1 << 3

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	rotation = 0.0
	
	if lock_x:
		global_position.x = base_x
	
	if lock_y:
		global_position.y = base_y
