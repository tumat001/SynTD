extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const BaseStack = preload("res://GameInfoRelated/BaseStack.gd")
const img_effect = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_StatusInflict.png")

var base_stack : BaseStack
var num_of_stacks_per_apply : int
var duration_refresh_per_apply : bool

func _init(arg_base_stack : BaseStack,
		arg_num_of_stacks : int,
		arg_effect_uuid : int,
		arg_duration_refresh_per_apply : bool = true).(EffectType.STACK_EFFECT, 
		arg_effect_uuid):
	
	base_stack = arg_base_stack
	num_of_stacks_per_apply = arg_num_of_stacks
	duration_refresh_per_apply = arg_duration_refresh_per_apply
	effect_icon = img_effect

