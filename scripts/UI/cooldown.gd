extends Node2D
@export var cooldown_time : float
@onready var timer = $Timer
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	start_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.set_text(str(timer.get_time_left()).pad_decimals(2))
	var time_ratio = (timer.get_wait_time() -timer.get_time_left())/timer.get_wait_time()
	$TextureProgressBar.value = time_ratio * 100
	
func _on_timer_timeout():
	pass # Replace with function body.

func start_timer():
	timer.start()
