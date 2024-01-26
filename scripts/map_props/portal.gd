extends Area2D

@export var next_scene: PackedScene
@onready var sprite = $AnimatedSprite2D
@onready var label = $Label

var portal_unlocked = false

func _ready():
	body_entered.connect(_on_body_entered)
	label.visible = false
	
func column_hit():
	sprite.frame += 1
	if sprite.frame == 4:
		portal_unlocked = true
		sprite.frame += 1

func _on_body_entered(body):
	if portal_unlocked:
		get_tree().change_scene_to_packed(next_scene)
	else:
		label.visible = true
		await get_tree().create_timer(2).timeout
		label.visible = false

