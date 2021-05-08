extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


var heal_as_modifier : Modifier
var delay_per_tick : float


func _init(arg_heal_as_modifier : Modifier,
		arg_effect_uuid : int,
		arg_num_of_ticks : int, 
		arg_delay_per_tick : float).(EffectType.HEAL_OVER_TIME,
		arg_effect_uuid):
	
	heal_as_modifier = arg_heal_as_modifier
	
	delay_per_tick = arg_delay_per_tick

