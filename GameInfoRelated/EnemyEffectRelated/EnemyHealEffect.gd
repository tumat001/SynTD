extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

var heal_as_modifier
var allows_overhealing : bool

func _init(arg_heal_as_modifier,
		arg_effect_uuid : int,
		arg_allow_overhealing : bool = false).(EffectType.HEAL, arg_effect_uuid):
	
	heal_as_modifier = arg_heal_as_modifier
	allows_overhealing = arg_allow_overhealing
	
	is_timebound = false


func _get_copy_scaled_by(scale : float):
	var scaled_modifier = heal_as_modifier.get_copy_scaled_by(scale)
	
	var copy = get_script().new(scaled_modifier, effect_uuid, allows_overhealing)
	
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	copy.status_bar_icon = status_bar_icon
	
	return copy

