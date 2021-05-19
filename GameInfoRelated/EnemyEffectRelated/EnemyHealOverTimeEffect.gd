extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


var heal_as_modifier : Modifier
var delay_per_tick : float


func _init(arg_heal_as_modifier : Modifier,
		arg_effect_uuid : int,
		arg_delay_per_tick : float).(EffectType.HEAL_OVER_TIME,
		arg_effect_uuid):
	
	heal_as_modifier = arg_heal_as_modifier
	delay_per_tick = arg_delay_per_tick


func _get_copy_scaled_by(scale : float):
	var scaled_modifier = heal_as_modifier.get_copy_scaled_by(scale)
	
	var copy = get_script().new(scaled_modifier, effect_uuid, delay_per_tick)
	return copy
