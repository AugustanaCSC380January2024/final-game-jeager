extends CharacterBody2D
class_name enemy

@onready var DAMAGE_INDICATOR = preload("res://scenes/ui/damage_indicator.tscn")
@onready var animated_sprite = $AnimatedSprite2D
@onready var damage_hit_box = $damage_hit_box
@onready var damage_hit_box_collision_box = $damage_hit_box/damage_area
@onready var player_detection_area = $player_detection_area
@onready var player_detection_area_collision_box = $player_detection_area/CollisionShape2D
@onready var collision_box = $collision_box
@onready var DEFAULT_PLAYER = CharacterBody2D.new()
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@export var level_tolerance = 1
@export var player: CharacterBody2D
@export var max_health_points = 100
@export var health_points = max_health_points
@export var damage = 20
@export var attack_range = 10
@export var player_detection_range = 1
@export var move_speed := 40.0

var animation_playing = false
var player_in_damage_hit_box: CharacterBody2D

signal enemy_death

func _ready():
	animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	player_detection_area.body_entered.connect(_on_player_detection_area_body_entered)
	player_detection_area.body_exited.connect(_on_player_detection_area_body_exited)
	damage_hit_box.body_entered.connect(_on_damage_hit_box_body_entered)
	damage_hit_box.body_exited.connect(_on_damage_hit_box_body_exited)
	DEFAULT_PLAYER.position = Vector2(-1000, -1000)
	player_detection_area.apply_scale(Vector2(player_detection_range, player_detection_range))
	player = DEFAULT_PLAYER

func _physics_process(delta):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	if !animation_playing:
		if player_in_damage_hit_box != null:
			animated_sprite.play("attack")
			animation_playing = true
		elif (player != DEFAULT_PLAYER):
			make_path()
			var distance = player.global_position - position
			velocity = dir * move_speed
			if dir.x > 0:
				animated_sprite.flip_h = false
				collision_box.position.x = -abs(collision_box.position.x)
				damage_hit_box_collision_box.position.x = abs(damage_hit_box_collision_box.position.x)
			elif dir.x < 0:
				animated_sprite.flip_h = true
				collision_box.position.x = abs(collision_box.position.x)
				damage_hit_box_collision_box.position.x = -abs(damage_hit_box_collision_box.position.x)
			animated_sprite.play("walk")
			move_and_slide()
		else:
			animated_sprite.play("idle")

func make_path():
	nav_agent.target_position = player.global_position

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
	elif animated_sprite.animation == "attack":
		if player_in_damage_hit_box != null:
			player_in_damage_hit_box.take_damage(damage)
	elif animated_sprite.animation == "death":
		enemy_death.emit(global_position)
		queue_free()
	animation_playing = false

func _on_player_detection_area_body_entered(body):
	if body is Player:
		#state_machine_follow.player = body
		player = body

func _on_player_detection_area_body_exited(body):
	if body is Player:
		player = DEFAULT_PLAYER

func _on_damage_hit_box_body_entered(body):
	player_in_damage_hit_box = body

func _on_damage_hit_box_body_exited(body):
	player_in_damage_hit_box = null
