extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerEffect_DomSyn_Red_PlayingWithFireBuff = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_DomSyn_Red_PlayingWithFireBuff.gd")

var attk_speed_gain_val
var damage_gain_val

var initial_good_desc_size : int

const health_max_threshold_before_offerable : float = 80.0
const health_min_threshold_before_offerable : float = 30.0

func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.PLAYING_WITH_FIRE, "Playing With Fire", arg_tier, arg_tier_for_activation):
	var possible_speed_gain_values : Array
	var possible_damage_gain_values : Array
	
	if tier == 0:
		possible_speed_gain_values = [100, 110, 120]
		possible_damage_gain_values = [30, 40, 50]
	elif tier == 1:
		possible_speed_gain_values = [60, 70, 80]
		possible_damage_gain_values = [7, 10, 13]
	elif tier == 2:
		possible_speed_gain_values = [30, 40, 45]
		possible_damage_gain_values = [4, 7, 10]
	elif tier == 3:
		possible_speed_gain_values = [10, 20, 25]
		possible_damage_gain_values = [2, 4, 7]
	
	var index_rng = pact_mag_rng.randi_range(0, 2)
	attk_speed_gain_val = possible_speed_gain_values[index_rng]
	damage_gain_val = possible_damage_gain_values[index_rng]
	
	# INS START
	var interpreter_for_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_attk_speed.display_body = false
	
	var ins_for_attk_speed = []
	ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", attk_speed_gain_val, true))
	
	interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
	
	# INS END
	good_descriptions = [
		["Towers gain from 0 to |0|, based on current player health.", [interpreter_for_attk_speed]]
	]
	initial_good_desc_size = good_descriptions.size()
	
	bad_descriptions = [
		"The first enemy escape per round deals extra %s player damage." % damage_gain_val
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_PlayingWithFire_Icon.png")


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.enemy_manager.is_connected("first_enemy_escaped" , self, "_first_enemy_escaped"):
		game_elements.enemy_manager.connect("first_enemy_escaped", self, "_first_enemy_escaped", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)


func _first_enemy_escaped(enemy, first_damage):
	game_elements.health_manager.decrease_health_by(damage_gain_val, game_elements.HealthManager.DecreaseHealthSource.SYNERGY)


func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.enemy_manager.is_connected("first_enemy_escaped" , self, "_first_enemy_escaped"):
		game_elements.enemy_manager.disconnect("first_enemy_escaped", self, "_first_enemy_escaped")
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)


#


func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_PLAYING_WITH_FIRE_BUFF_GIVER):
		var effect = TowerEffect_DomSyn_Red_PlayingWithFireBuff.new(game_elements.health_manager, self)
		
		effect.base_max_attk_speed_amount = attk_speed_gain_val
		
		tower.add_tower_effect(effect)



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_PLAYING_WITH_FIRE_BUFF_GIVER)
	
	if effect != null:
		tower.remove_tower_effect(effect)

#

func _first_time_initialize():
	if !game_elements.health_manager.is_connected("current_health_changed", self, "_on_player_health_changed"):
		game_elements.health_manager.connect("current_health_changed", self, "_on_player_health_changed", [], CONNECT_PERSIST)
	
	_on_player_health_changed(game_elements.health_manager.current_health)


func _on_player_health_changed(curr_health):
	var attk_speed_bonus = _calculate_attk_speed_bonus()
	
	if good_descriptions.size() > initial_good_desc_size:
		good_descriptions.remove(initial_good_desc_size)
	
	
	# INS START
	var interpreter_for_attk_speed = TextFragmentInterpreter.new()
	interpreter_for_attk_speed.display_body = false
	
	var ins_for_attk_speed = []
	ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "", attk_speed_bonus, true))
	
	interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
	# INS END
	
	good_descriptions.append(["Current attack speed bonus: |0|", [interpreter_for_attk_speed]])
	emit_signal("on_description_changed")

func _calculate_attk_speed_bonus():
	var attk_speed_bonus = attk_speed_gain_val * (1 - (game_elements.health_manager.current_health / game_elements.health_manager.starting_health))
	if attk_speed_bonus < 0:
		attk_speed_bonus = 0
	
	return attk_speed_bonus


#########

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.health_manager.current_health <= health_max_threshold_before_offerable and arg_game_elements.health_manager.current_health >= health_min_threshold_before_offerable
