extends Powerable
class_name PowerCable

var attached : bool = false
@export var node_i_am_attached_to : Node2D = null

@export var max_length = 1000
@export var max_spool_scale = 4.0

@onready var head_hitbox : Area2D = $head_hitbox
@onready var cable_head : Sprite2D = $cable_head
@onready var cable_body : Sprite2D = $cable_body


func interact(node_interacting_with_me : Node2D):
	if node_interacting_with_me is Player:
		if node_interacting_with_me.held_object == null:
			if node_i_am_attached_to != null:
				if node_i_am_attached_to is Powerable:
					node_i_am_attached_to.remove_input(self)
			
			node_interacting_with_me.held_object = self
			attached = true
			node_i_am_attached_to = node_interacting_with_me

func _ready():
	if node_i_am_attached_to != null:
		attached = true

func _process(_delta : float):
	
	if attached:
		head_hitbox.global_position = node_i_am_attached_to.global_position
		
		if head_hitbox.global_position.distance_to(node_i_am_attached_to.global_position) > max_length:
			#return home
			attached = false
		
		#if node_i_am_attached_to is Powerable
	else:
		pass
	
	cable_head.global_position = head_hitbox.global_position
	
	var dist_to = cable_head.global_position.distance_to(global_position)
	var dir_to = cable_head.global_position.direction_to(global_position)
	
	cable_body.global_position = cable_head.global_position +  dir_to * dist_to / 2
	cable_body.look_at(global_position)
	
	cable_body.scale.x = dist_to / 8 #px size of player sprite
