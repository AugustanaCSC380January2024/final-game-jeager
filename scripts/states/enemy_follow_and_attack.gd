extends State
class_name enemy_follow

@export var enemy: CharacterBody2D
@export var move_speed := 40.0
@export var animated_sprite : AnimatedSprite2D
@export var player: CharacterBody2D
@export var attack_range = 45
@export var attack = false
@export var player_detection_range = 300

func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	if direction.length() < player_detection_range:
		if direction.length() > attack_range:
			enemy.velocity = direction.normalized() * move_speed
		else:
			enemy.velocity = Vector2(0, 0)
			attack = true
	else:
		enemy.velocity = Vector2()
		attack = false
