extends Area2D

signal coin_collected


func _on_body_entered(body):
	coin_collected.emit()
	queue_free()
