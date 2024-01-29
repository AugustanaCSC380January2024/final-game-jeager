extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D



	
	
func _physics_process(delta):
	animated_sprite.play("idle")

func take_damage():
	animated_sprite.play("hurt")




