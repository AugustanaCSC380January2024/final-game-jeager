extends CharacterBody2D

var strucked = false
signal Strucked
@onready var point_light_2d = $PointLight2D


func _on_body_entered(body):
	print(body)

func take_damage(damage):
	if !strucked:
		strucked = true
		$PointLight2D.visible = true
		$AnimatedSprite2D.play("pillar_strucked")
		Strucked.emit()
