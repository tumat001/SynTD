extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"


func _ready():
	lifetime = 0.5
	scale = Vector2(0.4, 0.4)

func _process(delta):
	var inc = 1.3 * delta
	scale += Vector2(inc, inc)
	
	if lifetime > 0.3:
		modulate.a -= 4 * delta
