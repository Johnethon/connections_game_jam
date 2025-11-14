class_name player_main_cam
extends Camera3D

@onready var camera_ray = $RayCast3D

var player_mouse_col_point : Vector3 = Vector3.ZERO
var player_mouse_col_node : Node3D = null

func _process(_delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var ray_origin = project_ray_origin(get_viewport().get_mouse_position())
	var ray_end = ray_origin + project_ray_normal(get_viewport().get_mouse_position()) * 2000
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = space_state.intersect_ray(query)
	
	if intersection.size() != 0:
		var pos = intersection["position"]
		
		if camera_ray.global_position != pos:
			camera_ray.look_at(pos, Vector3(0,1,0))
		camera_ray.force_raycast_update()
		
		#var impact_normal = camera_ray.get_collision_normal()
		#var impact_position = camera_ray.get_collision_point()
		
