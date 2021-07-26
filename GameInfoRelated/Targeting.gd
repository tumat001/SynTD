extends Node

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")


# WHEN UPDATING THIS, UPDATE get_all_targeting()
enum {
	FIRST = 0,
	LAST = 1,
	CLOSE = 2,
	FAR = 3, #NOT MADE YET
	
	EXECUTE = 10,
	HEALTHIEST = 11,
	
	WEAKEST = 12,
	STRONGEST = 13,
	
	PERCENT_EXECUTE = 14,
	PERCENT_HEALTHIEST = 15,
	
	RANDOM = 20,
}

# UPDATE THIS WHEN CHANING THE ENUM
static func get_all_targeting_options() -> Array:
	return [
		FIRST,
		LAST,
		
		CLOSE,
		FAR,
		
		EXECUTE,
		HEALTHIEST,
		
		WEAKEST,
		STRONGEST,
		
		PERCENT_EXECUTE,
		PERCENT_HEALTHIEST,
		
		RANDOM,
	]


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


# Random, Close and Far will be shared for tower detection as well
static func enemies_to_target(arg_enemies : Array, targeting : int, num_of_enemies : int, pos : Vector2, include_invis_enemies : bool = false):
	var enemies = arg_enemies.duplicate(false)
	
	if targeting == FIRST:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_first")
		
	elif targeting == LAST:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_last")
		
	elif targeting == CLOSE:
		var enemy_distance_pair = _convert_enemies_to_enemy_distance_pair(enemies, pos)
		enemy_distance_pair.sort_custom(CustomSorter, "sort_enemies_by_close")
		enemies = _convert_enemy_distance_pairs_to_enemies(enemy_distance_pair)
		
	elif targeting == FAR:
		var enemy_distance_pair = _convert_enemies_to_enemy_distance_pair(enemies, pos)
		enemy_distance_pair.sort_custom(CustomSorter, "sort_enemies_by_far")
		enemies = _convert_enemy_distance_pairs_to_enemies(enemy_distance_pair)
		
	elif targeting == EXECUTE:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_execute")
		
	elif targeting == HEALTHIEST:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_healthiest")
		
		
	elif targeting == WEAKEST:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_weakest")
		
	elif targeting == STRONGEST:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_strongest")
		
		
	elif targeting == PERCENT_EXECUTE:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_percent_execute")
		
	elif targeting == PERCENT_HEALTHIEST:
		enemies.sort_custom(CustomSorter, "sort_enemies_by_percent_healthiest")
		
	elif targeting == RANDOM:
		enemies = _find_random_distinct_enemies(enemies, num_of_enemies)
	
	
	for enemy in enemies:
		if (!include_invis_enemies and enemy.last_calculated_invisibility_status) or enemy.is_reviving:
			enemies.erase(enemy)
	
	
	enemies.resize(num_of_enemies)
	while enemies.has(null):
		enemies.erase(null)
	
	return enemies


# Sorter

class CustomSorter:
	
	static func sort_enemies_by_first(a, b):
		return a.distance_to_exit < b.distance_to_exit
		
	
	static func sort_enemies_by_last(a, b):
		return a.distance_to_exit > b.distance_to_exit
		
	
	static func sort_enemies_by_close(a_enemy_dist, b_enemy_dist):
		return a_enemy_dist[1] < b_enemy_dist[1]
	
	static func sort_enemies_by_far(a_enemy_dist, b_enemy_dist):
		return a_enemy_dist[1] > b_enemy_dist[1]
	
	
	static func sort_enemies_by_execute(a, b):
		if a.current_health != b.current_health:
			return a.current_health < b.current_health
		else:
			return sort_enemies_by_first(a, b)
	
	static func sort_enemies_by_healthiest(a, b):
		if a.current_health != b.current_health:
			return a.current_health > b.current_health
		else:
			return sort_enemies_by_first(a, b)
	
	
	static func sort_enemies_by_weakest(a, b):
		if a._last_calculated_max_health != b._last_calculated_max_health:
			return a._last_calculated_max_health < b._last_calculated_max_health
		else:
			return sort_enemies_by_first(a, b)
	
	
	static func sort_enemies_by_strongest(a, b):
		if a._last_calculated_max_health != b._last_calculated_max_health:
			return a._last_calculated_max_health > b._last_calculated_max_health
		else:
			return sort_enemies_by_first(a, b)
	
	
	static func sort_enemies_by_percent_execute(a, b):
		var a_ratio = a.current_health / a._last_calculated_max_health
		var b_ratio = b.current_health / b._last_calculated_max_health
		
		if a_ratio != b_ratio:
			return a_ratio < b_ratio
		else:
			return sort_enemies_by_first(a, b)
	
	static func sort_enemies_by_percent_healthiest(a, b):
		var a_ratio = a.current_health / a._last_calculated_max_health
		var b_ratio = b.current_health / b._last_calculated_max_health
		
		if a_ratio != b_ratio:
			return a_ratio > b_ratio
		else:
			return sort_enemies_by_first(a, b)
	

# Computing of other stuffs

static func _convert_enemies_to_enemy_distance_pair(arg_enemies : Array, pos : Vector2) -> Array:
	var enemy_distance_pair : Array = []
	
	for enemy in arg_enemies:
		enemy_distance_pair.append([enemy, pos.distance_squared_to(enemy.global_position)])
	
	return enemy_distance_pair

static func _convert_enemy_distance_pairs_to_enemies(enemy_dist_pairs : Array):
	var enemy_bucket : Array = []
	
	for pair in enemy_dist_pairs:
		enemy_bucket.append(pair[0])
	
	return enemy_bucket


# prop finding

static func get_name_as_string(targeting : int) -> String:
	if targeting == FIRST:
		return "First"
	elif targeting == LAST:
		return "Last"
	elif targeting == CLOSE:
		return "Close"
	elif targeting == FAR:
		return "Far"
	elif targeting == EXECUTE:
		return "Execute"
	elif targeting == HEALTHIEST:
		return "Healthiest"
	elif targeting == WEAKEST:
		return "Weakest"
	elif targeting == STRONGEST:
		return "Strongest"
	elif targeting == RANDOM:
		return "Random"
	
	return "Err Unnamed"





# OLD

#static func enemy_to_target(enemies : Array, targeting : int) -> AbstractEnemy:
#	if targeting == FIRST:
#		return _find_first_enemy(enemies)
#	elif targeting == LAST:
#		return _find_last_enemy(enemies)
#	elif targeting == RANDOM:
#		pass
#
#	return null
#
#static func _find_first_enemy(enemies : Array):
#	var first_enemy : AbstractEnemy
#
#	for enemy in enemies:
#		if first_enemy == null:
#			first_enemy = enemy
#		elif first_enemy.distance_to_exit > enemy.distance_to_exit:
#			first_enemy = enemy
#
#	return first_enemy
#
#static func _find_last_enemy(enemies : Array):
#	var last_enemy : AbstractEnemy
#
#	for enemy in enemies:
#		if last_enemy == null:
#			last_enemy = enemy
#		elif last_enemy.distance_to_exit < enemy.distance_to_exit:
#			last_enemy = enemy
#
#	return last_enemy
#
#static func _find_random_enemy(enemies : Array):
#
#	var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.RANDOM_TARGETING)
#	var random_index = rng.randi_range(0, enemies.size() - 1)
#
#	return enemies[random_index]
