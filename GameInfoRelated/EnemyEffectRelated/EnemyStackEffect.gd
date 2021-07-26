extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const EnemyBaseEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd")

var base_effect : EnemyBaseEffect
var num_of_stacks_per_apply : int
var stack_cap : int

var duration_refresh_per_apply : bool
var consume_all_stacks_on_cap : bool

var _current_stack : int

func _init(arg_base_effect : EnemyBaseEffect,
		arg_num_of_stacks_per_apply : int,
		arg_stack_cap : int,
		arg_effect_uuid : int,
		arg_duration_refresh_per_apply : bool = true,
		arg_consume_all_stacks_on_cap : bool = true).(EffectType.STACK_EFFECT, 
		arg_effect_uuid):
	
	base_effect = arg_base_effect
	num_of_stacks_per_apply = arg_num_of_stacks_per_apply
	stack_cap = arg_stack_cap
	duration_refresh_per_apply = arg_duration_refresh_per_apply
	

func _get_copy_scaled_by(scale : float):
	var effect
	
	if base_effect != null:
		effect = base_effect._get_copy_scaled_by(scale)
	
	var copy = get_script().new(effect, 
			num_of_stacks_per_apply, stack_cap, 
			effect_uuid, duration_refresh_per_apply, 
			consume_all_stacks_on_cap)
	
	copy._current_stack = _current_stack
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	copy.status_bar_icon = status_bar_icon
	copy.is_from_enemy = is_from_enemy
	
	return copy
