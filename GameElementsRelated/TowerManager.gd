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

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const AttemptCountTrigger = preload("res://MiscRelated/AttemptCountTriggerRelated/AttemptCountTrigger.gd")
const InMapAreaPlacable = preload("res://GameElementsRelated/InMapPlacablesRelated/InMapAreaPlacable.gd")

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

signal ingredient_mode_turned_into(on_or_off)
signal show_ingredient_acceptability(ingredient_effect, tower_selected)
signal hide_ingredient_acceptability

signal in_tower_selection_mode()
signal tower_selection_mode_ended()

signal tower_to_benefit_from_synergy_buff(tower)
signal tower_to_remove_from_synergy_buff(tower)

signal tower_changed_colors(tower)

signal tower_added(tower)
signal tower_in_queue_free(tower)
signal tower_being_sold(sellback_gold, tower)
signal tower_being_absorbed_as_ingredient(tower)

signal tower_lost_all_health(tower)
signal tower_current_health_changed(tower, new_val)

signal tower_being_dragged(tower)
signal tower_dropped_from_dragged(tower)

signal tower_max_limit_changed(new_limit)
signal tower_current_limit_taken_changed(curr_slots_taken)

signal tower_ing_cap_set(cap_id, cap_amount)
signal tower_ing_cap_removed(cap_id)

signal tower_sellback_value_changed(arg_new_val, arg_tower)


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
var stage_round_manager
var ability_manager : AbilityManager
var input_prompt_manager : InputPromptManager setget set_input_prompt_manager
var game_elements

var _color_groups : Array
const TOWER_GROUP_ID : String = "All_Towers"

var _is_round_on_going : bool


#

var _tower_limit_id_amount_map : Dictionary = {}
var last_calculated_tower_limit : int
var current_tower_limit_taken : int

var _tower_ing_cap_amount_map : Dictionary = {}


# NOTIF for player desc

const level_up_to_place_more_towers_content_desc : String = "Level up to place more towers."
const level_up_to_place_more__count_for_trigger : int = 3

var attempt_count_trigger_for_level_up_to_place_more : AttemptCountTrigger

const tower_takes_more_than_1_slot_content_desc : String = "%s takes %s tower slots."


# setters

func set_level_manager(arg_manager : LevelManager):
	level_manager = arg_manager
	
	level_manager.connect("on_current_level_changed", self, "_level_manager_leveled_up", [], CONNECT_PERSIST)
	_level_manager_leveled_up(level_manager.current_level)

func set_left_panel(arg_panel):
	left_panel = arg_panel
	
	left_panel.connect("on_single_syn_tooltip_shown", self, "_glow_placables_of_towers_with_color_of_syn", [], CONNECT_PERSIST)
	left_panel.connect("on_single_syn_tooltip_hidden", self, "_unglow_all_placables", [], CONNECT_PERSIST)


# Called when the node enters the scene tree for the first time.
func _ready():
	calculate_tower_limit()
	set_ing_cap_changer(StoreOfIngredientLimitModifierID.LEVEL, base_ing_limit_of_tower)
	
	
	for color in TowerColors.get_all_colors():
		_color_groups.append(str(color))
	
	
	attempt_count_trigger_for_level_up_to_place_more = AttemptCountTrigger.new(self)
	attempt_count_trigger_for_level_up_to_place_more.count_for_trigger = level_up_to_place_more__count_for_trigger
	attempt_count_trigger_for_level_up_to_place_more.connect("on_reached_trigger_count", self, "_attempt_place_tower_but_not_enought_slot_limit_count_reached", [], CONNECT_PERSIST)
	attempt_count_trigger_for_level_up_to_place_more.count_for_trigger = 2


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

# Called after potentially updating synergy
func _tower_active_in_map(tower : AbstractTower):
	_register_tower_to_color_grouping_tags(tower)
	emit_signal("tower_to_benefit_from_synergy_buff", tower)
	
	call_deferred("calculate_current_tower_limit_taken")

# Called after potentially updating synergy
func _tower_inactivated_from_map(tower : AbstractTower):
	_remove_tower_from_color_grouping_tags(tower)
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
	
	connect("ingredient_mode_turned_into", tower_instance, "_set_is_in_ingredient_mode", [], CONNECT_PERSIST)
	connect("show_ingredient_acceptability", tower_instance, "show_acceptability_with_ingredient", [], CONNECT_PERSIST)
	connect("hide_ingredient_acceptability", tower_instance, "hide_acceptability_with_ingredient", [], CONNECT_PERSIST)
	
	connect("in_tower_selection_mode", tower_instance, "enter_selection_mode", [], CONNECT_PERSIST)
	connect("tower_selection_mode_ended" , tower_instance, "exit_selection_mode", [], CONNECT_PERSIST)
	
	connect("tower_ing_cap_set", tower_instance, "_tower_manager_ing_cap_set", [], CONNECT_PERSIST)
	connect("tower_ing_cap_removed", tower_instance, "_tower_manager_ing_cap_removed", [], CONNECT_PERSIST)
	
	tower_instance.connect("tower_selected_in_selection_mode", self, "_tower_selected", [], CONNECT_PERSIST)
	
	tower_instance.add_to_group(TOWER_GROUP_ID, true)
	
	tower_instance._set_round_started(_is_round_on_going)
	
	for lim_id in _tower_ing_cap_amount_map:
		tower_instance.set_ingredient_limit_modifier(lim_id, _tower_ing_cap_amount_map[lim_id])
	
	emit_signal("tower_added", tower_instance)

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


func can_place_tower_based_on_limit_and_curr_placement(tower : AbstractTower) -> bool:
	return tower.is_current_placable_in_map() or !is_beyond_limit_after_placing_tower(tower)


# Ingredient drag related

func _toggle_ingredient_combine_mode():
	is_in_ingredient_mode = !is_in_ingredient_mode
	
	emit_signal("ingredient_mode_turned_into", is_in_ingredient_mode)
	
	if is_in_ingredient_mode:
		if tower_being_dragged != null:
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

func _update_active_synergy():
	#synergy_manager.update_synergies(_get_all_synergy_contributing_towers())
	synergy_manager.call_deferred("update_synergies", _get_all_synergy_contributing_towers())

func _get_all_synergy_contributing_towers() -> Array:
	var bucket : Array = []
	for tower in get_children():
		if tower is AbstractTower and tower.last_calculated_is_contributing_to_synergy:
			bucket.append(tower)
	
	return bucket


# Gold Related

func _tower_sold(sellback_gold : int, tower):
	emit_signal("tower_being_sold", sellback_gold, tower)
	gold_manager.increase_gold_by(sellback_gold, GoldManager.IncreaseGoldSource.TOWER_SELLBACK)


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

func _update_final_range_in_info():
	tower_stats_panel.update_final_range()

func _update_final_attack_speed_in_info():
	tower_stats_panel.update_final_attack_speed()

func _update_final_base_damage_in_info():
	tower_stats_panel.update_final_base_damage()

func _update_final_ability_potency_in_info():
	tower_stats_panel.update_ability_potency()


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
	
	if tower_being_shown_in_info != null:
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
		
		tower_being_shown_in_info = null


# Round related

func _round_started(_stageround):
	for tower in get_all_towers():
		tower.is_round_started = true
	
	_is_round_on_going = true
	
	if tower_being_dragged != null and tower_being_dragged.is_current_placable_in_map():
		tower_being_dragged._end_drag()


func _round_ended(_stageround):
	for tower in get_all_towers():
		tower.is_round_started = false
	
	_is_round_on_going = false


# Towers related
func get_all_towers() -> Array:
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(TOWER_GROUP_ID):
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

func get_all_ids_of_towers_except_in_queue_free() -> Array:
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(TOWER_GROUP_ID) and !child.is_queued_for_deletion():
			bucket.append(child.tower_id)
	
	return bucket


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


func attempt_spend_relic_for_tower_lim_increase():
	if relic_manager.current_relic_count >= 1:
		if _tower_limit_id_amount_map.has(StoreOfTowerLimitIncId.RELIC):
			set_tower_limit_id_amount(StoreOfTowerLimitIncId.RELIC, _tower_limit_id_amount_map[StoreOfTowerLimitIncId.RELIC] + tower_limit_per_relic)
		else:
			set_tower_limit_id_amount(StoreOfTowerLimitIncId.RELIC, tower_limit_per_relic)
		
		relic_manager.decrease_relic_count_by(1, RelicManager.DecreaseRelicSource.TOWER_CAP_INCREASE)


#

func if_towers_can_swap_based_on_tower_slot_limit_and_map_placement(arg_tower_to_place, arg_tower_to_swap_with):
	if arg_tower_to_place.is_current_placable_in_map() and arg_tower_to_swap_with.is_current_placable_in_map():
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
		
		return (tower_slots_of_tower_in_bench - tower_slots_of_tower_in_map) <= excess_available_tower_slots



func _on_attempt_drop_tower_on_placable(arg_tower, arg_placable, arg_move_success):
	if !game_elements.stage_round_manager.round_started:
		if !arg_move_success and arg_placable != null and arg_placable is InMapAreaPlacable:
			if arg_tower.tower_limit_slots_taken == 1:
				attempt_count_trigger_for_level_up_to_place_more.add_attempt_to_trigger()
			elif arg_tower.tower_limit_slots_taken > 1:
				_attempt_place_tower_with_more_than_1_slot_limit_take(arg_tower, arg_tower.tower_limit_slots_taken)


func _attempt_place_tower_but_not_enought_slot_limit_count_reached():
	game_elements.generic_notif_panel.push_notification(level_up_to_place_more_towers_content_desc)

func _attempt_place_tower_with_more_than_1_slot_limit_take(arg_tower, arg_tower_slot_count):
	var final_desc = tower_takes_more_than_1_slot_content_desc % [arg_tower.tower_type_info.tower_name, str(arg_tower_slot_count)]
	game_elements.generic_notif_panel.push_notification(final_desc)

