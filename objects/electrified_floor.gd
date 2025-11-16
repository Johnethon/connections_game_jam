extends Powerable

func personal_ready():
	if reverse:
		given_power()

func given_power():
	$Node.do_damage = true

func removed_power():
	$Node.do_damage = false
