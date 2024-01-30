extends Control

@onready var story_image = $"1"

func _process(delta):
	story_image.position.y -= 70 * delta
	if story_image.position.y < -1980:
		get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
