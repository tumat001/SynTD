extends Reference


var min_sv_value : float = 1.0 #setget set_min_sv_value
var max_sv_value : float = 4.0 #setget set_max_sv_value
var middle_sv_value : float = (min_sv_value + max_sv_value) / 2.0
const correction_threshold_sv_value_diff : float = 0.2
const correction_threshold_count_to_max_ratio : float = 0.9

var strength_value_generator : RandomNumberGenerator

var weights_at_ave_min_sv_value : Dictionary = {
	1 : 2,
	2 : 22,
	3 : 38,
	4 : 38,
}
var weights_at_ave_max_sv_value : Dictionary = {
	1 : 38,
	2 : 38,
	3 : 22,
	4 : 2,
}
var weights_at_ave_ave_value : Dictionary = {
	1 : 25,
	2 : 25,
	3 : 25,
	4 : 25,
}

#func set_min_sv_value(arg_val : int):
#	min_sv_value = arg_val
#
#func set_max_sv_value(arg_val : int):
#	max_sv_value = arg_val

##

func _init():
	strength_value_generator = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.ENEMY_STRENGTH_VALUE_GENERATOR)

#

# ave being a float betwen min_sv and max_sv. Lower vals tend to make the result closer to max_sv (higher).
# count also serving as a "tolerance" or magnitude controler. Higher curr counts have less impact on output. Lower curr counts have more impact on output
# max count serving as reverser of count, but having more priority. More fluctuation if count is closer to max_count
func generate_strength_value(ave : float, count : int, max_count : int):
	var weight_map = _generate_weight_map_based_on_ave(ave)
	#_modify_weight_map_based_on_count(weight_map, ave, count, max_count)
	
	return _randomly_select_val_in_map_based_on_weight(weight_map)

func _generate_weight_map_based_on_ave(ave : float):
	var weight_map : Dictionary = {
		1 : 0,
		2 : 0,
		3 : 0,
		4 : 0
	}
	
	if is_equal_approx(ave, middle_sv_value):
		for i in weights_at_ave_ave_value:
			weight_map[i] = weights_at_ave_ave_value[i]
		
	elif ave > middle_sv_value:
		_set_average_of_weight_maps(middle_sv_value, max_sv_value, ave, weights_at_ave_ave_value, weights_at_ave_max_sv_value, weight_map)
		
	elif ave < middle_sv_value:
		_set_average_of_weight_maps(min_sv_value, middle_sv_value, ave, weights_at_ave_min_sv_value, weights_at_ave_ave_value, weight_map)
		
	
	#print(".........")
	#print(weight_map)
	
	
	return weight_map

# basis val is ave
func _set_average_of_weight_maps(lower_val : float, higher_val : float, basis_val : float, min_map : Dictionary, max_map : Dictionary, map_to_modify : Dictionary):
	#var mid_val = (higher_val + lower_val) / 2.0
	
	# ranging from 2 to 0
	var min_multiplier : float = (basis_val - lower_val)
	var max_multiplier : float = (higher_val - basis_val)
	#print("lower val: %s, higher val: %s, basis val: %s" % [str(lower_val), str(higher_val), str(basis_val)])
	#print("min_multiplier: %s, max_multiplier: %s" % [str(min_multiplier), str(max_multiplier)])
	
	for i in min_map.keys():
		var min_map_weight = min_map[i]
		var max_map_weight = max_map[i]
		
		map_to_modify[i] = ((min_map_weight * min_multiplier) + (max_map_weight * max_multiplier)) / ((min_multiplier + max_multiplier))
	
#
#func _modify_weight_map_based_on_count(weight_map : Dictionary, ave : float, count : int, max_count : int):
#	var count_to_max_ratio = count / float(max_count)
#	if count_to_max_ratio >= correction_threshold_count_to_max_ratio:   # if near end of stagerounds/game
#		if abs(middle_sv_value - ave) <= correction_threshold_sv_value_diff:     # if "far away enough" from middle/intended target sv value average
#			_increase_stratification_of_weight_map(weight_map, count_to_max_ratio)
#
#func _increase_stratification_of_weight_map(weight_map : Dictionary, count_to_max_ratio : float):
#	var weight_array_ascending : Array = []
#	var sv_val_order_match_to_weight_array : Array = []
#
#	sv_val_order_match_to_weight_array.append(weight_map.keys()[0]) 
#	weight_array_ascending.append(weight_map.values()[0])
#
#	for i in weight_map.size() + 1:
#		var sv_val = weight_map.keys()[i]
#		var weight = weight_map.values()[i]
#		var inserted : bool = false
#
#		#
#		for j in weight_array_ascending.size():
#			if weight < weight_array_ascending[j]:
#				weight_array_ascending.insert(0, weight)
#				sv_val_order_match_to_weight_array.insert(0, sv_val)
#
#				inserted = true
#				break
#
#		if !inserted:
#			weight_array_ascending[weight_array_ascending.size()] = weight
#			sv_val_order_match_to_weight_array[sv_val_order_match_to_weight_array.size()] = sv_val
#		#
#
#	######
#
#	var extra_vals_for_inc : float = 0
#
#


func _randomly_select_val_in_map_based_on_weight(weight_map):
	var rand_i : float = strength_value_generator.randi_range(1, 100)
	var curr_i : float = 0
	
	for i in weight_map:
		curr_i += weight_map[i]
		
		if curr_i >= rand_i or is_equal_approx(curr_i, rand_i):
			return i
	
	print("enemysvgenerator error - no weight selected. defaulting to 3")
	return 3


