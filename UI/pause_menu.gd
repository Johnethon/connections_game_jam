extends Control

@onready var main : Main = get_tree().get_first_node_in_group("main")
@export var things_to_fade : Array[Control] = []

var in_pause_menu : bool = false
func _input(event : InputEvent):
	if Input.is_action_just_pressed("pause"):
		no_more_pause()

func _ready():
	#print(size.x)
	#position.x = 0
	get_tree().paused = true
	
	for item in things_to_fade:
		item.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	var tween = create_tween()
	tween.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(main.camera,"zoom", Vector2(.8, .8), 1.0)
	tween.set_parallel()
	for item in things_to_fade:
		tween.tween_property(item,"self_modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	await tween.finished
	
	in_pause_menu = true

func no_more_pause():
	in_pause_menu = false
	
	var tween = create_tween()
	tween.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(main.camera,"zoom", Vector2(1.0, 1.0), 1.0)
	tween.set_parallel()
	for item in things_to_fade:
		tween.tween_property(item,"self_modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)
	
	await tween.finished
	get_tree().paused = false
	queue_free()
