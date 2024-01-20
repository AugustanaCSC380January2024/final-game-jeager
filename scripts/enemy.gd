extends CharacterBody2D
class_name enemy

@onready var DAMAGE_INDICATOR = preload("res://scenes/ui/damage_indicator.tscn")
@onready var state_machine_follow = $"State Machine/Follow"
@onready var animated_sprite = $AnimatedSprite2D
@onready var damage_hit_box = $damage_hit_box
@onready var hit_box = $hit_box

@export var max_health_points = 100
@export var health_points = max_health_points
@export var damage = 20

var animation_playing = false

signal enemy_death

func _ready():
	animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _physics_process(delta):
	if !animation_playing:
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
