extends Control


func _on_button_pressed() -> void:
	get_tree().get_first_node_in_group("main").start_game()
	#if pressed_once:
		#$VBoxContainer/Quit.text = "Yay :)"
		#pressed_once = false

func _on_level_select_pressed() -> void:
	get_tree().get_first_node_in_group("main").go_to_level_select()
	#if pressed_once:
		#$VBoxContainer/Quit.text = "Yay :)"
		#pressed_once = false

func _on_credits_pressed() -> void:
	get_tree().get_first_node_in_group("main").go_to_credits()
	#if pressed_once:
		#$VBoxContainer/Quit.text = "Yay :)"
		#pressed_once = false

#var pressed_once : bool = false
func _on_quit_pressed() -> void:
	#if not pressed_once:
		#$VBoxContainer/Quit.text = "Really? :("
		#pressed_once = true
	#else:
	get_tree().quit()
