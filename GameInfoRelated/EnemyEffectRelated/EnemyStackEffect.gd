extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const BaseStack = preload("res://GameInfoRelated/BaseStack.gd")
const img_effect = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_StatusInflict.png")

var base_stack : BaseStack
var num_of_stacks : int

func _init(arg_base_stack : BaseStack,
		arg_num_of_stacks : int,
		arg_effect_source : String).(EffectType.STACK_EFFECT, 
		arg_effect_source):
	
	base_stack = arg_base_stack
	num_of_stacks = arg_num_of_stacks
	effect_icon = img_effect

