extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

var knock_up_y_acceleration : float

var custom_stun_duration : float = -1

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
	
	if custom_stun_duration != -1:
		stun_effect.time_in_seconds = custom_stun_duration
		stun_effect.is_from_enemy = is_from_enemy
	
	return stun_effect

#

func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale or force_apply_scale:
		scale = 1
	
	var copy = get_script().new(time_in_seconds, knock_up_y_acceleration, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	copy.time_in_seconds = time_in_seconds * scale
	copy.knock_up_y_acceleration = knock_up_y_acceleration * scale
	copy.custom_stun_duration = custom_stun_duration * scale
	
	return copy

