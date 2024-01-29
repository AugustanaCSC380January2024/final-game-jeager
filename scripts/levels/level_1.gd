extends Level

#@onready var dart = preload("res://scenes/attacks/dart.tscn")
#@onready var companion = preload("res://scenes/players/companion.tscn")
var tutorial = true
#func _on_yassop_shoot_dart(dart_direction):
	#var new_dart = dart.instantiate()
	#add_child(new_dart)
	#new_dart.change_projectile_direction(dart_direction)
	#new_dart.global_position = $Enemies/Yassop/dart_spawn_location.global_position

#@onready var movement_collision_shape_2d = $tutorial/movement/CollisionShape2D
#@onready var switch_collision_shape_2d = $tutorial/switch/CollisionShape2D
#@onready var attack_collision_shape_2d = $tutorial/attack/CollisionShape2D
#@onready var ult_collision_shape_2d = $tutorial/ult/CollisionShape2D
#@onready var areasplash_collision_shape_2d = $tutorial/areasplash/CollisionShape2D
#@onready var slime_attack_collision_shape_2d = $tutorial/slimeattack/CollisionShape2D


@onready var movement_label: Label = $tutorial/movement/Label
@onready var switch_label : Label = $tutorial/switch/Label
@onready var attack_label : Label = $tutorial/attack/Label
@onready var areasplash_label : Label = $tutorial/areasplash/Label
@onready var ult_label : Label = $tutorial/ult/Label
@onready var slimeattack_label : Label = $tutorial/slimeattack/Label
@onready var hint1_label: Label = $tutorial/hint1/Label
@onready var rune_label: Label = $tutorial/rune/Label

func _process(delta):
	if tutorial == true:
		companion.tutorial_mode(true)
		if ($"enemies/tutorial slimes".get_child_count() == 0) :
			var pos = $companionTutorial.global_position
			$companionTutorial.queue_free()
			#var companion_instantiated = companion.instantiate()
			#companion_instantiated.player = curr_player
			#add_child(companion_instantiated)
			#companion_instantiated.global_position = pos
			companion.global_position = pos
			companion.tutorial_mode(false)
			tutorial = false
		#companion = companion_instantiated
		


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
	show_label(slimeattack_label, "save the outcast slime")
func _on_slimeattack_body_exited(body):
	hide_label(slimeattack_label)


func _on_areasplash_2_body_entered(body):
	show_label(hint1_label,"Switch characters between
	ult cooldown to deal more 
	damage per second")


func _on_areasplash_2_body_exited(body):
	hide_label(hint1_label)


func _on_rune_body_entered(body):
	show_label(rune_label,"Hit the rune to activate it")


func _on_rune_body_exited(body):
	hide_label(rune_label)
