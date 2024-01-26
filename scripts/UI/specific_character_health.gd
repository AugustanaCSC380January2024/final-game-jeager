extends Control

@onready var icon = $Sprite2D

@export var healthBar: HealthBar
@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player.name)
	if player:
		if player.name == "hayate":
			icon.texture = preload("res://assets/Skins/Player skins/character icon/hayate_icon.png")
		elif player.name == "miko":
			icon.texture = preload("res://assets/Skins/Player skins/character icon/miko_icon.png")
		elif player.name == "saber":
			icon.texture = preload("res://assets/Skins/Player skins/character icon/saber_icon.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	healthBar.update_health_bar()
