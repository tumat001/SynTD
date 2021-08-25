extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const HeatModule = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/HeatModule.gd")

signal on_round_end()
signal on_base_multiplier_changed(scale)


const tier_1_heat_effect_scale : float = 4.0
const tier_2_heat_effect_scale : float = 3.0
const tier_3_heat_effect_scale : float = 1.8
const tier_4_heat_effect_scale : float = 1.0
var current_heat_effect_scale : float

var should_modules_show_in_info : bool = false

var current_overheat_effects : Array = []

var game_elements : GameElements


# Adding syn to game ele

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	set_game_elements(arg_game_elements)
	should_modules_show_in_info = true
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	if tier == 4:
		current_heat_effect_scale = tier_4_heat_effect_scale
		_set_effect_multiplier_of_heat_modules(tier_4_heat_effect_scale)
	elif tier == 3:
		current_heat_effect_scale = tier_3_heat_effect_scale
		_set_effect_multiplier_of_heat_modules(tier_3_heat_effect_scale)
	elif tier == 2:
		current_heat_effect_scale = tier_2_heat_effect_scale
		_set_effect_multiplier_of_heat_modules(tier_2_heat_effect_scale)
	elif tier == 1:
		current_heat_effect_scale = tier_1_heat_effect_scale
		_set_effect_multiplier_of_heat_modules(tier_1_heat_effect_scale)
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	_towers_to_benefit_from_syn(all_towers)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


# Removing syn

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	should_modules_show_in_info = false
	current_heat_effect_scale = 0
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	var all_towers = game_elements.tower_manager.get_all_active_towers()
	_towers_to_remove_from_syn(all_towers)
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


# Game elements and round related

func set_game_elements(arg_game_elements):
	if game_elements == null:
		game_elements = arg_game_elements
		
		game_elements.stage_round_manager.connect("round_ended", self, "_on_round_ended")


func _on_round_ended(stageround):
	emit_signal("on_round_end")


# Heat module related

func construct_heat_module() -> HeatModule:
	var heat_module : HeatModule = HeatModule.new()
	heat_module.overheat_effects = current_overheat_effects
	heat_module.should_be_shown_in_info_panel = should_modules_show_in_info
	heat_module.base_effect_multiplier = current_heat_effect_scale
	
	connect("on_round_end", heat_module, "on_round_end", [], CONNECT_PERSIST)
	connect("on_base_multiplier_changed", heat_module, "set_base_effect_multiplier", [], CONNECT_PERSIST)
	
	return heat_module


func _set_effect_multiplier_of_heat_modules(scale : float):
	#emit_signal("on_base_multiplier_changed", scale)
	call_deferred("emit_signal", "on_base_multiplier_changed", scale)

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
			tower.heat_module.base_effect_multiplier = current_heat_effect_scale


func _towers_to_remove_from_syn(towers : Array):
	for tower in towers:
		_tower_to_remove_from_synergy(tower)

func _tower_to_remove_from_synergy(tower : AbstractTower):
	if tower._tower_colors.has(TowerColors.ORANGE):
		if tower.heat_module != null:
			tower.heat_module.base_effect_multiplier = 0
			tower.heat_module.should_be_shown_in_info_panel = false
			

