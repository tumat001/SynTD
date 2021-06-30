extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const tier_4_tower_ing_boost : int = 40
const tier_4_tower_limit : int = 3
const tier_4_tower_violet_limit : int = 2

const tier_3_tower_ing_boost : int = 12
const tier_3_tower_limit : int = 6
const tier_3_tower_violet_limit : int = 3

const tier_2_tower_ing_boost : int = 8
const tier_2_tower_limit : int = 9
const tier_2_tower_violet_limit : int = 4

const tier_1_tower_ing_boost : int = 9
const tier_1_tower_limit : int = 13
const tier_1_tower_violet_limit : int = 5


var game_elements : GameElements
var current_ing_boost : int
var current_tier : int

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
	
	var tower_manager := game_elements.tower_manager
	if !tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_added_or_removed"):
		tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_added_or_removed", [false], CONNECT_PERSIST)
		tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_added_or_removed", [true], CONNECT_PERSIST)
	
	current_tier = tier
	_attempt_apply_synergy_to_add_or_remove(tier)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _attempt_apply_synergy_to_add_or_remove(tier : int):
	var towers : Array = game_elements.tower_manager.get_all_active_towers()
	var violet_towers : Array = game_elements.tower_manager.get_all_active_towers_with_color(TowerColors.VIOLET)
	
	if tier == 4:
		if towers.size() <= tier_4_tower_limit and violet_towers.size() <= tier_4_tower_violet_limit:
			current_ing_boost = tier_4_tower_ing_boost
			_add_towers_to_benefit_from_synergy(violet_towers)
		else:
			_remove_towers_from_synergy(violet_towers)
		
	elif tier == 3:
		if towers.size() <= tier_3_tower_limit and violet_towers.size() <= tier_3_tower_violet_limit:
			current_ing_boost = tier_3_tower_ing_boost
			_add_towers_to_benefit_from_synergy(violet_towers)
		else:
			_remove_towers_from_synergy(violet_towers)
		
	elif tier == 2:
		if towers.size() <= tier_2_tower_limit and violet_towers.size() <= tier_2_tower_violet_limit:
			current_ing_boost = tier_2_tower_ing_boost
			_add_towers_to_benefit_from_synergy(violet_towers)
		else:
			_remove_towers_from_synergy(violet_towers)
		
	elif tier == 1:
		if towers.size() <= tier_1_tower_limit and violet_towers.size() <= tier_1_tower_violet_limit:
			current_ing_boost = tier_1_tower_ing_boost
			_add_towers_to_benefit_from_synergy(violet_towers)
		else:
			_remove_towers_from_synergy(violet_towers)



func _add_towers_to_benefit_from_synergy(violet_towers : Array):
	for tower in violet_towers:
		_tower_to_benefit_from_synergy(tower)

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	if tower._tower_colors.has(TowerColors.VIOLET):
		tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.VIOLET_SYNERGY, current_ing_boost)


func _remove_towers_from_synergy(violet_towers : Array):
	for tower in violet_towers:
		_tower_to_remove_from_synergy(tower)

func _tower_to_remove_from_synergy(tower : AbstractTower):
	if tower._tower_colors.has(TowerColors.VIOLET):
		tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.VIOLET_SYNERGY, 0)


func _tower_added_or_removed(tower, removing : bool):
	_attempt_apply_synergy_to_add_or_remove(current_tier)
	
	if removing:
		_tower_to_remove_from_synergy(tower)



func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	current_ing_boost = 0
	current_tier = 0
	
	var violet_towers : Array = game_elements.tower_manager.get_all_active_towers_with_color(TowerColors.VIOLET)
	_remove_towers_from_synergy(violet_towers)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_added_or_removed"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_added_or_removed")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_added_or_removed")
	
	._remove_syn_from_game_elements(arg_game_elements, tier)
