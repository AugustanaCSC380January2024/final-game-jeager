extends Level

@onready var skeleton = preload("res://scenes/enemy/normal enemy/skeleton.tscn")

func _on_death_summon_skeleton(pos):
	var new_skeleton = skeleton.instantiate()
	print(new_skeleton)
	enemies.add_child(new_skeleton)
	new_skeleton.global_position = pos
	new_skeleton.connect("enemy_death", _enemy_killed)
