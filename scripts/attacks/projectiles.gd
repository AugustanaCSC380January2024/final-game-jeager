extends Area2D
@export var projectile_damage = 50
@onready var projectile_timer = $Timer
@onready var sprite = $Sprite2D

@export var projectile_speed = 620


func _ready():
	projectile_timer.timeout.connect(_on_timer_timeout)
	body_entered.connect(_on_body_entered)
	projectile_timer.start()
	
func _physics_process(delta):
	position.x += delta * projectile_speed


func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.get_class() == "CharacterBody2D":
		body.take_damage(projectile_damage)
		queue_free()
	elif body.get_class() == "TileMap":
		queue_free()

func change_projectile_direction(val):
	if val < 0:
		projectile_speed = -projectile_speed
		sprite.flip_h = true
		$CollisionShape2D.position *= -1
	else:
		projectile_speed = abs(projectile_speed)
		sprite.flip_h = false
	
