extends Area2D

@onready var arrow_timer = $Timer
@onready var sprite = $Sprite2D

@export var arrow_speed = 620

func _ready():
	arrow_timer.start()
	
func _physics_process(delta):
	position.x += delta * arrow_speed

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.get_class() == "CharacterBody2D":
		body.take_damage(50)
	elif body.get_class() == "TileMap":
		queue_free()

func change_arrow_direction(val):
	if val < 0:
		arrow_speed = -arrow_speed
		sprite.flip_h = true
	else:
		arrow_speed = abs(arrow_speed)
		sprite.flip_h = false
