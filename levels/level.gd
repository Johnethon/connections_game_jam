extends Node2D
class_name level

@export var negative_leave_port : Area2D = null
@export var positive_leave_port : Area2D = null

@export var negative_entrance_port : Node2D = null
@export var positive_entrance_port : Node2D = null

@export var negative_exit_beam : Node2D = null
@export var positive_exit_beam : Node2D = null

@export var negative_in_port_indicator : Sprite2D = null
@export var positive_in_port_indicator : Sprite2D = null

var negative_in_win_spot : bool = false
var positive_in_win_spot : bool = false

var level_over : bool = false

var positive_player_scene = preload("res://player/player_positive.tscn")
var negative_player_scene = preload("res://player/player_negative.tscn")

var negative_player : Player = null
var positive_player : Player = null

@onready var main = get_tree().get_first_node_in_group("main")

func spawn_in_players():
	negative_exit_beam.scale.y = 0
	negative_exit_beam.global_position = negative_entrance_port.global_position + Vector2(0, 32)
	
	positive_exit_beam.scale.y = 0
	positive_exit_beam.global_position = positive_entrance_port.global_position + Vector2(0, 32)
	
	var tween = create_tween()
	tween.set_trans(tween.TRANS_QUAD)
	tween.tween_property(negative_exit_beam, "scale", Vector2(1, 20), 1.0)
	tween.set_parallel()
	tween.tween_property(positive_exit_beam, "scale", Vector2(1, 20), 1.0)
	tween.set_parallel(false)
	tween.tween_interval(1.0)
	
	await tween.finished
	
	positive_player = positive_player_scene.instantiate()
	add_child(positive_player)
	positive_player.global_position = positive_entrance_port.global_position + Vector2(0,-64)
	
	negative_player = negative_player_scene.instantiate()
	add_child(negative_player)
	negative_player.global_position = negative_entrance_port.global_position + Vector2(0,-64)
	negative_player.sprite.scale.x = -1
	
	tween = create_tween()
	tween.set_trans(tween.TRANS_QUAD)
	tween.tween_property(negative_exit_beam, "scale", Vector2(1, 0), 1.0)
	tween.set_parallel()
	tween.tween_property(positive_exit_beam, "scale", Vector2(1,0), 1.0)
	tween.set_parallel(false)
	tween.tween_interval(1.0)
	
	await tween.finished
	
	if has_cutscene:
		play_cutscene()
	else:
		main.in_cutscene = false

func make_players_leave():
	
	main.in_cutscene = true
	
	negative_exit_beam.scale.y = 0
	negative_exit_beam.global_position = negative_leave_port.global_position + Vector2(0, 32)
	
	positive_exit_beam.scale.y = 0
	positive_exit_beam.global_position = positive_leave_port.global_position + Vector2(0, 32)
	
	var tween = create_tween()
	tween.set_trans(tween.TRANS_QUAD)
	tween.tween_property(negative_exit_beam, "scale", Vector2(1, 20), 1.0)
	tween.set_parallel()
	tween.tween_property(positive_exit_beam, "scale", Vector2(1, 20), 1.0)
	tween.set_parallel(false)
	tween.tween_interval(1.0)
	
	await tween.finished
	negative_player.queue_free()
	positive_player.queue_free()
	
	tween = create_tween()
	tween.set_trans(tween.TRANS_QUAD)
	tween.tween_property(negative_exit_beam, "scale", Vector2(1, 0), 1.0)
	tween.set_parallel()
	tween.tween_property(positive_exit_beam, "scale", Vector2(1,0), 1.0)
	tween.set_parallel(false)
	tween.tween_interval(1.0)
	
	await tween.finished
	
	
	
	main.next_level()


func _ready():
	
	if negative_leave_port != null:
		negative_leave_port.body_entered.connect(negative_spot_entered)
		negative_leave_port.body_exited.connect(negative_spot_exited)
	
	if positive_leave_port != null:
		positive_leave_port.body_entered.connect(positive_spot_entered)
		positive_leave_port.body_exited.connect(positive_spot_exited)

func _process(_delta : float):
	if not level_over and (negative_in_win_spot and positive_in_win_spot):
		level_over = true
		level_end()

func negative_spot_entered(body : Node2D):
	if body is Player:
		negative_in_win_spot = true
		negative_in_port_indicator.visible = true

func negative_spot_exited(body : Node2D):
	if body is Player:
		negative_in_win_spot = false
		negative_in_port_indicator.visible = false

func positive_spot_entered(body : Node2D):
	if body is Player:
		positive_in_win_spot = true
		positive_in_port_indicator.visible = true
	
func positive_spot_exited(body : Node2D):
	if body is Player:
		positive_in_win_spot = false
		positive_in_port_indicator.visible = false

func level_end():
	make_players_leave()

@export var has_cutscene : bool = false
func play_cutscene():
	pass
