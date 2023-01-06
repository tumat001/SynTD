extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerEffect_Red_JeweledBlade = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactEffects/TowerEffect_Red_JeweledBlade.gd")

signal on_current_base_dmg_amount_changed(new_val)


var total_worth_per_100_to_base_dmg_ratio : float
var level_up_additional_cost_scale : float


var _current_base_dmg_amount : float

var _current_level_affected : int
var _current_additional_gold_cost_for_level_amount : int

const player_worth_for_offerable : int = 60
const player_level_max_inc : int = 8


func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.JEWELED_BLADE, "Jeweled Blade", arg_tier, arg_tier_for_activation):
	
	if tier == 0:
		total_worth_per_100_to_base_dmg_ratio = 7
		level_up_additional_cost_scale = 0.3
	elif tier == 1:
		total_worth_per_100_to_base_dmg_ratio = 4
		level_up_additional_cost_scale = 0.3
	elif tier == 2:
		total_worth_per_100_to_base_dmg_ratio = 2.5
		level_up_additional_cost_scale = 0.3
	elif tier == 3:
		total_worth_per_100_to_base_dmg_ratio = 1
		level_up_additional_cost_scale = 0.3
	
	var plain_fragment__total_worth_in_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "total worth in gold")
	
	good_descriptions = [
		["Towers gain base damage based on your |0|.", [plain_fragment__total_worth_in_gold]],
		""
	]
	
	bad_descriptions = [
		"",
		""
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_WealthBlade_Icon.png")


func _first_time_initialize():
	_update_level_related_vars()
	_update_curent_base_dmg_amount()
	
	# SIGNALS RELATED
	
	game_elements.tower_manager.connect("tower_in_queue_free", self, "_on_tower_in_queue_free", [], CONNECT_PERSIST)
	game_elements.tower_manager.connect("tower_added", self, "_on_tower_added", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	game_elements.tower_manager.connect("tower_sellback_value_changed", self, "_on_tower_sellback_value_changed", [], CONNECT_PERSIST)
	
	game_elements.gold_manager.connect("current_gold_changed", self, "_on_player_current_gold_changed", [], CONNECT_PERSIST)
	
	game_elements.level_manager.connect("on_current_level_changed", self, "_on_player_level_changed", [], CONNECT_PERSIST)


# SIGNALS RELATED

func _on_tower_in_queue_free(arg_tower_in_queue_free):
	_update_curent_base_dmg_amount()

func _on_tower_added(arg_tower):
	_update_curent_base_dmg_amount()

func _on_tower_sellback_value_changed(arg_new_val, arg_tower):
	_update_curent_base_dmg_amount()


func _on_player_current_gold_changed(arg_curr_gold):
	_update_curent_base_dmg_amount()


# BASE DMG RELATED

func _update_curent_base_dmg_amount():
	var total_worth = _calculate_total_player_worth()
	_current_base_dmg_amount = round(((float(total_worth) / 100.0) * total_worth_per_100_to_base_dmg_ratio) * 1000) / 1000
	
	# INS START
	var interpreter_for_base_dmg = TextFragmentInterpreter.new()
	interpreter_for_base_dmg.display_body = false
	
	var ins_for_base_dmg = []
	ins_for_base_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "base damage", _current_base_dmg_amount))
	
	interpreter_for_base_dmg.array_of_instructions = ins_for_base_dmg
	
	# INS END
	good_descriptions[1] = ["Current bonus: |0|", [interpreter_for_base_dmg]]
	emit_signal("on_description_changed")
	
	emit_signal("on_current_base_dmg_amount_changed", _current_base_dmg_amount)

func _calculate_total_player_worth(arg_game_elements : GameElements = game_elements):
	var total_worth : int = 0
	
	var all_towers = arg_game_elements.tower_manager.get_all_towers_except_in_queue_free()
	for tower in all_towers:
		total_worth += tower.last_calculated_sellback_value
	
	total_worth += arg_game_elements.gold_manager.current_gold
	
	#
	return total_worth


# LEVEL REALTED

func _get_next_level_after_current() -> int:
	return game_elements.level_manager.get_level_after_current()

func _calculate_extra_cost_for_next_level() -> int:
	var base_level_up_cost = game_elements.level_manager.base_level_up_costs[game_elements.level_manager.current_level]
	return int(ceil(base_level_up_cost[0] * level_up_additional_cost_scale))


func _on_player_level_changed(new_val): # disconnected when swearing this pact
	
	if !is_sworn and new_val == player_level_max_inc + 1:
		red_dom_syn.remove_pact_from_unsworn_list(self)
		
	else:
		_update_level_related_vars()


func _update_level_related_vars():
	_current_level_affected = _get_next_level_after_current()
	_current_additional_gold_cost_for_level_amount = _calculate_extra_cost_for_next_level()
	
	if game_elements.level_manager.base_level_up_costs[game_elements.level_manager.current_level][1] == game_elements.level_manager.Currency.GOLD:
		var plain_fragment__leveling_up = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.LEVEL_UP_ORANGE, "Leveling up")
		var plain_fragment__total_worth_in_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "%s more gold" % str(_current_additional_gold_cost_for_level_amount))
		
		var plain_fragment__level_9 = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.LEVEL_UP_ORANGE, "level 9")
		
		
		bad_descriptions[0] = ["|0| to %s costs |1| (irreversible)." % str(_current_level_affected), [plain_fragment__leveling_up, plain_fragment__total_worth_in_gold]]
		bad_descriptions[1] = ["This pact removes itself when |0| is reached while this is unsworn.", [plain_fragment__level_9]]
		
		emit_signal("on_description_changed")
	else:
		
		bad_descriptions[0] = ""
		
		emit_signal("on_description_changed")
		_current_additional_gold_cost_for_level_amount = 0


######

func pact_sworn():
	.pact_sworn()
	
	if game_elements.level_manager.is_connected("on_current_level_changed", self, "_on_player_level_changed"):
		game_elements.level_manager.disconnect("on_current_level_changed", self, "_on_player_level_changed")
		
		game_elements.level_manager.set_level_up_cost(game_elements.level_manager.current_level_up_cost + _current_additional_gold_cost_for_level_amount)
	
	
	bad_descriptions[0] = ""
	bad_descriptions.remove(1)
	emit_signal("on_description_changed")


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)


func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_JEWELED_BLADE_EFFECT):
		var effect = TowerEffect_Red_JeweledBlade.new(self)
		
		tower.add_tower_effect(effect)



func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)


func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_JEWELED_BLADE_EFFECT)
	
	if effect != null:
		tower.remove_tower_effect(effect)

#

func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return _calculate_total_player_worth(arg_game_elements) >= player_worth_for_offerable and arg_game_elements.level_manager.current_level <= player_level_max_inc
