extends ProgressBar
class_name HealthBar

@export var character: CharacterBody2D 

func _ready():
	character.connect("health_changed", update_health_bar)
	update_health_bar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_health_bar():
	if character:
		var health_ratio : float = float(character.health_points) / float(character.max_health_points)
		# Set the progress bar value based on the ratio
		value = health_ratio*100
		$Label.text = str(character.health_points) + "/" + str(character.max_health_points)

func change_player(new_player):
	character = new_player
	character.connect("health_changed", update_health_bar)
	update_health_bar()
