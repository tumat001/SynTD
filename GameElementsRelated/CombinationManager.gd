extends Node

const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")
const Towers = preload("res://GameInfoRelated/Towers.gd")

const ShowTowersWithParticleComponent = preload("res://MiscRelated/CommonComponents/ShowTowersWithParticleComponent.gd")
const CombinationEffect = preload("res://GameInfoRelated/CombinationRelated/CombinationEffect.gd")

const CombinationTopPanel = preload("res://GameHUDRelated/CombinationRelatedPanels/CombinationTopPanel/CombinationTopPanel.gd")

const CombinationIndicator_Pic01 = preload("res://GameInfoRelated/CombinationRelated/Assets/CombinationIndicator/CombinationIndicator_01.png")
const CombinationIndicator_Pic02 = preload("res://GameInfoRelated/CombinationRelated/Assets/CombinationIndicator/CombinationIndicator_02.png")
const CombinationIndicator_Pic03 = preload("res://GameInfoRelated/CombinationRelated/Assets/CombinationIndicator/CombinationIndicator_03.png")
const CombinationIndicator_Pic04 = preload("res://GameInfoRelated/CombinationRelated/Assets/CombinationIndicator/CombinationIndicator_04.png")
const CombinationIndicator_Pic05 = preload("res://GameInfoRelated/CombinationRelated/Assets/CombinationIndicator/CombinationIndicator_05.png")
const CombinationIndicator_Pic06 = preload("res://GameInfoRelated/CombinationRelated/Assets/CombinationIndicator/CombinationIndicator_06.png")
const CombinationIndicator_Pic07 = preload("res://GameInfoRelated/CombinationRelated/Assets/CombinationIndicator/CombinationIndicator_07.png")
const CombinationIndicator_Pic08 = preload("res://GameInfoRelated/CombinationRelated/Assets/CombinationIndicator/CombinationIndicator_08.png")


signal on_combination_amount_needed_changed(new_val)
signal on_tiers_affected_changed()

enum AmountForCombinationModifiers {
	DOMSYN_RED__COMBINATION_EFFICIENCY = 1
}

const base_combination_amount : int = 4 # amount of copies needed for combination
var _flat_combination_amount_modifier_map : Dictionary = {}
var last_calculated_combination_amount : int

const combination_indicator_fps : int = 25

#

enum TierLevelAffectedModifiers {
	DOMSYN_RED__COMBINATION_EXPERT = 1
}

const base_tier_level_affected_amount : int = 1  # ex:(at val = 2), tier 1 combo can affect tiers 1, 2 and 3.
var _flat_tier_level_affected_modifier_map : Dictionary = {}
var tiers_affected_per_combo_tier : Dictionary = {
	1 : [],
	2 : [],
	3 : [],
	4 : [],
	5 : [],
	6 : []
}
const highest_tower_tier : int = 6

#const tiers_affected_per_combo_tier : Dictionary = {
#	1 : [1, 2],
#	2 : [1, 2, 3],
#	3 : [1, 2, 3, 4],
#	4 : [1, 2, 3, 4, 5],
#	5 : [1, 2, 3, 4, 5, 6],
#	6 : [1, 2, 3, 4, 5, 6]
#}


#

const blacklisted_tower_ids_from_combining : Array = [
	Towers.TIME_MACHINE,
	
	Towers.RE,
	
	Towers._704,
	
	Towers.FRUIT_TREE_FRUIT
]

enum TowerBuyCardMetadata {
	NONE = 0,
	PROGRESS_TOWARDS_COMBINABLE = 1, # Should be a brief shine
	IMMEDIATELY_COMBINABLE = 2, # Should have distinct logo
	ALREADY_HAS_COMBINATION = 3, # Same as none, or faded logo
}

#



var tower_manager : TowerManager setget set_tower_manager

var combination_top_panel : CombinationTopPanel setget set_combination_top_panel

#

var combination_indicator_shower : ShowTowersWithParticleComponent

var current_combination_candidates : Array

#

# combi/tower id -> combi effect (Array)
var all_combination_id_to_effect_map : Dictionary


# init

func _ready():
	_construct_tower_indicator_shower()
	
	_update_combination_amount(false)
	_update_tier_affected_by_combi()

func _construct_tower_indicator_shower():
	combination_indicator_shower = ShowTowersWithParticleComponent.new()
	combination_indicator_shower.update_state_when_destroying_particles = false
	
	combination_indicator_shower.set_source_and_provider_func_name(self, "_get_towers_with_tower_combination_amount_met")
	
	var spriteframes = SpriteFrames.new()
	spriteframes.add_frame("default", CombinationIndicator_Pic01)
	spriteframes.add_frame("default", CombinationIndicator_Pic02)
	spriteframes.add_frame("default", CombinationIndicator_Pic03)
	spriteframes.add_frame("default", CombinationIndicator_Pic04)
	spriteframes.add_frame("default", CombinationIndicator_Pic05)
	spriteframes.add_frame("default", CombinationIndicator_Pic06)
	spriteframes.add_frame("default", CombinationIndicator_Pic07)
	spriteframes.add_frame("default", CombinationIndicator_Pic08)
	spriteframes.set_animation_speed("default", combination_indicator_fps)
	
	combination_indicator_shower.tower_particle_indicator = spriteframes
	
	combination_indicator_shower.show_particle_conditions = ShowTowersWithParticleComponent.ShowParticleConditions.ALWAYS
	combination_indicator_shower.destroy_particles_on_tower_target_on_bench = false


# setters

func set_tower_manager(arg_tower_manager):
	tower_manager = arg_tower_manager
	
	tower_manager.connect("tower_added", self, "_on_tower_added", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	tower_manager.connect("tower_in_queue_free", self, "_on_tower_in_queue_free", [], CONNECT_PERSIST | CONNECT_DEFERRED)


func set_combination_top_panel(arg_combi_top_panel):
	combination_top_panel = arg_combi_top_panel

# tier affected

func set_tier_affected_amount_modi(id : int, amount : int):
	_flat_tier_level_affected_modifier_map[id] = amount
	_update_tier_affected_by_combi()

func remove_tier_affected_amount_modi(id : int):
	if _flat_tier_level_affected_modifier_map.has(id):
		_flat_tier_level_affected_modifier_map.erase(id)
		_update_tier_affected_by_combi()

func _update_tier_affected_by_combi():
	var tier_affected_amount : int = base_tier_level_affected_amount
	
	for val in _flat_tier_level_affected_modifier_map.values():
		tier_affected_amount += val
	
	for tier in tiers_affected_per_combo_tier.keys():
		var affected_tiers : Array = tiers_affected_per_combo_tier[tier]
		affected_tiers.clear()
		
		var highest_tier_to_affect = tier + tier_affected_amount
		for i in (highest_tier_to_affect + 1):
			if i == 0:
				continue
			
			affected_tiers.append(i)
			
			if i == highest_tower_tier:
				break
	
	emit_signal("on_tiers_affected_changed")
	
	_update_combination_effects_of_towers_based_on_current()
	#call_deferred("_update_combination_effects_of_towers_based_on_current")


# combi amount

func set_combination_amount_modi(id : int, amount : int):
	_flat_combination_amount_modifier_map[id] = amount
	_update_combination_amount()

func remove_combination_amount_modi(id : int):
	if _flat_combination_amount_modifier_map.has(id):
		_flat_combination_amount_modifier_map.erase(id)
		_update_combination_amount()

func _update_combination_amount(arg_emit_signal : bool = true):
	var amount : int = base_combination_amount
	
	for val in _flat_combination_amount_modifier_map.values():
		amount += val
	
	if amount < 0:
		amount = 0
	last_calculated_combination_amount = amount
	
	if arg_emit_signal:
		emit_signal("on_combination_amount_needed_changed", last_calculated_combination_amount)
	
	call_deferred("_update_applicable_combinations_on_towers")

# signals

func _on_tower_added(tower_added):
	call_deferred("_update_applicable_combinations_on_towers")
	
	for combi_effect in all_combination_id_to_effect_map.values():
		_attempt_apply_all_combination_effects_to_tower(tower_added)


# destroyed, in queued free
func _on_tower_in_queue_free(tower_destroyed):
	call_deferred("_update_applicable_combinations_on_towers")
	


func _update_applicable_combinations_on_towers():
	var towers_combination_candidates : Array = _get_towers_with_tower_combination_amount_met()
	current_combination_candidates = towers_combination_candidates
	
	if (towers_combination_candidates.size() > 0):
		if !_if_previous_candidates_are_equal_to_new_candidates(combination_indicator_shower.get_towers_with_particle_indicators(), towers_combination_candidates):
			combination_indicator_shower.destroy_indicators_from_towers()
		
		combination_indicator_shower.show_indicators_to_towers(towers_combination_candidates, false)
	else:
		combination_indicator_shower.destroy_indicators_from_towers()


func _if_previous_candidates_are_equal_to_new_candidates(prev_candidates : Array, new_candidates : Array) -> bool:
	var is_equal : bool = true
	
	if prev_candidates.size() == new_candidates.size():
		for prev_cand in prev_candidates:
			if !new_candidates.has(prev_cand):
				is_equal = false
				break
	else:
		is_equal = false
	
	return is_equal


#

func _get_towers_with_tower_combination_amount_met(arg_combination_amount : int = last_calculated_combination_amount) -> Array:
	var all_towers : Array = tower_manager.get_all_towers()
	
	#var all_tower_ids : Array = tower_manager.get_all_ids_of_towers()
	
	var tower_id_map : Dictionary = {}
	var to_combine_towers : Array = []
	
	for tower in all_towers:
		if tower.originally_has_ingredient and !tower.is_queued_for_deletion() and !blacklisted_tower_ids_from_combining.has(tower.tower_id) and !all_combination_id_to_effect_map.keys().has(tower.tower_id):
			if (tower_id_map.has(tower.tower_id)):
				tower_id_map[tower.tower_id] += 1
				
				if tower_id_map[tower.tower_id] >= arg_combination_amount:
					
					var i_counter : int = 0
					for i_tower in all_towers:
						if (i_tower.tower_id == tower.tower_id and !i_tower.is_queued_for_deletion()):
							i_counter += 1
							to_combine_towers.append(i_tower)
							
						if (i_counter >= arg_combination_amount):
							break
					
					break
				
				
			else:
				tower_id_map[tower.tower_id] = 1
		
	
	return to_combine_towers


# Card Metadata related

func get_tower_buy_cards_metadata(arg_tower_id_arr_from_cards, arg_combination_amount : int = last_calculated_combination_amount) -> Dictionary:
	var to_combine_tower_ids_to_metadata : Dictionary = {}
	
	var towers_towards_progress_map : Array = _get_towers_towards_progress(arg_tower_id_arr_from_cards)
	var towers_immediately_ready_to_combine_map : Array = _get_towers_immediately_ready_to_combine(arg_tower_id_arr_from_cards)
	
	for tower_id in arg_tower_id_arr_from_cards:
		if towers_immediately_ready_to_combine_map.has(tower_id):
			to_combine_tower_ids_to_metadata[tower_id] = TowerBuyCardMetadata.IMMEDIATELY_COMBINABLE
		elif towers_towards_progress_map.has(tower_id):
			to_combine_tower_ids_to_metadata[tower_id] = TowerBuyCardMetadata.PROGRESS_TOWARDS_COMBINABLE
		elif all_combination_id_to_effect_map.has(tower_id):
			to_combine_tower_ids_to_metadata[tower_id] = TowerBuyCardMetadata.ALREADY_HAS_COMBINATION
		else:
			to_combine_tower_ids_to_metadata[tower_id] = TowerBuyCardMetadata.NONE
	
	return to_combine_tower_ids_to_metadata


# presence of tower id indicates true
func _get_towers_towards_progress(arg_tower_id_arr_from_cards) -> Array:
	var tower_ids_towards_progress : Array = []
	
	var current_tower_ids : Array = tower_manager.get_all_ids_of_towers_except_in_queue_free()
	
	
	for tower_id in arg_tower_id_arr_from_cards:
		var has_progress = current_tower_ids.has(tower_id) and !all_combination_id_to_effect_map.keys().has(tower_id)
		
		if (has_progress):
			tower_ids_towards_progress.append(tower_id)
	
	return tower_ids_towards_progress


# presence of certain amount of towers indicates true
func _get_towers_immediately_ready_to_combine(arg_tower_id_arr_from_cards : Array) -> Array:
	var tower_ids_ready_to_combine : Array = []
	
	var towers_one_off_from_combining = _get_towers_with_tower_combination_amount_met(last_calculated_combination_amount - 1)
	
	for tower_id_card in arg_tower_id_arr_from_cards:
		var is_one_off : bool = false
		
		for tower in towers_one_off_from_combining:
			var tower_id = tower.tower_id
			
			if tower_id_card == tower_id:
				is_one_off = true
				break
		
		if (is_one_off):
			tower_ids_ready_to_combine.append(tower_id_card)
	
	return tower_ids_ready_to_combine


# ----- On Combination Activated Related ------

func on_combination_activated():
	if current_combination_candidates.size() > 0:
		var combi_effect = _construct_combination_effect_from_tower(current_combination_candidates[0].tower_id)
		all_combination_id_to_effect_map[combi_effect.combination_id] = combi_effect
		
		_destroy_current_candidates()
		_apply_combination_effect_to_appropriate_towers(combi_effect)
		
		_put_combination_in_hud_display(combi_effect)
		


func _construct_combination_effect_from_tower(arg_tower_id : int) -> CombinationEffect:
	var tower_type_info_of_tower = Towers.get_tower_info(arg_tower_id)
	
	var combi_effect := CombinationEffect.new(tower_type_info_of_tower.tower_type_id, tower_type_info_of_tower.ingredient_effect, tower_type_info_of_tower)
	
	#combi_effect.applicable_to_tower_tiers = tiers_affected_per_combo_tier[tower_type_info_of_tower.tower_tier]
	combi_effect.tier_of_source_tower = tower_type_info_of_tower.tower_tier
	
	return combi_effect


func _destroy_current_candidates():
	for tower in current_combination_candidates:
		tower.queue_free()
	
	current_combination_candidates.clear()


#

func _apply_combination_effect_to_appropriate_towers(arg_combi_effect : CombinationEffect):
	for tower in tower_manager.get_all_towers_except_in_queue_free():
		_attempt_apply_all_combination_effects_to_tower(tower)


func _attempt_apply_all_combination_effects_to_tower(arg_tower):
	if arg_tower != null and !arg_tower.is_queued_for_deletion():
		var arg_tower_tier : int = arg_tower.tower_type_info.tower_tier
		
		for combi_effect in all_combination_id_to_effect_map.values():
			#if combi_effect.applicable_to_tower_tiers.has(arg_tower_tier):
			if _if_combination_effect_can_apply_to_tier(combi_effect, arg_tower_tier):
				_apply_combination_effect_id_to_tower(combi_effect.combination_id, arg_tower)


func _apply_combination_effect_id_to_tower(combi_id : int, arg_tower):
	var new_combi_effect = _construct_combination_effect_from_tower(combi_id)
	arg_tower.add_combination_effect(new_combi_effect)




func _if_combination_effect_can_apply_to_tier(arg_combi_effect, arg_tower_tier : int) -> bool:
	return tiers_affected_per_combo_tier[arg_combi_effect.tier_of_source_tower].has(arg_tower_tier)


func _put_combination_in_hud_display(arg_combi_effect : CombinationEffect):
	combination_top_panel.add_combination_effect(arg_combi_effect)


#func _remove_combination_effect_from_towers(arg_combi_effect: CombinationEffect):
#	for tower in tower_manager.get_all_towers_except_in_queue_free():
#		tower.remove_combination_effect(arg_combi_effect)
#
#func _remove_combination_effect_id_from_towers(arg_combi_id : int):
#	for tower in tower_manager.get_all_towers_except_in_queue_free():
#		tower.remove_combination_effect_id(arg_combi_id)


#

func _update_combination_effects_of_towers_based_on_current():
	for combi_id in all_combination_id_to_effect_map.keys():
		var combi_effect : CombinationEffect = all_combination_id_to_effect_map[combi_id]
		
		for tower in tower_manager.get_all_towers_except_in_queue_free():
			if _if_combination_effect_can_apply_to_tier(combi_effect, tower.tower_type_info.tower_tier):
				_apply_combination_effect_id_to_tower(combi_effect.combination_id, tower)
			else:
				_remove_combination_effect_id_from_tower(combi_effect.combination_id, tower)
			
			if tower.tower_type_info.tower_type_id == Towers.TRANSPORTER:
				print(tiers_affected_per_combo_tier)
				print(str(_if_combination_effect_can_apply_to_tier(combi_effect, tower.tower_type_info.tower_tier)))


func _remove_combination_effect_id_from_tower(combi_id : int, arg_tower):
	arg_tower.remove_combination_effect_id(combi_id)



# ----- 



