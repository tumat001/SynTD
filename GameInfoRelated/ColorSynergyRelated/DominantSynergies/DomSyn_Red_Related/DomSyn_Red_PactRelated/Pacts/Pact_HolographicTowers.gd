extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerMarkEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerMarkEffect.gd")
const LevelManager = preload("res://GameElementsRelated/LevelManager.gd")

const player_level_to_tower_tier_map : Dictionary = {
	LevelManager.LEVEL_6 : 4,
	LevelManager.LEVEL_7 : 4,
	LevelManager.LEVEL_8 : 5,
	LevelManager.LEVEL_9 : 6,
}

const player_level_to_tower_amount_map : Dictionary = {
	LevelManager.LEVEL_6 : 0,
	LevelManager.LEVEL_7 : 1,
	LevelManager.LEVEL_8 : 0,
	LevelManager.LEVEL_9 : 0,
}

const player_level_min_for_offerable_inc : int = LevelManager.LEVEL_6
const player_level_max_for_offerable_inc : int = LevelManager.LEVEL_9


const syn_tier_to_tower_amount_map : Dictionary = {
	0 : 4,
	1 : 3,
	2 : 2,
	3 : 1,
}

var tower_count_to_offer : int
var tower_tier_to_offer : int
var tower_amount_to_lose_after_pact_unsworn : int

var _towers_created : Array = []

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.HOLOGRAPHIC_TOWERS, "Holographic Towers", arg_tier, arg_tier_for_activation):
	tower_amount_to_lose_after_pact_unsworn = 2
	
	var plain_fragment__holographic_towers_paren = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Holographic tower(s)")
	var plain_fragment__random_towers_paren = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "%s random tower(s)" % str(tower_amount_to_lose_after_pact_unsworn))
	
	bad_descriptions = [
		["Sell all |0| + |1| when this pact is unsworn.", [plain_fragment__holographic_towers_paren, plain_fragment__random_towers_paren]]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_HolographicTowers_Icon.png")


func _first_time_initialize():
	var player_level = game_elements.level_manager.current_level
	
	tower_tier_to_offer = player_level_to_tower_tier_map[player_level]
	var tower_amount_to_offer_based_on_syn = syn_tier_to_tower_amount_map[tier]
	var tower_amount_to_offer_based_on_player_lvl = player_level_to_tower_amount_map[player_level]
	tower_count_to_offer = tower_amount_to_offer_based_on_syn + tower_amount_to_offer_based_on_player_lvl
	
	var plain_fragment_tier = PlainTextFragment.new(PlainTextFragment.get_stat_type_based_on_tower_tier(tower_tier_to_offer), "%s tier %s Holographic tower(s)" % [str(tower_count_to_offer), str(tower_tier_to_offer)])
	var plain_fragment__holographic_towers = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Holographic towers")
	var plain_fragment__absorbed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "absorbed")
	
	
	good_descriptions = [
		["Gain |0|. |1| cannot be |2|, and cannot be sold.", [plain_fragment_tier, plain_fragment__holographic_towers, plain_fragment__absorbed]],
		["|0| have zero gold value.", [plain_fragment__holographic_towers]],
	]
	
	#
	
	game_elements.tower_inventory_bench.connect("tower_entered_bench_slot", self, "_on_tower_entered_bench_space", [], CONNECT_PERSIST)
	game_elements.tower_inventory_bench.connect("tower_removed_from_bench_slot", self, "_on_tower_exited_bench_space", [], CONNECT_PERSIST)
	
	_update_bench_space_status()


# ensure bench spaces

func _on_tower_entered_bench_space(tower, bench_slot):
	_update_bench_space_status()

func _on_tower_exited_bench_space(tower, bench_slot):
	_update_bench_space_status()



func _update_bench_space_status():
	_check_requirement_status_and_do_appropriate_action()

func _if_other_requirements_are_met() -> bool:
	return game_elements.tower_inventory_bench._find_number_of_empty_slots() >= tower_count_to_offer or is_sworn


func _if_pact_can_be_sworn() -> bool:
	return _if_other_requirements_are_met()


#

func pact_sworn():
	.pact_sworn()
	
	# create towers
	for i in tower_count_to_offer:
		var tower = game_elements.shop_manager.create_random_tower_at_bench(tower_tier_to_offer)
		
		if is_instance_valid(tower):
			tower.can_be_sold_conditonal_clauses.attempt_insert_clause(tower.CanBeSoldClauses.DOM_SYN_RED__PACT_HOLOGRAPHIC_TOWERS)
			tower.can_be_used_as_ingredient_conditonal_clauses.attempt_insert_clause(tower.CanBeUsedAsIngredientClauses.DOM_SYN_RED__HOLOGRAPHIC_TOWERS)
			tower.set_base_gold_cost(0)
			_towers_created.append(tower)
			
			var effect = TowerMarkEffect.new(StoreOfTowerEffectsUUID.RED_PACT_HOLOGRAPHIC_TOWER_HOLOGRAPHIC_ICON_MARKER)
			effect.status_bar_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/HolographicTower_StatusBarIcon.png")
			tower.add_tower_effect(effect)
	
	if !if_tier_requirement_is_met():
		_disable_all_created_holographic_towers()


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	for tower in _towers_created:
		if is_instance_valid(tower):
			tower.disabled_from_attacking_clauses.remove_clause(tower.DisabledFromAttackingSourceClauses.DOM_SYN__RED__HOLOGRAPHIC_TOWERS)
			
			var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_HOLOGRAPHIC_TOWER_HOLOGRAPHIC_DISABLED_MARKER)
			if effect != null:
				tower.remove_tower_effect(effect)

#

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	_disable_all_created_holographic_towers()

func _disable_all_created_holographic_towers():
	for tower in _towers_created:
		if is_instance_valid(tower):
			tower.disabled_from_attacking_clauses.attempt_insert_clause(tower.DisabledFromAttackingSourceClauses.DOM_SYN__RED__HOLOGRAPHIC_TOWERS)
			
			var effect = TowerMarkEffect.new(StoreOfTowerEffectsUUID.RED_PACT_HOLOGRAPHIC_TOWER_HOLOGRAPHIC_DISABLED_MARKER)
			effect.status_bar_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/TowerDisabled_StatusBarIcon.png")
			tower.add_tower_effect(effect)


func pact_unsworn(arg_replacing_pact):
	.pact_unsworn(arg_replacing_pact)
	
	game_elements.tower_inventory_bench.disconnect("tower_entered_bench_slot", self, "_on_tower_entered_bench_space")
	
	for tower in _towers_created:
		if is_instance_valid(tower):
			tower.can_be_sold_conditonal_clauses.remove_clause(tower.CanBeSoldClauses.DOM_SYN_RED__PACT_HOLOGRAPHIC_TOWERS)
			tower.sell_tower()
	
	var random_tower = _get_random_tower()
	if is_instance_valid(random_tower):
		random_tower.sell_tower()


func _get_random_tower():
	#var all_towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	var all_towers = game_elements.tower_manager.get_all_towers_except_summonables_and_unsellables_in_queue_free()
	var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.RANDOM_TOWER_DECIDER)
	var rng_i = rng.randi_range(0, all_towers.size() - 1)
	
	return all_towers[rng_i]



###

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.level_manager.current_level >= player_level_min_for_offerable_inc and arg_game_elements.level_manager.current_level <= player_level_max_for_offerable_inc

