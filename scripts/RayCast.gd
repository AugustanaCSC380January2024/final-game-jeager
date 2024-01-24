extends RayCast2D

signal enemy_detected
signal enemy_not_detected
func _process(delta):
	if is_colliding():
		enemy_detected.emit()
	else:
		enemy_not_detected.emit()
