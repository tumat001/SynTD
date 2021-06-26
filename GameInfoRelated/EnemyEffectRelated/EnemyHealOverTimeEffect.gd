extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


var heal_as_modifier
var delay_per_tick : float


func _init(arg_heal_as_modifier,
		arg_effect_uuid : int,
		arg_delay_per_tick : float).(EffectType.HEAL_OVER_TIME,
		arg_effect_uuid):
	
	heal_as_modifier = arg_heal_as_modifier
	delay_per_tick = arg_delay_per_tick


func _get_copy_scaled_by(scale : float):
	var scaled_modifier = heal_as_modifier.get_copy_scaled_by(scale)
	
	var copy = get_script().new(scaled_modifier, effect_uuid, delay_per_tick)
	
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	copy.status_bar_icon = status_bar_icon
	
	return copy


# reapplied

func _reapply(copy):
	time_in_seconds = copy.time_in_seconds
	heal_as_modifier = copy.heal_as_modifier
