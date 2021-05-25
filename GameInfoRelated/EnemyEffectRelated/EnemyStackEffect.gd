extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const img_effect = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_GenericStatusInflict.png")
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
	effect_icon = img_effect
	

func _get_copy_scaled_by(scale : float):
	var copy = get_script().new(base_effect._get_copy_scaled_by(scale), 
			num_of_stacks_per_apply, stack_cap, 
			effect_uuid, duration_refresh_per_apply, 
			consume_all_stacks_on_cap)
	
	copy._current_stack = _current_stack
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	
	return copy
