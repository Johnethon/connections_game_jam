extends RigidBody2D
class_name MagneticObject

@export var positive : bool = true
@export var both : bool = false

@export var lock_x : bool = false
@export var lock_z : bool = false

func _ready():
	
	##collides with wire
	collision_layer += 1 << 1
	collision_mask += 1 << 1
	
	##collides with object stoppers
	collision_layer += 1 << 3
	collision_mask += 1 << 3

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	pass
