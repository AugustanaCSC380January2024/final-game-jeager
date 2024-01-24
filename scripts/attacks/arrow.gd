extends Area2D

@onready var arrow_timer = $Timer
var arrow_speed = 620

func _ready():
	arrow_timer.start()
	
func _physics_process(delta):
	position.x += delta * arrow_speed

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.get_class() == "CharacterBody2D":
		body.take_damage(50)
	queue_free()
