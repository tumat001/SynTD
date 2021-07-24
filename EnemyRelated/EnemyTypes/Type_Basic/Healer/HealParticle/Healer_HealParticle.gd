extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"


func _ready():
	pass

func _process(delta):
	position.y -= delta * 40
