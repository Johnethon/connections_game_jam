extends Control
class_name CutsceneController

@export var AustraController : CutsceneCharacterController
@export var BorealisController : CutsceneCharacterController

@export var textboxes : Array[Textbox]

@onready var text_box_display = $TextboxDisplay
var current_textbox_index : int = 0

func _ready() -> void:
	get_tree().paused = true
	if textboxes.is_empty():
		get_tree().paused = false
		queue_free()
	else:
		$TextboxDisplay.texture = textboxes[current_textbox_index].texture
		AustraController.is_talking = textboxes[current_textbox_index].Austra_Is_Talking
		BorealisController.is_talking = not textboxes[current_textbox_index].Austra_Is_Talking


func _input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		current_textbox_index += 1
	if current_textbox_index >= textboxes.size():
		get_tree().paused = false
		queue_free()
		pass # End cutscene
	else:
		$TextboxDisplay.texture = textboxes[current_textbox_index].texture
		AustraController.is_talking = textboxes[current_textbox_index].Austra_Is_Talking
		BorealisController.is_talking = not textboxes[current_textbox_index].Austra_Is_Talking
