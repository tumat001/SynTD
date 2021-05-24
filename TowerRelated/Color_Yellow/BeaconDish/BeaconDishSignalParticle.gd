extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"


func _ready():
	lifetime = 0.5
	scale = Vector2(0.4, 0.4)

func _process(delta):
	scale *= 1.05 + delta
	
	if lifetime > 0.3:
		modulate.a -= 4 * delta
