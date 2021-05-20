extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"

func _ready():
	lifetime = 0.75
	has_lifetime = true
	

func _process(delta):
	if lifetime < 0.2:
		modulate.a -= 4 * delta
