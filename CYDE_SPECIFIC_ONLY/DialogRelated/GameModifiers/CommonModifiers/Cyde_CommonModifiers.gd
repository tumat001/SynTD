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
	
	game_elements.combination_manager.connect("before_combination_is_executed_and_applied", self, "_on_before_combination_is_executed_and_applied", [], CONNECT_PERSIST)
	game_elements.combination_manager.prevent_usual_combination_processes = true
	game_elements.combination_manager.minimum_combination_amount = 3
	game_elements.combination_manager.set_combination_amount_modi(game_elements.combination_manager.AmountForCombinationModifiers.CYDE_COMMON_MODIFIERS, -3)
	game_elements.combination_top_panel.combination_more_details_button.visible = false

#

func set_can_toggle_to_ingredient_mode(arg_val : bool):
	if arg_val:
		game_elements.tower_manager.can_toggle_to_ingredient_mode_clauses.remove_clause(game_elements.tower_manager.CanToggleToIngredientModeClauses.TUTORIAL_DISABLE)
	else:
		game_elements.tower_manager.can_toggle_to_ingredient_mode_clauses.attempt_insert_clause(game_elements.tower_manager.CanToggleToIngredientModeClauses.TUTORIAL_DISABLE)


####################

func _on_before_combination_is_executed_and_applied():
	var combi_manager := game_elements.combination_manager
	
	var curr_candidates = combi_manager.current_combination_candidates
	var curr_placable_to_put_new_tower = curr_candidates[0]
	for candidate in curr_candidates:
		if candidate.is_current_placable_in_map():
			curr_placable_to_put_new_tower = candidate.current_placable
			break
	
	game_elements.combination_manager.destroy_current_candidates(curr_candidates[0].tower_tier)
	curr_candidates[0].connect("tower_in_queue_free", self, "_on_candidate_tower_queue_free", [curr_candidates[0].tower_id], CONNECT_DEFERRED)
	
	##
	
	

func _on_candidate_tower_queue_free():
	pass
	


