extends Node2D

@export var cutscene_layer : CanvasLayer = null

func spawn_in_players():
	play_cutscene()

@onready var main : Main = get_tree().get_first_node_in_group("main")

func play_cutscene():
	cutscene_layer.get_child(0).appear()
	
func cutscene_over():
	main.next_level()
