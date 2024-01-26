extends Area2D

@export var next_scene: PackedScene

func column_hit():
	$AnimatedSprite2D.frame += 1
