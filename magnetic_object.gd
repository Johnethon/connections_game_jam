extends RigidBody3D
class_name MagneticObject

@export var positive : bool = true
@export var both : bool = false

@export var lock_x : bool = false
@export var lock_z : bool = false

func _ready():
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true
	
	axis_lock_linear_x = lock_x
	axis_lock_linear_z = lock_z
	axis_lock_linear_y = true
	
	##collides with wire
	collision_layer += 1 << 1
	collision_mask += 1 << 1
	
	##collides with object stoppers
	collision_layer += 1 << 3
	collision_mask += 1 << 3
