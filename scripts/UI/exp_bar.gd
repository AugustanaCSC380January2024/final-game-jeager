extends ProgressBar
var level = 1

@onready var label = $Label

func update_exp_bar():
	value += 10
	if value >= 100:
		level += 1
		value = value - 100
		label.text = "LVL " + str(level) 
