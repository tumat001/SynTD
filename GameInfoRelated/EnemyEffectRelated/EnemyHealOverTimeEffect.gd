extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


var heal_effect
var delay_per_tick : float

var _curr_delay_per_tick : float

func _init(arg_heal_effect,
		arg_effect_uuid : int,
		arg_delay_per_tick : float,
		arg_respect_scale : bool = true).(EffectType.HEAL_OVER_TIME,
		arg_effect_uuid):
	
	heal_effect = arg_heal_effect
	delay_per_tick = arg_delay_per_tick
	_curr_delay_per_tick = arg_delay_per_tick
	respect_scale = arg_respect_scale


func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale and !force_apply_scale:
		scale = 1
	
	
	var copy = get_script().new(heal_effect._get_copy_scaled_by(scale), effect_uuid, delay_per_tick)
	
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	copy.status_bar_icon = status_bar_icon
	copy.respect_scale = respect_scale
	copy.is_from_enemy = is_from_enemy
	
	return copy


# reapplied

func _reapply(copy):
	time_in_seconds = copy.time_in_seconds
	heal_effect = copy.heal_effect

