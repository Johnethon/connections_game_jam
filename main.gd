extends Node2D
class_name Main

@export var levels : Array[PackedScene] = []

var cur_level_scene = null
var cur_level_node = null
var cur_level_index = 0

var resets_in_a_row = 0
func reset_cur_level():
	
	if cur_level_scene != null and cur_level_node != null:
		pass
	resets_in_a_row += 1
	
	if resets_in_a_row >= 3:
		resets_in_a_row = 0
		start_at_level(cur_level_index)
	
func next_level():
	pass

func start_at_level(index_to_start_at):
	pass

func start_game():
	pass

func play_transition():
	pass
