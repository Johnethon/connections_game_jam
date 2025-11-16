extends Control
class_name CutsceneController

@export var AustraController : CutsceneCharacterController
@export var BorealisController : CutsceneCharacterController

@export var textboxes : Array[Textbox]

@onready var text_box_display = $TextboxDisplay
var current_textbox_index : int = 0

var proper_Austra_pos : Vector2 = Vector2.ZERO
var proper_Borealis_pos : Vector2 = Vector2.ZERO
var proper_text_pos : Vector2 = Vector2.ZERO

var my_level : level = null

func _ready() -> void:
	
	visible = false
	
	#get_tree().paused = true
	if textboxes.is_empty():
		#get_tree().paused = false
		queue_free()
	else:
		$TextboxDisplay.texture = textboxes[current_textbox_index].texture
		AustraController.is_talking = textboxes[current_textbox_index].Austra_Is_Talking
		BorealisController.is_talking = not textboxes[current_textbox_index].Austra_Is_Talking
	
	proper_Austra_pos = AustraController.position
	proper_Borealis_pos = BorealisController.position
	proper_text_pos = $TextboxDisplay.position
	

var pos_tween : Tween = null

func appear():
	
	visible = true
	
	AustraController.position = Vector2(-1000, proper_Austra_pos.y)
	BorealisController.position = Vector2(1000, proper_Borealis_pos.y)
	$TextboxDisplay.position = Vector2(proper_text_pos.x, proper_text_pos.y + 500)
	
	pos_tween = create_tween()
	pos_tween.set_trans(Tween.TRANS_QUAD)
	pos_tween.tween_property(AustraController, "position", proper_Austra_pos, 1.0)
	pos_tween.set_parallel()
	pos_tween.tween_property(BorealisController, "position", proper_Borealis_pos, 1.0)
	pos_tween.tween_property($TextboxDisplay, "position", proper_text_pos, 1.0)
	
	await pos_tween.finished
	pos_tween = null

var disappearing : bool = false

func disappear():
	
	if pos_tween != null:
		if pos_tween.is_running():
			pos_tween.kill()
	
	pos_tween = create_tween()
	pos_tween.set_trans(Tween.TRANS_QUAD)
	pos_tween.tween_property(AustraController, "position", Vector2(-1000, proper_Austra_pos.y), 1.0)
	pos_tween.set_parallel()
	pos_tween.tween_property(BorealisController, "position", Vector2(1000, proper_Borealis_pos.y), 1.0)
	pos_tween.tween_property($TextboxDisplay, "position", Vector2(proper_text_pos.x, proper_text_pos.y + 500), 1.0)
	
	await pos_tween.finished
	
	pos_tween = null
	visible = false
	get_tree().get_first_node_in_group("main").level_cutscene_finished()

func _input(event: InputEvent) -> void:
	
	if not visible or pos_tween != null:
		return
	
	if event.is_pressed() and not event.is_echo():
		current_textbox_index += 1
	
	if current_textbox_index >= textboxes.size():
		disappear()
	else:
		$TextboxDisplay.texture = textboxes[current_textbox_index].texture
		AustraController.is_talking = textboxes[current_textbox_index].Austra_Is_Talking
		BorealisController.is_talking = not textboxes[current_textbox_index].Austra_Is_Talking
