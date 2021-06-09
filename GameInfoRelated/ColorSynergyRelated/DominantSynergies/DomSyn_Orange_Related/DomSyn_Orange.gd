extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const HeatModule = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/HeatModule.gd")


const tier_1_heat_effect_scale : float = 3.4
const tier_2_heat_effect_scale : float = 2.6
const tier_3_heat_effect_scale : float = 1.8
const tier_4_heat_effect_scale : float = 1.0
var current_heat_effect_scale : float

var should_modules_show_in_info : bool = false

var current_overheat_effects : Array = []

var all_heat_modules : Array = []

var game_elements : GameElements

# Adding syn to game ele

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	set_game_elements(arg_game_elements)
	should_modules_show_in_info = true
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	if tier == 4:
		_set_effect_multiplier_of_heat_modules(tier_4_heat_effect_scale)
		current_heat_effect_scale = tier_4_heat_effect_scale
	elif tier == 3:
		_set_effect_multiplier_of_heat_modules(tier_3_heat_effect_scale)
		current_heat_effect_scale = tier_3_heat_effect_scale
	elif tier == 2:
		_set_effect_multiplier_of_heat_modules(tier_2_heat_effect_scale)
		current_heat_effect_scale = tier_2_heat_effect_scale
	elif tier == 1:
		_set_effect_multiplier_of_heat_modules(tier_1_heat_effect_scale)
		current_heat_effect_scale = tier_1_heat_effect_scale
	
	var all_orange_towers = game_elements.tower_manager.get_all_active_towers_with_color(TowerColors.ORANGE)
	_towers_to_benefit_from_syn(all_orange_towers)

# Removing syn

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	should_modules_show_in_info = false
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	var all_orange_towers = game_elements.tower_manager.get_all_active_towers_with_color(TowerColors.ORANGE)
	_towers_to_remove_from_syn(all_orange_towers)


# Game elements and round related

func set_game_elements(arg_game_elements):
	if game_elements == null:
		game_elements = arg_game_elements
		
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_ended")


func _on_round_ended(stageround):
	for module in all_heat_modules:
		module.on_round_end()


# Heat module related

func construct_heat_module() -> HeatModule:
	var heat_module : HeatModule = HeatModule.new()
	heat_module.overheat_effects = current_overheat_effects
	heat_module.should_be_shown_in_info_panel = should_modules_show_in_info
	heat_module.base_effect_multiplier = current_heat_effect_scale
	
	all_heat_modules.append(heat_module)
	return heat_module


func _set_effect_multiplier_of_heat_modules(scale : float):
	for module in all_heat_modules:
		module.base_effect_multiplier = scale


# Towers

func _towers_to_benefit_from_syn(towers : Array):
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)

func _tower_to_benefit_from_synergy(tower : AbstractTower):
	if tower._tower_colors.has(TowerColors.ORANGE):
		if tower.heat_module == null:
			tower.heat_module = construct_heat_module()
			tower.heat_module.set_tower(tower)
		else:
			tower.heat_module.should_be_shown_in_info_panel = true


func _towers_to_remove_from_syn(towers : Array):
	for tower in towers:
		_tower_to_remove_from_synergy(tower)

func _tower_to_remove_from_synergy(tower : AbstractTower):
	if tower._tower_colors.has(TowerColors.ORANGE):
		if tower.heat_module != null:
			tower.heat_module.should_be_shown_in_info_panel = false
