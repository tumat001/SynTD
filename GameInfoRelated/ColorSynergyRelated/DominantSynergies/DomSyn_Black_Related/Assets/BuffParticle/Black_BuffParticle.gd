extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"

var current_y_disp_per_sec : float = 20.0
const delta_multiplier : float = 40.0

func _ready():
	pass

func _process(delta):
	if current_y_disp_per_sec < 0:
		current_y_disp_per_sec = 0
	
	global_position.y -= current_y_disp_per_sec * delta
	
	current_y_disp_per_sec -= delta * delta_multiplier
	
	
	if lifetime < 0.2:
		modulate.a -= delta * 2
