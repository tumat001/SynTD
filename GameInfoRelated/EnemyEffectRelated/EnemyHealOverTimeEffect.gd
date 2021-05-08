extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


var heal_as_modifier : Modifier
var number_of_ticks : int
var delay_per_tick : float


func _init(arg_heal_as_modifier : Modifier,
		effect_source : String,
		arg_num_of_ticks : int, 
		arg_delay_per_tick : float).(EffectType.HEAL_OVER_TIME,
		effect_source):
	
	heal_as_modifier = arg_heal_as_modifier
	
	number_of_ticks = arg_num_of_ticks
	delay_per_tick = arg_delay_per_tick

