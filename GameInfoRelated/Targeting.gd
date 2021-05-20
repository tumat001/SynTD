
const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")

enum {
	FIRST,
	LAST,
	
	RANDOM,
}

static func enemy_to_target(enemies : Array, targeting : int) -> AbstractEnemy:
	if targeting == FIRST:
		return _find_first_enemy(enemies)
	elif targeting == LAST:
		return _find_last_enemy(enemies)
	elif targeting == RANDOM:
		pass
	
	
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

static func _find_random_enemy(enemies : Array):
	
	var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.RANDOM_TARGETING)
	var random_index = rng.randi_range(0, enemies.size() - 1)
	
	return enemies[random_index]


static func _find_random_distinct_enemies(enemies : Array, count : int):
	var copy : Array = enemies.duplicate(false)
	
	if count >= enemies.size():
		return copy
	
	var bucket : Array = []
	var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.RANDOM_TARGETING)
	
	for i in count:
		if i >= copy.size():
			return bucket
		
		var rand_index = rng.randi_range(0, copy.size() - 1)
		bucket.append(copy[rand_index])
		copy.remove(rand_index)
	
	return bucket


static func enemies_to_target(arg_enemies : Array, targeting : int, num_of_enemies : int):
	var enemies = arg_enemies.duplicate(false)
	
	if targeting == FIRST:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_first")
	elif targeting == LAST:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_last")
	elif targeting == RANDOM:
		enemies = _find_random_distinct_enemies(enemies, num_of_enemies)
	
	enemies.resize(num_of_enemies)
	
	return enemies

# Sorter

class CustomSorter:
	
	static func sort_enemies_by_first(a, b):
		if a.distance_to_exit < b.distance_to_exit:
			return true
		return false
	
	static func sort_enemies_by_last(a, b):
		if a.distance_to_exit > b.distance_to_exit:
			return true
		return false
	

# prop finding

static func get_name_as_string(targeting : int) -> String:
	if targeting == FIRST:
		return "First"
	elif targeting == LAST:
		return "Last"
	elif targeting == RANDOM:
		return "Random"
	
	return "Err Unnamed"
