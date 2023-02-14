extends Node

const Towers = preload("res://GameInfoRelated/Towers.gd")
const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const ColorSynergy = preload("res://GameInfoRelated/ColorSynergy.gd")
const ColorSynergyChecker = preload("res://GameInfoRelated/ColorSynergyChecker.gd")
const ColorSynergyResults = preload("res://GameInfoRelated/ColorSynergyCheckResults.gd")
const LeftPanel = preload("res://GameHUDRelated/LeftSidePanel/LeftPanel.gd")
const TowerManager = preload("res://GameElementsRelated/TowerManager.gd")
const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const ConditonalClause = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

const AbstractTowerModifyingSynergyEffect = preload("res://GameInfoRelated/ColorSynergyRelated/AbstractTowerModifyingSynergyEffect.gd")
const AbstractGameElementsModifyingSynergyEffect = preload("res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd")

const ColorSplatterDrawer = preload("res://MiscRelated/ColorAestheticRelated/ColorSplatterDrawer.gd")
const ColorSplatterDrawer_Scene = preload("res://MiscRelated/ColorAestheticRelated/ColorSplatterDrawer.tscn")
const ColorFillCircleDrawer = preload("res://MiscRelated/ColorAestheticRelated/ColorFillCircleDrawer.gd")
const ColorFillCircleDrawer_Scene = preload("res://MiscRelated/ColorAestheticRelated/ColorFillCircleDrawer.tscn")
const ColorAestheticDrawerPool = preload("res://MiscRelated/PoolRelated/Implementations/ColorAestheticDrawerPool.gd")


enum DontAllowSameTotalsContionalClauseIds {
	GREEN_PATH_BLESSING = 10
	
	SYN_RED__DOMINANCE_SUPPLEMENT = 11
	SYN_RED__COMPLEMENTARY_SUPPLEMENT = 12
}

signal synergies_updated()


var non_active_group_synergies_res : Array
var non_active_dominant_synergies_res : Array
var active_synergies_res : Array

var active_dom_color_synergies_res : Array
var active_compo_color_synergies_res : Array


var previous_active_synergies_res : Array

var left_panel : LeftPanel
var tower_manager : TowerManager setget _set_tower_manager
var game_elements

#

var base_dominant_synergy_limit : int = 1
var _flat_dominant_synergy_limit_modi : Dictionary = {}
var last_calculated_dominant_synergy_limit : int

var base_composite_synergy_limit : int = 1
var _flat_composite_synergy_limit_modi : Dictionary = {}
var last_calculated_composite_synergy_limit : int

var dont_allow_same_total_conditonal_clause : ConditonalClause


#

enum SynergiesToAlwaysActivateModiIds {
	DOM_SYN_RED__ORANGE_SYNERGY__ORANGE = 10,
	DOM_SYN_RED__ORANGE_SYNERGY__RED = 11,
	
	DOM_SYN_RED__BLUE_SYNERGY__BLUE = 12,
	DOM_SYN_RED__BLUE_SYNERGY__RED = 13,
	
	DOM_SYN_RED__VIOLET_SYNERGY__VIOLET = 14,
	DOM_SYN_RED__VIOLET_SYNERGY__RED = 15,
}

var _modi_id_to_dominant_synergy_ids_to_always_activate_map : Dictionary = {}
var _modi_id_to_composite_synergy_ids_to_always_activate_map : Dictionary = {}

#

var _syn_id_to__syn_tier_to_first_time_activated_map : Dictionary = {}

var color_id_to_basis_color_map : Dictionary = {
	TowerColors.BLACK : Color(0.3, 0.3, 0.3),
	TowerColors.WHITE : Color(0.9, 0.9, 0.9),
	TowerColors.BLUE : Color(2/255.0, 57/255.0, 217/255.0),
	TowerColors.GREEN : Color(30/255.0, 218/255.0, 2/255.0),
	TowerColors.ORANGE : Color(255/255.0, 128/255.0, 0/255.0),
	TowerColors.RED : Color(218/255.0, 2/255.0, 5/255.0),
	TowerColors.VIOLET : Color(163/255.0, 77/255.0, 253/255.0),
	TowerColors.YELLOW : Color(232/255.0, 253/255.0, 0/255.0),
}
const basis_color_to_ripple_color_multiplier : float = 0.8


var _color_circle_fill_drawer_pool : ColorAestheticDrawerPool
var _color_splatter_drawer_pool : ColorAestheticDrawerPool

var _color_circle_fill_data_arr : Array = []
var _color_splatter_data_arr : Array = []

#

var non_essential_rng : RandomNumberGenerator

#

enum EnableProcessClauseIds {
	DRAWING_COLOR_FILL_CIRCLES = 0,
	DRAWING_COLOR_SPLATTER = 1,
}
var enable_process_conditional_clauses : ConditonalClause


enum AllowStartColorAestheticDisplay {
#	DOM_SYN_BLACK__IN_PANEL = 0,
#	DOM_SYN_GREEN__IN_PANEL = 1,
#	DOM_SYN_RED__IN_PANEL = 2,
	WHOLE_SCREEN_GUI_IS_OPEN = 3,
	
	
}
var allow_start_color_aesthetic_display_clauses : ConditonalClause
var last_calculated_allow_start_color_aesthetic_display : bool

var _attempted_start_color_aesthetic_display : bool

#

var _dominant_synergy_ids_banned_this_game : Array = []
var _composite_synergy_ids_banned_this_game : Array = []

var _dominant_synergy_id_to_syn_available_this_game_map : Dictionary = {}
var _composite_synergy_id_to_syn_available_this_game : Dictionary = {}


var _before_game_started_initialize_ran = false

#

func _ready():
	dont_allow_same_total_conditonal_clause = ConditonalClause.new()
	dont_allow_same_total_conditonal_clause.connect("clause_inserted", self, "_dont_allow_same_total_clause_added_or_removed", [], CONNECT_PERSIST)
	dont_allow_same_total_conditonal_clause.connect("clause_removed", self, "_dont_allow_same_total_clause_added_or_removed", [], CONNECT_PERSIST)
	
	calculate_final_composite_synergy_limit()
	calculate_final_dominant_synergy_limit()
	
	for syn_id in TowerDominantColors.available_synergy_ids:
		var tier_to_first_time_act_map : Dictionary = {}
		for i in TowerDominantColors.get_synergy_with_id(syn_id).number_of_towers_in_tier.size():
			tier_to_first_time_act_map[i + 1] = true
		
		_syn_id_to__syn_tier_to_first_time_activated_map[syn_id] = tier_to_first_time_act_map
		
	
	for syn_id in TowerCompositionColors.available_synergy_ids:
		var tier_to_first_time_act_map : Dictionary = {}
		for i in TowerCompositionColors.get_synergy_with_id(syn_id).number_of_towers_in_tier.size():
			tier_to_first_time_act_map[i + 1] = true
		
		_syn_id_to__syn_tier_to_first_time_activated_map[syn_id] = tier_to_first_time_act_map
	
	
	#
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	_construct_color_circle_fill_drawer_pool__and_relateds()
	
	
	#
	enable_process_conditional_clauses = ConditonalClause.new()
	enable_process_conditional_clauses.connect("clause_inserted", self, "_on_enable_process_clause_updated", [], CONNECT_PERSIST)
	enable_process_conditional_clauses.connect("clause_removed", self, "_on_enable_process_clause_updated", [], CONNECT_PERSIST)
	_update_enable_process()
	
	allow_start_color_aesthetic_display_clauses = ConditonalClause.new()
	allow_start_color_aesthetic_display_clauses.connect("clause_inserted", self, "_on_allow_start_color_aesthetic_display_clauses_updated", [], CONNECT_PERSIST)
	allow_start_color_aesthetic_display_clauses.connect("clause_removed", self, "_on_allow_start_color_aesthetic_display_clauses_updated", [], CONNECT_PERSIST)
	_update_allow_start_color_aesth_display()
	


func _on_enable_process_clause_updated(arg_clause):
	_update_enable_process()

func _update_enable_process():
	set_process(!enable_process_conditional_clauses.is_passed)


func _on_allow_start_color_aesthetic_display_clauses_updated(arg_clause):
	_update_allow_start_color_aesth_display()

func _update_allow_start_color_aesth_display():
	last_calculated_allow_start_color_aesthetic_display = allow_start_color_aesthetic_display_clauses.is_passed
	if _attempted_start_color_aesthetic_display and last_calculated_allow_start_color_aesthetic_display:
		call_deferred("_attempt_start_color_aesthetic_display")

#

func _set_tower_manager(arg_tower_manager):
	arg_tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_make_tower_benefit_from_active_synergies")
	arg_tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_undo_tower_benefit_from_active_synergies")
	
	tower_manager = arg_tower_manager

#

func update_synergies(towers : Array):
	var distinct_towers : Array = _get_list_of_distinct_towers(towers)
	var active_colors : Array = _convert_towers_to_colors(distinct_towers)
	
	var results_of_dom : Array = ColorSynergyChecker.get_all_results(
	_dominant_synergy_id_to_syn_available_this_game_map.values(), active_colors)
	
	var results_of_compo : Array = ColorSynergyChecker.get_all_results(
	_composite_synergy_id_to_syn_available_this_game.values(), active_colors)
	
	#Remove doms with raw_total of 0
	var to_remove : Array = []
	for res in results_of_dom:
		if res.raw_total == 0:
			to_remove.append(res)
	for to_rem in to_remove:
		results_of_dom.erase(to_rem)
	#Remove compos with raw_total of 0, or if only meets x - 1 of its colors
	to_remove.clear()
	for res in results_of_compo:
		if res.raw_total == 0 or (res.color_types_amount_met < res.color_types_amount_from_baseline - 1):
			to_remove.append(res)
	for to_rem in to_remove:
		results_of_compo.erase(to_rem)
	
	
	results_of_dom = ColorSynergyChecker.sort_by_descending_total_towers(results_of_dom)
	results_of_compo = ColorSynergyChecker.sort_by_descending_total_towers(results_of_compo)
	
	
	var syn_res_to_activate : Array = []
	var dom_to_activate : Array = ColorSynergyChecker.get_synergies_with_results_to_activate(results_of_dom, last_calculated_dominant_synergy_limit, dont_allow_same_total_conditonal_clause.is_passed, _modi_id_to_dominant_synergy_ids_to_always_activate_map.values())
	var compo_to_activate : Array = ColorSynergyChecker.get_synergies_with_results_to_activate(results_of_compo, last_calculated_composite_synergy_limit, dont_allow_same_total_conditonal_clause.is_passed, _modi_id_to_composite_synergy_ids_to_always_activate_map.values())
	
	active_dom_color_synergies_res = []
	active_compo_color_synergies_res = []
	
	
	for res in dom_to_activate:
		syn_res_to_activate.append(res)
		results_of_dom.erase(res)
		active_dom_color_synergies_res.append(res)
	for res in compo_to_activate:
		syn_res_to_activate.append(res)
		results_of_compo.erase(res)
		active_compo_color_synergies_res.append(res)
	
	# Assign-ments
	
	previous_active_synergies_res = active_synergies_res
	
	active_synergies_res = syn_res_to_activate
	non_active_dominant_synergies_res = results_of_dom
	non_active_group_synergies_res = results_of_compo
	
	_update_synergy_displayer()
	
	_apply_active_synergies_and_remove_old(previous_active_synergies_res)
	call_deferred("emit_signal", "synergies_updated")
	
	call_deferred("_attempt_start_color_aesthetic_display")


# Synergy Calculation

func _get_list_of_distinct_towers(towers: Array) -> Array:
	var tower_bucket : Array = []
	var id_bucket : Array = []
	for tower in towers:
		if is_instance_valid(tower) and tower.can_contribute_to_synergy_color_count:
			var id = tower.tower_id
			if !id_bucket.has(id):
				id_bucket.append(id)
				tower_bucket.append(tower)
	
	return tower_bucket

func _convert_towers_to_colors(towers: Array) -> Array:
	var all_colors : Array = []
	for tower in towers:
		for color in tower._tower_colors:
			all_colors.append(color)
	
	return all_colors


# Update displayer

func _update_synergy_displayer():
	left_panel.active_synergies_res = active_synergies_res
	left_panel.non_active_composite_synergies_res = non_active_group_synergies_res
	left_panel.non_active_dominant_synergies_res = non_active_dominant_synergies_res
	left_panel.update_synergy_displayers()


# Synergy application

# actually removes old first then adds new
func _apply_active_synergies_and_remove_old(previous_synergies_res : Array):
	var old_synergies_to_remove : Array = previous_synergies_res
	var new_synergies_to_apply : Array = []
	
	for active_syn_res in active_synergies_res:
		var has_functional_equivalent : bool = false
		var functionally_equal_syn_res : ColorSynergyResults
		var has_same_synergy_but_different_tier : bool = false
		var same_synergy_res_different_tier : ColorSynergyResults = null
		
		for previous_syn_res in previous_synergies_res:
			if !has_functional_equivalent:
				has_functional_equivalent = active_syn_res.functionally_equal_to(previous_syn_res)
				functionally_equal_syn_res = previous_syn_res
			
			if !has_same_synergy_but_different_tier:
				has_same_synergy_but_different_tier = (active_syn_res.synergy.synergy_effects == previous_syn_res.synergy.synergy_effects) and (active_syn_res.synergy_tier != previous_syn_res.synergy_tier) 
				if has_same_synergy_but_different_tier:
					same_synergy_res_different_tier = active_syn_res
		
		if !has_functional_equivalent:
			new_synergies_to_apply.append(active_syn_res)
		else:
			old_synergies_to_remove.erase(functionally_equal_syn_res)
	
	
	var all_towers = tower_manager.get_all_active_towers()
	
	if old_synergies_to_remove.size() != 0:
		_remove_synergies(old_synergies_to_remove, all_towers)
	
	if new_synergies_to_apply.size() != 0:
		_apply_synergies(new_synergies_to_apply, all_towers)


func _apply_synergies(synergies_reses : Array, towers : Array, tower_synergies_only : bool = false):
	for syn_res in synergies_reses:
		syn_res.synergy.apply_this_synergy_to_towers(syn_res.synergy_tier, towers, game_elements, tower_synergies_only)
#		var synergy_effects = syn_res.synergy.synergy_effects
#
#		for synergy_effect in synergy_effects:
#			if synergy_effect is AbstractTowerModifyingSynergyEffect:
#				for tower in towers:
#					synergy_effect._apply_syn_to_tower(tower, syn_res.synergy_tier)
#
#			elif synergy_effect is AbstractGameElementsModifyingSynergyEffect and !tower_synergies_only:
#				synergy_effect._apply_syn_to_game_elements(game_elements, syn_res.synergy_tier)


func _remove_synergies(synergies_reses : Array, towers : Array, tower_synergies_only : bool = false):
	for syn_res in synergies_reses:
		syn_res.synergy.remove_this_synergy_from_towers(syn_res.synergy_tier, towers, game_elements, tower_synergies_only)
#		var synergy_effects = syn_res.synergy.synergy_effects
#
#		for synergy_effect in synergy_effects:
#			if synergy_effect is AbstractTowerModifyingSynergyEffect:
#				for tower in towers:
#					synergy_effect._remove_syn_from_tower(tower, syn_res.synergy_tier)
#
#			elif synergy_effect is AbstractGameElementsModifyingSynergyEffect and !tower_synergies_only:
#				synergy_effect._remove_syn_from_game_elements(game_elements, syn_res.synergy_tier)


# From signals

func _make_tower_benefit_from_active_synergies(tower : AbstractTower):
	_apply_synergies(active_synergies_res, [tower], true)

func _undo_tower_benefit_from_active_synergies(tower : AbstractTower):
	_remove_synergies(active_synergies_res, [tower], true)

#

func add_dominant_syn_limit_modi(modi : FlatModifier):
	_flat_dominant_synergy_limit_modi[modi.internal_id] = modi
	calculate_final_dominant_synergy_limit()
	#update_synergies(tower_manager.get_all_active_towers())
	tower_manager.update_active_synergy__called_from_syn_manager()

func add_composite_syn_limit_modi(modi : FlatModifier):
	_flat_composite_synergy_limit_modi[modi.internal_id] = modi
	calculate_final_composite_synergy_limit()
	#update_synergies(tower_manager.get_all_active_towers())
	tower_manager.update_active_synergy__called_from_syn_manager()

func remove_dominant_syn_limit_modi(modi_id : int, update_syns : bool = true):
	_flat_dominant_synergy_limit_modi.erase(modi_id)
	calculate_final_dominant_synergy_limit()
	
	if update_syns:
		#update_synergies(tower_manager.get_all_active_towers())
		tower_manager.update_active_synergy__called_from_syn_manager()

func remove_composite_syn_limit_modi(modi_id : int, update_syns : bool = true):
	_flat_composite_synergy_limit_modi.erase(modi_id)
	calculate_final_composite_synergy_limit()
	
	if update_syns:
		#update_synergies(tower_manager.get_all_active_towers())
		tower_manager.update_active_synergy__called_from_syn_manager()

func calculate_final_dominant_synergy_limit() -> int:
	var final_val : int = base_dominant_synergy_limit
	
	for flat_modi in _flat_dominant_synergy_limit_modi.values():
		final_val += flat_modi.get_modification_to_value(base_dominant_synergy_limit)
	
	last_calculated_dominant_synergy_limit = final_val
	return final_val

func calculate_final_composite_synergy_limit() -> int:
	var final_val : int = base_composite_synergy_limit
	
	for flat_modi in _flat_composite_synergy_limit_modi.values():
		final_val += flat_modi.get_modification_to_value(base_composite_synergy_limit)
	
	last_calculated_composite_synergy_limit = final_val
	return final_val

#

func _dont_allow_same_total_clause_added_or_removed(id):
	#update_synergies(tower_manager.get_all_active_towers())
	tower_manager.update_active_synergy__called_from_syn_manager()

###### QUERIES related

func is_dom_color_synergy_active(syn) -> bool:
	for res in active_dom_color_synergies_res:
		if res.synergy == syn:
			return true
	
	return false

func is_compo_color_synergy_active(syn) -> bool:
	for res in active_compo_color_synergies_res:
		if res.synergy == syn:
			return true
	
	return false


func is_color_synergy_name_active__with_tier_being_equal_to(arg_syn_name : String, arg_tier : int):
	for res in active_synergies_res:
		if res.synergy.synergy_name == arg_syn_name and res.synergy_tier == arg_tier:
			return true
	
	return false

func is_color_synergy_id_active__with_tier_being_equal_to(arg_syn_id, arg_tier : int):
	for res in active_synergies_res:
		if res.synergy.synergy_id == arg_syn_id and res.synergy_tier == arg_tier:
			return true
	
	return false

#############

func add_dominant_synergy_id_to_always_activate(arg_modi_id, arg_syn_id):
	if !_modi_id_to_dominant_synergy_ids_to_always_activate_map.has(arg_modi_id):
		_modi_id_to_dominant_synergy_ids_to_always_activate_map[arg_modi_id] = arg_syn_id
		tower_manager.update_active_synergy__called_from_syn_manager()

func remove_dominant_synergy_id_to_always_activate(arg_modi_id):
	if _modi_id_to_dominant_synergy_ids_to_always_activate_map.has(arg_modi_id):
		_modi_id_to_dominant_synergy_ids_to_always_activate_map.erase(arg_modi_id)
		tower_manager.update_active_synergy__called_from_syn_manager()


func add_composite_synergy_id_to_always_activate(arg_modi_id, arg_syn_id):
	if !_modi_id_to_composite_synergy_ids_to_always_activate_map.has(arg_modi_id):
		_modi_id_to_composite_synergy_ids_to_always_activate_map[arg_modi_id] = arg_syn_id
		tower_manager.update_active_synergy__called_from_syn_manager()

func remove_composite_synergy_id_to_always_activate(arg_modi_id):
	if _modi_id_to_composite_synergy_ids_to_always_activate_map.has(arg_modi_id):
		_modi_id_to_composite_synergy_ids_to_always_activate_map.erase(arg_modi_id)
		tower_manager.update_active_synergy__called_from_syn_manager()


###########

func _construct_color_circle_fill_drawer_pool__and_relateds():
	_color_circle_fill_drawer_pool = ColorAestheticDrawerPool.new()
	_color_circle_fill_drawer_pool.node_to_parent = CommsForBetweenScenes.current_game_elements__node_hoster_below_screen_effects_mngr
	_color_circle_fill_drawer_pool.source_of_create_resource = self
	_color_circle_fill_drawer_pool.func_name_for_create_resource = "_create_color_fill_circle_drawer__for_pool"
	
	_color_splatter_drawer_pool = ColorAestheticDrawerPool.new()
	_color_splatter_drawer_pool.node_to_parent = CommsForBetweenScenes.current_game_elements__node_hoster_below_screen_effects_mngr
	_color_splatter_drawer_pool.source_of_create_resource = self
	_color_splatter_drawer_pool.func_name_for_create_resource = "_create_color_splatter_drawer__for_pool"
	


func _create_color_fill_circle_drawer__for_pool():
	var fill_circle_drawer = ColorFillCircleDrawer_Scene.instance()
	
	return fill_circle_drawer


func _create_color_splatter_drawer__for_pool():
	var splatter_drawer = ColorSplatterDrawer_Scene.instance()
	
	splatter_drawer.scale = Vector2(2, 2)
	
	return splatter_drawer

#

class ColorCircleFillData:
	var poses_remaining : Array
	var show_ripple_for_pos_rem : Array  # if pos_rem = [x, x], then this should be [false, true] if you want the first one to ripple but not the second
	var color_for_pos_rem : Array  # rem = remaining
	
	var syn_id
	var syn_tier
	#var color_id
	
	var delta_left_before_next_show : float = 0

class ColorSplatterData:
	var poses_remaining : Array
	var color_for_pos_rem : Array  # rem = remaining
	
	var syn_id
	var syn_tier
	
	var delta_left_before_next_show : float = 0


#

func _attempt_start_color_aesthetic_display():
	if last_calculated_allow_start_color_aesthetic_display:
		_attempted_start_color_aesthetic_display = false
		_start_color_aesthetic_display()
		
	else:
		_attempted_start_color_aesthetic_display = true



func _start_color_aesthetic_display():
	for res in active_dom_color_synergies_res:
		var id = res.synergy.synergy_id
		var first_time = _syn_id_to__syn_tier_to_first_time_activated_map[id][res.synergy_tier]
		
		if first_time:
			#_start_play_color_fill_circle_for_syn(res.synergy.colors_required, id, res.synergy_tier)
			_start_play_color_splatter_for_syn(res.synergy.colors_required, id, res.synergy_tier)
			_syn_id_to__syn_tier_to_first_time_activated_map[id][res.synergy_tier] = false
	
	for res in active_compo_color_synergies_res:
		var id = res.synergy.synergy_id
		var first_time = _syn_id_to__syn_tier_to_first_time_activated_map[id][res.synergy_tier]
		
		if first_time:
			#_start_play_color_splatter_for_syn(res.synergy.colors_required, id, res.synergy_tier)
			_start_play_color_fill_circle_for_syn(res.synergy.colors_required, id, res.synergy_tier)
			_syn_id_to__syn_tier_to_first_time_activated_map[id][res.synergy_tier] = false


func _start_play_color_fill_circle_for_syn(arg_color_ids : Array, arg_syn_id, arg_syn_tier : int):
	var active_towers_with_color : Array = game_elements.tower_manager.get_all_active_towers_with_colors(arg_color_ids)
	var data = _convert_towers_to_poses_and_ripple_and_color_arr(active_towers_with_color, arg_color_ids)
	
	var loc_data = ColorCircleFillData.new()
	loc_data.poses_remaining = data[0]
	loc_data.show_ripple_for_pos_rem = data[1]
	loc_data.color_for_pos_rem = data[2]
	loc_data.syn_id = arg_syn_id
	loc_data.syn_tier = arg_syn_tier
	#loc_data.color_id = arg_color_id
	
	_add_color_fill_circle_loc_data_to_arr(loc_data)

func _convert_towers_to_poses_and_ripple_and_color_arr(arg_towers, arg_color_ids):
	var pos_bucket = []
	var ripple_bucket = []
	var color_bucket = []
	for tower in arg_towers:
		pos_bucket.append(tower.global_position)
		ripple_bucket.append(true)
		
		var final_color
		for color_id in tower.get_all_tower_colors(false):
			if arg_color_ids.has(color_id):
				var curr_color = color_id_to_basis_color_map[color_id]
				final_color = _average_colors(final_color, curr_color)
		
		color_bucket.append(final_color)
	
	return [pos_bucket, ripple_bucket, color_bucket]


func _add_color_fill_circle_loc_data_to_arr(arg_loc_data : ColorCircleFillData):
	_color_circle_fill_data_arr.append(arg_loc_data)
	
	#set_process(true)
	enable_process_conditional_clauses.attempt_insert_clause(EnableProcessClauseIds.DRAWING_COLOR_FILL_CIRCLES)

func _remove_color_circle_fill_loc_data_from_arr(arg_loc_data : ColorCircleFillData):
	_color_circle_fill_data_arr.erase(arg_loc_data)
	
	if _color_circle_fill_data_arr.size() == 0:
		#set_process(false)
		enable_process_conditional_clauses.remove_clause(EnableProcessClauseIds.DRAWING_COLOR_FILL_CIRCLES)

func _randomize_color_aesthetic_delta_left(arg_loc_data):
	arg_loc_data.delta_left_before_next_show = non_essential_rng.randf_range(0.1, 0.4)


########

func _process(delta):
	for loc_data in _color_circle_fill_data_arr:
		loc_data.delta_left_before_next_show -= delta
		if loc_data.delta_left_before_next_show <= 0:
			_play_color_fill_for_using_loc_data(loc_data)
			
			if loc_data.poses_remaining.size() > 0:
				_randomize_color_aesthetic_delta_left(loc_data)
			else:
				_remove_color_circle_fill_loc_data_from_arr(loc_data)
	
	for loc_data in _color_splatter_data_arr:
		loc_data.delta_left_before_next_show -= delta
		if loc_data.delta_left_before_next_show <= 0:
			_play_color_splatter_for_using_loc_data(loc_data)
			
			if !loc_data.poses_remaining.empty():
				_randomize_color_aesthetic_delta_left(loc_data)
			else:
				_remove_color_splatter_loc_data_from_arr(loc_data)


func _play_color_fill_for_using_loc_data(arg_loc_data : ColorCircleFillData):
	var pos_to_use = arg_loc_data.poses_remaining.pop_back()
	var color_to_use : Color = arg_loc_data.color_for_pos_rem.pop_back() #color_id_to_basis_color_map[arg_loc_data.color_id]
	var show_ripple = arg_loc_data.show_ripple_for_pos_rem.pop_back()
	
	_create_and_configure_color_fill_circle_drawer(color_to_use, pos_to_use, show_ripple, color_to_use)


func _create_and_configure_color_fill_circle_drawer(
			arg_color : Color, arg_pos : Vector2,
			arg_show_ripple : bool, arg_ripple_color : Color):
	
	var fill_circle_drawer : ColorFillCircleDrawer = _color_circle_fill_drawer_pool.get_or_create_resource_from_pool()
	
	var randomized_colors := _get_randomized_weight_colors(arg_color, arg_ripple_color)
	
	fill_circle_drawer.global_position = arg_pos
	
	fill_circle_drawer.current_color = randomized_colors[0]
	fill_circle_drawer.initial_radius = 10
	
	fill_circle_drawer.current_radius_expand_per_sec = non_essential_rng.randf_range(100, 120)
	fill_circle_drawer.radius_expand_change_per_sec = non_essential_rng.randf_range(-60, -80)
	
	fill_circle_drawer.lifetime_to_start_modulate_a = non_essential_rng.randf_range(0.65, 1.15)
	fill_circle_drawer.modulate_a_per_sec = -0.15
	
	if arg_show_ripple:
		fill_circle_drawer.lifetime_to_show_ripple = 0.35
		fill_circle_drawer.current_ripple_color = randomized_colors[1]
		
		fill_circle_drawer.ripple_initial_radius = 10
		fill_circle_drawer.current_ripple_radius_expand_per_sec = non_essential_rng.randf_range(80, 110)
		fill_circle_drawer.ripple_radius_expand_change_per_sec = -20
		
		fill_circle_drawer.ripple_lifetime_to_start_modulate_a = fill_circle_drawer.lifetime_to_show_ripple + non_essential_rng.randf_range(0, 0.3)
		fill_circle_drawer.ripple_modulate_a_per_sec = -0.15
		
		fill_circle_drawer.ripple_line_width = 3
	
	
	fill_circle_drawer.start_display()

func _get_randomized_weight_colors(arg_color, arg_ripple_color) -> Array:
	var mod_r_mul = non_essential_rng.randf_range(0.9, 1.1)
	var mod_g_mul = non_essential_rng.randf_range(0.9, 1.1)
	var mod_b_mul = non_essential_rng.randf_range(0.9, 1.1)
	var mod_a_flat_val = non_essential_rng.randf_range(0.25, 0.5)
	
	return [Color(arg_color.r * mod_r_mul, arg_color.g * mod_g_mul, arg_color.b * mod_b_mul, mod_a_flat_val), Color(arg_ripple_color.r * mod_r_mul * basis_color_to_ripple_color_multiplier, arg_ripple_color.g * mod_g_mul * basis_color_to_ripple_color_multiplier, arg_ripple_color.b * mod_b_mul * basis_color_to_ripple_color_multiplier, mod_a_flat_val)]

func _get_randomized_weight_color__full_a(arg_color) -> Color:
	var mod_r_mul = non_essential_rng.randf_range(0.9, 1.1)
	var mod_g_mul = non_essential_rng.randf_range(0.9, 1.1)
	var mod_b_mul = non_essential_rng.randf_range(0.9, 1.1)
	#var mod_a_flat_val = non_essential_rng.randf_range(0.25, 0.5)
	
	return Color(arg_color.r * mod_r_mul, arg_color.g * mod_g_mul, arg_color.b * mod_b_mul, 1)


###########

func _start_play_color_splatter_for_syn(arg_color_ids : Array, arg_syn_id, arg_syn_tier : int):
	var active_towers_with_color : Array = game_elements.tower_manager.get_all_active_towers_with_colors(arg_color_ids)
	var data = _convert_towers_to_poses_and_color_arr(active_towers_with_color, arg_color_ids)
	
	var loc_data = ColorSplatterData.new()
	loc_data.poses_remaining = data[0]
	loc_data.color_for_pos_rem = data[1]
	loc_data.syn_id = arg_syn_id
	loc_data.syn_tier = arg_syn_tier
	
	_add_color_splatter_loc_data_to_arr(loc_data)

func _convert_towers_to_poses_and_color_arr(arg_towers : Array, arg_allowed_color_ids : Array):
	var pos_bucket = []
	var color_bucket = []
	for tower in arg_towers:
		pos_bucket.append(tower.global_position)
		
		var final_color
		for color_id in tower.get_all_tower_colors(false):
			if arg_allowed_color_ids.has(color_id):
				var curr_color = color_id_to_basis_color_map[color_id]
				final_color = _average_colors(final_color, curr_color)
		
		color_bucket.append(final_color)
	
	return [pos_bucket, color_bucket]

func _average_colors(arg_color_01, arg_color_02):
	if arg_color_01 != null:
		return Color(_get_average_of_num(arg_color_01.r, arg_color_02.r), _get_average_of_num(arg_color_01.g, arg_color_02.g), _get_average_of_num(arg_color_01.b, arg_color_02.b), 1)
		
	else:
		return arg_color_02
	

func _get_average_of_num(arg_num_01, arg_num_02):
	return (arg_num_01 + arg_num_02) / 2



func _add_color_splatter_loc_data_to_arr(arg_loc_data : ColorSplatterData):
	_color_splatter_data_arr.append(arg_loc_data)
	
	enable_process_conditional_clauses.attempt_insert_clause(EnableProcessClauseIds.DRAWING_COLOR_SPLATTER)

func _remove_color_splatter_loc_data_from_arr(arg_loc_data : ColorSplatterData):
	_color_splatter_data_arr.erase(arg_loc_data)
	
	if _color_splatter_data_arr.size() == 0:
		#set_process(false)
		enable_process_conditional_clauses.remove_clause(EnableProcessClauseIds.DRAWING_COLOR_SPLATTER)



func _play_color_splatter_for_using_loc_data(arg_loc_data : ColorSplatterData):
	var pos_to_use = arg_loc_data.poses_remaining.pop_back()
	var color_to_use : Color = arg_loc_data.color_for_pos_rem.pop_back() #color_id_to_basis_color_map[arg_loc_data.color_id]
	
	_create_and_configure_color_splatter_drawer(color_to_use, pos_to_use)

func _create_and_configure_color_splatter_drawer(arg_color_to_use : Color, arg_pos_to_use : Vector2):
	
	var color_splatter : ColorSplatterDrawer = _color_splatter_drawer_pool.get_or_create_resource_from_pool()
	color_splatter.global_position = arg_pos_to_use
	
	var randomized_color := _get_randomized_weight_color__full_a(arg_color_to_use)
	color_splatter.current_color = randomized_color
	
	color_splatter.initial_mod_a_val_at_start = 0.05
	color_splatter.initial_mod_a_inc_per_sec_at_start = non_essential_rng.randf_range(1.3, 1.6)
	color_splatter.initial_mod_a_inc_lifetime_to_start = 0
	color_splatter.initial_mod_a_inc_lifetime_to_end = 0.5
	
	color_splatter.mod_a_dec_lifetime_to_start = non_essential_rng.randf_range(0.75, 1.25)
	color_splatter.mod_a_dec_per_sec = non_essential_rng.randf_range(0.25, 0.35)
	
	color_splatter.randomize_splatter_texture(non_essential_rng)
	
	color_splatter.visible = true
	color_splatter.start_display()

###########################

func before_game_start__synergies_this_game_initialize():
	_before_game_started_initialize_ran = true
	
	_update_dominant_available_synergies_this_game()
	_update_composite_available_synergies_this_game()


func add_dominant_synergy_id_banned_this_game(arg_syn_id, if_calc_and_update : bool = true):
	if !_dominant_synergy_ids_banned_this_game.has(arg_syn_id):
		_dominant_synergy_ids_banned_this_game.append(arg_syn_id)
		
		if if_calc_and_update:
			_update_dominant_available_synergies_this_game()
			
			if _before_game_started_initialize_ran:
				call_deferred("update_synergies")
				

func add_composite_synergy_id_banned_this_game(arg_syn_id, if_calc_and_update : bool = true):
	if !_composite_synergy_ids_banned_this_game.has(arg_syn_id):
		_composite_synergy_ids_banned_this_game.append(arg_syn_id)
		
		if if_calc_and_update:
			_update_composite_available_synergies_this_game()
			
			if _before_game_started_initialize_ran:
				call_deferred("update_synergies")
				

func _update_dominant_available_synergies_this_game():
	for syn_id in TowerDominantColors.available_synergy_ids:
		if !_dominant_synergy_ids_banned_this_game.has(syn_id):
			var syn = TowerDominantColors.get_synergy_with_id(syn_id)
			
			_dominant_synergy_id_to_syn_available_this_game_map[syn_id] = syn

func _update_composite_available_synergies_this_game():
	for syn_id in TowerCompositionColors.available_synergy_ids:
		if !_composite_synergy_ids_banned_this_game.has(syn_id):
			var syn = TowerCompositionColors.get_synergy_with_id(syn_id)
			
			_composite_synergy_id_to_syn_available_this_game[syn_id] = syn
	

