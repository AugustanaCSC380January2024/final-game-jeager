extends Level

#@onready var dart = preload("res://scenes/attacks/dart.tscn")
#@onready var companion = preload("res://scenes/players/companion.tscn")
var tutorial = true
#func _on_yassop_shoot_dart(dart_direction):
	#var new_dart = dart.instantiate()
	#add_child(new_dart)
	#new_dart.change_projectile_direction(dart_direction)
	#new_dart.global_position = $Enemies/Yassop/dart_spawn_location.global_position


func _process(delta):
	if tutorial == true:
		companion.tutorial_mode(true)
		if ($"enemies/tutorial slimes".get_child_count() == 0) :
			var pos = $companionTutorial.global_position
			$companionTutorial.queue_free()
			#var companion_instantiated = companion.instantiate()
			#companion_instantiated.player = curr_player
			#add_child(companion_instantiated)
			#companion_instantiated.global_position = pos
			companion.global_position = pos
			companion.tutorial_mode(false)
			tutorial = false
		#companion = companion_instantiated
		
