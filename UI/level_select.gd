extends Control

@export var number_of_levels_per_line : int = 5

@onready var main = get_tree().get_first_node_in_group("main")
@onready var button_scene = preload("res://UI/menu_button.tscn")
var cur_row_container = null

func _ready():
	for i in range(len(main.levels)):
		
		if i % number_of_levels_per_line == 0:
			var new_row_container = HBoxContainer.new()
			$VBoxContainer.add_child(new_row_container)
			cur_row_container = new_row_container
		
		var new_button = button_scene.instantiate()
		cur_row_container.add_child(new_button)
		if i == 0:
			new_button.text = "Intro"
		elif i == len(main.levels) - 1:
			new_button.text = "End"
		else:
			new_button.text = str(i)
		new_button.pressed.connect(main.start_at_level.bind(i))

func _on_button_pressed() -> void:
	main.go_to_main_menu()
