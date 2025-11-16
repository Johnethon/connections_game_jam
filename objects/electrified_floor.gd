extends Powerable

func given_power():
	$Node.do_damage = true

func removed_power():
	$Node.do_damage = false
