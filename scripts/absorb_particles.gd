extends CharacterBody2D

@export var speed = 150
@onready var nav_agent = $NavigationAgent2D

var target: CharacterBody2D

signal absorbed_by_slime

func _ready():
	nav_agent.target_reached.connect(_on_target_reached)

func _physics_process(delta):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	nav_agent.target_position = target.global_position
	velocity = dir * speed
	move_and_slide()

func set_global_pos(pos):
	global_position = pos

func set_target(tar):
	target = tar

func _on_target_reached():
	absorbed_by_slime.emit()
	queue_free()
	target.set_stop_movement(false)

