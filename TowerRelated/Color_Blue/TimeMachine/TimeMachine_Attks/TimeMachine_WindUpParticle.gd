extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"


var rotation_per : float

func _ready():
	rotation_per = 360 / lifetime

func _process(delta):
	rotation_degrees += rotation_per * delta
