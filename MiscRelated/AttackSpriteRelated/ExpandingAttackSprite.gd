extends "res://MiscRelated/AttackSpriteRelated/AttackSprite.gd"


export(float) var scale_trigger_lifetime_threshold : float = 100
export(float) var scale_of_scale : float = 1


func _process(delta):
	if lifetime <= scale_trigger_lifetime_threshold:
		scale *= scale_of_scale + delta
