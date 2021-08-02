extends Node

const AbstractTower = preload("res://TowerRelated/AbstractTower.gd")
const InMapPlacablesManager = preload("res://GameElementsRelated/InMapPlacablesManager.gd")
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

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

signal ingredient_mode_turned_into(on_or_off)
signal show_ingredient_acceptability(ingredient_effect, tower_selected)
signal hide_ingredient_acceptability

signal in_tower_selection_mode()
signal tower_selection_mode_ended()

signal tower_to_benefit_from_synergy_buff(tower)
signal tower_to_remove_from_synergy_buff(tower)

signal tower_in_queue_free(tower)
signal tower_being_sold(sellback_gold, tower)
signal tower_being_absorbed_as_ingredient(tower)


var tower_inventory_bench
var in_map_placables_manager : InMapPlacablesManager
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

var synergy_manager
var stage_round_manager
var ability_manager : AbilityManager
var input_prompt_manager : InputPromptManager setget set_input_prompt_manager
var game_elements

var _color_groups : Array
const TOWER_GROUP_ID : String = "Towers"

var _is_round_on_going : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	for color in TowerColors.get_all_colors():
		_color_groups.append(str(color))


# Generic things that can branch out to other resp.

func _tower_in_queue_free(tower):
	emit_signal("tower_in_queue_free", tower)
	
	_tower_inactivated_from_map(tower)
	for color in _color_groups:
		if tower.is_in_group(color):
			tower.remove_from_group(color)
	
	_update_active_synergy()
	
	if tower == tower_being_shown_in_info:
		_show_round_panel()



# Called after potentially updating synergy
func _tower_active_in_map(tower):
	_register_tower_to_color_grouping_tags(tower)
	emit_signal("tower_to_benefit_from_synergy_buff", tower)
	#call_deferred("emit_signal", "tower_to_benefit_from_synergy_buff", tower)

# Called after potentially updating synergy
func _tower_inactivated_from_map(tower):
	_remove_tower_from_color_grouping_tags(tower)
	emit_signal("tower_to_remove_from_synergy_buff", tower)
	#call_deferred("emit_signal", "tower_to_remove_from_synergy_buff", tower)

# Adding tower as child of this to monitor it
func add_tower(tower_instance : AbstractTower):
	tower_instance.connect("register_ability", self, "_register_ability_from_tower", [], CONNECT_PERSIST)
	tower_instance.tower_manager = self
	tower_instance.tower_inventory_bench = tower_inventory_bench
	tower_instance.input_prompt_manager = input_prompt_manager
	tower_instance.ability_manager = ability_manager
	tower_instance.synergy_manager = synergy_manager
	tower_instance.game_elements = game_elements
	
	tower_instance.is_in_select_tower_prompt = input_prompt_manager.is_in_tower_selection_mode()
	tower_instance.is_in_ingredient_mode = is_in_ingredient_mode
	
	add_child(tower_instance)
	tower_instance.connect("tower_being_dragged", self, "_tower_being_dragged", [], CONNECT_PERSIST)
	tower_instance.connect("tower_dropped_from_dragged", self, "_tower_dropped_from_dragged", [], CONNECT_PERSIST)
	tower_instance.connect("tower_toggle_show_info", self, "_tower_toggle_show_info", [], CONNECT_PERSIST)
	tower_instance.connect("tower_in_queue_free", self, "_tower_in_queue_free", [], CONNECT_PERSIST)
	tower_instance.connect("update_active_synergy", self, "_update_active_synergy", [], CONNECT_PERSIST)
	tower_instance.connect("tower_being_sold", self, "_tower_sold", [tower_instance], CONNECT_PERSIST)
	tower_instance.connect("tower_give_gold", self, "_tower_generate_gold", [], CONNECT_PERSIST)
	tower_instance.connect("tower_being_absorbed_as_ingredient", self, "_emit_tower_being_absorbed_as_ingredient", [], CONNECT_PERSIST)
	
	tower_instance.connect("tower_colors_changed", self, "_register_tower_to_color_grouping_tags", [tower_instance], CONNECT_PERSIST)
	tower_instance.connect("tower_active_in_map", self, "_tower_active_in_map", [tower_instance], CONNECT_PERSIST)
	tower_instance.connect("tower_not_in_active_map", self, "_tower_inactivated_from_map", [tower_instance], CONNECT_PERSIST)
	
	connect("ingredient_mode_turned_into", tower_instance, "_set_is_in_ingredient_mode", [], CONNECT_PERSIST)
	connect("show_ingredient_acceptability", tower_instance, "show_acceptability_with_ingredient", [], CONNECT_PERSIST)
	connect("hide_ingredient_acceptability", tower_instance, "hide_acceptability_with_ingredient", [], CONNECT_PERSIST)
	
	connect("in_tower_selection_mode", tower_instance, "set_is_in_selection_mode", [true], CONNECT_PERSIST)
	connect("tower_selection_mode_ended" , tower_instance, "set_is_in_selection_mode", [false], CONNECT_PERSIST)
	
	tower_instance.connect("tower_selected_in_selection_mode", self, "_tower_selected", [], CONNECT_PERSIST)
	
	tower_instance.add_to_group(TOWER_GROUP_ID, true)
	
	tower_instance._set_round_started(_is_round_on_going)
	
	# TODO TEMPORARY
	tower_instance.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.LEVEL, 4)


# Color and grouping related

func _register_tower_to_color_grouping_tags(tower : AbstractTower, force : bool = false):
	if tower.is_contributing_to_synergy or force:
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
	in_map_placables_manager.make_all_placables_glow()
	
	inner_bottom_panel.sell_panel.tower = tower_dragged
	inner_bottom_panel.make_sell_panel_visible()
	
	if is_in_ingredient_mode:
		emit_signal("show_ingredient_acceptability", tower_being_dragged.ingredient_of_self, tower_being_dragged)

func _tower_dropped_from_dragged(tower_released : AbstractTower):
	tower_being_dragged = null
	tower_inventory_bench.make_all_slots_not_glow()
	in_map_placables_manager.make_all_placables_not_glow()
	
	#inner_bottom_panel.sell_panel.tower = null
	inner_bottom_panel.make_sell_panel_invisible()
	
	if is_in_ingredient_mode:
		emit_signal("hide_ingredient_acceptability")
	

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


# Synergy Related

func _update_active_synergy():
	#synergy_manager.update_synergies(_get_all_synergy_contributing_towers())
	synergy_manager.call_deferred("update_synergies", _get_all_synergy_contributing_towers())

func _get_all_synergy_contributing_towers() -> Array:
	var bucket : Array = []
	for tower in get_children():
		if tower is AbstractTower and tower.is_contributing_to_synergy:
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
	tower.connect("final_range_changed", self, "_update_final_range_in_info")
	tower.connect("final_attack_speed_changed", self, "_update_final_attack_speed_in_info")
	tower.connect("final_base_damage_changed", self, "_update_final_base_damage_in_info")
	tower.connect("ingredients_absorbed_changed", self, "_update_ingredients_absorbed_in_info")
	tower.connect("ingredients_limit_changed", self, "_update_ingredients_absorbed_in_info")
	tower.connect("targeting_changed", self, "_update_targeting")
	tower.connect("targeting_options_modified", self, "_update_targeting")
	tower.connect("energy_module_attached", self, "_update_energy_module_display")
	tower.connect("energy_module_detached", self ,"_update_energy_module_display")
	tower.connect("heat_module_should_be_displayed_changed", self, "_update_heat_module_should_display_display")

func _update_final_range_in_info():
	tower_stats_panel.update_final_range()

func _update_final_attack_speed_in_info():
	tower_stats_panel.update_final_attack_speed()

func _update_final_base_damage_in_info():
	tower_stats_panel.update_final_base_damage()

func _update_ingredients_absorbed_in_info(_new_limit):
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
		tower_being_shown_in_info.disconnect("ingredients_limit_changed", self, "_update_ingredients_absorbed_in_info")
		tower_being_shown_in_info.disconnect("targeting_changed", self, "_update_targeting")
		tower_being_shown_in_info.disconnect("targeting_options_modified", self, "_update_targeting")
		tower_being_shown_in_info.disconnect("energy_module_attached", self, "_update_energy_module_display")
		tower_being_shown_in_info.disconnect("energy_module_detached", self ,"_update_energy_module_display")
		tower_being_shown_in_info.disconnect("heat_module_should_be_displayed_changed", self, "_update_heat_module_should_display_display")
		
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


# Towers in map related
func get_all_towers() -> Array:
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(TOWER_GROUP_ID):
			bucket.append(child)
	
	return bucket


func get_all_active_towers() -> Array:
	var bucket : Array = []
	
	for color in _color_groups:
		for tower in get_all_active_towers_with_color(color):
			if !bucket.has(tower):
				bucket.append(tower)
	
	return bucket


func get_all_active_towers_with_color(color) -> Array:
	if color is int:
		color = str(color)
	
	var bucket : Array = []
	for child in get_children():
		if child.is_in_group(color):
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


func _prompted_for_tower_selection():
	emit_signal("in_tower_selection_mode")

func _tower_selection_ended():
	emit_signal("tower_selection_mode_ended")


func _tower_selected(tower):
	input_prompt_manager.tower_selected_from_prompt(tower)

