class_name Player
extends CharacterBody2D

@export var speed = 150
@export var health_points = 100

@onready var animated_sprite = $AnimatedSprite2D
@onready var ultimate = $ultimate
@onready var attack_hitbox = $attack_hitbox

var is_right = true
var alive = true
var active = true
var stop_movement = false

func _ready():
	animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	ultimate.animation_finished.connect(_on_ultimate_animation_finished)
	
func _physics_process(delta):
	var left_right_direction = 0
	var up_down_direction = 0
	var animation
	if !stop_movement and alive:
	#MOVEMENT
		left_right_direction = Input.get_axis("move left", "move right")
		up_down_direction = Input.get_axis("move up", "move down")
		animation = 0
			
	if left_right_direction != 0:
		animation = 0
		if left_right_direction == 1:
			if !is_right:
				flip_sprites(false)
			is_right = true
		else:
			if is_right:
				flip_sprites(true)
			is_right = false
		animated_sprite.flip_h = (left_right_direction == -1)
		animation = abs(left_right_direction)
	if up_down_direction != 0:
		animation = abs(up_down_direction)
	velocity.x = left_right_direction * speed
	velocity.y = up_down_direction * speed
		
	if Input.is_action_just_pressed("normal attack"):
		animation = 2
	elif Input.is_action_just_pressed("ultimate"):
		animation = 3
		
	move_and_slide()
	update_moving_animation(animation)

func update_moving_animation(animation):
	if animation == 0:
		animated_sprite.play("idle")
	elif animation == 1:
		animated_sprite.play("run")
	elif animation == 2:
		animated_sprite.play("attack 1")
		stop_movement = true
	elif animation == 3:
		animated_sprite.play("attack 2")
		stop_movement = true
	elif animation == 4:
		animated_sprite.play("hurt")
	elif animation == 5:
		animated_sprite.play("dead")

func _on_animated_sprite_2d_animation_finished():
	if stop_movement:
		stop_movement = false
		if (animated_sprite.animation == "attack 2"):
			stop_movement = true
			ultimate.visible = true
			ultimate.play("default")

func _on_ultimate_animation_finished():
	ultimate.visible = false
	stop_movement = false

func flip_sprites(flag : bool):
	attack_hitbox.position.x = attack_hitbox.position.x * -1
	ultimate.position.x = ultimate.position.x * -1
	ultimate.flip_h = flag

func take_damage(damage):
	if alive:
		health_points -= damage
		stop_movement = true
		update_moving_animation(4)
		if health_points <= 0:
			alive = false
			update_moving_animation(5)
