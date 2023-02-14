extends Node

const BasePreGameModifier = preload("res://PreGameRelated/PreGameModifiers/BasePreGameModifier.gd")

const Cyde_CommonPreGameModis = preload("res://CYDE_SPECIFIC_ONLY/DialogRelated/PreGameModifiers/Cyde_CommonPreGameModis.gd")


var _all_pre_game_modifiers__before_S_initialize : Array
var _all_pre_game_modifiers__after_S_initialize : Array

func _add_pre_game_modifier(arg_modifier : BasePreGameModifier):
	if arg_modifier.breakpoint_activation == arg_modifier.BreakpointActivation.BEFORE_SINGLETONS_INITIALIZE:
		_all_pre_game_modifiers__before_S_initialize.append(arg_modifier)
	elif arg_modifier.breakpoint_activation == arg_modifier.BreakpointActivation.AFTER_SINGLETONS_INITIALIZE:
		_all_pre_game_modifiers__after_S_initialize.append(arg_modifier)

#

func _ready():
	#Note: add pre game modifiers to apply here
	# TODO. Remove this then Cyde is over...
	var modi = Cyde_CommonPreGameModis.new()
	_add_pre_game_modifier(modi)
	
	#
	
	call_deferred("_deferred_ready")
	
	


func _deferred_ready():
	
	for modi in _all_pre_game_modifiers__before_S_initialize:
		modi._apply_pre_game_modifier()
	
	#
	
	for autoload in get_tree().root.get_children():
		if autoload.has_method("_on_singleton_initialize"):
			autoload.call("_on_singleton_initialize")
	
	#
	
	for modi in _all_pre_game_modifiers__after_S_initialize:
		modi._apply_pre_game_modifier()

