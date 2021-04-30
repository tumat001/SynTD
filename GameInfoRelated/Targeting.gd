
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


static func enemies_to_target(arg_enemies : Array, targeting : int, num_of_enemies : int):
	var enemies = arg_enemies.duplicate()
	
	if targeting == FIRST:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_first")
	elif targeting == LAST:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_last")
	
	enemies.resize(num_of_enemies)
	
	return enemies


class CustomSorter:
	
	static func sort_enemies_by_first(a, b):
		if a.distance_to_exit > b.distance_to_exit:
			return true
		return false
	
	static func sort_enemies_by_last(a, b):
		if a.distance_to_exit < b.distance_to_exit:
			return true
		return false
	
