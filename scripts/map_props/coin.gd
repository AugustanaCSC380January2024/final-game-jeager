extends CharacterBody2D

signal coin_collected

func _on_area_2d_body_entered(body):
	coin_collected.emit()
	queue_free()
