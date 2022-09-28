extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const DomSyn_Yellow_EnergyBattery = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/DomSyn_Yellow_EnergyBattery.gd")
const EnergyBattery = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/EnergyBattery.gd")

const _energy_gain_if_won : int = 1 #tier 1
const _energy_gain_if_lost : int = 2 # tier 2

var domsyn_yellow_energy : DomSyn_Yellow_EnergyBattery
var game_elements : GameElements

func _init(arg_domsyn : DomSyn_Yellow_EnergyBattery):
	domsyn_yellow_energy = arg_domsyn
	

func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	game_elements = arg_game_elements
	
	if (tier <= 4) and domsyn_yellow_energy.energy_battery == null:
		domsyn_yellow_energy.energy_battery = EnergyBattery.new(game_elements.stage_round_manager)
	
	if tier == 1:
		if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_over_tier_1"):
			game_elements.stage_round_manager.connect("round_ended", self, "_on_round_over_tier_1")
	
	if tier == 1 or tier == 2:
		if !game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_over_tier_2_and_1"):
			game_elements.stage_round_manager.connect("round_ended", self, "_on_round_over_tier_2_and_1")
	
	if tier <= 4:
		if !domsyn_yellow_energy.eligible_colors.has(TowerColors.VIOLET):
			domsyn_yellow_energy.eligible_colors.append(TowerColors.VIOLET)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_over_tier_1"):
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_over_tier_1")
	
	if game_elements.stage_round_manager.is_connected("round_ended", self, "_on_round_over_tier_2_and_1"):
		game_elements.stage_round_manager.disconnect("round_ended", self, "_on_round_over_tier_2_and_1")
	
	if domsyn_yellow_energy.eligible_colors.has(TowerColors.VIOLET):
		domsyn_yellow_energy.eligible_colors.erase(TowerColors.VIOLET)
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


# Energy generation

func _on_round_over_tier_1(curr_stage_round):
	if !game_elements.stage_round_manager.lost_life_in_round:
		_generate_power(_energy_gain_if_won)


func _on_round_over_tier_2_and_1(curr_stage_round):
	if game_elements.stage_round_manager.lost_life_in_round:
		_generate_power(_energy_gain_if_lost)


func _generate_power(power_amount : int):
	domsyn_yellow_energy.energy_battery.current_energy_amount += power_amount