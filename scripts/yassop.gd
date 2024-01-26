extends CharacterBody2D
class_name boss

@onready var DAMAGE_INDICATOR = preload("res://scenes/ui/damage_indicator.tscn")
@onready var animated_sprite = $AnimatedSprite2D
@onready var damage_hit_box = $damage_hit_box
@onready var damage_hit_box_collision_box = $damage_hit_box/damage_area
@onready var player_detection_area = $player_detection_area
@onready var player_detection_area_collision_box = $player_detection_area/CollisionShape2D
@onready var collision_box = $collision_box
@onready var DEFAULT_PLAYER = CharacterBody2D.new()
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var attack_cooldown_timer = $attack_cooldown_timer

@export var player: CharacterBody2D
@export var max_health_points = 500
var health_points = max_health_points
@export var damage = 20
@export var attack_range = 10
@export var player_detection_range = 1
@export var move_speed := 40.0

var animation_playing = false
var player_in_damage_hit_box: CharacterBody2D
var attacks = ["attack", "attack 1", "attack 2"]
var invincible = false

signal enemy_death
signal health_changed
signal shoot_dart

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
		if player_in_damage_hit_box != null and player != DEFAULT_PLAYER:
			if (attack_cooldown_timer.is_stopped()):
				animated_sprite.play(attacks[randi_range(0, 2)])
				attack_cooldown_timer.start()
				animation_playing = true
			else:
				animated_sprite.play("idle")
		elif (player != DEFAULT_PLAYER):
			make_path()
			var distance = player.global_position - position
			velocity = dir * move_speed
			flip_enemy(velocity)
			animated_sprite.play("walk")
			move_and_slide()
		else:
			animated_sprite.play("idle")
	elif invincible:
		if (attack_cooldown_timer.is_stopped()):
			flip_enemy(player.position - position)
			animated_sprite.play("shoot")
			invincible = false
			attack_cooldown_timer.start()
			shoot_dart.emit((player.position - position).x)

func flip_enemy(dir):
	if dir.x > 0:
		animated_sprite.flip_h = false
		collision_box.position.x = -abs(collision_box.position.x)
		damage_hit_box_collision_box.position.x = abs(damage_hit_box_collision_box.position.x)
		$dart_spawn_location.position.x = abs($dart_spawn_location.position.x)
	elif dir.x < 0:
		animated_sprite.flip_h = true
		collision_box.position.x = abs(collision_box.position.x)
		damage_hit_box_collision_box.position.x = -abs(damage_hit_box_collision_box.position.x)
		$dart_spawn_location.position.x = -abs($dart_spawn_location.position.x)
func make_path():
	nav_agent.target_position = player.global_position

func take_damage(damage):
	if !invincible:
		health_points -= damage
		spawn_dmgIndicator(damage)
		if name == "Yassop" and (float(health_points) / max_health_points < 0.5):
			disguise()
		health_changed.emit()
		if (health_points <= 0):
			animation_playing = true
			animated_sprite.play("death")

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
	elif "attack" in animated_sprite.animation:
		if player_in_damage_hit_box != null:
			player_in_damage_hit_box.take_damage(damage)

	if animated_sprite.animation != "disguise" and animated_sprite.animation != "shoot":
		animation_playing = false

func _on_player_detection_area_body_entered(body):
	if body is Player:
		player = body
		if !invincible:
			if name == "Yassop" and (float(health_points) / max_health_points < 0.5):
				disguise()
func disguise():
	animated_sprite.play("disguise")
	animation_playing = true
	invincible = true
func _on_player_detection_area_body_exited(body):
	if body is Player:
		player = DEFAULT_PLAYER

func _on_damage_hit_box_body_entered(body):
	player_in_damage_hit_box = body

func _on_damage_hit_box_body_exited(body):
	player_in_damage_hit_box = null
