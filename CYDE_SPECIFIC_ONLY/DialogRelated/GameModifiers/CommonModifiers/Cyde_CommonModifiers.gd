extends "res://GameplayRelated/GameModifiersRelated/BaseGameModifier.gd"


func _init().(StoreOfGameModifiers.GameModiIds.CYDE__COMMON_GAME_MODIFIERS,
		BreakpointActivation.BEFORE_MAIN_INIT, 
		"Cyde_CommonModifiers"):
	
	pass

##

func _apply_game_modifier_to_elements(arg_elements : GameElements):
	._apply_game_modifier_to_elements(arg_elements)
	
	game_elements.connect("before_game_start", self, "_on_before_game_start_of_GE", [], CONNECT_ONESHOT)


func _on_before_main_init_of_GE():
	pass
	

##

func _on_before_game_start_of_GE():
	pass
	

