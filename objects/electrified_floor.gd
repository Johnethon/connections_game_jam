extends Powerable
@export var Negative : bool = false

func _ready():
	super()
	if Negative:
		removed_power()

func given_power():
	if Negative:
		$Node.do_damage = false
	else:
		$Node.do_damage = true

func removed_power():
	if Negative:
		$Node.do_damage = true
	else:
		$Node.do_damage = false
