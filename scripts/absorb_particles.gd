extends Node2D

var target_position = position
var speed = 200

@onready var nav_agent = $NavigationAgent2D

func _physics_process(delta):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	nav_agent.target_position = target_position
	position = dir * speed

func set_target_position(tar_pos):
	target_position = tar_pos
