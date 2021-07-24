extends "res://EnemyRelated/AbstractEnemy.gd"


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.BRUTE))

