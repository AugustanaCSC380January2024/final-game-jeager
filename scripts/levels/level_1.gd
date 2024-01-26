extends Level

@onready var dart = preload("res://scenes/attacks/dart.tscn")

func _on_yassop_shoot_dart(dart_direction):
	var new_dart = dart.instantiate()
	add_child(new_dart)
	new_dart.change_projectile_direction(dart_direction)
	new_dart.global_position = $Enemies/Yassop/dart_spawn_location.global_position
