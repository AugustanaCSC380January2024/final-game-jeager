extends ProgressBar
var level = 1

@onready var label = $Label

func update_exp_bar():
	value += 10
	if value >= 100:
		level += 1
		value = value - 100
		label.text = "LVL " + str(level) 

func get_level():
	return level + (value / 100.0)

func set_level(new_level):
	level = int(new_level)
	value = (new_level - level) * 100.0
	label.text = "LVL " + str(level) 
