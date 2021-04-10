
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")

enum {
	FIRST,
	LAST,
}

static func enemy_to_target(enemies : Array, targeting : int) -> AbstractEnemy:
	if targeting == FIRST:
		return _find_first_enemy(enemies)
	elif targeting == LAST:
		return _find_last_enemy(enemies)
	
	return null

static func _find_first_enemy(enemies : Array):
	var first_enemy : AbstractEnemy
	
	for enemy in enemies:
		if first_enemy == null:
			first_enemy = enemy
		elif first_enemy.distance_to_exit > enemy.distance_to_exit:
			first_enemy = enemy
	
	return first_enemy

static func _find_last_enemy(enemies : Array):
	var last_enemy : AbstractEnemy
	
	for enemy in enemies:
		if last_enemy == null:
			last_enemy = enemy
		elif last_enemy.distance_to_exit < enemy.distance_to_exit:
			last_enemy = enemy
	
	return last_enemy
