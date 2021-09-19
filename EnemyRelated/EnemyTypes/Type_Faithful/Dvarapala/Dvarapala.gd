extends "res://EnemyRelated/EnemyTypes/Type_Faithful/AbstractFaithfulEnemy.gd"


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.DVARAPALA))
