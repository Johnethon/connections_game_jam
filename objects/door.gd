extends Powerable

var open_shut_tween : Tween = null

@onready var left_door = $left_door
@onready var right_door = $right_door

func given_power():
	
	if open_shut_tween != null:
		open_shut_tween.kill()
	
	open_shut_tween = create_tween()
	open_shut_tween.set_trans(Tween.TRANS_QUAD)
	open_shut_tween.tween_property(left_door, "position", Vector2(-32,0), 1.0)
	open_shut_tween.parallel()
	open_shut_tween.tween_property(right_door, "position", Vector2(32, 0), 1.0)

func removed_power():
	
	if open_shut_tween != null:
		open_shut_tween.kill()
	
	open_shut_tween = create_tween()
	open_shut_tween.set_trans(Tween.TRANS_QUAD)
	open_shut_tween.tween_property(left_door, "position", Vector2(-16,0), 1.0)
	open_shut_tween.parallel()
	open_shut_tween.tween_property(right_door, "position", Vector2(16, 0), 1.0)
