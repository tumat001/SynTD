extends Reference


var stack_name : String
var base_effect_on_trigger
var stacks_to_trigger_effect : int

func _init(arg_stack_name : String, arg_max_stacks : int):
	stack_name = arg_stack_name
	stacks_to_trigger_effect = arg_max_stacks
