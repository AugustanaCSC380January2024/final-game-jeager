extends CharacterBody2D

@export var speed = 150

@onready var animated_sprite = $AnimatedSprite2D

var active = true
var player_attacking = false

func _ready():
	animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	
func _physics_process(delta):
	if !player_attacking:
	#MOVEMENT
		var left_right_direction = Input.get_axis("move left", "move right")
		var up_down_direction = Input.get_axis("move up", "move down")
		var animation = 0
		if left_right_direction != 0:
			animated_sprite.flip_h = (left_right_direction == -1)
			animation = abs(left_right_direction)
		if up_down_direction != 0:
			animation = abs(up_down_direction)
		velocity.x = left_right_direction * speed
		velocity.y = up_down_direction * speed
		
		if Input.is_action_just_pressed("normal attack"):
			animation = 2
		
		move_and_slide()
		update_moving_animation(animation)

func update_moving_animation(animation):
	if animation == 0:
		animated_sprite.play("idle")
	elif animation == 1:
		animated_sprite.play("run")
	elif animation == 2:
		animated_sprite.play("attack 1")
		player_attacking = true

func _on_animated_sprite_2d_animation_finished():
	if player_attacking:
		player_attacking = false
	
