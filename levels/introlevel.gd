extends level


@export var text_boxes : Array[Sprite2D] = []

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().get_first_node_in_group("main").pause_game()
