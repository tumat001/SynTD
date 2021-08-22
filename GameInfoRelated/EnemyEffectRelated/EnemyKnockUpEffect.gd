extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

var knock_up_y_acceleration : float

func _init(arg_duration : float, 
		arg_y_accel : float,
		arg_effect_uuid : int).(EffectType.KNOCK_UP, arg_effect_uuid):
	
	time_in_seconds = arg_duration
	knock_up_y_acceleration = arg_y_accel
	is_timebound = true
	should_map_in_all_effects_map = false
	
	is_clearable = false


func generate_stun_effect_from_self() -> EnemyStunEffect:
	var stun_effect = EnemyStunEffect.new(time_in_seconds, effect_uuid)
	
	stun_effect.respect_scale = respect_scale
	stun_effect.is_clearable = false
	
	return stun_effect

#

func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale or force_apply_scale:
		scale = 1
	
	var copy = get_script().new(time_in_seconds, knock_up_y_acceleration, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	copy.time_in_seconds = time_in_seconds * scale
	copy.knock_up_height = knock_up_y_acceleration * scale
	
	return copy

