extends Node2D

@export var timer: Timer

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(_on_timer_timeout)
	label.set_text(str(timer.wait_time).pad_decimals(2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!timer.is_stopped()):
		label.set_text(str(timer.get_time_left()).pad_decimals(2))
		update_texture_bar()

func _on_timer_timeout():
	update_texture_bar()
	label.set_text("5.00")
	
func start_timer():
	timer.start()

func reset_label():
	if timer.time_left == 0:
		label.set_text(str(timer.wait_time).pad_decimals(2))
	else:
		label.set_text(str(timer.time_left).pad_decimals(2))

func update_texture_bar():
	var time_ratio = (timer.get_wait_time() -timer.get_time_left())/timer.get_wait_time()
	$TextureProgressBar.value = time_ratio * 100
