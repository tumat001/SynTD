extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"


func _ready():
	lifetime = 0.2
	has_lifetime = true
	
	scale = Vector2(0.1, 0.1)

func _process(delta):
	
	var inc = 12 * delta
	scale += Vector2(inc, inc)
