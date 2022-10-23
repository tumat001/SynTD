extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"


var tier_affected_amount : int
var less_ingredient_amount : int

const combinations_required_for_offerable_inclusive : int = 4

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.COMBINATION_EXPERTISE, "Combination Expertise", arg_tier, arg_tier_for_activation):
	if tier == 0:
		tier_affected_amount = 2
		less_ingredient_amount = -2
		
	elif tier == 1:
		tier_affected_amount = 2
		less_ingredient_amount = -2
		
	elif tier == 2:
		tier_affected_amount = 1
		less_ingredient_amount = -1
		
	elif tier == 3:
		tier_affected_amount = 1
		less_ingredient_amount = -2
	
	
	var plain_fragment__combination_effects = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.COMBINATION, "Combination effects")
	var plain_fragment__ingredients = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredients")
	
	
	good_descriptions = [
		["|0| can affect +%s tiers above." % str(tier_affected_amount), [plain_fragment__combination_effects]]
	]
	
	bad_descriptions = [
		["Towers can absorb %s less |0|" % str(-less_ingredient_amount), [plain_fragment__ingredients]]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_CombinationExpertise_Icon.png")
	


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	game_elements.combination_manager.set_tier_affected_amount_modi(game_elements.combination_manager.TierLevelAffectedModifiers.DOMSYN_RED__COMBINATION_EXPERT, tier_affected_amount)
	
	if !game_elements.tower_manager.is_connected("tower_added", self, "_on_tower_added_to_game"):
		game_elements.tower_manager.connect("tower_added", self, "_on_tower_added_to_game", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)
	


func _on_tower_added_to_game(arg_tower):
	_tower_to_benefit_from_synergy(arg_tower)

func _tower_to_benefit_from_synergy(arg_tower):
	arg_tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.DOMSYN_RED__COMBINATION_EXPERTISE, less_ingredient_amount)


##

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	
	game_elements.combination_manager.remove_tier_affected_amount_modi(game_elements.combination_manager.TierLevelAffectedModifiers.DOMSYN_RED__COMBINATION_EXPERT)
	
	if game_elements.tower_manager.is_connected("tower_added", self, "_on_tower_added_to_game"):
		game_elements.tower_manager.disconnect("tower_added", self, "_on_tower_added_to_game")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)


func _tower_to_remove_from_synergy(arg_tower):
	arg_tower.remove_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.DOMSYN_RED__COMBINATION_EXPERTISE)

#####

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.combination_manager.all_combination_id_to_effect_map.size() >= combinations_required_for_offerable_inclusive

