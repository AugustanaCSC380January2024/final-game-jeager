extends CharacterBody2D
class_name enemy

@onready var DAMAGE_INDICATOR = preload("res://scenes/ui/damage_indicator.tscn")
@onready var state_machine_follow = $"State Machine/Follow"
@onready var animated_sprite = $AnimatedSprite2D
@onready var damage_hit_box = $damage_hit_box
@onready var damage_hit_box_collision_box = $damage_hit_box/damage_area
@onready var player_detection_area = $player_detection_area
@onready var collision_box = $collision_box

@export var max_health_points = 100
@export var health_points = max_health_points
@export var damage = 20

var animation_playing = false
var player_direction

signal enemy_death

func _ready():
	animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	player_detection_area.body_entered.connect(_on_player_detection_area_body_entered)
	player_detection_area.body_exited.connect(_on_player_detection_area_body_exited)

func _physics_process(delta):
	player_direction = state_machine_follow.player.position - position
	if !animation_playing:
		if velocity.length() > 0:
			animated_sprite.play("walk")
			move_and_slide()
		else:
			if state_machine_follow.attack:
				animated_sprite.play("attack")
				animation_playing = true
			else:
				animated_sprite.play("idle")
		if player_direction.x > 0:
			animated_sprite.flip_h = false
			collision_box.position.x = -abs(collision_box.position.x)
			damage_hit_box_collision_box.position.x = abs(damage_hit_box_collision_box.position.x)
		else:
			animated_sprite.flip_h = true
			collision_box.position.x = abs(collision_box.position.x)
			damage_hit_box_collision_box.position.x = -abs(damage_hit_box_collision_box.position.x)

func take_damage(damage):
	health_points -= damage
	spawn_dmgIndicator(damage)
	if (health_points <= 0):
		animation_playing = true
		animated_sprite.play("death")
	else:
		animation_playing = true
		animated_sprite.play("hurt")

func spawn_effect(EFFECT: PackedScene, effect_position):
	if EFFECT:
		var effect = EFFECT.instantiate()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect

func spawn_dmgIndicator(damage: int):
	var indicator = spawn_effect(DAMAGE_INDICATOR, global_position + Vector2(20, 10))
	if indicator:
		indicator.label.text = str(damage)

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "death":
		enemy_death.emit(global_position)
		queue_free()
	elif animated_sprite.animation == "hurt":
		animation_playing = false
	elif animated_sprite.animation == "attack":
		animation_playing = false

func _on_player_detection_area_body_entered(body):
	if body is Player:
		state_machine_follow.player = body

func _on_player_detection_area_body_exited(body):
	if body is Player:
		state_machine_follow.player = state_machine_follow.DEFAULT_PLAYER

