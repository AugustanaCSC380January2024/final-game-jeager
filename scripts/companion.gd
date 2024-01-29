extends CharacterBody2D

@export var player: Player
@export var speed = 90

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var nav_agent = $NavigationAgent2D
@onready var coin = preload("res://scenes/other/coin.tscn")

var stop_movement = false

var teleport_in_progress = false

func _ready():
	animated_sprite.animation_finished.connect(animation_finished)
	
func _physics_process(delta):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	nav_agent.target_position = player.get_companion_maker_position()
	#var distance = position - nav_agent.target_position
	var distance = sqrt(pow(global_position.x - player.global_position.x, 2) + pow(global_position.y - player.global_position.y, 2))
	
	if dir.x < 0:
		animated_sprite.flip_h = false
	elif dir.x > 0:
		animated_sprite.flip_h = true
		
	#if (abs(distance.x)> 70 and abs(distance.y) > 70):
	if distance > 500:
		velocity = dir * speed
		global_position = player.get_companion_maker_position()
		animated_sprite.play("teleport")
		teleport_in_progress = true
	elif !teleport_in_progress:
		if (distance > 100):
			velocity = dir * speed
			animated_sprite.play("walk")
			move_and_slide()
		else:
			animated_sprite.play("idle")

func take_damage():
	animated_sprite.play("idle")

func animation_finished():
	if animated_sprite.animation == "teleport":
		teleport_in_progress = false

func set_stop_movement(flag):
	stop_movement = flag

