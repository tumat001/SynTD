extends "res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd"


func _process(delta):
	print("center based pos: %s. speed: %s" % [center_pos_of_basis, current_speed_towards_center])
