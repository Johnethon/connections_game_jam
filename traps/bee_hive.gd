extends Powerable

@export var number_of_bees : int = 10
@export var bee : PackedScene
@export var min_aggro_radius : int = 50
@export var max_aggro_radius : int = 200

@export var bee_speed : int = 100
@export var bee_turn_rate : int = 5

@export var bee_handler_patrol_accel : int = 6
@export var bee_handler_chase_accel : int = 3

var intruder : Node2D

func personal_ready() -> void:
	
	$AggroActivator/CollisionShape2D.shape.radius = min_aggro_radius
	$AggroDeactivator/CollisionShape2D.shape.radius = max_aggro_radius
	$aggro_radius.scale = Vector2(min_aggro_radius * 2.0 / 8.0, min_aggro_radius * 2.0 / 8.0)
	
	for bee_index in number_of_bees:
		
		var this_bee = bee.instantiate()
		$BeeHandler.add_child(this_bee)
		
		this_bee.speed = bee_speed
		this_bee.turn_speed = bee_turn_rate
		$BeeHandler.move_speed = bee_speed * 1.3
		$BeeHandler.patrol_accel = bee_handler_chase_accel
		$BeeHandler.chase_accel = bee_handler_patrol_accel
		
	$bee_target_axis.get_child(0).position.x = min_aggro_radius

func personal_process(delta:float):
	$bee_target_axis.rotation += 5 * delta
	#$RedCircle2.global_position = $BeeHandler.fake_global_position
