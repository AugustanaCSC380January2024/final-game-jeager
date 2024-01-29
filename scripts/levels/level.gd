extends Node2D
class_name Level

@onready var hayate = $hayate
@onready var miko = $miko
@onready var saber = $saber
@onready var camera = Camera2D.new()
@onready var health_bar = $CanvasLayer/health_bar
@onready var arrow = preload("res://scenes/attacks/arrow.tscn")
@onready var arrow_spawn_location = $hayate/arrow_spawn_position
@onready var companion = $companion
@onready var enemies = $enemies.get_children()
@onready var absorb_particles = preload("res://scenes/absorb_particles.tscn")
@onready var coin = preload("res://scenes/other/coin.tscn")
@onready var exp_bar = $CanvasLayer/exp_bar
@onready var cooldown = $CanvasLayer/cooldown

var curr_player: CharacterBody2D

func _ready():
	miko.visible = false
	saber.visible = false
	miko.set_stop_movement(true)
	saber.set_stop_movement(true)
	add_child(miko)
	add_child(saber)
	curr_player = hayate
	camera.set_zoom(Vector2(1.5,1.5))
	curr_player.add_child(camera)
	hayate.shoot_arrow.connect(_on_shoot_arrow)
	$hayate/RayCast2D.enemy_detected.connect(_on_ray_cast_2d_enemy_detected)
	$hayate/RayCast2D.enemy_not_detected.connect(_on_ray_cast_2d_enemy_not_detected)
	$map_props/column1.Strucked.connect(_on_pillar_strucked)
	$map_props/column2.Strucked.connect(_on_pillar_strucked)
	$map_props/column3.Strucked.connect(_on_pillar_strucked)
	$map_props/column4.Strucked.connect(_on_pillar_strucked)
	for enemy in enemies:
		enemy.connect("enemy_death", _enemy_killed)

func _process(delta):
	if Input.is_action_just_pressed("ultimate"):
		if (cooldown.over()):
			cooldown.start_timer()
			curr_player.ultimate_attack()

func _enemy_killed(pos):
	var new_particle = absorb_particles.instantiate()
	add_child(new_particle)
	new_particle.absorbed_by_slime.connect(spawn_coin)
	new_particle.set_global_pos(pos)
	new_particle.set_target(companion)
	companion.set_stop_movement(true)

func _physics_process(delta):
	if Input.is_action_just_pressed("character 1 selected"):
		change_curr_player(hayate)
	if Input.is_action_just_pressed("character 2 selected"):
		change_curr_player(miko)
	if Input.is_action_just_pressed("character 3 selected"):
		change_curr_player(saber)

func change_curr_player(new_player):
	if (curr_player != new_player) and !curr_player.is_attacking():
		new_player.global_position = curr_player.global_position
		curr_player.visible = false
		curr_player.set_stop_movement(true)
		curr_player.remove_child(camera)
		new_player.add_child(camera)
		curr_player.global_position = Vector2(-10000, -10000)
		curr_player = new_player
		companion.player = curr_player
		health_bar.character = curr_player
		health_bar.update_health_bar()
		health_bar.change_player(curr_player)
		curr_player.visible = true
		curr_player.set_stop_movement(false)

func get_curr_player():
	return curr_player

func _on_shoot_arrow(arrow_direction):
	var new_arrow = arrow.instantiate()
	add_child(new_arrow)
	new_arrow.change_projectile_direction(arrow_direction)
	new_arrow.global_position = arrow_spawn_location.global_position

func _on_ray_cast_2d_enemy_detected():
	$CanvasLayer/press_shoot_label.visible = true

func _on_ray_cast_2d_enemy_not_detected():
	$CanvasLayer/press_shoot_label.visible = false

func _on_pillar_strucked():
	$map_props/portal.column_hit()

func spawn_coin():
	var new_coin = coin.instantiate()
	add_child(new_coin)
	new_coin.position = companion.global_position
	new_coin.coin_collected.connect(exp_bar.update_exp_bar)
