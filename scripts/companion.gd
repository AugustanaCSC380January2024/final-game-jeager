extends CharacterBody2D

@export var player: Player
@export var speed = 90

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var nav_agent = $NavigationAgent2D
@onready var coin = preload("res://scenes/other/coin.tscn")

var stop_movement = false

func _physics_process(delta):
	if !stop_movement:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		nav_agent.target_position = player.get_companion_maker_position()
		var distance = position - nav_agent.target_position
		if dir.x < 0:
			animated_sprite.flip_h = false
		elif dir.x > 0:
			animated_sprite.flip_h = true

		if (abs(distance.x)> 2 or abs(distance.y) > 2):
			velocity = dir * speed
			animated_sprite.play("walk")
			move_and_slide()
		else:
			animated_sprite.play("idle")

func take_damage():
	animated_sprite.play("idle")

func set_stop_movement(flag):
	stop_movement = flag
