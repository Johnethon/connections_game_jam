extends Control

@onready var main = get_tree().get_first_node_in_group("main")


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	main.go_to_main_menu()
