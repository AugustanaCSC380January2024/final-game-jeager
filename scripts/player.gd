extends CharacterBody2D
class_name Player

@export var level = 1
@export var speed = 150
@export var max_health_points = 100
@export var defence = 30
@export var attack = 30
@export var health_points = max_health_points

var ultimate_damage = attack * 2

signal health_changed
signal shoot_arrow
signal player_death

@onready var DAMAGE_INDICATOR = preload("res://scenes/ui/damage_indicator.tscn")
@onready var animated_sprite = $AnimatedSprite2D
@onready var ultimate = $ultimate
@onready var damage_hitbox = $damage_hit_box
@onready var damage_hitbox_collision_box = $damage_hit_box/hitbox
@onready var damage_taken = $damage_taken
@onready var switch_position = $player_switch_position
@onready var health_bar = $health_bar
@onready var companion_marker = $companion_marker
@onready var ultimate_sprite = $ultimate
@onready var cooldown = $cooldown


var bodies_in_damage_box = []
var is_right = true
var alive = true
var active = true
var stop_movement = false
var arrow_direction = 1

func _ready():
	animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	ultimate.animation_finished.connect(_on_ultimate_animation_finished)
	damage_hitbox.body_entered.connect(_on_damage_hit_box_body_entered)
	damage_hitbox.body_exited.connect(_on_damage_hit_box_body_exited)

func _physics_process(delta):
	var left_right_direction = 0
	var up_down_direction = 0
	var animation
	
	if !stop_movement and alive:
	#MOVEMENT
		left_right_direction = Input.get_axis("move left", "move right")
		up_down_direction = Input.get_axis("move up", "move down")
		animation = 0
		if Input.is_action_just_pressed("normal attack"):
			animation = 2
		if Input.is_action_just_pressed("ultimate"):
			if cooldown.is_stopped():
				cooldown.start()
				animation = 5
	if left_right_direction != 0:
		animation = 0
		if left_right_direction == 1:
			if !is_right:
				flip_sprites(false)
				if name == "hayate":
					$arrow_spawn_position.position.x *= -1
					arrow_direction = 1
			is_right = true
		else:
			if is_right:
				flip_sprites(true)
				if name == "hayate":
					$arrow_spawn_position.position.x *= -1
					arrow_direction = -1
			is_right = false
		animated_sprite.flip_h = (left_right_direction == -1)
		animation = abs(left_right_direction)

	if up_down_direction != 0:
		animation = abs(up_down_direction)
	velocity.x = left_right_direction * speed
	velocity.y = up_down_direction * speed
	
	move_and_slide()
	update_moving_animation(animation)

func update_moving_animation(animation):
	if animation == 0:
		animated_sprite.play("idle")
	elif animation == 1:
		animated_sprite.play("run")
	elif animation == 2:
		animated_sprite.play("attack 1")
		$audio_player/attack.play()
		stop_movement = true
	elif animation == 3:
		animated_sprite.play("hurt")
		$audio_player/hurt.play()
	elif animation == 4:
		animated_sprite.play("dead")
		$audio_player/dead.play()
	elif animation == 5:
		animated_sprite.play("attack 2")
		stop_movement = true
		$audio_player/ult.play()

func _on_animated_sprite_2d_animation_finished():
	if stop_movement:
		stop_movement = false
		if (animated_sprite.animation == "attack 2"):
			stop_movement = true
			ultimate.visible = true
			ultimate.play("default")
		elif (animated_sprite.animation == "hurt" or animated_sprite.animation == "dead"):
			damage_taken.visible = false
		elif animated_sprite.animation == "attack 1":
			if get_name() == "hayate":
				shoot_arrow.emit(arrow_direction)
			else:
				for body in bodies_in_damage_box:
					body.take_damage(attack)
					if get_name() != "miko":
						break

func _on_ultimate_animation_finished():
	ultimate.visible = false
	stop_movement = false
	for body in bodies_in_damage_box:
		body.take_damage(ultimate_damage)
		if get_name() != "miko":
			break

func flip_sprites(flag : bool):
	damage_hitbox_collision_box.position.x = damage_hitbox_collision_box.position.x * -1
	ultimate.position.x = ultimate.position.x * -1
	ultimate.flip_h = flag
	companion_marker.position *= -1
	if name == "hayate":
		$RayCast2D.position.x *= -1
		$RayCast2D.target_position *= -1

func get_companion_maker_position():
	return companion_marker.global_position

func take_damage(damage):
	if alive:
		var d = damage * (1 - defence/150)
		spawn_dmgIndicator(d)
		health_points -= d
		stop_movement = true
		update_moving_animation(3)
		health_changed.emit()
		if health_points <= 0:
			alive = false
			update_moving_animation(4)

func get_health_bar():
	return health_bar


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

func heal_health(heal):
	if alive:
		health_points += heal
		health_changed.emit()
		
func get_cooldown_timer():
	return cooldown

func get_switch_position():
	return switch_position.global_position

func set_stop_movement(flag):
	stop_movement = flag

func is_attacking():
	return stop_movement

func _on_damage_hit_box_body_entered(body):
	bodies_in_damage_box.append(body)

func _on_damage_hit_box_body_exited(body):
	bodies_in_damage_box.erase(body)

func is_alive():
	return alive

func update_stats():
	attack += int(level) * 10
	#defence += int(level) * 10
	max_health_points += int(level) * 20
	reset_health()
	ultimate_damage = attack * 2

func reset_health():
	health_points = max_health_points
	health_changed.emit()
