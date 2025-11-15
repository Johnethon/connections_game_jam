extends Node2D
class_name level

@export var negative_leave_port : Area2D = null
@export var positive_leave_port : Area2D = null

var negative_in_win_spot : bool = false
var positive_in_win_spot : bool = false
	
var level_over : bool = false

func _ready():
	pass

func _process(delta : float):
	if not level_over and (negative_in_win_spot and positive_in_win_spot):
		level_over = true
		level_end()

func negative_spot_entered(body : Node2D):
	if body is Player:
		negative_in_win_spot = true

func negative_spot_exited(body : Node2D):
	if body is Player:
		negative_in_win_spot= false

func positive_spot_entered(body : Node2D):
	if body is Player:
		positive_in_win_spot = true

func positive_spot_exited(body : Node2D):
	if body is Player:
		positive_in_win_spot = false

func level_end():
	var main = get_tree().get_first_node_in_group("main")
	main.next_level()
