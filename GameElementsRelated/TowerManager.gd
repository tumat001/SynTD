extends Node

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const MapManager = preload("res://GameElementsRelated/MapManager.gd")
const RightSidePanel = preload("res://GameHUDRelated/RightSidePanel/RightSidePanel.gd")
const TowerStatsPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerStatsPanel/TowerStatsPanel.gd")
const ActiveIngredientsPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/ActiveIngredientsPanel/ActiveIngredientsPanel.gd")
const TowerColorsPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TowerColorsPanel/TowerColorsPanel.gd")
const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const InnerBottomPanel = preload("res://GameElementsRelated/InnerBottomPanel.gd")
const TargetingPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/InfoPanelComponents/TargetingPanel/TargetingPanel.gd")
const TowerInfoPanel = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerInfoPanel.gd")
const AbilityManager = preload("res://GameElementsRelated/AbilityManager.gd")
const InputPromptManager = preload("res://GameElementsRelated/InputPromptManager.gd")
const LevelManager = preload("res://GameElementsRelated/LevelManager.gd")
const RelicManager = preload("res://GameElementsRelated/RelicManager.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const AttemptCountTrigger = preload("res://MiscRelated/AttemptCountTriggerRelated/AttemptCountTrigger.gd")
const InMapAreaPlacable = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.gd")

const RelicStoreOfferOption = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Classes/RelicStoreOfferOption.gd")
const IncreaseIngredientLimit_Normal_Pic = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Assets/Buttons/IncreaseIngredientLimit_Normal.png")
const IncreaseIngredientLimit_Highlighted_Pic = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Assets/Buttons/IncreaseIngredientLimit_Highlighted.png")
const IncreaseTowerLimit_Normal_Pic = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Assets/Buttons/IncreaseTowerLimit_Normal.png")
const IncreaseTowerLimit_Highlighted_Pic = preload("res://GameHUDRelated/WholeScreenRelicGeneralStorePanel/Assets/Buttons/IncreaseTowerLimit_Highlighted.png")

const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const AttackSpritePoolComponent = preload("res://MiscRelated/AttackSpriteRelated/GenerateRelated/AttackSpritePoolComponent.gd")
const AbsorbIngParticle_Scene = preload("res://TowerRelated/CommonTowerParticles/AbsorbRelated/AbsorbIngParticle.tscn")
const CentralAbsorbParticle_Scene = preload("res://TowerRelated/CommonTowerParticles/AbsorbRelated/CentralAbsorbParticle/CentralAbsorbParticle.tscn")
const FirstTimeAbsorbParticle_Scene = preload("res://TowerRelated/CommonTowerParticles/AbsorbRelated/FirstTimeAbsorbParticle/FirstTimeAbsorbParticle.tscn")

const FirstTimeTierBuyAesthPool = preload("res://MiscRelated/PoolRelated/Implementations/FirstTimeTierBuyAesthDrawerPool.gd")
const FirstTimeTierBuyAesth_Scene = preload("res://TowerRelated/CommonTowerParticles/FirstTimeTierBuyRelated/FirstTimeTierBuyAesth.tscn")
const FirstTimeTierBuyAesth = preload("res://TowerRelated/CommonTowerParticles/FirstTimeTierBuyRelated/FirstTimeTierBuyAesth.gd")
const FTTBA_ShowerParticle = preload("res://TowerRelated/CommonTowerParticles/FirstTimeTierBuyRelated/Particles/FTTBA_ShowerParticle.gd")
const FTTBA_ShowerParticle_Scene = preload("res://TowerRelated/CommonTowerParticles/FirstTimeTierBuyRelated/Particles/FTTBA_ShowerParticle.tscn")

#

enum StoreOfTowerLimitIncId {
	NATURAL_LEVEL = 10,
	RELIC = 11,
	SYNERGY = 12,
	TOWER = 13,
}

const level_tower_limit_amount_map : Dictionary = {
	LevelManager.LEVEL_1 : 1,
	LevelManager.LEVEL_2 : 2,
	LevelManager.LEVEL_3 : 3,
	LevelManager.LEVEL_4 : 4,
	LevelManager.LEVEL_5 : 5,
	LevelManager.LEVEL_6 : 6,
	LevelManager.LEVEL_7 : 7,
	LevelManager.LEVEL_8 : 8,
	LevelManager.LEVEL_9 : 9,
	LevelManager.LEVEL_10 : 9,
}

signal ingredient_mode_turned_into(on_or_off) # true if on
signal show_ingredient_acceptability(ingredient_effect, tower_selected)
signal hide_ingredient_acceptability

signal in_tower_selection_mode()
signal tower_selection_mode_ended()

signal tower_to_benefit_from_synergy_buff(tower)
signal tower_to_remove_from_synergy_buff(tower)

signal tower_changed_colors(tower)

signal tower_added(tower)
signal tower_added_in_map(tower)
signal tower_in_queue_free(tower)
signal tower_being_sold(sellback_gold, tower)
signal tower_being_absorbed_as_ingredient(tower)

signal tower_lost_all_health(tower)
signal tower_current_health_changed(tower, new_val)

signal tower_being_dragged(tower)
signal tower_dropped_from_dragged(tower)
signal tower_transfered_to_placable(tower, arg_placable)
signal tower_transfered_in_map_from_bench(tower_self, arg_map_placable, arg_bench_placable)
signal tower_transfered_on_bench_from_in_map(tower_self, arg_bench_placable, arg_map_placable)
signal tower_transfered_to_different_type_of_placable(tower, arg_placable_from, arg_placable_to)

signal tower_absorbed_ingredients_changed(tower)

signal tower_max_limit_changed(new_limit)
signal tower_current_limit_taken_changed(curr_slots_taken)

signal tower_ing_cap_set(cap_id, cap_amount)
signal tower_ing_cap_removed(cap_id)

signal tower_sellback_value_changed(arg_new_val, arg_tower)

signal tower_info_panel_shown(arg_tower_associated)

signal tower_last_calculated_untargetability_changed(arg_val, arg_tower)

#

const base_ing_limit_of_tower : int = 1

const ing_cap_per_relic : int = 1
const tower_limit_per_relic : int = 1

#

var tower_inventory_bench
var map_manager : MapManager
var gold_manager : GoldManager

var is_in_ingredient_mode : bool = false
var tower_being_dragged : AbstractTower

var tower_being_shown_in_info : AbstractTower

var right_side_panel : RightSidePanel
var tower_stats_panel : TowerStatsPanel
var active_ing_panel : ActiveIngredientsPanel
var inner_bottom_panel : InnerBottomPanel
var targeting_panel : TargetingPanel
var tower_info_panel : TowerInfoPanel
var level_manager : LevelManager setget set_level_manager
var left_panel setget set_left_panel
var relic_manager : RelicManager

var synergy_manager
var stage_round_manager setget set_stage_round_manager
var ability_manager : AbilityManager
var input_prompt_manager : InputPromptManager setget set_input_prompt_manager
var game_elements setget set_game_elements
var whole_screen_relic_general_store_panel setget set_whole_screen_relic_general_store_panel

var _color_groups : Array
const TOWER_GROUP_ID : String = "All_Towers"
const TOWER_IN_MAP_GROUP_ID : String = "All_Towers_In_Map"
const HIDDEN_TOWERS_GROUP_ID : String = "Hidden_Towers"

var _is_round_on_going : bool

#

var _tower_limit_id_amount_map : Dictionary = {}
var last_calculated_tower_limit : int
var current_tower_limit_taken : int

var _tower_ing_cap_amount_map : Dictionary = {}

#

enum CanToggleToIngredientModeClauses {
	TUTORIAL_DISABLE = 1000
}
var can_toggle_to_ingredient_mode_clauses : ConditionalClauses
var last_calculated_can_toggle_to_ing_mode : bool


enum CanTowersSwapPositionsClauses {
	TUTORIAL_DISABLE = 1000
}
var can_towers_swap_positions_clauses : ConditionalClauses
var last_calculated_can_towers_swap_position : bool

# restore pos related

var tower_to_original_placable_map : Dictionary = {}


# relic store related

var ing_limit_shop_offer_id : int
var tower_limit_shop_offer_id : int


# NOTIF for player desc

const level_up_to_place_more_towers_content_desc : String = "Level up to place more towers."
const level_up_to_place_more__count_for_trigger : int = 3

var attempt_count_trigger_for_level_up_to_place_more : AttemptCountTrigger

const tower_takes_more_than_1_slot_content_desc : String = "%s takes %s tower slots."

var can_show_player_desc_of_level_required : bool = true


### particle related

const ing_tier_to_amount_of_particles_map : Dictionary = {
	1 : 3,
	2 : 3,
	3 : 3,
	4 : 4,
	5 : 5,
	6 : 6
}
var mini_orb_absorb_ing_particle_pool_component : AttackSpritePoolComponent
var central_absorb_ing_particle_pool_component : AttackSpritePoolComponent
var first_time_absorb_ing_particle_pool_component : AttackSpritePoolComponent

var _first_time_absorb_ing_tier_displayed_status : Dictionary = {
	1 : true,
	2 : true,
	3 : true,
	4 : true,
	5 : true,
	6 : true,
}

#

var _tier_shower_particle_pool_component : AttackSpritePoolComponent

const tier_to_tier_shower_particle_color_map : Dictionary = {
	1 : Color(122/255.0, 122/255.0, 122/255.0, 0.5),
	2 : Color(21/255.0, 151/255.0, 2/255.0, 0.5),
	3 : Color(2/255.0, 58/255.0, 218/255.0, 0.5),
	4 : Color(108/255.0, 2/255.0, 218/255.0, 0.5),
	5 : Color(218/255.0, 2/255.0, 5/255.0, 0.5),
	6 : Color(252/255.0, 190/255.0, 3/255.0, 0.5)
}

const shower_particle_duration : float = 1.3
const tier_to_shower_particle_count_map : Dictionary = {
	1 : 5,
	2 : 6,
	3 : 8,
	4 : 10,
	5 : 12,
	6 : 16,
}



const tier_to_ray_middle_color_map : Dictionary = {
	1 : Color(189/255.0, 189/255.0, 189/255.0),
	2 : Color(21/255.0, 227/255.0, 2/255.0),
	3 : Color(63/255.0, 185/255.0, 253/255.0),
	4 : Color(198/255.0, 144/255.0, 254/255.0),
	5 : Color(254/255.0, 144/255.0, 146/255.0),
	6 : Color(254/255.0, 221/255.0, 124/255.0)
}

const tier_to_ray_top_width_color_map : Dictionary = {
	1 : 15,
	2 : 15,
	3 : 15,
	4 : 17,
	5 : 19,
	6 : 21,
}

const tier_to_ray_bottom_width_color_map : Dictionary = {
	1 : 25,
	2 : 25,
	3 : 25,
	4 : 28,
	5 : 31,
	6 : 34,
}

var _first_time_tower_tier_acquired_status : Dictionary = {
	1 : true,
	2 : true,
	3 : true,
	4 : true,
	5 : true,
	6 : true,
}

var _first_time_tier_aesth_pool : FirstTimeTierBuyAesthPool

#

enum AllowStartTierAestheticDisplay {
	WHOLE_SCREEN_GUI_IS_OPEN = 3,
	
	
}
var allow_start_tier_aesthetic_display_clauses : ConditionalClauses
var last_calculated_allow_start_tier_aesthetic_display : bool

var _attempted_start_tier_aesthetic_display : bool
var _tier_aesthetic_queue_arr : Array = []
var _pos_aesthetic_queue_arr : Array = []

#

var non_essential_rng : RandomNumberGenerator

################ setters

func set_game_elements(arg_elements):
	game_elements = arg_elements
	
	attempt_count_trigger_for_level_up_to_place_more = AttemptCountTrigger.new(game_elements)
	attempt_count_trigger_for_level_up_to_place_more.count_for_trigger = level_up_to_place_more__count_for_trigger
	attempt_count_trigger_for_level_up_to_place_more.connect("on_reached_trigger_count", self, "_attempt_place_tower_but_not_enought_slot_limit_count_reached", [], CONNECT_PERSIST)
	attempt_count_trigger_for_level_up_to_place_more.count_for_trigger = 2
	
	game_elements.connect("before_game_start", self, "_on_before_game_starts", [], CONNECT_ONESHOT)


func set_level_manager(arg_manager : LevelManager):
	level_manager = arg_manager
	
	level_manager.connect("on_current_level_changed", self, "_level_manager_leveled_up", [], CONNECT_PERSIST)
	_level_manager_leveled_up(level_manager.current_level)

func set_left_panel(arg_panel):
	left_panel = arg_panel
	
	left_panel.connect("on_single_syn_tooltip_shown", self, "_glow_placables_of_towers_with_color_of_syn", [], CONNECT_PERSIST)
	left_panel.connect("on_single_syn_tooltip_hidden", self, "_unglow_all_placables", [], CONNECT_PERSIST)

func set_stage_round_manager(arg_manager):
	stage_round_manager = arg_manager
	
	arg_manager.connect("round_started", self, "_on_round_start__for_restore_position", [], CONNECT_PERSIST)
	arg_manager.connect("round_ended", self, "_on_round_end__to_restore_position", [], CONNECT_PERSIST)

func set_whole_screen_relic_general_store_panel(arg_panel):
	whole_screen_relic_general_store_panel = arg_panel


# Called when the node enters the scene tree for the first time.
func _ready():
	can_toggle_to_ingredient_mode_clauses = ConditionalClauses.new()
	can_toggle_to_ingredient_mode_clauses.connect("clause_inserted", self, "_on_can_toggle_to_ing_mode_clause_ins_or_rem", [], CONNECT_PERSIST)
	can_toggle_to_ingredient_mode_clauses.connect("clause_removed", self, "_on_can_toggle_to_ing_mode_clause_ins_or_rem", [], CONNECT_PERSIST)
	_update_last_calc_can_toggle_to_ing_mode()
	
	can_towers_swap_positions_clauses = ConditionalClauses.new()
	can_towers_swap_positions_clauses.connect("clause_inserted", self, "_on_can_towers_swap_positions_clause_ins_or_rem", [], CONNECT_PERSIST)
	can_towers_swap_positions_clauses.connect("clause_removed", self, "_on_can_towers_swap_positions_clause_ins_or_rem", [], CONNECT_PERSIST)
	_update_can_towers_swap_positions_clauses()
	
	allow_start_tier_aesthetic_display_clauses = ConditionalClauses.new()
	allow_start_tier_aesthetic_display_clauses.connect("clause_inserted", self, "_on_allow_start_tier_aesthetic_display_clauses_updated", [], CONNECT_PERSIST)
	allow_start_tier_aesthetic_display_clauses.connect("clause_removed", self, "_on_allow_start_tier_aesthetic_display_clauses_updated", [], CONNECT_PERSIST)
	_update_allow_start_tier_aesth_display()
	
	_initialize_tier_shower_particle_pool()
	_initialize_first_time_tier_aesth_pool()
	
	calculate_tower_limit()
	set_ing_cap_changer(StoreOfIngredientLimitModifierID.LEVEL, base_ing_limit_of_tower)
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	for color in TowerColors.get_all_colors():
		_color_groups.append(str(color))
	
	#
	
	_initialize_absorb_ing_particle_pool_components()

# Generic things that can branch out to other resp.

func _tower_in_queue_free(tower):
	emit_signal("tower_in_queue_free", tower)
	
	_tower_inactivated_from_map(tower)
	for color in _color_groups:
		if tower.is_in_group(color):
			tower.remove_from_group(color)
	
	_update_active_synergy()
	
	if tower == tower_being_dragged:
		emit_signal("tower_dropped_from_dragged", tower)
	
	if tower == tower_being_shown_in_info:
		_show_round_panel()
	
	#
	_on_tower_in_queue_free__for_restore_position(tower)

# Called after potentially updating synergy
func _tower_active_in_map(tower : AbstractTower):
	_register_tower_to_color_grouping_tags(tower)
	if !tower.is_in_group(TOWER_IN_MAP_GROUP_ID):
		tower.add_to_group(TOWER_IN_MAP_GROUP_ID)
	
	emit_signal("tower_to_benefit_from_synergy_buff", tower)
	#emit_tower_to_benefit_from_synergy_buff(tower)
	
	call_deferred("calculate_current_tower_limit_taken")

#func emit_tower_to_benefit_from_synergy_buff(tower):
#	emit_signal("tower_to_benefit_from_synergy_buff", tower)
#
#func emit_tower_to_benefit_from_synergy_buff__called_from_misc(tower):
#	emit_tower_to_benefit_from_synergy_buff(tower)


# Called after potentially updating synergy
func _tower_inactivated_from_map(tower : AbstractTower):
	_remove_tower_from_color_grouping_tags(tower)
	if tower.is_in_group(TOWER_IN_MAP_GROUP_ID):
		tower.remove_from_group(TOWER_IN_MAP_GROUP_ID)
	
	emit_signal("tower_to_remove_from_synergy_buff", tower)
	
	call_deferred("calculate_current_tower_limit_taken")

func _tower_can_contribute_to_synergy_color_count_changed(arg_val, arg_tower):
	_update_active_synergy()
	




# Adding tower as child of this to monitor it
func add_tower(tower_instance : AbstractTower):
	tower_instance.connect("register_ability", self, "_register_ability_from_tower", [], CONNECT_PERSIST)
	tower_instance.tower_manager = self
	tower_instance.tower_inventory_bench = tower_inventory_bench
	tower_instance.input_prompt_manager = input_prompt_manager
	tower_instance.ability_manager = ability_manager
	tower_instance.synergy_manager = synergy_manager
	tower_instance.game_elements = game_elements
	
	tower_instance.is_in_ingredient_mode = is_in_ingredient_mode
	
	add_child(tower_instance)
	
	if input_prompt_manager.is_in_tower_selection_mode():
		tower_instance.enter_selection_mode(input_prompt_manager._current_prompter, input_prompt_manager._current_prompt_tower_checker_predicate_name)
	else:
		tower_instance.exit_selection_mode()
	
	tower_instance.connect("tower_being_dragged", self, "_tower_being_dragged", [], CONNECT_PERSIST)
	tower_instance.connect("tower_dropped_from_dragged", self, "_tower_dropped_from_dragged", [], CONNECT_PERSIST)
	tower_instance.connect("on_attempt_drop_tower_on_placable", self, "_on_attempt_drop_tower_on_placable", [], CONNECT_PERSIST)
	tower_instance.connect("on_tower_transfered_to_placable", self, "_tower_transfered_to_placable", [], CONNECT_PERSIST)
	tower_instance.connect("on_tower_transfered_in_map_from_bench", self, "_on_tower_transfered_in_map_from_bench", [], CONNECT_PERSIST)
	tower_instance.connect("on_tower_transfered_on_bench_from_in_map", self, "_on_tower_transfered_on_bench_from_in_map", [], CONNECT_PERSIST)
	
	tower_instance.connect("tower_toggle_show_info", self, "_tower_toggle_show_info", [], CONNECT_PERSIST)
	tower_instance.connect("tower_in_queue_free", self, "_tower_in_queue_free", [], CONNECT_PERSIST)
	tower_instance.connect("update_active_synergy", self, "_update_active_synergy", [], CONNECT_PERSIST)
	tower_instance.connect("tower_being_sold", self, "_tower_sold", [tower_instance], CONNECT_PERSIST)
	tower_instance.connect("tower_give_gold", self, "_tower_generate_gold", [], CONNECT_PERSIST)
	tower_instance.connect("tower_being_absorbed_as_ingredient", self, "_emit_tower_being_absorbed_as_ingredient", [], CONNECT_PERSIST)
	
	tower_instance.connect("tower_colors_changed", self, "_tower_changed_colors", [tower_instance], CONNECT_PERSIST)
	tower_instance.connect("tower_active_in_map", self, "_tower_active_in_map", [tower_instance], CONNECT_PERSIST)
	tower_instance.connect("tower_not_in_active_map", self, "_tower_inactivated_from_map", [tower_instance], CONNECT_PERSIST)
	
	tower_instance.connect("on_tower_no_health", self, "_emit_tower_lost_all_health", [tower_instance], CONNECT_PERSIST)
	tower_instance.connect("on_current_health_changed", self, "_emit_tower_current_health_changed", [tower_instance], CONNECT_PERSIST)
	
	tower_instance.connect("on_sellback_value_changed", self, "_emit_tower_sellback_value_changed", [tower_instance], CONNECT_PERSIST)
	
	tower_instance.connect("on_is_contributing_to_synergy_color_count_changed", self, "_tower_can_contribute_to_synergy_color_count_changed", [tower_instance], CONNECT_PERSIST)
	tower_instance.connect("on_tower_transfered_in_map_from_bench", self, "_on_tower_placed_in_map_from_bench", [], CONNECT_PERSIST)
	
	tower_instance.connect("ingredients_absorbed_changed", self, "_emit_tower_ingredients_absorbed_changed", [tower_instance], CONNECT_PERSIST)
	
	tower_instance.connect("last_calculated_untargetability_changed", self, "_emit_last_calculated_untargetability_changed", [tower_instance], CONNECT_PERSIST)
	
	connect("ingredient_mode_turned_into", tower_instance, "_set_is_in_ingredient_mode", [], CONNECT_PERSIST)
	connect("show_ingredient_acceptability", tower_instance, "show_acceptability_with_ingredient", [], CONNECT_PERSIST)
	connect("hide_ingredient_acceptability", tower_instance, "hide_acceptability_with_ingredient", [], CONNECT_PERSIST)
	
	connect("in_tower_selection_mode", tower_instance, "enter_selection_mode", [], CONNECT_PERSIST)
	connect("tower_selection_mode_ended" , tower_instance, "exit_selection_mode", [], CONNECT_PERSIST)
	
	connect("tower_ing_cap_set", tower_instance, "_tower_manager_ing_cap_set", [], CONNECT_PERSIST)
	connect("tower_ing_cap_removed", tower_instance, "_tower_manager_ing_cap_removed", [], CONNECT_PERSIST)
	
	tower_instance.connect("tower_selected_in_selection_mode", self, "_tower_selected", [], CONNECT_PERSIST)
	
	if !tower_instance.is_tower_hidden:
		tower_instance.add_to_group(TOWER_GROUP_ID, true)
	else:
		tower_instance.add_to_group(HIDDEN_TOWERS_GROUP_ID, true)
	
	tower_instance._set_round_started(_is_round_on_going)
	
	for lim_id in _tower_ing_cap_amount_map:
		tower_instance.set_ingredient_limit_modifier(lim_id, _tower_ing_cap_amount_map[lim_id])
	
	if !tower_instance.is_tower_hidden:
		tower_instance.transfer_to_placable(tower_instance.hovering_over_placable, false, !can_place_tower_based_on_limit_and_curr_placement(tower_instance))
	
	emit_signal("tower_added", tower_instance)
	
	if tower_instance.is_current_placable_in_map():
		emit_signal("tower_added_in_map", tower_instance)
	
	call_deferred("_on_after_tower_added", tower_instance)

func _on_after_tower_added(tower_instance : AbstractTower):
	if is_instance_valid(tower_instance):
		
		var tower_tier = tower_instance.tower_type_info.tower_tier
		var first_time = _first_time_tower_tier_acquired_status[tower_tier]
		if first_time:
			_first_time_tower_tier_acquired_status[tower_tier] = false
			
			_add_to_tier_aesth_queue__and_attempt_start_display(tower_tier, tower_instance.global_position)


# Color and grouping related

func _tower_changed_colors(tower : AbstractTower):
	_register_tower_to_color_grouping_tags(tower)
	
	if tower.is_current_placable_in_map():
		_tower_active_in_map(tower)
	
	emit_signal("tower_changed_colors", tower)

func _register_tower_to_color_grouping_tags(tower : AbstractTower, force : bool = false):
	#if tower.is_contributing_to_synergy or force:
	if tower.last_calculated_is_contributing_to_synergy or force:
		_remove_tower_from_color_grouping_tags(tower)
		
		for color in tower._tower_colors:
			tower.add_to_group(str(color))


func _remove_tower_from_color_grouping_tags(tower : AbstractTower):
	for group in tower.get_groups():
		if _color_groups.has(group):
			tower.remove_from_group(group)



# Movement drag related

func _tower_being_dragged(tower_dragged : AbstractTower):
	tower_being_dragged = tower_dragged
	
	tower_inventory_bench.make_all_slots_glow()
	
	if can_place_tower_based_on_limit_and_curr_placement(tower_being_dragged):
		map_manager.make_all_placables_glow()
	else:
		map_manager.make_all_placables_with_towers_glow()
	
	inner_bottom_panel.sell_panel.tower = tower_dragged
	inner_bottom_panel.make_sell_panel_visible()
	
	emit_signal("tower_being_dragged", tower_dragged)
	
	if is_in_ingredient_mode:
		emit_signal("show_ingredient_acceptability", tower_being_dragged.ingredient_of_self, tower_being_dragged)


func _tower_dropped_from_dragged(tower_released : AbstractTower):
	tower_being_dragged = null
	tower_inventory_bench.make_all_slots_not_glow()
	map_manager.make_all_placables_not_glow()
	
	#inner_bottom_panel.sell_panel.tower = null
	inner_bottom_panel.make_sell_panel_invisible()
	
	emit_signal("tower_dropped_from_dragged", tower_released)
	
	if is_in_ingredient_mode:
		emit_signal("hide_ingredient_acceptability")

func _tower_transfered_to_placable(arg_tower, arg_placable):
	emit_signal("tower_transfered_to_placable", arg_tower, arg_placable)

func _on_tower_transfered_in_map_from_bench(arg_tower, arg_map_pla, arg_bench_pla):
	emit_signal("tower_transfered_in_map_from_bench", arg_tower, arg_map_pla, arg_bench_pla)
	emit_signal("tower_transfered_to_different_type_of_placable", arg_tower, arg_bench_pla, arg_map_pla)

func _on_tower_transfered_on_bench_from_in_map(arg_tower, arg_bench_pla, arg_map_pla):
	emit_signal("tower_transfered_on_bench_from_in_map", arg_tower, arg_bench_pla, arg_map_pla)
	emit_signal("tower_transfered_to_different_type_of_placable", arg_tower, arg_map_pla, arg_bench_pla)

func can_place_tower_based_on_limit_and_curr_placement(tower : AbstractTower) -> bool:
	return (tower.is_current_placable_in_map() or !is_beyond_limit_after_placing_tower(tower))


# Ingredient drag related

func _toggle_ingredient_combine_mode():
	if last_calculated_can_toggle_to_ing_mode:
		is_in_ingredient_mode = !is_in_ingredient_mode
		
		emit_signal("ingredient_mode_turned_into", is_in_ingredient_mode)
		
		if is_in_ingredient_mode:
			if is_instance_valid(tower_being_dragged):
				emit_signal("show_ingredient_acceptability", tower_being_dragged.ingredient_of_self, tower_being_dragged)
			
			
			inner_bottom_panel.show_only_ingredient_notification_mode()
		else:
			emit_signal("hide_ingredient_acceptability")
			inner_bottom_panel.show_only_buy_sell_panel()


func _emit_tower_being_absorbed_as_ingredient(tower):
	emit_signal("tower_being_absorbed_as_ingredient", tower)


# Ability related

func _register_ability_from_tower(ability, add_to_panel : bool = true):
	ability_manager.add_ability(ability, add_to_panel)


# Health related

func _emit_tower_lost_all_health(tower):
	emit_signal("tower_lost_all_health", tower)

func _emit_tower_current_health_changed(new_val, tower):
	emit_signal("tower_current_health_changed", tower, new_val)


# Other emit related

func _emit_tower_sellback_value_changed(arg_new_val, arg_tower):
	emit_signal("tower_sellback_value_changed", arg_new_val, arg_tower)

# Synergy Related

func update_active_synergy__called_from_syn_manager():
	_update_active_synergy()

func update_active_synergy__called_from_misc():   #right now, it is used in: Pact_XIdentity(s)
	_update_active_synergy()

func _update_active_synergy():
	#synergy_manager.update_synergies(_get_all_synergy_contributing_towers())
	synergy_manager.call_deferred("update_synergies", _get_all_synergy_contributing_towers())

func _get_all_synergy_contributing_towers() -> Array:
	var bucket : Array = []
	for tower in get_children():
		# if something synergy related broke, its probably by !is_queued_by_deletion()
		if is_instance_valid(tower) and tower is AbstractTower and tower.last_calculated_is_contributing_to_synergy and !tower.is_queued_for_deletion():
			bucket.append(tower)
	
	return bucket


# Gold Related

func _tower_sold(sellback_gold : int, tower):
	emit_signal("tower_being_sold", sellback_gold, tower)
	gold_manager.increase_gold_by(sellback_gold, GoldManager.IncreaseGoldSource.TOWER_SELLBACK)
	game_elements.display_gold_particles(tower.global_position, sellback_gold)

func _tower_generate_gold(gold : int, source_type : int):
	gold_manager.increase_gold_by(gold, source_type)


# Tower info show related

func _tower_toggle_show_info(tower : AbstractTower):
	if right_side_panel.panel_showing != right_side_panel.Panels.TOWER_INFO:
		_show_tower_info_panel(tower)
	else:
		_show_round_panel()


func _show_tower_info_panel(tower : AbstractTower):
	right_side_panel.show_tower_info_panel(tower)
	
	tower_being_shown_in_info = tower
	
	if !tower.is_connected("final_range_changed", self, "_update_final_range_in_info"):
		tower.connect("final_range_changed", self, "_update_final_range_in_info")
		tower.connect("final_attack_speed_changed", self, "_update_final_attack_speed_in_info")
		tower.connect("final_base_damage_changed", self, "_update_final_base_damage_in_info")
		tower.connect("ingredients_absorbed_changed", self, "_update_ingredients_absorbed_in_info")
		tower.connect("ingredients_limit_changed", self, "_update_ingredient_limit_in_info")
		tower.connect("targeting_changed", self, "_update_targeting")
		tower.connect("targeting_options_modified", self, "_update_targeting")
		tower.connect("energy_module_attached", self, "_update_energy_module_display")
		tower.connect("energy_module_detached", self ,"_update_energy_module_display")
		tower.connect("heat_module_should_be_displayed_changed", self, "_update_heat_module_should_display_display")
		tower.connect("final_ability_potency_changed", self, "_update_final_ability_potency_in_info")
		tower.connect("final_on_hit_damages_changed", self, "_update_on_hit_dmges_in_info")
	
	emit_signal("tower_info_panel_shown", tower)

func _update_final_range_in_info():
	tower_stats_panel.update_final_range()

func _update_final_attack_speed_in_info():
	tower_stats_panel.update_final_attack_speed()

func _update_final_base_damage_in_info():
	tower_stats_panel.update_final_base_damage()

func _update_final_ability_potency_in_info():
	tower_stats_panel.update_ability_potency()

func _update_on_hit_dmges_in_info():
	tower_stats_panel.update_on_hit_flat_dmges()


func _update_ingredients_absorbed_in_info():
	active_ing_panel.update_display()

func _update_ingredient_limit_in_info(_new_limit):
	active_ing_panel.update_display()


func _update_targeting():
	targeting_panel.update_display()

func _update_energy_module_display():
	tower_info_panel.update_display_of_energy_module()

func _update_heat_module_should_display_display():
	tower_info_panel.update_display_of_heat_module_panel()


func _show_round_panel():
	right_side_panel.show_round_panel()
	
	if is_instance_valid(tower_being_shown_in_info):
		tower_being_shown_in_info.disconnect("final_range_changed", self, "_update_final_range_in_info")
		tower_being_shown_in_info.disconnect("final_attack_speed_changed", self, "_update_final_attack_speed_in_info")
		tower_being_shown_in_info.disconnect("final_base_damage_changed", self, "_update_final_base_damage_in_info")
		tower_being_shown_in_info.disconnect("ingredients_absorbed_changed", self, "_update_ingredients_absorbed_in_info")
		tower_being_shown_in_info.disconnect("ingredients_limit_changed", self, "_update_ingredient_limit_in_info")
		tower_being_shown_in_info.disconnect("targeting_changed", self, "_update_targeting")
		tower_being_shown_in_info.disconnect("targeting_options_modified", self, "_update_targeting")
		tower_being_shown_in_info.disconnect("energy_module_attached", self, "_update_energy_module_display")
		tower_being_shown_in_info.disconnect("energy_module_detached", self ,"_update_energy_module_display")
		tower_being_shown_in_info.disconnect("heat_module_should_be_displayed_changed", self, "_update_heat_module_should_display_display")
		tower_being_shown_in_info.disconnect("final_ability_potency_changed", self, "_update_final_ability_potency_in_info")
		tower_being_shown_in_info.disconnect("final_on_hit_damages_changed", self, "_update_on_hit_dmges_in_info")
		
		tower_being_shown_in_info = null


# Round related

func _round_started(_stageround):
	for tower in get_all_towers_including_hidden():
		tower.is_round_started = true
	
	_is_round_on_going = true
	
	drop_currently_dragged_tower_from_the_map_if_any()

func _round_ended(_stageround):
	#for tower in get_all_towers():
	for tower in get_all_towers_including_hidden():
		tower.is_round_started = false
	
	_is_round_on_going = false


#

func drop_currently_dragged_tower_from_the_map_if_any():
	if is_instance_valid(tower_being_dragged) and tower_being_dragged.is_current_placable_in_map():
		tower_being_dragged._end_drag()

func drop_currently_dragged_tower_if_any():
	if is_instance_valid(tower_being_dragged):
		tower_being_dragged._end_drag()


# Towers related
# all, except for hidden ones
func get_all_towers() -> Array:
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(TOWER_GROUP_ID):
			bucket.append(child)
	
	return bucket

func get_all_towers_including_hidden() -> Array:
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(TOWER_GROUP_ID) or child.is_in_group(HIDDEN_TOWERS_GROUP_ID):
			bucket.append(child)
	
	return bucket

func get_all_ids_of_towers() -> Array:
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(TOWER_GROUP_ID):
			bucket.append(child.tower_id)
	
	return bucket


func get_all_towers_except_in_queue_free() -> Array:
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(TOWER_GROUP_ID) and !child.is_queued_for_deletion():
			bucket.append(child)
	
	return bucket

func get_all_towers_except_summonables_and_unsellables_in_queue_free() -> Array:
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(TOWER_GROUP_ID) and !child.is_queued_for_deletion() and !child.is_a_summoned_tower and child.last_calculated_can_be_sold:
			bucket.append(child)
	
	return bucket


func get_all_ids_of_towers_except_in_queue_free() -> Array:
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(TOWER_GROUP_ID) and !child.is_queued_for_deletion():
			bucket.append(child.tower_id)
	
	return bucket

# "Active" Towers meaning towers in map and contributing to synergy
# if you want all in map towers, then use "get_all_in_map_towers()"
func get_all_active_towers() -> Array:
	var bucket : Array = []
	
	for color in _color_groups:
		for tower in get_all_active_towers_with_color(color):
			if !bucket.has(tower):
				bucket.append(tower)
	
	return bucket

func get_all_active_towers_except_in_queue_free() -> Array:
	var bucket : Array = []
	
	for color in _color_groups:
		for tower in get_all_active_towers_with_color(color):
			if !bucket.has(tower) and !tower.is_queued_for_deletion():
				bucket.append(tower)
	
	return bucket

func get_all_active_towers_except_summonables_and_in_queue_free() -> Array:
	var bucket : Array = []
	
	for color in _color_groups:
		for tower in get_all_active_towers_with_color(color):
			if !bucket.has(tower) and !tower.is_queued_for_deletion() and !tower.is_a_summoned_tower:
				bucket.append(tower)
	
	return bucket

func get_all_active_and_alive_towers_except_in_queue_free() -> Array:
	var bucket : Array = []
	
	for color in _color_groups:
		for tower in get_all_active_towers_with_color(color):
			if !bucket.has(tower) and !tower.is_queued_for_deletion() and !tower.is_dead_for_the_round:
				bucket.append(tower)
	
	return bucket


#

func get_all_active_towers_with_color(color) -> Array:
	if color is int:
		color = str(color)
	
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(color):
			#if child.is_in_group(color) and child.is_current_placable_in_map():
			bucket.append(child)
	
	return bucket

func get_all_active_towers_with_colors(colors : Array) -> Array:
	var converted_colors : Array = []
	
	for color in colors:
		var converted : String
		
		if color is int:
			converted = str(color)
		else:
			converted = color
		
		converted_colors.append(converted)
	
	var bucket : Array = []
	for child in get_children():
		if child.is_current_placable_in_map():
			var to_add : bool = false
			
			for color in converted_colors:
				if child.is_in_group(color):
					to_add = true
					break
			
			if to_add:
				bucket.append(child)
	
	return bucket



func get_all_active_towers_without_color(color) -> Array:
	if color is int:
		color = str(color)
	
	var bucket : Array = []
	for child in get_children():
		if child.is_current_placable_in_map() and !child.is_in_group(color):
			bucket.append(child)
	
	return bucket

func get_all_active_towers_without_colors(colors : Array) -> Array:
	var converted_colors : Array = []
	
	for color in colors:
		var converted : String
		
		if color is int:
			converted = str(color)
		else:
			converted = color
		
		converted_colors.append(converted)
	
	var bucket : Array = []
	for child in get_children():
		if child.is_current_placable_in_map():
			var to_add : bool = true
			
			for color in converted_colors:
				if child.is_in_group(color):
					to_add = false
					break
			
			if to_add:
				bucket.append(child)
	
	return bucket


# All In map towers, not considering if they contribute to the synergy
func get_all_in_map_towers() -> Array:
	var bucket : Array = []
	
	for tower in get_all_towers():
		if !bucket.has(tower) and tower.is_in_group(TOWER_IN_MAP_GROUP_ID):
			bucket.append(tower)
	
	return bucket

func get_all_in_map_towers_except_in_queue_free() -> Array:
	var bucket : Array = []
	
	for tower in get_all_towers_except_in_queue_free():
		if !bucket.has(tower) and tower.is_in_group(TOWER_IN_MAP_GROUP_ID):
			bucket.append(tower)
	
	return bucket

func get_all_in_map_and_alive_towers_except_in_queue_free() -> Array:
	var bucket : Array = []
	
	for tower in get_all_in_map_towers():
		if !bucket.has(tower) and !tower.is_queued_for_deletion() and !tower.is_dead_for_the_round:
			bucket.append(tower)
	
	return bucket


# currently used for damage display (right side panel)
func get_all_in_map_and_hidden_towers_except_in_queue_free() -> Array:
	var bucket : Array = []
	for child in get_children():
		if (child.is_in_group(HIDDEN_TOWERS_GROUP_ID) or child.is_in_group(TOWER_IN_MAP_GROUP_ID)) and !child.is_queued_for_deletion():
			bucket.append(child)
	
	return bucket


## Synergy queries related

func get_all_in_map_towers_to_benefit_from_syn_with_color(color):
	if color is int:
		color = str(color)
	
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(color) and child.is_benefit_from_syn_having_or_as_if_having_color(int(color)):
			bucket.append(child)
	
	return bucket

func get_all_in_map_towers_to_benefit_from_syn_with_color_except_summonables_and_in_queue_free(color):
	if color is int:
		color = str(color)
	
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(color) and child.is_benefit_from_syn_having_or_as_if_having_color(int(color)) and !child.is_queued_for_deletion() and !child.is_a_summoned_tower:
			bucket.append(child)
	
	return bucket

#########

func get_towers_in_range_of_pos(arg_towers : Array, arg_global_center : Vector2, arg_range : float, arg_include_invis : bool = false) -> Array:
	return Targeting.get_targets__based_on_range_from_center_as_circle(arg_towers, Targeting.CLOSE, arg_towers.size(), arg_global_center, arg_range, Targeting.TargetingRangeState.IN_RANGE, arg_include_invis)

func get_random_towers_in_range_of_pos(arg_towers : Array, arg_global_center : Vector2, arg_range : float, arg_include_invis : bool = false, arg_count : int = 1) -> Array:
	var towers = Targeting.get_targets__based_on_range_from_center_as_circle(arg_towers, Targeting.CLOSE, arg_towers.size(), arg_global_center, arg_range, Targeting.TargetingRangeState.IN_RANGE, arg_include_invis)
	return Targeting._find_random_distinct_enemies(towers, arg_count)

#


# Tower prompt/selection related

func get_tower_on_mouse_hover() -> AbstractTower:
	for tower in get_all_towers():
		if tower.is_being_hovered_by_mouse:
			return tower
	
	return null


# Input manager related

func set_input_prompt_manager(arg_manager):
	input_prompt_manager = arg_manager
	
	input_prompt_manager.connect("prompted_for_tower_selection", self, "_prompted_for_tower_selection", [], CONNECT_PERSIST)
	input_prompt_manager.connect("tower_selection_ended", self, "_tower_selection_ended", [], CONNECT_PERSIST)


func _prompted_for_tower_selection(prompter, arg_prompt_tower_checker_predicate_name : String):
	emit_signal("in_tower_selection_mode", prompter, arg_prompt_tower_checker_predicate_name)

func _tower_selection_ended():
	emit_signal("tower_selection_mode_ended")


func _tower_selected(tower):
	input_prompt_manager.tower_selected_from_prompt(tower)


# Glowing of towers on syn info hover

func _glow_placables_of_towers_with_color_of_syn(syn):
	map_manager.make_all_placables_with_tower_colors_glow(syn.colors_required)

func _unglow_all_placables(syn):
	map_manager.make_all_placables_not_glow()


# Tower limit related

func _level_manager_leveled_up(new_level):
	set_tower_limit_id_amount(StoreOfTowerLimitIncId.NATURAL_LEVEL, level_tower_limit_amount_map[new_level])

func set_tower_limit_id_amount(limit_id : int, limit_amount : int):
	_tower_limit_id_amount_map[limit_id] = limit_amount
	calculate_tower_limit()

func erase_tower_limit_id_amount(limit_id : int):
	_tower_limit_id_amount_map.erase(limit_id)
	calculate_tower_limit()

func calculate_tower_limit():
	var final_limit : int = 0
	for lim in _tower_limit_id_amount_map.values():
		final_limit += lim
	
	last_calculated_tower_limit = final_limit
	emit_signal("tower_max_limit_changed", last_calculated_tower_limit)


func is_beyond_limit_after_placing_tower(tower : AbstractTower) -> bool:
	return last_calculated_tower_limit < current_tower_limit_taken + tower.tower_limit_slots_taken


func calculate_current_tower_limit_taken():
	var total : int = 0
	
	for tower in _get_all_synergy_contributing_towers():
		total += tower.tower_limit_slots_taken
	
	current_tower_limit_taken = total
	emit_signal("tower_current_limit_taken_changed", current_tower_limit_taken)


# ing cap

func set_ing_cap_changer(cap_id : int, cap_amount : int):
	_tower_ing_cap_amount_map[cap_id] = cap_amount
	
	emit_signal("tower_ing_cap_set", cap_id, cap_amount)

func remove_ing_cap_changer(cap_id : int):
	_tower_ing_cap_amount_map.erase(cap_id)
	
	emit_signal("tower_ing_cap_removed", cap_id)


#

func attempt_spend_relic_for_ing_cap_increase():
	if relic_manager.current_relic_count >= 1:
		if _tower_ing_cap_amount_map.has(StoreOfIngredientLimitModifierID.RELIC):
			set_ing_cap_changer(StoreOfIngredientLimitModifierID.RELIC, _tower_ing_cap_amount_map[StoreOfIngredientLimitModifierID.RELIC] + ing_cap_per_relic)
		else:
			set_ing_cap_changer(StoreOfIngredientLimitModifierID.RELIC, ing_cap_per_relic)
		
		relic_manager.decrease_relic_count_by(1, RelicManager.DecreaseRelicSource.ING_CAP_INCREASE)
		return true
	
	return false

func attempt_spend_relic_for_tower_lim_increase():
	if relic_manager.current_relic_count >= 1:
		if _tower_limit_id_amount_map.has(StoreOfTowerLimitIncId.RELIC):
			set_tower_limit_id_amount(StoreOfTowerLimitIncId.RELIC, _tower_limit_id_amount_map[StoreOfTowerLimitIncId.RELIC] + tower_limit_per_relic)
		else:
			set_tower_limit_id_amount(StoreOfTowerLimitIncId.RELIC, tower_limit_per_relic)
		
		relic_manager.decrease_relic_count_by(1, RelicManager.DecreaseRelicSource.TOWER_CAP_INCREASE)
		return true
	
	return false

#

func if_towers_can_swap_based_on_tower_slot_limit_and_map_placement(arg_tower_to_place, arg_tower_to_swap_with):
	if !last_calculated_can_towers_swap_position:
		return false
	
	if arg_tower_to_place.is_current_placable_in_map() and arg_tower_to_swap_with.is_current_placable_in_map():
		return true
	elif !arg_tower_to_place.is_current_placable_in_map() and !arg_tower_to_swap_with.is_current_placable_in_map():
		return true
		
	else:
		var tower_in_bench 
		var tower_in_map
		
		if arg_tower_to_place.is_current_placable_in_map():
			tower_in_map = arg_tower_to_place
			tower_in_bench = arg_tower_to_swap_with
		else:
			tower_in_map = arg_tower_to_swap_with
			tower_in_bench = arg_tower_to_place
		
		var excess_available_tower_slots = last_calculated_tower_limit - current_tower_limit_taken
		var tower_slots_of_tower_in_bench = tower_in_bench.tower_limit_slots_taken
		var tower_slots_of_tower_in_map = tower_in_map.tower_limit_slots_taken
		
		return (tower_slots_of_tower_in_bench - tower_slots_of_tower_in_map) <= excess_available_tower_slots and tower_in_map.last_calculated_can_be_placed_in_bench



func _on_attempt_drop_tower_on_placable(arg_tower, arg_placable, arg_move_success):
	if can_show_player_desc_of_level_required:
		if !game_elements.stage_round_manager.round_started and !is_in_ingredient_mode:
			if !arg_move_success and is_instance_valid(arg_placable) and arg_placable is InMapAreaPlacable and arg_tower.last_calculated_can_be_placed_in_map and arg_placable.last_calculated_can_be_occupied__ignoring_has_tower_clause:
				if arg_tower.tower_limit_slots_taken == 1:
					attempt_count_trigger_for_level_up_to_place_more.add_attempt_to_trigger()
				elif arg_tower.tower_limit_slots_taken > 1:
					_attempt_place_tower_with_more_than_1_slot_limit_take(arg_tower, arg_tower.tower_limit_slots_taken)


func _attempt_place_tower_but_not_enought_slot_limit_count_reached():
	game_elements.generic_notif_panel.push_notification(level_up_to_place_more_towers_content_desc)

func _attempt_place_tower_with_more_than_1_slot_limit_take(arg_tower, arg_tower_slot_count):
	var final_desc = tower_takes_more_than_1_slot_content_desc % [arg_tower.tower_type_info.tower_name, str(arg_tower_slot_count)]
	game_elements.generic_notif_panel.push_notification(final_desc)


#### clauses

func _on_can_toggle_to_ing_mode_clause_ins_or_rem(arg_clause):
	_update_last_calc_can_toggle_to_ing_mode()

func _update_last_calc_can_toggle_to_ing_mode():
	last_calculated_can_toggle_to_ing_mode = can_toggle_to_ingredient_mode_clauses.is_passed


func _on_can_towers_swap_positions_clause_ins_or_rem(arg_clause):
	_update_can_towers_swap_positions_clauses()

func _update_can_towers_swap_positions_clauses():
	last_calculated_can_towers_swap_position = can_towers_swap_positions_clauses.is_passed


func _on_allow_start_tier_aesthetic_display_clauses_updated(arg_clause):
	_update_allow_start_tier_aesth_display()

func _update_allow_start_tier_aesth_display():
	last_calculated_allow_start_tier_aesthetic_display = allow_start_tier_aesthetic_display_clauses.is_passed
	if _attempted_start_tier_aesthetic_display:
		call_deferred("_attempt_start_tier_aesthetic_display")



################### RESTORE POSITION RELATED

func _on_round_start__for_restore_position(arg_curr_stageround):
	for tower in get_all_in_map_towers_except_in_queue_free():
		_record_tower_for_restore_position(tower, tower.current_placable)

func _on_round_end__to_restore_position(arg_curr_stageround):
	_restore_tower_positions()
	
	tower_to_original_placable_map.clear()
	#call_deferred("_clear_tower_to_original_placable_map__deferred")

#func _clear_tower_to_original_placable_map__deferred():
#	tower_to_original_placable_map.clear()

func _on_tower_placed_in_map_from_bench(arg_tower, arg_in_map_placable, arg_bench_placable):
	if stage_round_manager.round_started:
		_record_tower_for_restore_position(arg_tower, arg_in_map_placable)

func _on_tower_in_queue_free__for_restore_position(arg_tower):
	if stage_round_manager.round_started:
		_unrecord_tower_for_restore_position(arg_tower)


func _emit_tower_ingredients_absorbed_changed(arg_tower):
	emit_signal("tower_absorbed_ingredients_changed", arg_tower)

func _emit_last_calculated_untargetability_changed(arg_val, arg_tower):
	emit_signal("tower_last_calculated_untargetability_changed", arg_val, arg_tower)


#

func _record_tower_for_restore_position(arg_tower, arg_placable_to_mark_as_origin):
	tower_to_original_placable_map[arg_tower] = arg_placable_to_mark_as_origin

func _unrecord_tower_for_restore_position(arg_tower):
	tower_to_original_placable_map.erase(arg_tower)

#

func _restore_tower_positions():
	var towers_with_changed_placables : Array = []
	for tower in get_all_in_map_towers_except_in_queue_free():
		if is_instance_valid(tower.current_placable) and tower_to_original_placable_map.has(tower) and is_instance_valid(tower_to_original_placable_map[tower]):
			if !is_tower_original_placable_same_as_current(tower):
				towers_with_changed_placables.append(tower)
				tower.remove_self_from_current_placable__for_restore_to_position()
	
	for tower in towers_with_changed_placables:
		var orig_placable = tower_to_original_placable_map[tower]
		var curr_tower_in_orig_placable = orig_placable.tower_occupying
		
		if !is_instance_valid(curr_tower_in_orig_placable) or towers_with_changed_placables.has(curr_tower_in_orig_placable):
			tower.transfer_to_placable(orig_placable)

func is_tower_original_placable_same_as_current(tower):
	return tower.current_placable == tower_to_original_placable_map[tower]


############ 

func _on_before_game_starts():
	_create_relic_store_offer_options()
	

func _create_relic_store_offer_options():
	var plain_fragment__ingredients = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredients")
	var plain_fragment__absorb = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABSORB, "absorb")
	
	var ing_limit_desc = [
		["Increase the number of |0| a tower can |1| by %s" % (str(ing_cap_per_relic) + "."), [plain_fragment__ingredients, plain_fragment__absorb]]
	]
	
	var ing_limit_shop_offer := RelicStoreOfferOption.new(self, "_on_ing_limit_shop_offer_selected", IncreaseIngredientLimit_Normal_Pic, IncreaseIngredientLimit_Highlighted_Pic)
	ing_limit_shop_offer.descriptions = ing_limit_desc
	ing_limit_shop_offer.header_left_text = "Absorb Limit Increase"
	
	whole_screen_relic_general_store_panel.add_relic_store_offer_option(ing_limit_shop_offer)
	
	######
	
	var plain_fragment__tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "towers")
	
	var tower_limit_desc = [
		["Increase the number of |0| you can place in the map by %s" % (str(tower_limit_per_relic) + "."), [plain_fragment__tower]]
	]
	
	var tower_limit_shop_offer := RelicStoreOfferOption.new(self, "_on_tower_limit_shop_offer_selected", IncreaseTowerLimit_Normal_Pic, IncreaseTowerLimit_Highlighted_Pic)
	tower_limit_shop_offer.descriptions = tower_limit_desc
	tower_limit_shop_offer.header_left_text = "Tower Limit Increase"
	
	whole_screen_relic_general_store_panel.add_relic_store_offer_option(tower_limit_shop_offer)
	

func _on_ing_limit_shop_offer_selected():
	return attempt_spend_relic_for_ing_cap_increase()
	


func _on_tower_limit_shop_offer_selected():
	return attempt_spend_relic_for_tower_lim_increase()
	

######## PARTICLE RELATED

func display_absorbed_ingredient_effects(arg_tier_of_ing : int, arg_pos : Vector2): 
	if mini_orb_absorb_ing_particle_pool_component == null:
		_initialize_absorb_ing_particle_pool_components()
	
	var max_i = 3 #default
	
	if ing_tier_to_amount_of_particles_map.has(arg_tier_of_ing):
		max_i = ing_tier_to_amount_of_particles_map[arg_tier_of_ing]
	else:
		max_i = 3
		arg_tier_of_ing = 1
	
	for i in max_i:
		var particle = mini_orb_absorb_ing_particle_pool_component.get_or_create_attack_sprite_from_pool()
		particle.center_pos_of_basis = arg_pos
		particle.tier = arg_tier_of_ing
		particle.particle_i_val = i
		particle.particle_max_i_val = max_i
		particle.lifetime = 0.6
		
		particle.visible = true
		particle.reset_for_another_use__absorb_ing_specific()
		particle.reset_for_another_use()
	
	##
	
	var central_particle = central_absorb_ing_particle_pool_component.get_or_create_attack_sprite_from_pool()
	central_particle.lifetime = 0.6  #if changing this, change val at _create_central_abosrb_ing_particle
	central_particle.tier = arg_tier_of_ing
	central_particle.frame = 0
	
	central_particle.visible = true
	central_particle.global_position = arg_pos
	
	##
	
	if _first_time_absorb_ing_tier_displayed_status[arg_tier_of_ing]:
		_first_time_absorb_ing_tier_displayed_status[arg_tier_of_ing] = false
		
		_display_first_time_absorb_ing_particle_effects(arg_tier_of_ing, arg_pos)


func _initialize_absorb_ing_particle_pool_components():
	mini_orb_absorb_ing_particle_pool_component = AttackSpritePoolComponent.new()
	mini_orb_absorb_ing_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	mini_orb_absorb_ing_particle_pool_component.node_to_listen_for_queue_free = self
	mini_orb_absorb_ing_particle_pool_component.source_for_funcs_for_attk_sprite = self
	mini_orb_absorb_ing_particle_pool_component.func_name_for_creating_attack_sprite = "_create_mini_orb_abosrb_ing_particle"
	mini_orb_absorb_ing_particle_pool_component.func_name_for_setting_attks_sprite_properties_when_get_from_pool_after_add_child = "_set_absorb_ing_particle_properties_when_get_from_pool_after_add_child"
	
	central_absorb_ing_particle_pool_component = AttackSpritePoolComponent.new()
	central_absorb_ing_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	central_absorb_ing_particle_pool_component.node_to_listen_for_queue_free = self
	central_absorb_ing_particle_pool_component.source_for_funcs_for_attk_sprite = self
	central_absorb_ing_particle_pool_component.func_name_for_creating_attack_sprite = "_create_central_abosrb_ing_particle"
	
	first_time_absorb_ing_particle_pool_component = AttackSpritePoolComponent.new()
	first_time_absorb_ing_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	first_time_absorb_ing_particle_pool_component.node_to_listen_for_queue_free = self
	first_time_absorb_ing_particle_pool_component.source_for_funcs_for_attk_sprite = self
	first_time_absorb_ing_particle_pool_component.func_name_for_creating_attack_sprite = "_create_first_time_ing_particle"
	

func _create_mini_orb_abosrb_ing_particle():
	var particle = AbsorbIngParticle_Scene.instance()
	particle.speed_accel_towards_center = 450
	particle.initial_speed_towards_center = -100
	
	particle.min_starting_distance_from_center = 35
	particle.max_starting_distance_from_center = 35
	
	particle.queue_free_at_end_of_lifetime = false
	
	return particle

func _set_absorb_ing_particle_properties_when_get_from_pool_after_add_child(arg_particle):
	pass


func _create_central_abosrb_ing_particle():
	var particle = CentralAbsorbParticle_Scene.instance()
	
	particle.lifetime = 0.6
	particle.rotation_degrees = 45
	particle.set_anim_speed_based_on_lifetime()
	particle.scale = Vector2(2.5, 2.5)
	
	return particle


func _create_first_time_ing_particle():
	var particle = FirstTimeAbsorbParticle_Scene.instance()
	
	particle.speed_accel_towards_center = 450
	particle.initial_speed_towards_center = -170
	
	particle.max_speed_towards_center = -5
	
	particle.min_starting_distance_from_center = 35
	particle.max_starting_distance_from_center = 35
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.lifetime_to_start_transparency = 1
	particle.transparency_per_sec = 1 / 0.25
	
	return particle

func _display_first_time_absorb_ing_particle_effects(arg_tier, arg_pos):
	var particle_count : int
	var show_beams : bool
	
	if arg_tier == 1:
		particle_count = 3
		show_beams = false
		
	elif arg_tier == 2:
		particle_count = 3
		show_beams = false
		
	elif arg_tier == 3:
		particle_count = 3
		show_beams = true
		
	elif arg_tier == 4:
		particle_count = 4
		show_beams = true
		
	elif arg_tier == 5:
		particle_count = 5
		show_beams = true
		
	elif arg_tier == 6:
		particle_count = 6
		show_beams = true
	
	
	var particle_angle_arr : Array = _get_particle_angle_arr_with_particle_count(particle_count)
	var previous_particle
	var first_particle
	
	for i in particle_count:
		var particle = first_time_absorb_ing_particle_pool_component.get_or_create_attack_sprite_from_pool()
		
		particle.set_tier__to_set_particle_color(arg_tier)
		
		particle.min_starting_angle = particle_angle_arr[i]
		particle.max_starting_angle = particle_angle_arr[i]
		
		particle.center_pos_of_basis = arg_pos
		
		
		particle.reset_for_another_use()
		particle.is_enabled_mov_toward_center = true
		
		
		particle.lifetime = 1.75 #1.25
		particle.visible = true
		particle.modulate.a = 1
		
		if show_beams:
			if previous_particle != null:
				particle.set_beam_target(previous_particle)
				particle.start_beam_display()
			
		else:
			particle.set_beam_target(null)
		
		previous_particle = particle
		
		if first_particle == null:
			first_particle = particle
	
	#
	if show_beams:
		if first_particle != null and previous_particle != null:
			first_particle.set_beam_target(previous_particle)
			first_particle.start_beam_display()

func _get_particle_angle_arr_with_particle_count(arg_count):
	var bucket = []
	for i in arg_count:
		bucket.append(360 * (i / float(arg_count)) - 90)
	
	return bucket


########

func _initialize_tier_shower_particle_pool():
	_tier_shower_particle_pool_component = AttackSpritePoolComponent.new()
	_tier_shower_particle_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	_tier_shower_particle_pool_component.node_to_listen_for_queue_free = self
	_tier_shower_particle_pool_component.source_for_funcs_for_attk_sprite = self
	_tier_shower_particle_pool_component.func_name_for_creating_attack_sprite = "_create_tier_shower_particle"

func _create_tier_shower_particle():
	var particle = FTTBA_ShowerParticle_Scene.instance()
	
	#particle.max_speed_towards_center = 0
	
	#particle.initial_speed_towards_center = -200 #rng_to_use.randf_range(-190, -220)
	#particle.speed_accel_towards_center = 150
	
	particle.queue_free_at_end_of_lifetime = false
	
	particle.lifetime_to_start_transparency = 0.5
	particle.transparency_per_sec = 2
	
	particle.stop_process_at_invisible = true
	
	particle.min_starting_distance_from_center = 15
	particle.max_starting_distance_from_center = 15
	
	
	return particle


func _initialize_first_time_tier_aesth_pool():
	_first_time_tier_aesth_pool = FirstTimeTierBuyAesthPool.new()
	_first_time_tier_aesth_pool.node_to_parent = CommsForBetweenScenes.current_game_elements__node_hoster_below_screen_effects_mngr
	_first_time_tier_aesth_pool.source_of_create_resource = self
	_first_time_tier_aesth_pool.func_name_for_create_resource = "_create_first_time_aesth__for_pool"

func _create_first_time_aesth__for_pool():
	var aesth = FirstTimeTierBuyAesth_Scene.instance()
	
	aesth.rng_to_use = non_essential_rng
	aesth.shower_particle_compo_pool = _tier_shower_particle_pool_component
	
	return aesth

#

func _add_to_tier_aesth_queue__and_attempt_start_display(arg_tier, arg_pos):
	if arg_tier >= 3:
		_tier_aesthetic_queue_arr.append(arg_tier)
		_pos_aesthetic_queue_arr.append(arg_pos)
		
		_attempt_start_tier_aesthetic_display()

func _attempt_start_tier_aesthetic_display():
	if last_calculated_allow_start_tier_aesthetic_display:
		_attempted_start_tier_aesthetic_display = false
		_start_tier_aesthetic_display()
		
	else:
		_attempted_start_tier_aesthetic_display = true

func _start_tier_aesthetic_display():
	for i in _tier_aesthetic_queue_arr.size():
		var tier = _tier_aesthetic_queue_arr[i]
		var pos = _pos_aesthetic_queue_arr[i]
		
		_display_tier_aesthetic_with_tier_at_pos(tier, pos)
	
	_tier_aesthetic_queue_arr.clear()
	_pos_aesthetic_queue_arr.clear()

func _display_tier_aesthetic_with_tier_at_pos(arg_tier, arg_pos):
	var aesth : FirstTimeTierBuyAesth = _first_time_tier_aesth_pool.get_or_create_resource_from_pool()
	
	aesth.main_single_ray.ray_main_color = tier_to_ray_middle_color_map[arg_tier]
	#aesth.main_single_ray.ray_edge_color = tier_to_ray_edge_color_map[arg_tier]
	aesth.main_single_ray.ray_upper_ray_total_width = tier_to_ray_top_width_color_map[arg_tier]
	aesth.main_single_ray.ray_lower_ray_total_width = tier_to_ray_bottom_width_color_map[arg_tier]
	
	aesth.global_position = arg_pos + Vector2(0, 7)
	aesth.main_single_ray.ray_length = 120
	
	aesth.main_single_ray.initial_mod_a_val_at_start = 0.05
	aesth.main_single_ray.initial_mod_a_inc_per_sec_at_start = non_essential_rng.randf_range(1.3, 1.6)
	aesth.main_single_ray.initial_mod_a_inc_lifetime_to_start = 0
	aesth.main_single_ray.initial_mod_a_inc_lifetime_to_end = 0.5
	
	aesth.main_single_ray.mod_a_dec_lifetime_to_start = non_essential_rng.randf_range(0.75, 1.25)
	aesth.main_single_ray.mod_a_dec_per_sec = non_essential_rng.randf_range(0.25, 0.35)
	
	aesth.main_single_ray.update_ray_properties_based_on_properies()
	
	aesth.shower_particle_count = tier_to_shower_particle_count_map[arg_tier]
	aesth.shower_particle_delta = shower_particle_duration / aesth.shower_particle_count
	aesth.shower_particle_color = tier_to_tier_shower_particle_color_map[arg_tier]
	aesth.visible = true
	aesth.start_display()
	
#	if arg_tier == 1:
#		aesth.main_single_ray.ray_main_color = Color
#
#	elif arg_tier == 2:
#		pass





