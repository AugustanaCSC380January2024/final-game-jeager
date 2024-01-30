extends Area2D

@export var next_scene: PackedScene
@onready var sprite = $AnimatedSprite2D
@onready var label = $Label
@onready var point_light_2d = $PointLight2D

var portal_unlocked = false

func _ready():
	body_entered.connect(_on_body_entered)
	label.visible = false
	point_light_2d.visible = false
	
func column_hit():
	sprite.frame += 1
	if sprite.frame == 4:
		unlock_portal()

func unlock_portal():
	portal_unlocked = true
	point_light_2d.visible = true
	sprite.frame = 5
	
func _on_body_entered(body):
	if portal_unlocked:
		get_tree().change_scene_to_packed(next_scene)
	else:
		label.visible = true
		await get_tree().create_timer(2).timeout
		label.visible = false

