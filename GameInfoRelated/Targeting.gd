extends Node

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")


# WHEN UPDATING THIS, UPDATE get_all_targeting()
enum {
	FIRST = 0,
	LAST = 1,
	CLOSE = 2,
	FAR = 3,
	
	EXECUTE = 10,
	HEALTHIEST = 11,
	
	WEAKEST = 12,
	STRONGEST = 13,
	
	PERCENT_EXECUTE = 14,
	PERCENT_HEALTHIEST = 15,
	
	RANDOM = 20,
	
	
	# TOWERS ONLY (1000)
	TOWERS_HIGHEST_IN_ROUND_DAMAGE = 1000 
	TOWERS_HIGHEST_TOTAL_BASE_DAMAGE = 1001
	TOWERS_HIGHEST_TOTAL_ATTACK_SPEED = 1002
	
}

# UPDATE THIS WHEN CHANING THE ENUM.
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

#

enum TargetingRangeState {
	ANY = 0,
	OUT_OF_RANGE = 1,
	IN_RANGE = 2,
}

class TargetingParameters:
	var priority_enemies_in_range : Array
	var priority_enemies_regardless_of_range : Array
	
	#var range_of_search : float
	#var range_state : int = TargetingRangeState.ANY


#

# used by other methods outside of this obj.
static func _find_random_distinct_enemies(enemies : Array, count : int):
	var orig_copy_count : int = enemies.size()
	var copy : Array = enemies.duplicate(false)
	
	#if count >= enemies.size():
	#	return copy
	
	var bucket : Array = []
	var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.RANDOM_TARGETING)
	
	for i in count:
		if i >= orig_copy_count:
			return bucket
		
		if count <= bucket.size():
			return bucket
		
		var rand_index = rng.randi_range(0, copy.size() - 1)
		bucket.append(copy[rand_index])
		copy.remove(rand_index)
	
	return bucket


# Also shared by towers (and other nodes: placables)
# Random, Close and Far will be shared for tower detection as well
static func enemies_to_target(arg_enemies : Array, targeting : int, num_of_enemies : int, pos : Vector2,
		 include_invis_enemies : bool = false, targeting_parameters : TargetingParameters = null):
	
	if num_of_enemies == -1:
		num_of_enemies = arg_enemies.size()
	
	var enemies : Array = []
	var priority_enemies_in_range : Array
	var priority_enemies_regardless_of_range : Array
	
	
	if targeting_parameters != null:
		for enemy in targeting_parameters.priority_enemies_in_range:
			if is_instance_valid(enemy) and !enemy.is_queued_for_deletion():
				priority_enemies_in_range.append(enemy)
			
		
		for enemy in targeting_parameters.priority_enemies_regardless_of_range:
			if is_instance_valid(enemy) and !enemy.is_queued_for_deletion():
				priority_enemies_regardless_of_range.append(enemy)
	
	
	for enemy in arg_enemies:
		if is_instance_valid(enemy) and !enemy.is_queued_for_deletion() and !priority_enemies_in_range.has(enemy) and !priority_enemies_regardless_of_range.has(enemy):
			#if targeting_parameters == null:
			enemies.append(enemy)
#
#			else:
#				var range_state = targeting_parameters.range_state
#				var distance = enemy.global_position.distance_to(pos)
#
#				if range_state == TargetingRangeState.ANY:
#					enemies.append(enemy)
#				elif range_state == TargetingRangeState.IN_RANGE and distance <= targeting_parameters.range_of_search:
#					enemies.append(enemy)
#				elif range_state == TargetingRangeState.OUT_OF_RANGE and distance <= targeting_parameters.range_of_search:
#					enemies.append(enemy)
#
		
	
	#
	
	var bucket_removal : Array = []
	for enemy in priority_enemies_in_range:
		if !arg_enemies.has(enemy):
			bucket_removal.append(enemy)
	
	for enemy in bucket_removal:
		priority_enemies_in_range.erase(enemy)
	
	#
	
	
	filter_untargetable_enemies(enemies, include_invis_enemies)
	filter_untargetable_enemies(priority_enemies_in_range, include_invis_enemies)
	filter_untargetable_enemies(priority_enemies_regardless_of_range, include_invis_enemies)
	
	
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
		
		
		
	# TOWERS
	elif targeting == TOWERS_HIGHEST_IN_ROUND_DAMAGE:
		enemies.sort_custom(CustomSorter, "sort_towers_by_highest_in_round_damage")
		
	elif targeting == TOWERS_HIGHEST_TOTAL_ATTACK_SPEED:
		for tower in enemies:
			if !is_instance_valid(tower.main_attack_module):
				enemies.erase(tower)
		enemies.sort_custom(CustomSorter, "sort_towers_by_highest_total_attack_speed")
		
	elif targeting == TOWERS_HIGHEST_TOTAL_BASE_DAMAGE:
		for tower in enemies:
			if !is_instance_valid(tower.main_attack_module):
				enemies.erase(tower)
		enemies.sort_custom(CustomSorter, "sort_towers_by_highest_total_base_damage")
	
	
	var final_enemies : Array = []
	
	for enemy in priority_enemies_regardless_of_range:
		final_enemies.append(enemy)
	for enemy in priority_enemies_in_range:
		final_enemies.append(enemy)
	for enemy in enemies:
		final_enemies.append(enemy)
	
	final_enemies.resize(num_of_enemies)
	var deletion_bucket : Array = []
	
	for enemy in final_enemies:
		if !is_instance_valid(enemy) or enemy.is_queued_for_deletion():
			deletion_bucket.append(enemy)
	
	for enemy in deletion_bucket:
		final_enemies.erase(enemy)
	
	return final_enemies


static func filter_untargetable_enemies(enemies, include_invis_enemies : bool = false) -> Array:
	var delete_bucket : Array = []
	
	for enemy in enemies:
		if enemy.is_queued_for_deletion():
			delete_bucket.append(enemy)
			continue
		
		if enemy.last_calculated_is_untargetable:
			if include_invis_enemies and enemy.is_untargetable_only_from_invisibility():
				continue
			else:
				delete_bucket.append(enemy)
				#enemies.erase(enemy)
	
	for ent in delete_bucket:
		enemies.erase(ent)
	
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
	
	
	
	# TOWERS
	
	static func sort_towers_by_highest_in_round_damage(a, b):
		return a.in_round_total_damage_dealt > b.in_round_total_damage_dealt
	
	static func sort_towers_by_highest_total_attack_speed(a, b):
		return a.main_attack_module.last_calculated_final_attk_speed > b.main_attack_module.last_calculated_final_attk_speed
	
	static func sort_towers_by_highest_total_base_damage(a, b):
		return a.main_attack_module.last_calculated_final_damage > b.main_attack_module.last_calculated_final_damage
	
	

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
	elif targeting == PERCENT_EXECUTE:
		return "Percent Execute"
	elif targeting == PERCENT_HEALTHIEST:
		return "Percent Healthiest"
	
	return "Err Unnamed"


############ -------------------------------------- #############

class LineTargetParameters:
	
	var target_positions : Array
	
	var line_width : float
	var line_width_reduction_forgiveness : float = 2
	
	var line_range : float
	
	var source_position : Vector2
	
	# an array with [min, max]
	var _min_and_max_angle_blacklist : Array
	var _min_and_max_angle_requirement : Array
	
	#
	
	var circle_slice_count : int = 120
	
	#
	
	func get_line_width_with_forgiveness():
		return line_width - line_width_reduction_forgiveness
	
	#
	
	func add_min_max_at_blacklist(arg_min_angle : float, arg_max_angle : float):
		_add_min_max_at_arr(arg_min_angle, arg_max_angle, _min_and_max_angle_blacklist)
	
	func add_min_max_at_requirement(arg_min_angle : float, arg_max_angle : float):
		_add_min_max_at_arr(arg_min_angle, arg_max_angle, _min_and_max_angle_requirement)
	
	
	
	func _add_min_max_at_arr(arg_min_angle : float, arg_max_angle : float, arg_arr):
		var arr = []
		arr.append(arg_min_angle)
		if arg_min_angle > arg_max_angle:
			arg_max_angle += 360
		arr.append(arg_max_angle)
		
		arg_arr.append(arr)
	
	
	#
	
	func if_angle_passes_all_conditions(arg_angle : float):
		return if_angle_passes_blacklist(arg_angle) and if_angle_passes_requirement(arg_angle)
	
	
	func if_angle_passes_blacklist(arg_angle : float):
		return _if_angle_passes_min_max_arr(arg_angle, _min_and_max_angle_blacklist)
	
	func if_angle_passes_requirement(arg_angle : float):
		return _if_angle_passes_min_max_arr(arg_angle, _min_and_max_angle_requirement)
	
	
	
	func _if_angle_passes_min_max_arr(arg_angle : float, arg_arr : Array):
		for min_and_max in arg_arr:
			if arg_angle > min_and_max[0] and arg_angle < min_and_max[1]:
				return false
		
		return true

#

# returns an array [angle, hit count]. Returns an empty arr if no candidate was found
static func get_deg_angle_and_enemy_hit_count__that_hits_most_enemies(arg_param : LineTargetParameters) -> Array:
	var angles_to_consider : Array = _get_angles_of_circle_slice_that_passes_param_conditions(arg_param)
	var candidate_angle : float
	var candidate_angle_targets_hit : int = 0
	var candidate_is_set : bool = false
	var candidate_deviation : float
	
	for angle in angles_to_consider:
		var targets_hit_and_ave_deviation = _get_target_hit_count_on_angle__and_average_deviation(arg_param, angle)
		
		if candidate_angle_targets_hit <= targets_hit_and_ave_deviation[0] and targets_hit_and_ave_deviation[0] != 0:
			if (candidate_is_set and candidate_deviation > targets_hit_and_ave_deviation[1]) or !candidate_is_set or (candidate_angle_targets_hit < targets_hit_and_ave_deviation[0]):
				candidate_angle = angle
				candidate_angle_targets_hit = targets_hit_and_ave_deviation[0]
				candidate_deviation = targets_hit_and_ave_deviation[1]
				
				if !candidate_is_set:
					candidate_is_set = true
				
	
	
#	print("cand angle: %s, true angle: %s, " % [candidate_angle, 360 + rad2deg(arg_param.source_position.angle_to_point(arg_param.target_positions[0]))])
#	print("difference: %s" % [candidate_angle - (360 + rad2deg(arg_param.source_position.angle_to_point(arg_param.target_positions[0])))])
#	print("-------------------")
	
	if candidate_is_set:
		return [candidate_angle, candidate_angle_targets_hit]
	else:
		return []

#

static func _get_angles_of_circle_slice_that_passes_param_conditions(arg_param : LineTargetParameters):
	var angles : Array = []
	
	for i in arg_param.circle_slice_count:
		var angle = _get_angle_of_circle_slice_and_index(arg_param, i)
		if arg_param.if_angle_passes_all_conditions(angle):
			angles.append(angle)
	
	return angles

static func _get_angle_of_circle_slice_and_index(arg_param : LineTargetParameters, arg_index_of_circle_slice : int) -> float:
	return rad2deg(2 * PI * arg_index_of_circle_slice / arg_param.circle_slice_count)



static func _get_target_hit_count_on_angle__and_average_deviation(arg_param : LineTargetParameters, arg_angle : float) -> Array:
	var count : int = 0
	var total_deviation : float = 0
	
	for target_pos in arg_param.target_positions:
		var arr = _if_target_is_hit_by_line_with_width__and_get_difference_of_angle_to_target(target_pos, arg_param, arg_angle)
		
		if arr[0]:
			count += 1
			total_deviation += arr[1]
	
	var ave_deviation : float = 0
	if count > 0:
		ave_deviation = total_deviation / count
	
	return [count, ave_deviation]


static func _if_target_is_hit_by_line_with_width__and_get_difference_of_angle_to_target(arg_target_pos : Vector2, arg_param : LineTargetParameters, arg_angle : float) -> Array:
	var source_pos = arg_param.source_position
	var distance_to_target = arg_target_pos.distance_to(source_pos)
	
	# check distance
	if distance_to_target > arg_param.line_range:
		return [false, 0]
	
	
	var line_width = arg_param.get_line_width_with_forgiveness()
	
	var line_width_as_vector = Vector2(line_width, 0).rotated(deg2rad(90 + arg_angle))
	line_width_as_vector.x = abs(line_width_as_vector.x)
	line_width_as_vector.y = abs(line_width_as_vector.y)
	
	var end_pos_01 = arg_target_pos + line_width_as_vector
	var end_pos_02 = arg_target_pos - line_width_as_vector
#	var angle_to_end_pos_01 = 360 + rad2deg(source_pos.angle_to_point(end_pos_01))
#	var angle_to_end_pos_02 = 360 + rad2deg(source_pos.angle_to_point(end_pos_02))
	var angle_to_end_pos_01 = rad2deg(source_pos.angle_to_point(end_pos_01))
	var angle_to_end_pos_02 = rad2deg(source_pos.angle_to_point(end_pos_02))
	
	
	var within_angle : bool = is_angle_between_angles(arg_angle, angle_to_end_pos_01, angle_to_end_pos_02)
	
	#print("angle: %s, angle_end_pos_02 : %s, angle_end_pos_01 : %s, arg_target_pos : %s, within angle: %s, angle_to_enemy: %s" % [arg_angle, angle_to_end_pos_02, angle_to_end_pos_01, arg_target_pos, within_angle, rad2deg(source_pos.angle_to_point(arg_target_pos))])
	#print("-------------")
	
	var angle_to_enemy_pos = rad2deg(source_pos.angle_to_point(arg_target_pos))
	angle_to_enemy_pos = _convert_angle_to_1to360(angle_to_enemy_pos)
	arg_angle = _convert_angle_to_1to360(arg_angle)
	
#	var diff = abs(angle_to_enemy_pos - arg_angle)
#	if diff > 180:
#		diff = abs(diff - 360)
	
	var diff = _get_angle_diff(angle_to_enemy_pos, arg_angle)
	#var diff = 0 # TODO use this for now to check is angle between angle
	
	return [within_angle, diff]

static func _get_angle_diff(angle_01, angle_02):
	var diff = angle_02 - angle_01
	if diff < -180:
		diff += 360
	elif diff > 180:
		diff -= 360

	return abs(diff)


static func is_angle_between_angles(arg_angle, arg_angle_01, arg_angle_02):
	arg_angle = _convert_angle_to_1to360(arg_angle)
	arg_angle_01 = _convert_angle_to_1to360(arg_angle_01)
	arg_angle_02 = _convert_angle_to_1to360(arg_angle_02)
	
	
	if arg_angle_01 < arg_angle_02:
		if arg_angle_02 - arg_angle_01 < 270:
			return arg_angle_01 <= arg_angle and arg_angle <= arg_angle_02 #orig
		else:
			return arg_angle_01 >= arg_angle and arg_angle >= arg_angle_02
		
	else:
		if arg_angle_01 - arg_angle_02 < 270:
			return arg_angle_01 >= arg_angle and arg_angle >= arg_angle_02 #orig
		else:
			#print("angle: %s, angle_end_pos_01 : %s, angle_end_pos_02 : %s" % [arg_angle, arg_angle_01, arg_angle_02])
			return arg_angle <= arg_angle_02 and arg_angle_01 >= arg_angle


static func is_angle_between_angles__do_no_correction(arg_angle, arg_angle_01, arg_angle_02):
	arg_angle = _convert_angle_to_1to360(arg_angle)
	arg_angle_01 = _convert_angle_to_1to360(arg_angle_01)
	arg_angle_02 = _convert_angle_to_1to360(arg_angle_02)
	
	return arg_angle_01 <= arg_angle and arg_angle <= arg_angle_02

static func is_angle_between_angles__v2(arg_angle, arg_angle_01, arg_angle_02):
	if arg_angle_01 > arg_angle_02:
		return Targeting.is_angle_between_angles__do_no_correction(arg_angle, arg_angle_01, arg_angle_02)
	else:
		return Targeting.is_angle_between_angles__do_no_correction(arg_angle, arg_angle_02, arg_angle_01)




static func _convert_angle_to_1to360(arg_angle):
	arg_angle = fmod(arg_angle, 360)
	if arg_angle > 0:
		return arg_angle
	else:
		return arg_angle + 360



#	var smaller_angle
#	var bigger_angle
#	var dir    # 1 = clockwise, 2 = counter
#
#
##	if arg_angle_01 < 0:
##		arg_angle_01 += 360
##
##	if arg_angle_02 < 0:
##		arg_angle_02 += 360
##
##	if arg_angle < 0:
##		arg_angle += 360
#
#
#	if arg_angle_01 > arg_angle_02:
#		bigger_angle = arg_angle_01
#		smaller_angle = arg_angle_02
#		dir = 2
#	else:
#		bigger_angle = arg_angle_02
#		smaller_angle = arg_angle_01
#
#		dir = 1
#
#
##	if smaller_angle < 0:
##		smaller_angle += 360
##		bigger_angle += 360
#
#	#return arg_angle >= smaller_angle and arg_angle <= bigger_angle
#
#
#	if dir == 1:
#		return arg_angle >= smaller_angle and arg_angle <= bigger_angle
#
#	else: #dir == 2
#		return arg_angle <= smaller_angle and arg_angle >= bigger_angle
#


static func convert_deg_angle_to_pos_to_target(arg_deg_angle_hit_count_arr : Array, arg_life_distance_of_proj : float, arg_pos_of_source : Vector2):
	if arg_deg_angle_hit_count_arr.size() > 0:
		return arg_pos_of_source + Vector2(-arg_life_distance_of_proj, 0).rotated(deg2rad(arg_deg_angle_hit_count_arr[0]))
		
	else:
		return arg_pos_of_source + Vector2(-1, 0)


############

static func get_targets__based_on_range_from_center_as_circle(
		arg_targets : Array,
		targeting : int,
		arg_target_count : int,
		center_pos : Vector2, 
		radius : float,
		range_state : int = TargetingRangeState.IN_RANGE,
		arg_include_invis : bool = false) -> Array:
	
	var bucket = []
	
	for target in arg_targets:
		var distance = center_pos.distance_to(target.global_position)
		if (range_state == TargetingRangeState.IN_RANGE and radius >= distance):
			bucket.append(target)
		elif (range_state == TargetingRangeState.OUT_OF_RANGE and radius < distance):
			bucket.append(target)
	
	#
	
	return enemies_to_target(bucket, targeting, arg_target_count, center_pos, arg_include_invis)

#################


class AngleTargetParameters:
	
	# use either based on use case
	var target_node_2ds : Array
	var target_positions : Array
	
	var source_position : Vector2
	
	var angle_a : float
	var angle_b : float
	
	var max_distance_incl : float
	
	#

func get_nodes_within_angle(arg_angle_target_params : AngleTargetParameters):
	var bucket := []
	
	for node in arg_angle_target_params.target_node_2ds:
		var node_pos = node.global_position
		var angle_to_node = arg_angle_target_params.source_position.angle_to_point(node_pos)
		
		var is_node_within_angle : bool
		#if angle_to_node < 0:
		if ((arg_angle_target_params.angle_a + arg_angle_target_params.angle_b) / 2 < 0):
			#return Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_tower), angle_01, angle_02)
			is_node_within_angle = !Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_node), rad2deg(arg_angle_target_params.angle_b), rad2deg(arg_angle_target_params.angle_a))
			#is_node_within_angle = Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_node), arg_angle_target_params.angle_a, arg_angle_target_params.angle_b)
		else:
			is_node_within_angle = Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_node), rad2deg(arg_angle_target_params.angle_b), rad2deg(arg_angle_target_params.angle_a))
			#is_node_within_angle = !Targeting.is_angle_between_angles__do_no_correction(rad2deg(angle_to_node), arg_angle_target_params.angle_a, arg_angle_target_params.angle_b)
		
		if is_node_within_angle:
			var dist = arg_angle_target_params.source_position.distance_to(node_pos)
			if dist <= arg_angle_target_params.max_distance_incl:
				bucket.append(node)
	
	return bucket



