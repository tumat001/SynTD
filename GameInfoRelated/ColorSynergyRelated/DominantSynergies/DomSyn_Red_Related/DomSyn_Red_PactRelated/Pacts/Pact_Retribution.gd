extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerEffect_Red_RetributionEffect = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_RetributionEffect.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")

var _bonus_damage_scale : float

var _initial_enemy_damage_resistance_percent_amount : float

var _enemy_dmg_resist_effect : EnemyAttributesEffect

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.RETRIBUTION, "Retribution", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		_bonus_damage_scale = 9.0
		_initial_enemy_damage_resistance_percent_amount = 6
	elif tier == 1:
		_bonus_damage_scale = 7.0
		_initial_enemy_damage_resistance_percent_amount = 5
	elif tier == 2:
		_bonus_damage_scale = 5.0
		_initial_enemy_damage_resistance_percent_amount = 4
	elif tier == 3:
		_bonus_damage_scale = 3.0
		_initial_enemy_damage_resistance_percent_amount = 3
	
	
	# INS START
	var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
	interpreter_for_bonus_dmg.display_body = false
	
	var ins_for_bonus_dmg = []
	ins_for_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", (_bonus_damage_scale - 1) * 100, true))
	
	interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_dmg
	
	# INS END
	good_descriptions = [
		["A tower's first main attack against enemies that have exited its range then entered again deal |0| (retribution).", [interpreter_for_bonus_dmg]]
	]
	
	bad_descriptions = [
		"Enemies gain %s%% damage reduction. Triggering retribution removes this effect." % str(_initial_enemy_damage_resistance_percent_amount)
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_Retribution_Icon.png")


func pact_sworn():
	.pact_sworn()
	
	_construct_enemy_dmg_res_effect()

func _construct_enemy_dmg_res_effect():
	var modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.RED_RETRIBUTION_DAMAGE_RESISTANCE)
	modi.flat_modifier = _initial_enemy_damage_resistance_percent_amount
	
	_enemy_dmg_resist_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_RESISTANCE, modi, StoreOfEnemyEffectsUUID.RED_RETRIBUTION_DAMAGE_RESISTANCE)
	_enemy_dmg_resist_effect.is_from_enemy = false
	_enemy_dmg_resist_effect.is_clearable = true
	


#

func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
		game_elements.enemy_manager.connect("enemy_spawned", self, "_on_enemy_spawned", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)


func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_RETRIBUTION_EFFECT_GIVER):
		var effect = TowerEffect_Red_RetributionEffect.new()
		effect.bonus_dmg_on_retribution_scale = _bonus_damage_scale
		
		tower.add_tower_effect(effect)


func _on_enemy_spawned(arg_enemy_spawned):
	arg_enemy_spawned._add_effect(_enemy_dmg_resist_effect)

#

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
		game_elements.enemy_manager.disconnect("enemy_spawned", self, "_on_enemy_spawned")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_RETRIBUTION_EFFECT_GIVER)
	
	if effect != null:
		tower.remove_tower_effect(effect)


###

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return true

