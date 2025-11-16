extends Powerable
class_name PowerCable

var attached : bool = false
@export var node_i_am_attached_to : Node2D = null

@export var max_length = 300
@export var max_spool_scale = 3.0
@export var min_spool_scale = 1.0

@onready var head_hitbox : Area2D = $head_hitbox
@onready var cable_head : Sprite2D = $cable_head
@onready var cable_head_no_power : Sprite2D = $cable_head_no_power

@onready var cable_body : Sprite2D = $cable_body
@onready var cable_spool : Sprite2D = $cable_spool

var cable_head_home_position = Vector2.ZERO

func interact(node_interacting_with_me : Node2D):
	if node_interacting_with_me is Player:
		if node_interacting_with_me.held_object == null:
			if node_i_am_attached_to != null:
				if node_i_am_attached_to is Powerable:
					node_i_am_attached_to.remove_input(self)
			
			node_interacting_with_me.held_object = self
			attached = true
			node_i_am_attached_to = node_interacting_with_me.wire_holding_spot
	
func personal_ready():
	
	if node_i_am_attached_to != null:
		attached = true
		if node_i_am_attached_to is Powerable:
			node_i_am_attached_to.connect_input(self)
	
	if get_parent() is RigidBody2D:
		cable_spool.get_child(0).get_child(0).disabled = true

	cable_head_home_position = cable_head.position

func personal_process(delta : float):
	
	if attached:
		head_hitbox.global_position = node_i_am_attached_to.global_position

		if head_hitbox.global_position.distance_to(global_position) > max_length:
			attached = false
			
			if node_i_am_attached_to is Powerable:
				node_i_am_attached_to.remove_input(self)
			elif node_i_am_attached_to.get_parent() is Player:
				node_i_am_attached_to.get_parent().held_object = null
			
			node_i_am_attached_to = null
		
		#if node_i_am_attached_to is Powerable
	else:
		
		head_hitbox.position = head_hitbox.position.lerp(cable_head_home_position, delta * 3)
	
	cable_head.global_position = head_hitbox.global_position
	cable_head_no_power.global_position = head_hitbox.global_position
	
	var dist_to = cable_head.global_position.distance_to(global_position)
	var dir_to = cable_head.global_position.direction_to(global_position)
	
	cable_body.global_position = cable_head.global_position +  dir_to * dist_to / 2
	cable_body.look_at(global_position)
	
	cable_body.scale.x = dist_to / 8 #px size of player sprite
	
	var spool_scale = max_spool_scale - (max_spool_scale - min_spool_scale) * dist_to / max_length
	cable_spool.scale = Vector2(spool_scale, spool_scale)
	
	cable_head_home_position.y = -max_spool_scale * 6
