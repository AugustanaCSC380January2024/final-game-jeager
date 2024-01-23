extends ProgressBar
class_name HealthBar

@export var Player: CharacterBody2D 

func _ready():
	Player.connect("health_changed", update_health_bar)
	update_health_bar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_health_bar():
	if Player:
		var health_ratio : float = float(Player.health_points) / float(Player.max_health_points)
		# Set the progress bar value based on the ratio
		value = health_ratio*100

func change_player(new_player):
	Player = new_player
	Player.connect("health_changed", update_health_bar)
	update_health_bar()
