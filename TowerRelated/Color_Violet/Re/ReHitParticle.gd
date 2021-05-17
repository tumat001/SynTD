extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"


func _ready():
	lifetime = 0.2
	has_lifetime = true
	
	scale = Vector2(0.2, 0.2)

func _process(delta):
	scale *= 1.35
	
