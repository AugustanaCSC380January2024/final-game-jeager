extends Node2D


@onready var Player = $hayate


func _on_timer_timeout():
	Player.take_damage(10)
