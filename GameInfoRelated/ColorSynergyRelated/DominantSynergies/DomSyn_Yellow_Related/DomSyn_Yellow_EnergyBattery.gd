extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const EnergyBattery = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/EnergyBattery.gd")
const EnergyBatteryPanel = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/Panels/BatteryEnergyPanel/EnergyBatteryPanel.gd")
const EnergyBatteryPanel_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Yellow_Related/Panels/BatteryEnergyPanel/EnergyBatteryPanel.tscn")

var energy_battery : EnergyBattery
var energy_battery_panel : EnergyBatteryPanel

var game_elements : GameElements

var _is_first_time_activated : bool = true

const tier_1_recharge_rate : int = 3
const tier_2_recharge_rate : int = 2
const tier_3_recharge_rate : int = 1


const tier_1_max_capacity = 8
const tier_2_max_capacity = 4
const tier_3_max_capacity = 2


# used by violet yellow
var eligible_colors : Array = [TowerColors.YELLOW]


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	game_elements = arg_game_elements
	
	if (tier == 1 or tier == 2 or tier == 3) and energy_battery == null:
		energy_battery = EnergyBattery.new(game_elements.stage_round_manager)
	
	if tier == 1:
		energy_battery.recharge_rate_per_round_from_main = tier_1_recharge_rate
		energy_battery.max_energy_capacity = tier_1_max_capacity
	elif tier == 2:
		energy_battery.recharge_rate_per_round_from_main = tier_2_recharge_rate
		
		if energy_battery.max_energy_capacity < tier_2_max_capacity:
			energy_battery.max_energy_capacity = tier_2_max_capacity
		
	elif tier == 3:
		energy_battery.recharge_rate_per_round_from_main = tier_3_recharge_rate
		
		if energy_battery.max_energy_capacity < tier_3_max_capacity:
			energy_battery.max_energy_capacity = tier_3_max_capacity
	else:
		_inactivate_self()
	
	if tier == 1 or tier == 2 or tier == 3:
		if !game_elements.stage_round_manager.is_connected("round_started", self, "_first_time_activation"):
			game_elements.stage_round_manager.connect("round_started", self, "_first_time_activation", [], CONNECT_ONESHOT)
		
		if !game_elements.stage_round_manager.is_connected("round_started", self, "_round_started"):
			game_elements.stage_round_manager.connect("round_started", self, "_round_started")
		
		if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_attempt_give_energy_module_to_eligible_tower"):
			game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_attempt_give_energy_module_to_eligible_tower")
		
		
		if !is_instance_valid(energy_battery_panel):
			energy_battery_panel = EnergyBatteryPanel_Scene.instance()
			energy_battery_panel.energy_battery = energy_battery
		
		if !game_elements.synergy_interactable_panel.has_synergy_interactable(energy_battery_panel):
			game_elements.synergy_interactable_panel.add_synergy_interactable(energy_battery_panel)
		
		
		if game_elements.stage_round_manager.round_started:
			#_attempt_give_all_eligible_towers_energy_module()
			_first_time_activation("")
		
		_attempt_give_all_eligible_towers_energy_module()
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	_inactivate_self()
	
	._remove_syn_from_game_elements(arg_game_elements, tier)


func _inactivate_self():
	if energy_battery != null:
		energy_battery.recharge_rate_per_round_from_main = 0
	
	if game_elements != null:
		if game_elements.stage_round_manager.is_connected("round_started", self, "_round_started"):
			game_elements.stage_round_manager.disconnect("round_started", self, "_round_started")
		
		if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_attempt_give_energy_module_to_eligible_tower"):
			game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_attempt_give_energy_module_to_eligible_tower")
		
		if game_elements.stage_round_manager.is_connected("round_started", self, "_first_time_activation"):
			game_elements.stage_round_manager.disconnect("round_started", self, "_first_time_activation")

#

func _first_time_activation(curr_stageround):
	if _is_first_time_activated:
		energy_battery.current_energy_amount += 1
		_is_first_time_activated = false


#


func _round_started(curr_stageround):
	_attempt_give_all_eligible_towers_energy_module()


func _attempt_give_all_eligible_towers_energy_module():
	for tower in game_elements.tower_manager.get_all_active_towers():
		_attempt_give_energy_module_to_eligible_tower(tower)


func _attempt_give_energy_module_to_eligible_tower(tower : AbstractTower):
	#if game_elements.stage_round_manager.round_started:
		if tower.energy_module == null:
			for color in eligible_colors:
				if tower._tower_colors.has(color):
					tower.energy_module = energy_battery.create_connected_energy_module()
					break
