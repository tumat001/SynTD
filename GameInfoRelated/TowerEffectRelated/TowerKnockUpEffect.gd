extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

const TowerStunEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerStunEffect.gd")



var knock_up_y_acceleration : float

var custom_stun_duration : float = -1

func _init(arg_duration : float, 
		arg_y_accel : float,
		arg_effect_uuid : int).(EffectType.KNOCK_UP, arg_effect_uuid):
	
	should_map_in_all_effects_map = false
	
	time_in_seconds = arg_duration
	knock_up_y_acceleration = arg_y_accel
	is_timebound = true
	


func generate_stun_effect_from_self() -> TowerStunEffect:
	var stun_effect = TowerStunEffect.new(time_in_seconds, effect_uuid)
	
	if custom_stun_duration != -1:
		stun_effect.time_in_seconds = custom_stun_duration
		stun_effect.is_from_enemy = is_from_enemy
	
	return stun_effect

#

func _get_copy_scaled_by(scale : float):
	var copy = get_script().new(time_in_seconds, knock_up_y_acceleration, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	copy.time_in_seconds = time_in_seconds * scale
	copy.knock_up_y_acceleration = knock_up_y_acceleration * scale
	copy.custom_stun_duration = custom_stun_duration * scale
	
	return copy

func _shallow_copy():
	var copy = get_script().new(time_in_seconds, knock_up_y_acceleration, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	copy.time_in_seconds = time_in_seconds
	copy.knock_up_y_acceleration = knock_up_y_acceleration
	copy.custom_stun_duration = custom_stun_duration
	
	return copy
