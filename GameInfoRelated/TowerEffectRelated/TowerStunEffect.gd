extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"



func _init(arg_duration : float, 
		arg_effect_uuid : int).(EffectType.STUN, arg_effect_uuid):
	
	time_in_seconds = arg_duration
	is_timebound = true
	
	_can_be_scaled_by_yel_vio = true



func _get_copy_scaled_by(scale : float):
	var copy = get_script().new(time_in_seconds, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	var scaled_stun = time_in_seconds * scale
	copy.time_in_seconds = scaled_stun
	
	return copy

func _shallow_duplicate():
	var copy = get_script().new(time_in_seconds, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy
