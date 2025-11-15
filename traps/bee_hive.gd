extends CharacterBody2D

@export var number_of_bees : int = 10
@export var bee : PackedScene
@export var min_aggro_radius : int = 10
@export var max_aggro_radius : int = 100

var intruder : Node2D

func _ready() -> void:
	$AggroActivator/CollisionShape2D.shape.radius = min_aggro_radius
	$AggroDeactivator/CollisionShape2D.shape.radius = max_aggro_radius
	for bee_index in number_of_bees:
		var this_bee = bee.instantiate()
		#this_bee.global_position = global_position + Vector2(randi_range(-10,10),randi_range(-10,10))
		$BeeHandler.add_child(this_bee)
