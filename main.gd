extends Node2D
class_name Main

@export var main_menu : PackedScene = null
@export var pause_menu : PackedScene = null
@export var level_select_menu : PackedScene = null
@export var credits_menu : PackedScene = null

@export var cur_menu : Control = null

@export var levels : Array[PackedScene] = []

@onready var camera : Camera2D = $Camera2D

var cur_level_scene = null
var cur_level_node = null
var cur_level_index = 0

var in_cutscene : bool = false

var resets_in_a_row = 0
func reset_cur_level( instant:bool = false):
	
	if cur_level_scene != null and cur_level_node != null:
		pass
	resets_in_a_row += 1
	
	if resets_in_a_row >= 3 or instant:
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
	cur_level_index = index_to_start_at
	play_level_transition()

@onready var transition_sprite : AnimatedSprite2D = $CanvasLayer/transition_anim
func play_level_transition():
	in_cutscene = true
	
	transition_sprite.visible = true
	
	transition_sprite.play("fade_to_black")
	await transition_sprite.animation_finished
	
	if cur_level_node:
		cur_level_node.queue_free()
	
	cur_level_node = cur_level_scene.instantiate()
	$level_spot.add_child(cur_level_node)
	
	if cur_menu != null:
		cur_menu.queue_free()
		cur_menu = null
	
	await get_tree().create_timer(1.0).timeout
	
	transition_sprite.play("fade_to_screen")
	await transition_sprite.animation_finished
	
	transition_sprite.visible = false
	
	
	cur_level_node.spawn_in_players()
	
func pause_game():
	if cur_menu != null:
		cur_menu.queue_free()
		cur_menu = null
	
	cur_menu = pause_menu.instantiate()
	$CanvasLayer.add_child(cur_menu)
	
func go_to_level_select():
	
	if cur_menu != null:
		cur_menu.queue_free()
		cur_menu = null
		
	cur_menu = level_select_menu.instantiate()
	$CanvasLayer.add_child(cur_menu)

func go_to_credits():
	if cur_menu != null:
		cur_menu.queue_free()
		cur_menu = null
		
	cur_menu = credits_menu.instantiate()
	$CanvasLayer.add_child(cur_menu)
	
func go_to_main_menu():
	if cur_menu != null:
		cur_menu.queue_free()
		cur_menu = null
		
	cur_menu = main_menu.instantiate()
	$CanvasLayer.add_child(cur_menu)
	
func level_cutscene_finished():
	if cur_level_node != null:
		cur_level_node.cutscene_over()

func _physics_process(delta: float) -> void:
	#print(camera.get_viewport_rect())
	transition_sprite.position = camera.get_viewport_rect().size/2
