extends Node

var current_state: State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.Transio
