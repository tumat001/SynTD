extends "res://GameplayRelated/GameModifiersRelated/BaseGameModifier.gd"



const Cyde_HeaderIDName = "Cyde_"
const id_name = "%s%s" % [Cyde_HeaderIDName, "CommonGameModifiers"]

func _init().(id_name,
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
	set_can_toggle_to_ingredient_mode(false)
	game_elements.color_wheel_gui.visible = false
	
	game_elements.combination_top_panel.combination_more_details_button.visible = false

#

func set_can_toggle_to_ingredient_mode(arg_val : bool):
	if arg_val:
		game_elements.tower_manager.can_toggle_to_ingredient_mode_clauses.remove_clause(game_elements.tower_manager.CanToggleToIngredientModeClauses.TUTORIAL_DISABLE)
	else:
		game_elements.tower_manager.can_toggle_to_ingredient_mode_clauses.attempt_insert_clause(game_elements.tower_manager.CanToggleToIngredientModeClauses.TUTORIAL_DISABLE)


####################



