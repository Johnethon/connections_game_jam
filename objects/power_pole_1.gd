extends MagneticObject

@export var max_length = 300
@export var max_spool_scale = 1.5

@export var power_cable : PowerCable = null

func personal_ready():
	power_cable.max_length = max_length
	power_cable.max_spool_scale = max_spool_scale
