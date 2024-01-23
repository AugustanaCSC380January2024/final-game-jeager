extends State
class_name enemy_follow

@export var enemy: CharacterBody2D
@export var move_speed := 40.0
@export var animated_sprite : AnimatedSprite2D
@export var player: CharacterBody2D
@export var attack_range = 45
@export var attack = false
@export var player_detection_range = 300
@export var level_tolerance = 1

@onready var damage_hit_box = $"../../damage_hit_box"
@onready var DEFAULT_PLAYER = CharacterBody2D.new()

func _ready():
	DEFAULT_PLAYER.position = Vector2(-1000, -1000)
	player = DEFAULT_PLAYER
	animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	var verticle_difference = enemy.global_position.y - player.global_position.y
	if direction.length() < player_detection_range:
		if direction.length() > attack_range:
			enemy.velocity = direction.normalized() * move_speed
		else:
			enemy.velocity = Vector2(0, 0)
			attack = true
			if (abs(verticle_difference) > level_tolerance):
				enemy.velocity = Vector2(0, -sign(verticle_difference)) * move_speed
				attack = false
	else:
		enemy.velocity = Vector2()
		attack = false

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack":
		var direction = player.global_position - enemy.global_position
		print("hereeeee")
		if direction.length() < attack_range:
			player.take_damage(enemy.damage)
