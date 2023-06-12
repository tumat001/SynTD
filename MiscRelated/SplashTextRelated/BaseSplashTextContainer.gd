extends Node2D


## PRE POSITION RELATED
#var pre_position_id_to_position_map : Dictionary = {}


## OUTWARD DOWNWARD SPRAY RELATED (ODS)

class OutwardDownwardSprayParam:
	var starting_distance : float
	var starting_pos : Vector2
	
	var upwards_climb_height : float
	var downwards_fall_height : float
	
	var outward_speed : float
	
	
	#
	
	var _current_pos : Vector2
	
	var _current_climb_height
	var _current_climb_speed
	
	var _current_climb_time_left
	
	var _current_fall_height
	var _current_fall_speed
	
	var _current_fall_time_left
	

var ods__min_starting_distance : float
var ods__max_starting_distance : float

var ods__starting_pos : Vector2


var ods__min_upwards_climb : float
var ods__max_upwards_climb : float
var ods__upwards_climb_time : float

var ods__min_downwards_fall : float
var ods__max_downwards_fall : float
var ods__downwards_climb_time : float

var ods__min_outward_speed : float
var ods__max_outward_speed : float


var adv_param_to_ods_param_map : Dictionary

#########

enum SplashTextDisplayMode {
	OUTWARD_DOWNWARD_SPRAY = 0,
	#PRE_POSITION = 1,
	RISING_SPRAY = 2
}
var _display_mode : int = -1

const display_mode_to_func_name_map : Dictionary = {
	SplashTextDisplayMode.OUTWARD_DOWNWARD_SPRAY : "_add_splash_text__for_outward_downward_spray",
	#SplashTextDisplayMode.PRE_POSITION : "_add_splash_text__for_random_pre_positions",
	SplashTextDisplayMode.RISING_SPRAY : "_add_splash_text__for_rising_spray"
}

var _add_splash_text_func_name_to_call : String

var rng_to_use : RandomNumberGenerator


#

func _init():
	rng_to_use = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)

##

# initialize fields as well
func initialize_using_ods():
	_display_mode = SplashTextDisplayMode.OUTWARD_DOWNWARD_SPRAY
	_add_splash_text_func_name_to_call = display_mode_to_func_name_map[_display_mode]
	


#todo do this when needing to implement "pre positions"

## PRE POSITION:
## each position is determined by the number of rows, and dist from center
## when a splash text is assigned a position, that position will be reserved until the splash display is done. This prevents overlapping
#func initialize_using_pre_positions():
#	_display_mode = SplashTextDisplayMode.PRE_POSITION
#
#	_add_splash_text_func_name_to_call = display_mode_to_func_name_map[_display_mode]

# turn these params for the initialize_x into fields
#arg_rows : int, arg_spacing_per_row : float, arg_initial_dist_from_center : float

#####


func _add_splash_text__for_outward_downward_spray(adv_param, ods_param : OutwardDownwardSprayParam):
	if ods_param == null:
		ods_param = construct_randomized_ods_param()
	
	adv_param_to_ods_param_map[adv_param] = ods_param
	

#func _add_splash_text__for_random_pre_positions(adv_param):
#	pass
#

func _add_splash_text__for_rising_spray(adv_param, rising_param):
	pass
	
	#todo


######

func construct_randomized_ods_param() -> OutwardDownwardSprayParam:
	var param = OutwardDownwardSprayParam.new()
	
	param.starting_distance = rng_to_use.randf_range(ods__min_starting_distance, ods__max_starting_distance)
	param.starting_pos = ods__starting_pos
	
	param.upwards_climb_height = rng_to_use.randf_range(ods__min_upwards_climb, ods__max_upwards_climb)
	param._current_climb_time_left = ods__upwards_climb_time
	
	param.downwards_fall_height = rng_to_use.randf_range(ods__min_downwards_fall, ods__max_downwards_fall)
	param._current_fall_time_left = ods__downwards_climb_time
	
	param.outward_speed = rng_to_use.randf_range(ods__min_outward_speed, ods__max_outward_speed)
	
	return param


###################
# PRE-CONFIGURATED values
##################

func configure_to_default_vals_of__ods():
	pass
	




