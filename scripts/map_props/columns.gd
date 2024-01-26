extends CharacterBody2D

var strucked = false

func _on_body_entered(body):
	print(body)

func take_damage(damage):
	if !strucked:
		strucked = true
		$AnimatedSprite2D.play("pillar_strucked")

func is_strucked():
	return strucked
