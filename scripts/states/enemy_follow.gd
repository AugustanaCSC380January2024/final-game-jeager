extends State
class_name enemy_follow

@export var enemy: CharacterBody2D
@export var move_speed := 40.0
@export var animated_sprite : AnimatedSprite2D
@export var player: CharacterBody2D
@export var attack = false

#func Enter():
	#player = get_tree().get_first_node_in_group("hayate")


func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	if direction.length() < 300:
		if direction.length() > 45:
			enemy.velocity = direction.normalized() * move_speed
		else:
			enemy.velocity = Vector2(0, 0)
			attack = true
	else:
		enemy.velocity = Vector2()
		attack = false
