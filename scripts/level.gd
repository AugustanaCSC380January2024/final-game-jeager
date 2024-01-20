extends Node2D

@onready var hayate = $Players/hayate
@onready var miko = $Players/miko
@onready var saber = $Players/saber

var curr_player: CharacterBody2D

func _ready():
	miko.visible = false
	saber.visible = false
	miko.set_stop_movement(true)
	saber.set_stop_movement(true)
	add_child(miko)
	add_child(saber)
	curr_player = hayate

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
		curr_player = new_player
		curr_player.visible = true
		curr_player.set_stop_movement(false)

func get_curr_player():
	return curr_player
