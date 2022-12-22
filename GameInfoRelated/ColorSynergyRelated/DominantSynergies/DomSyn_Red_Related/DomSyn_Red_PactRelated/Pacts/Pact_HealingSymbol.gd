extends "res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/Red_BasePact.gd"

const TowerMarkEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerMarkEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")

var _healing_symbol_count : int
var _tower_max_health_reduc_percent : float

var _current_healing_symbols : Array = []

const player_health_maximum_for_offerable_inc : int = 100


func _init(arg_tier : int, arg_tier_for_activation : int).(StoreOfPactUUID.PactUUIDs.HEALING_SYMBOLS, "Healing Symbols", arg_tier, arg_tier_for_activation):
	if tier == 0:
		_healing_symbol_count = 4
		_tower_max_health_reduc_percent = -25
	elif tier == 1:
		_healing_symbol_count = 3
		_tower_max_health_reduc_percent = -25
	elif tier == 2:
		_healing_symbol_count = 2
		_tower_max_health_reduc_percent = -20
	elif tier == 3:
		_healing_symbol_count = 1
		_tower_max_health_reduc_percent = -20
	
	
	var plain_fragment__healing_symbols = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "%s Healing Symbol(s)" % str(_healing_symbol_count))
	
	good_descriptions = [
		["Gain |0|. Heals damaged towers in range. Heals you if no towers are healed. Does not take tower slots.", [plain_fragment__healing_symbols]]
	]
	
	bad_descriptions = [
		"Towers lose %s%% max health." % [str(-_tower_max_health_reduc_percent)]
	]
	
	pact_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_Icons/Pact_HealingSymbols_Icon.png")
	


func _first_time_initialize():
	
	game_elements.tower_inventory_bench.connect("tower_entered_bench_slot", self, "_on_tower_entered_bench_space", [], CONNECT_PERSIST)
	game_elements.tower_inventory_bench.connect("tower_removed_from_bench_slot", self, "_on_tower_exited_bench_space", [], CONNECT_PERSIST)
	
	_update_bench_space_status()


# ensure bench spaces

func _on_tower_entered_bench_space(tower, bench_slot):
	_update_bench_space_status()

func _on_tower_exited_bench_space(tower, bench_slot):
	_update_bench_space_status()



func _update_bench_space_status():
	if _if_enough_bench_space_is_available():
		pact_can_be_sworn_conditional_clauses.remove_clause(PactCanBeSwornClauseId.HEALING_SYMBOL_BENCH_STATUS)
	else:
		pact_can_be_sworn_conditional_clauses.attempt_insert_clause(PactCanBeSwornClauseId.HEALING_SYMBOL_BENCH_STATUS)
	
	_check_requirement_status_and_do_appropriate_action()

func _if_other_requirements_are_met() -> bool:
	return _if_enough_bench_space_is_available() or is_sworn

func _if_enough_bench_space_is_available():
	return game_elements.tower_inventory_bench._find_number_of_empty_slots() >= _healing_symbol_count

#func _if_pact_can_be_sworn() -> bool:
#	return _if_other_requirements_are_met()

#


func pact_sworn():
	.pact_sworn()
	
	for i in _healing_symbol_count:
		var healing_symbol_tower = game_elements.tower_inventory_bench.insert_tower_from_last(Towers.HEALING_SYMBOL)
		if is_instance_valid(healing_symbol_tower):
			_current_healing_symbols.append(healing_symbol_tower)
	
	if !if_tier_requirement_is_met():
		_disable_all_created_healing_symbols()


func _apply_pact_to_game_elements(arg_game_elements : GameElements):
	._apply_pact_to_game_elements(arg_game_elements)
	
	for tower in _current_healing_symbols:
		if is_instance_valid(tower):
			tower.disabled_from_attacking_clauses.remove_clause(tower.DisabledFromAttackingSourceClauses.DOM_SYN__RED__HEALING_SYMBOLS)
			
			var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_HEALING_SYMBOL_TOWER_DISABLED_MARKER)
			if effect != null:
				tower.remove_tower_effect(effect)
	
	if !game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.connect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy", [], CONNECT_PERSIST)
		game_elements.tower_manager.connect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy", [], CONNECT_PERSIST)
	
	var towers = game_elements.tower_manager.get_all_active_towers_except_in_queue_free()
	for tower in towers:
		_tower_to_benefit_from_synergy(tower)


func _tower_to_benefit_from_synergy(tower : AbstractTower):
	_attempt_add_effect_to_tower(tower)

func _attempt_add_effect_to_tower(tower : AbstractTower):
	if !tower.has_tower_effect_uuid_in_buff_map(StoreOfTowerEffectsUUID.RED_PACT_HEALING_SYMBOL_TOWER_HEALTH_REDUC_EFFECT):
		var base_health_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_HEALING_SYMBOL_TOWER_HEALTH_REDUC_EFFECT)
		base_health_mod.percent_amount = _tower_max_health_reduc_percent
		base_health_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_HEALTH , base_health_mod, StoreOfTowerEffectsUUID.ING_TRANSMUTATOR)
		
		tower.add_tower_effect(attr_effect)


#

func _remove_pact_from_game_elements(arg_game_elements : GameElements):
	._remove_pact_from_game_elements(arg_game_elements)
	
	_disable_all_created_healing_symbols()
	
	if game_elements.tower_manager.is_connected("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy"):
		game_elements.tower_manager.disconnect("tower_to_benefit_from_synergy_buff", self, "_tower_to_benefit_from_synergy")
		game_elements.tower_manager.disconnect("tower_to_remove_from_synergy_buff", self, "_tower_to_remove_from_synergy")
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		_tower_to_remove_from_synergy(tower)

func _disable_all_created_healing_symbols():
	for tower in _current_healing_symbols:
		if is_instance_valid(tower):
			tower.disabled_from_attacking_clauses.attempt_insert_clause(tower.DisabledFromAttackingSourceClauses.DOM_SYN__RED__HEALING_SYMBOLS)
			
			var effect = TowerMarkEffect.new(StoreOfTowerEffectsUUID.RED_PACT_HEALING_SYMBOL_TOWER_DISABLED_MARKER)
			effect.status_bar_icon = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_Assets/Pact_OtherAssets/TowerDisabled_StatusBarIcon.png")
			tower.add_tower_effect(effect)



func _tower_to_remove_from_synergy(tower : AbstractTower):
	_remove_effect_from_tower(tower)

func _remove_effect_from_tower(tower : AbstractTower):
	var effect = tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_HEALING_SYMBOL_TOWER_HEALTH_REDUC_EFFECT)
	
	if effect != null:
		tower.remove_tower_effect(effect)




func pact_unsworn(arg_replacing_pact):
	.pact_unsworn(arg_replacing_pact)
	
	game_elements.tower_inventory_bench.disconnect("tower_entered_bench_slot", self, "_on_tower_entered_bench_space")
	
	for tower in _current_healing_symbols:
		if is_instance_valid(tower):
			tower.queue_free()
	

##


func is_pact_offerable(arg_game_elements : GameElements, arg_dom_syn_red, arg_tier_to_be_offered : int) -> bool:
	return arg_game_elements.health_manager.current_health <= player_health_maximum_for_offerable_inc

