extends Node2D
class_name Main

@export var main_menu : PackedScene = null
@export var pause_menu : PackedScene = null
@export var level_select_menu : PackedScene = null
@export var settings_menu : PackedScene = null

@export var cur_menu : Control = null

@export var levels : Array[PackedScene] = []

var cur_level_scene = null
var cur_level_node = null
var cur_level_index = 0

var in_cutscene : bool = false
var resets_in_a_row = 0
func reset_cur_level():
	
	if cur_level_scene != null and cur_level_node != null:
		pass
	resets_in_a_row += 1
	
	if resets_in_a_row >= 3:
		resets_in_a_row = 0
		start_at_level(cur_level_index)
	
func start_game():
	cur_level_index = 0
	start_at_level(0)

func next_level():
	cur_level_index += 1
	start_at_level(cur_level_index)

func start_at_level(index_to_start_at):
	cur_level_scene = levels[index_to_start_at]
	play_transition()

@onready var transition_sprite : AnimatedSprite2D = $transition_anim
func play_transition():
	in_cutscene = true
	
	transition_sprite.visible = true
	
	transition_sprite.play("fade_to_black")
	await transition_sprite.animation_finished
	
	cur_level_node = cur_level_scene.instantiate()
	add_child(cur_level_node)
	cur_menu.queue_free()
	cur_menu = null
	
	await get_tree().create_timer(1.0).timeout
	
	transition_sprite.play("fade_to_screen")
	await transition_sprite.animation_finished
	
	transition_sprite.visible = false
	in_cutscene = false
	
