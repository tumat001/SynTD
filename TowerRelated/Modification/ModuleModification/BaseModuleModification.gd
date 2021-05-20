
const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")


# The "to_modify" parameter can be anything listed, can
# be a bullet, an AbstractEnemy, etc.
func _modify_attack(to_modify):
	
	if to_modify is BaseBullet:
		_finalize_bullet(to_modify)
	elif to_modify is AbstractEnemy:
		_after_effect_to_enemy(to_modify)
	elif to_modify is Vector2:
		_after_effect_at_location(to_modify)


func _finalize_bullet(to_modify : BaseBullet):
	pass

func _after_effect_to_enemy(to_modify : AbstractEnemy):
	pass

func _after_effect_at_location(to_modify : Vector2):
	pass
