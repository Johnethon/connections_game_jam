extends CharacterBody2D

@export var lifetime := 2.0

func _physics_process(delta):
	move_and_slide()

func _process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
