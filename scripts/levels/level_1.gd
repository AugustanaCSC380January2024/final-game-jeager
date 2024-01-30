extends Level

var tutorial = true

@onready var movement_label: Label = $tutorial/movement/Label
@onready var switch_label : Label = $tutorial/switch/Label
@onready var attack_label : Label = $tutorial/attack/Label
@onready var areasplash_label : Label = $tutorial/areasplash/Label
@onready var ult_label : Label = $tutorial/ult/Label
@onready var slimeattack_label : Label = $tutorial/slimeattack/Label
@onready var hint1_label: Label = $tutorial/hint1/Label
@onready var rune_label: Label = $tutorial/rune/Label
@onready var slime_message_label = $tutorial/slime_message/Label

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
	if tutorial == true:
		companion.tutorial_mode(true)
		if ($"enemies/tutorial slimes".get_child_count() == 0) :
			var pos = $companionTutorial.global_position
			$companionTutorial.queue_free()
			companion.global_position = pos
			companion.tutorial_mode(false)
			tutorial = false


func show_label(label: Label, text: String) -> void:
	label.text = text
	label.visible = true
	
func hide_label(label: Label) -> void:
	label.visible = false
	

func _on_movement_body_entered(body: Node) -> void:
	show_label(movement_label, "Use W, A, S, D, or arrow keys to move")
func _on_movement_body_exited(body: Node) -> void:
	hide_label(movement_label)


func _on_switch_body_entered(body):
	show_label(switch_label, "Press 1, 2,3 to switch between characters")
func _on_switch_body_exited(body):
	hide_label(switch_label)
	


func _on_attack_body_entered(body):
	show_label(attack_label, "Press spacebar to attack the slime")
func _on_attack_body_exited(body):
	hide_label(attack_label)

func _on_areasplash_body_entered(body):
	show_label(areasplash_label, "Switch to miko and attack to 
	deal damage to multiple
	 enemies at once")
func _on_areasplash_body_exited(body):
	hide_label(areasplash_label)


func _on_ult_body_entered(body):
	show_label(ult_label, "Press E to ult. Be mindful of the 
	cooldown on the bottom right!")
func _on_ult_body_exited(body):
	hide_label(ult_label)


func _on_slimeattack_body_entered(body):
	show_label(slimeattack_label, "Save the outcast slime")
func _on_slimeattack_body_exited(body):
	hide_label(slimeattack_label)


func _on_areasplash_2_body_entered(body):
	show_label(hint1_label,"Switch characters between
	ult cooldown to deal more 
	damage per second")


func _on_areasplash_2_body_exited(body):
	hide_label(hint1_label)


func _on_rune_body_entered(body):
	show_label(rune_label,"Htting the runes activate it. Activate 4 runes 
	to unlock the portal to the next level")


func _on_rune_body_exited(body):
	hide_label(rune_label)


func _on_slime_message_body_entered(body):
	show_label(slime_message_label ,"The slime is greatful and want's to join 
	you as a companion. In exchange the slime will absorb the enemies
	you defeat and provide you with gems that the aid in leveling up.")

func _on_slime_message_body_exited(body):
	hide_label(slime_message_label)
