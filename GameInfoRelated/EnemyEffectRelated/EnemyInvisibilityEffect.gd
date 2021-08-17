extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


var _current_time

func _init(arg_time_in_seconds : float,
		arg_effect_uuid : int,
		arg_respect_scale : bool = true).(EffectType.INVISIBILITY, arg_effect_uuid):
	
	time_in_seconds = arg_time_in_seconds
	_current_time = time_in_seconds
	
	respect_scale = arg_respect_scale
	
	is_timebound = true


func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale and !force_apply_scale:
		scale = 1
	
	var copy = get_script().new(time_in_seconds * scale, effect_uuid, respect_scale)
	
	_configure_copy_to_match_self(copy)
	
	return copy
