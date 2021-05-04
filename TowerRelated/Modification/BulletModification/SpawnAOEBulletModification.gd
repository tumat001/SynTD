extends "res://TowerRelated/Modification/BulletModification/BaseBulletModification.gd"


var spawn_aoe_template

func _finalize_bullet(bullet):
	if spawn_aoe_template != null:
		spawn_aoe_template._spawn_aoe(bullet.global_position)
	
	._finalize_bullet(bullet)

