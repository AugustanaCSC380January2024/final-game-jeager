extends Node2D
@export var cooldown_time : float
@onready var timer = $Timer
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = cooldown_time
	start_timer()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!timer.is_stopped()):
		label.set_text(str(timer.get_time_left()).pad_decimals(2))
		var time_ratio = (timer.get_wait_time() -timer.get_time_left())/timer.get_wait_time()
		$TextureProgressBar.value = time_ratio * 100
	
func _on_timer_timeout():
	label.set_text(str(cooldown_time).pad_decimals(2))
	

func start_timer():
	timer.start()
# checking to see if timer works
	#await get_tree().create_timer(5).timeout
	#timer.start()
	
	
