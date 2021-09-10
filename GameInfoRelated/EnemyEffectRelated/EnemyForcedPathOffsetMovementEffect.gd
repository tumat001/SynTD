extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


var initial_mov_speed : float
var mov_speed_dec_per_sec : float
var allow_mov_sign_cross : bool

var current_movement_speed : float


func _init(arg_initial_mov_speed : float,
		arg_mov_speed_dec_per_sec : float,
		arg_effect_uuid : int,
		arg_allow_mov_sign_cross : bool = false).(EffectType.FORCED_PATH_OFFSET_MOVEMENT, arg_effect_uuid):
	
	initial_mov_speed = arg_initial_mov_speed
	mov_speed_dec_per_sec = arg_mov_speed_dec_per_sec
	allow_mov_sign_cross = arg_allow_mov_sign_cross
	
	current_movement_speed = initial_mov_speed
	
	should_map_in_all_effects_map = false


func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale and !force_apply_scale:
		scale = 1
	
	
	var copy = get_script().new(initial_mov_speed, mov_speed_dec_per_sec, effect_uuid, allow_mov_sign_cross)
	_configure_copy_to_match_self(copy)
	
	copy.scale_movements(scale)
	
	return copy


#

func time_passed(delta):
	current_movement_speed -= mov_speed_dec_per_sec * delta
	
	if !allow_mov_sign_cross:
		if initial_mov_speed > 0:
			if current_movement_speed < 0:
				current_movement_speed = 0
		else:
			if current_movement_speed > 0:
				current_movement_speed = 0


func reverse_movements():
	scale_movements(-1)


func scale_movements(mov_scale : float):
	initial_mov_speed *= mov_scale
	mov_speed_dec_per_sec *= mov_scale
	current_movement_speed *= mov_scale
