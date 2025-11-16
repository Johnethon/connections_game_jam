extends Node2D

func spawn_in_players():
	play_cutscene()

@export var text_boxes : Array[Sprite2D] = []
@onready var main : Main = get_tree().get_first_node_in_group("main")
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		main.pause_game()

func play_cutscene():
	main.next_level()
