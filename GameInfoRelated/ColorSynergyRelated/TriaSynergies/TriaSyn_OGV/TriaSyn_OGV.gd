extends "res://GameInfoRelated/ColorSynergyRelated/AbstractGameElementsModifyingSynergyEffect.gd"

const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")
const GoldManager = preload("res://GameElementsRelated/GoldManager.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const EnemyManager = preload("res://GameElementsRelated/EnemyManager.gd")

const TriaSyn_OGV_Syn_Interactable = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_OGV/GUIRelated/TriaSyn_OGV_Syn_Interactable.gd")
const TriaSyn_OGV_Syn_Interactable_Scene = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_OGV/GUIRelated/TriaSyn_OGV_Syn_Interactable.tscn")

const PowerFund_Pic = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_OGV/Assets/PowerFund/PowerFund_AbilityIcon.png")
const PowerFund_StatusBarIcon = preload("res://GameInfoRelated/ColorSynergyRelated/TriaSynergies/TriaSyn_OGV/Assets/PowerFund/PowerFund_StatusBarIcon.png")


#

signal enemy_player_health_changed(max_val, new_curr_health_val)

#

const enemy_soul_spawn_at_timepos_in_round_percent : float = 0.7

const min_unit_distance_for_full_damage_points = 0.50

const enemy_player_max_health : float = 100.0
var enemy_player_current_health : float = enemy_player_max_health

const tier_1_max_damage_per_round : float = 30.0
const tier_2_max_damage_per_round : float = 16.0
const tier_3_max_damage_per_round : float = 12.0

#

const tier_1_power_fund_attack_speed_amount : float = 70.0
const tier_2_power_fund_attack_speed_amount : float = 50.0
const tier_3_power_fund_attack_speed_amount : float = 30.0

const power_fund_gold_cost : int = 3
const power_fund_duration : float = 5.0
const power_fund_attack_count : int = 8
const power_fund_round_cooldown : int = 1

const power_fund_insufficient_gold_clause_id : int = -10

var power_fund_ability : BaseAbility
var power_fund_ability_activational_clauses : ConditionalClauses
var power_fund_ability_descriptions = [
	"Spend %s gold to give all towers bonus attack speed for %s attacks for %s seconds." % [str(power_fund_gold_cost), str(power_fund_attack_count), str(power_fund_duration)],
	"Cooldown: %s round" % [str(power_fund_round_cooldown)],
]

var power_fund_effect : TowerAttributesEffect

#

var game_elements : GameElements
var gold_manager : GoldManager
var enemy_manager : EnemyManager
var game_result_manager 
var curr_tier : int

var enemy_soul_id : int
var enemy_soul

var current_max_damage_per_round : float

var syn_interactable : TriaSyn_OGV_Syn_Interactable

#


func _apply_syn_to_game_elements(arg_game_elements : GameElements, tier : int):
	if game_elements == null:
		game_elements = arg_game_elements
		gold_manager = game_elements.gold_manager
		enemy_manager = game_elements.enemy_manager
		game_result_manager = game_elements.game_result_manager
	
	if !gold_manager.is_connected("current_gold_changed", self, "_gold_changed"):
		gold_manager.connect("current_gold_changed", self, "_gold_changed", [], CONNECT_PERSIST)
	
	if !enemy_manager.is_connected("round_time_passed", self, "_enemy_manager_spawn_timepos_moved"):
		enemy_manager.connect("round_time_passed", self, "_enemy_manager_spawn_timepos_moved", [], CONNECT_PERSIST)
	
	if !enemy_manager.is_connected("enemy_spawned", self, "_enemy_manager_enemy_spawn"):
		enemy_manager.connect("enemy_spawned", self, "_enemy_manager_enemy_spawn", [], CONNECT_PERSIST)
	
	if !game_elements.stage_round_manager.is_connected("round_started", self, "_on_round_start"):
		game_elements.stage_round_manager.connect("round_started", self, "_on_round_start", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	curr_tier = tier
	
	_configure_current_max_damage_per_round()
	
	#
	
	if !is_instance_valid(syn_interactable):
		_construct_and_add_syn_interactable()
	
	#
	
	enemy_soul_id = EnemyConstants.Enemies.TRIASYN_OGV_SOUL
	
	if power_fund_ability == null:
		_construct_power_fund_ability_relateds()
	_configure_power_fund_attack_speed_stats()
	
	_gold_changed(gold_manager.current_gold)
	
	._apply_syn_to_game_elements(arg_game_elements, tier)


func _configure_current_max_damage_per_round():
	if curr_tier == 1:
		current_max_damage_per_round = tier_1_max_damage_per_round
	elif curr_tier == 2:
		current_max_damage_per_round = tier_2_max_damage_per_round
	elif curr_tier == 3:
		current_max_damage_per_round = tier_3_max_damage_per_round


#

func _remove_syn_from_game_elements(arg_game_elements : GameElements, tier : int):
	curr_tier = -1
	
	._remove_syn_from_game_elements(arg_game_elements, tier)
	
	if gold_manager.is_connected("current_gold_changed", self, "_gold_changed"):
		gold_manager.disconnect("current_gold_changed", self, "_gold_changed")
	
	if enemy_manager.is_connected("round_time_passed", self, "_enemy_manager_spawn_timepos_moved"):
		enemy_manager.disconnect("round_time_passed", self, "_enemy_manager_spawn_timepos_moved")
	
	if enemy_manager.is_connected("enemy_spawned", self, "_enemy_manager_enemy_spawn"):
		enemy_manager.disconnect("enemy_spawned", self, "_enemy_manager_enemy_spawn")
	
	
	if game_elements.stage_round_manager.is_connected("round_started", self, "_on_round_start"):
		game_elements.stage_round_manager.disconnect("round_started", self, "_on_round_start")
	

#

func _construct_and_add_syn_interactable():
	syn_interactable = TriaSyn_OGV_Syn_Interactable_Scene.instance()
	syn_interactable.configure_self_with_synergy(self)
	
	game_elements.synergy_interactable_panel.add_synergy_interactable(syn_interactable)


#

func _construct_power_fund_ability_relateds():
	power_fund_ability = BaseAbility.new()
	
	power_fund_ability.is_timebound = true
	power_fund_ability.connect("ability_activated", self, "_power_fund_ability_activated", [], CONNECT_PERSIST)
	power_fund_ability.icon = PowerFund_Pic
	
	power_fund_ability.set_properties_to_usual_synergy_based()
	power_fund_ability.synergy = self
	
	power_fund_ability.descriptions = power_fund_ability_descriptions
	power_fund_ability.display_name = "Power Fund"
	
	power_fund_ability_activational_clauses = power_fund_ability.activation_conditional_clauses
	
	register_ability_to_manager(power_fund_ability)
	
	
	var power_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.OVG_POWER_FUND_ATTACK_SPEED_EFFECT)
	power_modi.percent_based_on = PercentType.BASE
	
	power_fund_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, power_modi, StoreOfTowerEffectsUUID.OVG_POWER_FUND_ATTACK_SPEED_EFFECT)
	power_fund_effect.is_timebound = true
	power_fund_effect.time_in_seconds = power_fund_duration
	power_fund_effect.is_countbound = true
	power_fund_effect.count = power_fund_attack_count
	power_fund_effect.status_bar_icon = PowerFund_StatusBarIcon


func register_ability_to_manager(ability : BaseAbility, add_to_panel : bool = true):
	game_elements.ability_manager.add_ability(ability, add_to_panel)


func _configure_power_fund_attack_speed_stats():
	var amount_to_use : float = 0
	
	if curr_tier == 1:
		amount_to_use = tier_1_power_fund_attack_speed_amount
	elif curr_tier == 2:
		amount_to_use = tier_2_power_fund_attack_speed_amount
	elif curr_tier == 3:
		amount_to_use = tier_3_power_fund_attack_speed_amount
	
	power_fund_effect.attribute_as_modifier.percent_amount = amount_to_use

#

func _gold_changed(new_amount : int):
	if power_fund_gold_cost > new_amount:
		power_fund_ability_activational_clauses.attempt_insert_clause(power_fund_insufficient_gold_clause_id)
	else:
		power_fund_ability_activational_clauses.remove_clause(power_fund_insufficient_gold_clause_id)


#

func _power_fund_ability_activated():
	power_fund_ability.on_ability_before_cast_start(power_fund_ability.ON_ABILITY_CAST_NO_COOLDOWN)
	var final_ap_scale : float = power_fund_ability.get_potency_to_use(1)
	
	var towers = game_elements.tower_manager.get_all_active_towers()
	for tower in towers:
		if is_instance_valid(tower) and !tower.is_queued_for_deletion():
			tower.add_tower_effect(power_fund_effect._get_copy_scaled_by(final_ap_scale))
	
	gold_manager.decrease_gold_by(power_fund_gold_cost, GoldManager.DecreaseGoldSource.SYNERGY)
	
	power_fund_ability.start_round_cooldown(power_fund_round_cooldown)
	power_fund_ability.on_ability_after_cast_ended(power_fund_ability.ON_ABILITY_CAST_NO_COOLDOWN)

#

func _on_round_start(current_stageround):
	if !enemy_manager.is_connected("round_time_passed", self, "_enemy_manager_spawn_timepos_moved"):
		enemy_manager.connect("round_time_passed", self, "_enemy_manager_spawn_timepos_moved", [], CONNECT_PERSIST)


func _enemy_manager_spawn_timepos_moved(delta, current_timepos):
	var spawn_soul : bool = false
	if enemy_manager.highest_enemy_spawn_timepos_in_round > 0:
		var round_percent = current_timepos / enemy_manager.highest_enemy_spawn_timepos_in_round
		if round_percent >= enemy_soul_spawn_at_timepos_in_round_percent:
			spawn_soul = true
		
	elif enemy_manager.highest_enemy_spawn_timepos_in_round == 0:
		spawn_soul = true
	
	if spawn_soul:
		_instruct_spawn_soul()
		
		if enemy_manager.is_connected("round_time_passed", self, "_enemy_manager_spawn_timepos_moved"):
			enemy_manager.disconnect("round_time_passed", self, "_enemy_manager_spawn_timepos_moved")


func _instruct_spawn_soul():
	enemy_manager.spawn_enemy(enemy_soul_id)

#

func _enemy_manager_enemy_spawn(enemy):
	if enemy.enemy_id == enemy_soul_id:
		enemy_soul = enemy
		
		enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_enemy_soul_killed_no_more_revives", [], CONNECT_ONESHOT)


func _on_enemy_soul_killed_no_more_revives(damage_instance_report, soul):
	_damage_enemy_player(_get_damage_multiplier_based_on_unit_distance(soul.unit_distance_to_exit) * current_max_damage_per_round)

func _get_damage_multiplier_based_on_unit_distance(unit_distance : float) -> float:
	if unit_distance >= min_unit_distance_for_full_damage_points:
		return 1.0
	else:
		return (unit_distance + (1 - min_unit_distance_for_full_damage_points))


func _damage_enemy_player(damage_amount):
	enemy_player_current_health -= damage_amount
	emit_signal("enemy_player_health_changed", enemy_player_max_health, enemy_player_current_health)
	
	if enemy_player_current_health <= 0:
		_enemy_player_reached_zero_health()

#

func _enemy_player_reached_zero_health():
	game_result_manager.set_game_result__accessed_from_outside(game_result_manager.GameResult.VICTORY)


