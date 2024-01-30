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
@onready var enemies = $enemies
@onready var absorb_particles = preload("res://scenes/absorb_particles.tscn")
@onready var coin = preload("res://scenes/other/coin.tscn")
@onready var exp_bar = $CanvasLayer/exp_bar
@onready var canvas_layer = $CanvasLayer
@onready var cooldown = $CanvasLayer/cooldown
@onready var pause = false
@onready var pausemenu = $CanvasLayer/pausemenu
@onready var portal = $map_props/portal

var curr_player: CharacterBody2D
var curr_level_file_path = "res://curr_level.txt"
var character_switch
var alive_players = []

func _ready():
	miko.visible = false
	saber.visible = false
	miko.set_stop_movement(true)
	saber.set_stop_movement(true)
	add_child(miko)
	add_child(saber)
	curr_player = hayate
	camera.set_zoom(Vector2(1.2,1.2))
	curr_player.add_child(camera)
	load_level()
	miko.level = exp_bar.get_level()
	saber.level = exp_bar.get_level()
	hayate.level = exp_bar.get_level()
	alive_players = [miko, saber, hayate]
	
	hayate.shoot_arrow.connect(_on_shoot_arrow)
	$hayate/RayCast2D.enemy_detected.connect(_on_ray_cast_2d_enemy_detected)
	$hayate/RayCast2D.enemy_not_detected.connect(_on_ray_cast_2d_enemy_not_detected)
	$map_props/column1.Strucked.connect(_on_pillar_strucked)
	$map_props/column2.Strucked.connect(_on_pillar_strucked)
	$map_props/column3.Strucked.connect(_on_pillar_strucked)
	$map_props/column4.Strucked.connect(_on_pillar_strucked)
	exp_bar.level_up.connect(update_stats)
	
	for enemy in enemies.get_children():
		enemy.connect("enemy_death", _enemy_killed)

func update_stats():
	miko.update_stats()
	saber.update_stats()
	hayate.update_stats()

func _enemy_killed(pos):
	var new_particle = absorb_particles.instantiate()
	add_child(new_particle)
	new_particle.absorbed_by_slime.connect(spawn_coin)
	new_particle.set_global_pos(pos)
	new_particle.set_target(companion)
	#companion.set_stop_movement(true)

func _physics_process(delta):
	if Input.is_action_just_pressed("character 1 selected"):
		change_curr_player(hayate)
	if Input.is_action_just_pressed("character 2 selected"):
		change_curr_player(miko)
	if Input.is_action_just_pressed("character 3 selected"):
		change_curr_player(saber)
	save_level()
	if !(hayate.is_alive() or miko.is_alive() or saber.is_alive()):
		get_tree().reload_current_scene()

func change_curr_player(new_player):
	if (curr_player != new_player) and !curr_player.is_attacking():
		CharacerSwitchSound.play()
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
		cooldown.timer = curr_player.get_cooldown_timer()
		cooldown.reset_label()
		cooldown.update_texture_bar()

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
	new_coin.global_position = companion.global_position
	new_coin.coin_collected.connect(exp_bar.update_exp_bar)
	
func pauseMenu():
	if pause:
		pausemenu.hide()
		Engine.time_scale = 1
	else:
		pausemenu.show()
		Engine.time_scale = 0
	pause = !pause

func save_level():
	var file = FileAccess.open(curr_level_file_path, FileAccess.WRITE)
	file.store_line(str(exp_bar.get_level()))
	file = null

func load_level():
	var file = FileAccess.open(curr_level_file_path, FileAccess.READ)
	if file:
		var level = file.get_line()
		file = null
		exp_bar.set_level(float(level))
	else:
		exp_bar.set_level(1.0)
