extends Node3D
class_name power_cable

var cable_nodes = []

#@onready var base_cable_piece : CablePiece = null
var picked_up : bool = false

func _process(delta : float):
	if picked_up:
		cable_check_and_place()

func cable_check_and_place():
	pass
