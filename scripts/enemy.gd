extends CharacterBody2D
class_name enemy

@onready var state_machine_follow = $"State Machine/Follow"
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_hit_box = $attack_hit_box
@onready var hit_box = $hit_box

@export var max_health_points = 100
@export var health_points = max_health_points
@export var damage = 20


func _physics_process(delta):
	if velocity.length() > 0:
		animated_sprite.play("walk")
		move_and_slide()
	else:
		if state_machine_follow.attack:
			animated_sprite.play("attack")
		else:
			animated_sprite.play("idle")
	if velocity.x > 0:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true

func take_damage(damage):
	health_points -= damage
