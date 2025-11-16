extends Control


func _on_button_pressed() -> void:
	get_tree().get_first_node_in_group("main").go_to_main_menu()
