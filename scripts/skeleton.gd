extends CharacterBody2D
class_name skeleton

@onready var state_machine_follow = $"State Machine/Follow"
@onready var animated_sprite = $AnimatedSprite2D

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
		


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.name == "attack":
		state_machine_follow.attack = false
