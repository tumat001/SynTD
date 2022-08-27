extends "res://MiscRelated/AttackSpriteRelated/CenterBasedAttackSprite.gd"

const mod_a : float = 0.8
const starting_modulate := Color(1, 1, 1, mod_a)
const tier_1_color := Color(0.4, 0.4, 0.4, mod_a)
const tier_2_color := Color(31/255.0, 227/255.0, 2/255.0, mod_a)
const tier_3_color := Color(2/255.0, 139/255.0, 218/255.0, mod_a)
const tier_4_color := Color(165/255.0, 78/255.0, 253/255.0, mod_a)
const tier_5_color := Color(253/255.0, 73/255.0, 76/255.0, mod_a)
const tier_6_color := Color(253/255.0, 207/255.0, 68/255.0, mod_a)

const tier_to_color_map : Dictionary = {
	1 : tier_1_color,
	2 : tier_2_color,
	3 : tier_3_color,
	4 : tier_4_color,
	5 : tier_5_color,
	6 : tier_6_color
}

var particle_i_val : int
var particle_max_i_val : int
var particle_deviation_rand : float
var tier : int setget set_tier__to_set_particle_color

var _modulate_to_turn_to : Color
var _mod_r_per_sec : float
var _mod_g_per_sec : float
var _mod_b_per_sec : float
var time_for_modulate_transform : float
var _curr_time_for_modulate_transform : float

var second_center_global_pos : Vector2

var time_before_center_change_and_other_relateds : float
var _curr_time_before_center_change_and_other_relateds : float

var time_of_arrival_to_center : float

#


func set_tier__to_set_particle_color(arg_tier):
	tier = arg_tier
	_modulate_to_turn_to = tier_to_color_map[arg_tier]


#


func reset_for_another_use():
	.reset_for_another_use()
	
	is_enabled_mov_toward_center = true
	_curr_time_for_modulate_transform = 0
	_curr_time_before_center_change_and_other_relateds = time_before_center_change_and_other_relateds
	modulate = starting_modulate

func reset_for_another_use__combi_ing_specific():
	var angle = _get_angle_to_start_on()
	min_starting_angle = angle - particle_deviation_rand
	max_starting_angle = angle + particle_deviation_rand
	set_tier__to_set_particle_color(tier)

func _get_angle_to_start_on():
	return (360 * particle_i_val / particle_max_i_val) - 45

#

func transform_modulate_to_given_param():
	_mod_r_per_sec = (modulate.r - _modulate_to_turn_to.r) / time_for_modulate_transform
	_mod_g_per_sec = (modulate.g - _modulate_to_turn_to.g) / time_for_modulate_transform
	_mod_b_per_sec = (modulate.b - _modulate_to_turn_to.b) / time_for_modulate_transform
	_curr_time_for_modulate_transform = time_for_modulate_transform

func _process(delta):
	if _curr_time_before_center_change_and_other_relateds > 0:
		_curr_time_before_center_change_and_other_relateds -= delta
		
		if _curr_time_before_center_change_and_other_relateds <= 0:
			#pass
			transform_modulate_to_given_param()
			relocate_to_new_global_pos_as_center()
			configure_speed_based_on_distance_to_center()
	
	if _curr_time_for_modulate_transform > 0:
		_curr_time_for_modulate_transform -= delta
		
		modulate.r -= _mod_r_per_sec * delta
		modulate.g -= _mod_g_per_sec * delta
		modulate.b -= _mod_b_per_sec * delta
	


func relocate_to_new_global_pos_as_center():
	center_pos_of_basis = second_center_global_pos

func configure_speed_based_on_distance_to_center():
	var dist = global_position.distance_to(center_pos_of_basis)
	
	speed_accel_towards_center = 2 * (dist - (current_speed_towards_center * time_of_arrival_to_center)) / (time_of_arrival_to_center * time_of_arrival_to_center)
	
