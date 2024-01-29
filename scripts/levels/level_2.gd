extends Level


@onready var label = $map_props/moonTowerTutorial/Label


func _on_moon_tower_tutorial_body_entered(body):
	label.text = "Replenish the health of 
your party by staying 
close to the blood moon tower"
	label.visible = true


func _on_moon_tower_tutorial_body_exited(body):
	label.visible = false
	
