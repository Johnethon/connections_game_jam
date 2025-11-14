extends StaticBody2D


@export var target : Node2D
var active : bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("cable"):
		if target.has_method("activate"):
			target.activate()
			active = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("cable"):
		if target.has_method("deactivate"):
			target.deactivate()
			active = false
