extends Control
class_name CutsceneController

@export var character1 : CutsceneCharacterController
@export var character2 : CutsceneCharacterController

@export var textboxes : Array[Textbox]

@onready var text_box_display = $TextboxDisplay
var current_textbox_index : int = 0

func _ready() -> void:
	get_tree().paused = true
	if textboxes.is_empty():
		print("There were no textboxes for this cutscene: " + self.to_string())
		get_tree().paused = false
		queue_free()
	else:
		$TextboxDisplay.texture = textboxes[current_textbox_index].texture
		character1.is_talking = textboxes[current_textbox_index].Person1Talking
		character2.is_talking = textboxes[current_textbox_index].Person2Talking
		print("timer_started")
		$Timer.start(textboxes[current_textbox_index].Duration)


func _on_timer_timeout() -> void:
	print("current_textbox_index: " + str(current_textbox_index))
	current_textbox_index += 1
	if current_textbox_index >= textboxes.size():
		get_tree().paused = false
		queue_free()
		pass # End cutscene
	else:
		$TextboxDisplay.texture = textboxes[current_textbox_index].texture
		character1.is_talking = textboxes[current_textbox_index].Person1Talking
		character2.is_talking = textboxes[current_textbox_index].Person2Talking
		$Timer.start(textboxes[current_textbox_index].Duration)
	
