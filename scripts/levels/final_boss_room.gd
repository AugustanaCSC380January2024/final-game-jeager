extends Level

@onready var skeleton = preload("res://scenes/enemy/normal enemy/skeleton.tscn")
@onready var throne = $map_props/throne
@onready var finaL_boss = preload("res://scenes/enemy/boss/final boss.tscn")
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var final_boss_music = preload("res://assets/Sounds/game sfx/Final Struggle (Boss Theme).mp3")

func _on_death_summon_skeleton(pos):
	var new_skeleton = skeleton.instantiate()
	enemies.add_child(new_skeleton)
	new_skeleton.global_position = pos
	new_skeleton.connect("enemy_death", _enemy_killed)

func _process(delta):
	if enemies.get_child_count() == 0:
		if companion.player != throne:
			companion.global_position = Vector2(330, -530)
			companion.player = throne
			companion.speed = 45
		if abs(companion.global_position - throne.get_companion_maker_position()) < Vector2(5, 100):
			throne_reached()
# (334.5856, -749.0712)(339, -847.9999)
func throne_reached():
	print("here")
	companion.movement = false
	companion.animation_in_progress = true
	companion.get_animated_sprite().play("transformation")
	await get_tree().create_timer(3).timeout
	
	var pos = companion.global_position
	var final_boss_instance = finaL_boss.instantiate()
	add_child(final_boss_instance)
	final_boss_instance.play_appear_sound()
	audio_stream_player_2d.stop()
	#await get_tree().create_timer(3).timeout
	audio_stream_player_2d.stream = final_boss_music
	audio_stream_player_2d.play()
	final_boss_instance.global_position = pos
	companion.global_position = Vector2(-2000, -2000)
