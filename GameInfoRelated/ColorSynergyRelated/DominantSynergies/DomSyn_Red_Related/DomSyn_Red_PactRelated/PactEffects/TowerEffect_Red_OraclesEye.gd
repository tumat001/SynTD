extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")


var base_downtime_for_range_gain : float

var range_gain_per_second_percent : float
var max_limit_of_range_percent : float

var range_per_shadow_kill : float


var _oracle_range_modi : PercentModifier
var _oracle_range_effect : TowerAttributesEffect

var _per_shadow_kill_range_modi : FlatModifier
var _per_shadow_kill_range_effect : TowerAttributesEffect

var _tower

var _base_downtime_timer : Timer
var _per_sec_timer : Timer

var _dom_syn_red

func _init(arg_dom_syn_red).(StoreOfTowerEffectsUUID.RED_PACT_ORACLES_EYE_EFFECT_GIVER):
	_dom_syn_red = arg_dom_syn_red


func _make_modifications_to_tower(tower):
	_tower = tower
	
	if !_tower.is_connected("on_main_attack", self, "_on_tower_main_attack"):
		_tower.connect("on_main_attack", self, "_on_tower_main_attack", [], CONNECT_PERSIST)
		_tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)
		_tower.connect("on_round_start", self, "_on_round_start", [], CONNECT_PERSIST)
	
	if !is_instance_valid(_base_downtime_timer):
		_base_downtime_timer = Timer.new()
		_base_downtime_timer.one_shot = true
		_base_downtime_timer.connect("timeout", self, "_on_base_downtime_timer_expired", [], CONNECT_PERSIST)
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_base_downtime_timer)
	
	if !is_instance_valid(_per_sec_timer):
		_per_sec_timer = Timer.new()
		_per_sec_timer.one_shot = true
		_per_sec_timer.connect("timeout", self, "_on_per_sec_timer_expired", [], CONNECT_PERSIST)
		CommsForBetweenScenes.ge_add_child_to_other_node_hoster(_per_sec_timer)
	
	_construct_and_add_range_effects()
	
	if _tower.is_round_started:
		_base_downtime_timer.start(base_downtime_for_range_gain)
	
	if !_dom_syn_red.is_connected("on_shadow_enemy_killed", self, "_on_shadow_enemy_killed"):
		_dom_syn_red.connect("on_shadow_enemy_killed", self, "_on_shadow_enemy_killed", [], CONNECT_PERSIST)


#

func _construct_and_add_range_effects():
	if _oracle_range_effect == null:
		_oracle_range_modi = PercentModifier.new(StoreOfTowerEffectsUUID.RED_PACT_ORACLES_EYE_RANGE_EFFECT) 
		_oracle_range_modi.percent_amount = 0
		_oracle_range_modi.percent_based_on = PercentType.BASE
		
		_oracle_range_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_RANGE, _oracle_range_modi, StoreOfTowerEffectsUUID.RED_PACT_ORACLES_EYE_RANGE_EFFECT)
		
		_tower.add_tower_effect(_oracle_range_effect)
	
	if _per_shadow_kill_range_effect == null:
		_per_shadow_kill_range_modi = FlatModifier.new(StoreOfTowerEffectsUUID.RED_PACT_ORACLES_EYE_PER_SHADOW_KILL_RANGE_EFFECT)
		_per_shadow_kill_range_modi.flat_modifier = 0
		
		_per_shadow_kill_range_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, _per_shadow_kill_range_modi, StoreOfTowerEffectsUUID.RED_PACT_ORACLES_EYE_PER_SHADOW_KILL_RANGE_EFFECT)
		
		_tower.add_tower_effect(_per_shadow_kill_range_effect)

#

func _on_base_downtime_timer_expired():
	_increase_range_by_per_sec_amount()
	_per_sec_timer.start(1)

func _on_per_sec_timer_expired():
	if _oracle_range_modi.percent_amount < max_limit_of_range_percent:
		_increase_range_by_per_sec_amount()
		_per_sec_timer.start(1)


func _increase_range_by_per_sec_amount():
	_oracle_range_modi.percent_amount += range_gain_per_second_percent
	_tower.recalculate_range()


#

func _on_tower_main_attack(attk_speed_delay, enemies, module):
	_per_sec_timer.stop()
	_base_downtime_timer.start(base_downtime_for_range_gain)


func _on_round_end():
	_reset_oracle_range_modi(false)
	_reset_per_shadow_kill_range_modi()
	_per_sec_timer.stop()
	_base_downtime_timer.stop()

func _reset_oracle_range_modi(arg_recalc : bool = true):
	_oracle_range_modi.percent_amount = 0
	
	if arg_recalc:
		_tower.recalculate_range()

#


func _on_shadow_enemy_killed():
	_per_shadow_kill_range_modi.flat_modifier += range_per_shadow_kill
	_tower.recalculate_range()

func _reset_per_shadow_kill_range_modi():
	_per_shadow_kill_range_modi.flat_modifier = 0
	_tower.recalculate_range()


#

func _on_round_start():
	_base_downtime_timer.start(base_downtime_for_range_gain)

##

func _undo_modifications_to_tower(tower):
	var oracle_range_effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_ORACLES_EYE_RANGE_EFFECT)
	if oracle_range_effect != null:
		_tower.remove_tower_effect(oracle_range_effect)
	
	var per_kill_range_effect = _tower.get_tower_effect(StoreOfTowerEffectsUUID.RED_PACT_ORACLES_EYE_PER_SHADOW_KILL_RANGE_EFFECT)
	if per_kill_range_effect != null:
		_tower.remove_tower_effect(per_kill_range_effect)
	
	
	if _tower.is_connected("on_main_attack", self, "_on_tower_main_attack"):
		_tower.disconnect("on_main_attack", self, "_on_tower_main_attack")
		_tower.disconnect("on_round_end", self, "_on_round_end")
		_tower.disconnect("on_round_start", self, "_on_round_start")
	
	if _dom_syn_red.is_connected("on_shadow_enemy_killed", self, "_on_shadow_enemy_killed"):
		_dom_syn_red.disconnect("on_shadow_enemy_killed", self, "_on_shadow_enemy_killed")

	
	_base_downtime_timer.queue_free()
	_per_sec_timer.queue_free()
	

