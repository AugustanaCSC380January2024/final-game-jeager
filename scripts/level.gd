extends Node2D

@onready var hayate = $hayate
@onready var miko = $miko
@onready var saber = $saber
@onready var camera = Camera2D.new()
@onready var health_bar = $CanvasLayer/health_bar
@onready var arrow = preload("res://scenes/attacks/arrow.tscn")
@onready var dart = preload("res://scenes/attacks/dart.tscn")
@onready var arrow_spawn_location = $hayate/arrow_spawn_position
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
	$Enemies/Yassop.shoot_dart.connect(_on_shoot_dart)

func _physics_process(delta):
	if Input.is_action_just_pressed("character 1 selected"):
		change_curr_player(saber)
	if Input.is_action_just_pressed("character 2 selected"):
		change_curr_player(miko)
	if Input.is_action_just_pressed("character 3 selected"):
		change_curr_player(hayate)

func change_curr_player(new_player):
	if (curr_player != new_player) and !curr_player.is_attacking():
		new_player.global_position = curr_player.global_position
		curr_player.visible = false
		curr_player.set_stop_movement(true)
		curr_player.remove_child(camera)
		new_player.add_child(camera)
		curr_player.global_position = Vector2(-10000, -10000)
		curr_player = new_player
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

func _on_shoot_dart(dart_direction):
	var new_dart = dart.instantiate()
	add_child(new_dart)
	new_dart.change_projectile_direction(dart_direction)
	new_dart.global_position = $Enemies/Yassop/dart_spawn_location.global_position

func _on_ray_cast_2d_enemy_detected():
	$CanvasLayer/press_shoot_label.visible = true

func _on_ray_cast_2d_enemy_not_detected():
	$CanvasLayer/press_shoot_label.visible = false
	
