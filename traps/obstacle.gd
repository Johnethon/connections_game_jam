extends Node
class_name Obstacle2D

@export var damage_area: Area2D

func _ready():
	damage_area.body_entered.connect(damage)


func damage(body):
	if body.has_method("die"):
		body.die()
