extends Control
class_name  CutsceneCharacterController

@export var mouth_shut_eyes_open : Texture2D
@export var mouth_open_eyes_open : Texture2D
@export var mouth_shut_eyes_shut : Texture2D
@export var mouth_open_eyes_shut : Texture2D

@onready var display = $TextureRect

var is_talking: bool = false
var is_blinking: bool = false
@onready var blink_duration: float = randf_range(0.2,0.4)

func _ready() -> void:
	$BlinkTimer.timeout.connect(_on_blink_timer_timeout)
	$BlinkTimer.start(randf_range(3,4))

func _process(delta: float) -> void:
	if is_blinking:
		blink_duration -=delta
		if is_talking:
			display.texture = mouth_open_eyes_shut
		else:
			display.texture = mouth_shut_eyes_shut
	else:
		blink_duration = randf_range(0.3,0.4)
		if is_talking:
			display.texture = mouth_open_eyes_open
		else:
			display.texture = mouth_shut_eyes_open
	
	if blink_duration <= 0:
		is_blinking = false

func _on_blink_timer_timeout() -> void:
	is_blinking = true
	$BlinkTimer.start(randf_range(3,4))
