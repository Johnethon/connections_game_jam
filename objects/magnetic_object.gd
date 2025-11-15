extends RigidBody2D
class_name MagneticObject

@export var positive : bool = true
@export var both : bool = false

@export var lock_x : bool = false
@export var lock_y : bool = false

var base_x = 0
var base_y = 0

var avoid_collision_box : Area2D = null
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
	
	linear_damp = 1
	gravity_scale = 0.0
	
	contact_monitor = true
	
	avoid_collision_box = Area2D.new()
	add_child(avoid_collision_box)
	var new_col_box = $CollisionShape2D.duplicate()
	avoid_collision_box.add_child(new_col_box)
	new_col_box.scale *= 1.3
	avoid_collision_box.body_entered.connect(stop_moving)
	avoid_collision_box.body_exited.connect(start_moving)
	
	personal_ready()
	
func personal_ready():
	pass
	
var player_close = false
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	rotation = 0.0
	
	if lock_x:
		global_position.x = base_x
	
	if lock_y:
		global_position.y = base_y
	
	if player_close:
		linear_velocity = Vector2.ZERO
	
	if len(get_colliding_bodies()) != 0:
		linear_velocity = Vector2.ZERO

func stop_moving(body : Node2D):
	if body is Player:
		player_close = true

func start_moving(body : Node2D):
	if body is Player:
		player_close = false
