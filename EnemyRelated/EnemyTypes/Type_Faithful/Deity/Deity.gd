extends "res://EnemyRelated/AbstractEnemy.gd"

const RangeModule = preload("res://TowerRelated/Modules/RangeModule.gd")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")

const TowerPriorityTargetEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerPriorityTargetEffect.gd")
const TowerKnockUpEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerKnockUpEffect.gd")

const AbstractFaithfulEnemy = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/AbstractFaithfulEnemy.gd")


const ArmorToughness_StatusBarIcon = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/StatusBarIcons/Faithful_ArmorToughnessGain.png")
const HealthRegen_StatusBarIcon = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/StatusBarIcons/Faithful_HealthRegenGain.png")
const AP_StatusBarIcon = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/StatusBarIcons/Faithful_APGain.png")

#

enum PeriodicAbilities {
	
	TAUNT_TOWERS,
	GRANT_REVIVE,
	KNOCK_UP_TOWERS,
	
}
const NO_ABILITY_CASTED_YET : int = -1


const faithful_interaction_range_amount : float = 160.0
const tower_interaction_range_amount : float = 160.0

const base_armor_toughness_amount_per_faithful : float = 1.0
const base_health_regen_per_sec_per_sacrificer : float = 5.0
const base_ap_per_seer : float = 0.5
const base_health_gain_scale_from_cross_marker : float = 0.2

var faithfuls_in_range : int
var sacrificers_in_range : int
var seers_in_range : int

var armor_modi : FlatModifier
var toughness_modi : FlatModifier

var heal_modi : FlatModifier
var heal_effect : EnemyHealEffect

var ap_modi : FlatModifier
var ap_effect : EnemyAttributesEffect

var armor_modi_uuid : int
var heal_modi_uuid : int
var ap_modi_uuid : int


var _heal_timer : Timer
var _first_time_sacrificer_went_to_range : bool = false

#

var _current_cross_marker_unit_offset : float

var max_health_gain_modi : PercentModifier
var max_health_effect : EnemyAttributesEffect

#

var current_abilities_ids_ability_map = {}

var current_ability_rotation_cooldown_amount : float = 15.0
var rotation_ability : BaseAbility # ability that determines when abilities should be casted
var last_casted_ability_id : int = NO_ABILITY_CASTED_YET


var taunt_ability : BaseAbility
var taunt_ability_activation_clauses : ConditionalClauses
const taunt_duration : float = 5.0
var tower_target_priority_effect : TowerPriorityTargetEffect


var grant_revive_ability : BaseAbility
var grant_revive_ability_activation_clauses : ConditionalClauses
const revive_target_count : int = 15
const revive_heal_amount : float = 10.0
const revive_delay : float = 3.0
const revive_duration : float = 7.0
var revive_effect : EnemyReviveEffect


var knock_up_towers_ability : BaseAbility
var knock_up_ability_activation_clauses : ConditionalClauses
const knock_up_duration : float = 1.25
const knock_up_stun_duration : float = 2.5
const knock_up_y_accel_amount : float = 70.0
var knock_up_effect : TowerKnockUpEffect


#

var range_module : RangeModule
var tower_detecting_range_module : TowerDetectingRangeModule

#

func _ready():
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = faithful_interaction_range_amount
	range_module.set_range_shape(CircleShape2D.new())
	range_module.clear_all_targeting()
	range_module.add_targeting_option(Targeting.CLOSE)
	range_module.set_current_targeting(Targeting.CLOSE)
	
	range_module.connect("enemy_entered_range", self, "_on_enemy_entered_range_d")
	range_module.connect("enemy_left_range", self, "_on_enemy_left_range_d")
	
	add_child(range_module)
	range_module.update_range()
	
	#
	
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.can_display_range = false
	tower_detecting_range_module.detection_range = tower_interaction_range_amount
	
	add_child(tower_detecting_range_module)
	
	#
	
	_construct_and_register_abilities()
	connect("final_ability_potency_changed", self, "_on_ability_potency_changed_d")


func _post_inherit_ready():
	._post_inherit_ready()
	
	_construct_and_add_effects()



func _construct_and_add_effects():
	armor_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.DEITY_ARMOR_EFFECT)
	var armor_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_ARMOR, armor_modi, StoreOfEnemyEffectsUUID.DEITY_ARMOR_EFFECT)
	armor_effect.is_from_enemy = true
	armor_effect.is_clearable = false
	armor_modi_uuid = StoreOfEnemyEffectsUUID.DEITY_ARMOR_EFFECT
	
	
	toughness_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.DEITY_TOUGHNESS_EFFECT)
	var toughness_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_TOUGHNESS, toughness_modi, StoreOfEnemyEffectsUUID.DEITY_TOUGHNESS_EFFECT)
	toughness_effect.is_from_enemy = true
	toughness_effect.is_clearable = false
	
	armor_effect = _add_effect(armor_effect)
	toughness_effect = _add_effect(toughness_effect)
	
	armor_modi = armor_effect.attribute_as_modifier
	toughness_modi = toughness_effect.attribute_as_modifier
	
	#
	
	heal_modi_uuid = StoreOfEnemyEffectsUUID.DEITY_HEALTH_REGEN_EFFECT
	heal_modi = FlatModifier.new(heal_modi_uuid)
	
	heal_effect = EnemyHealEffect.new(heal_modi, heal_modi_uuid)
	heal_effect.is_from_enemy = true
	
	_heal_timer = Timer.new()
	_heal_timer.one_shot = true
	add_child(_heal_timer)
	_heal_timer.connect("timeout", self, "_heal_timer_expired")
	
	#
	
	ap_modi_uuid = StoreOfEnemyEffectsUUID.DEITY_AP_EFFECT
	ap_modi = FlatModifier.new(ap_modi_uuid)
	
	ap_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_ABILITY_POTENCY, ap_modi, ap_modi_uuid)
	ap_effect.is_from_enemy = true
	ap_effect.is_clearable = false
	
	ap_effect = _add_effect(ap_effect)
	ap_modi = ap_effect.attribute_as_modifier
	
	#
	
	if !_if_surpassed_cross_marker():
		max_health_gain_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.DEITY_MAX_HEALTH_GAIN_EFFECT)
		max_health_gain_modi.percent_amount = base_health_gain_scale_from_cross_marker
		max_health_gain_modi.percent_based_on = PercentType.MAX
		
		max_health_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_HEALTH, max_health_gain_modi, StoreOfEnemyEffectsUUID.DEITY_MAX_HEALTH_GAIN_EFFECT)
		max_health_effect.is_clearable = false
		max_health_effect.is_from_enemy = true
		
		max_health_effect = _add_effect(max_health_effect)
	
	#
	
	tower_target_priority_effect = TowerPriorityTargetEffect.new(self, StoreOfTowerEffectsUUID.FAITHFUL_TAUNT_EFFECT)
	tower_target_priority_effect.is_from_enemy = true
	tower_target_priority_effect.time_in_seconds = taunt_duration
	tower_target_priority_effect.is_timebound = true
	tower_target_priority_effect.status_bar_icon = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/StatusBarIcons/Deity_TauntIcon.png")
	
	#
	
	var rev_heal_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.DEITY_GRANTED_REVIVE_HEAL_EFFECT)
	rev_heal_modi.percent_amount = revive_heal_amount
	rev_heal_modi.percent_based_on = PercentType.MAX
	
	var rev_heal_effect = EnemyHealEffect.new(rev_heal_modi, StoreOfEnemyEffectsUUID.DEITY_GRANTED_REVIVE_HEAL_EFFECT)
	
	revive_effect = EnemyReviveEffect.new(rev_heal_effect, StoreOfEnemyEffectsUUID.DEITY_GRANTED_REVIVE_EFFECT, revive_delay)
	revive_effect.time_in_seconds = revive_duration
	revive_effect.is_timebound = true
	revive_effect.is_from_enemy = true
	
	#
	
	knock_up_effect = TowerKnockUpEffect.new(knock_up_duration, knock_up_y_accel_amount, StoreOfTowerEffectsUUID.FAITHFUL_KNOCK_UP_EFFECT)
	knock_up_effect.custom_stun_duration = knock_up_stun_duration
	knock_up_effect.is_from_enemy = true
	knock_up_effect.is_timebound = true


func _construct_and_register_abilities():
	rotation_ability = BaseAbility.new()
	
	rotation_ability.is_timebound = true
	rotation_ability._time_current_cooldown = current_ability_rotation_cooldown_amount / 2
	rotation_ability.connect("updated_is_ready_for_activation", self, "_on_rotation_ability_ready_updated")
	
	register_ability(rotation_ability)
	
	
	#
	taunt_ability = BaseAbility.new()
	
	taunt_ability.is_timebound = true
	
	register_ability(taunt_ability)
	
	taunt_ability_activation_clauses = taunt_ability.activation_conditional_clauses
	current_abilities_ids_ability_map[PeriodicAbilities.TAUNT_TOWERS] = taunt_ability
	
	taunt_ability.auto_cast_func = "_cast_taunt_ability"
	
	#
	
	grant_revive_ability = BaseAbility.new()
	
	grant_revive_ability.is_timebound = true
	
	register_ability(grant_revive_ability)
	
	grant_revive_ability_activation_clauses = grant_revive_ability.activation_conditional_clauses
	current_abilities_ids_ability_map[PeriodicAbilities.GRANT_REVIVE] = grant_revive_ability
	
	grant_revive_ability.auto_cast_func = "_cast_grant_revive_ability"
	
	#
	
	knock_up_towers_ability = BaseAbility.new()
	
	knock_up_towers_ability.is_timebound = true
	
	register_ability(knock_up_towers_ability)
	
	knock_up_ability_activation_clauses = knock_up_towers_ability.activation_conditional_clauses
	current_abilities_ids_ability_map[PeriodicAbilities.KNOCK_UP_TOWERS] = knock_up_towers_ability
	
	knock_up_towers_ability.auto_cast_func = "_cast_knock_up_ability"
	

#

func _on_enemy_entered_range_d(enemy):
	if enemy is AbstractFaithfulEnemy:
		enemy.on_self_enter_deity_range(self)
		_increment_faithfuls_in_range_by(1)
		
		if enemy.enemy_id == EnemyConstants.Enemies.SACRIFICER:
			_increment_sacrificers_in_range_by(1)
		elif enemy.enemy_id == EnemyConstants.Enemies.SEER:
			_increment_seers_in_range_by(1)


func _on_enemy_left_range_d(enemy):
	if enemy is AbstractFaithfulEnemy:
		enemy.on_self_leave_deity_range(self)
		_increment_faithfuls_in_range_by(-1)
		
		if enemy.enemy_id == EnemyConstants.Enemies.SACRIFICER:
			_increment_sacrificers_in_range_by(-1)
		elif enemy.enemy_id == EnemyConstants.Enemies.SEER:
			_increment_seers_in_range_by(-1)

#

func _increment_faithfuls_in_range_by(arg_amount : int):
	faithfuls_in_range += arg_amount
	
	_update_armor_toughness_effect_from_faithfuls()

func _update_armor_toughness_effect_from_faithfuls():
	var amounts : float = base_armor_toughness_amount_per_faithful * faithfuls_in_range * last_calculated_final_ability_potency
	if faithfuls_in_range > 0:
		statusbar.add_status_icon(armor_modi_uuid, ArmorToughness_StatusBarIcon)
	else:
		statusbar.remove_status_icon(armor_modi_uuid)
	
	armor_modi.flat_modifier = amounts
	toughness_modi.flat_modifier = amounts
	
	calculate_final_armor()
	calculate_final_toughness()


#

func _increment_sacrificers_in_range_by(arg_amount : int):
	sacrificers_in_range += arg_amount
	
	_update_heal_effect_from_sacrificers()
	
	if !_first_time_sacrificer_went_to_range:
		_first_time_sacrificer_went_to_range = true
		_heal_timer_expired()

func _update_heal_effect_from_sacrificers():
	var amounts : float = base_health_regen_per_sec_per_sacrificer * sacrificers_in_range * last_calculated_final_ability_potency
	if sacrificers_in_range > 0:
		statusbar.add_status_icon(heal_modi_uuid, HealthRegen_StatusBarIcon)
	else:
		statusbar.remove_status_icon(heal_modi_uuid)
	
	heal_modi.flat_modifier = amounts

#

func _increment_seers_in_range_by(arg_amount : int):
	seers_in_range += arg_amount
	
	_update_ap_effect_from_seers()

func _update_ap_effect_from_seers():
	var amounts : float = base_ap_per_seer * seers_in_range
	if seers_in_range > 0:
		statusbar.add_status_icon(ap_modi_uuid, AP_StatusBarIcon)
	else:
		statusbar.remove_status_icon(ap_modi_uuid)
	
	ap_modi.flat_modifier = amounts
	
	calculate_final_ability_potency()
	_on_ability_potency_changed_d(last_calculated_final_ability_potency)


#

func _on_ability_potency_changed_d(new_amount):
	_update_armor_toughness_effect_from_faithfuls()
	_update_heal_effect_from_sacrificers()
	
	revive_effect.heal_effect_upon_revival.heal_as_modifier.percent_amount = revive_heal_amount * last_calculated_final_ability_potency
	tower_target_priority_effect.time_in_seconds = taunt_duration * last_calculated_final_ability_potency
	
	knock_up_effect.time_in_seconds = knock_up_duration * last_calculated_final_ability_potency
	knock_up_effect.custom_stun_duration = knock_up_stun_duration * last_calculated_final_ability_potency
	knock_up_effect.knock_up_y_acceleration = knock_up_y_accel_amount * last_calculated_final_ability_potency
	


#

func _heal_timer_expired():
	if sacrificers_in_range > 0:
		_add_effect(heal_effect)
	
	_heal_timer.start(1)


#

func _on_rotation_ability_ready_updated(is_ready):
	if is_ready:
		var ability := _get_next_ready_ability()
		
		if ability != null:
			call(ability.auto_cast_func)
			rotation_ability.start_time_cooldown(current_ability_rotation_cooldown_amount)
		else:
			rotation_ability.start_time_cooldown(1)


func _get_next_ready_ability() -> BaseAbility:
	var next_candidiate_id : int = _cycle_to_next_ability_id(last_casted_ability_id)
	var check_cycle_count : int = 0
	
	var ability : BaseAbility = null
	
	if current_abilities_ids_ability_map.size() != 0:
		ability = current_abilities_ids_ability_map[next_candidiate_id]
		while !ability.is_ready_for_activation():
			next_candidiate_id = _cycle_to_next_ability_id(next_candidiate_id)
			ability = current_abilities_ids_ability_map[next_candidiate_id]
			check_cycle_count += 1
			
			if check_cycle_count > current_abilities_ids_ability_map.size():
				break
	
	last_casted_ability_id = next_candidiate_id
	return ability

func _cycle_to_next_ability_id(curr_ability_id : int):
	curr_ability_id += 1
	
	if !current_abilities_ids_ability_map.has(curr_ability_id):
		curr_ability_id = 0
	
	return curr_ability_id


#

func _cast_taunt_ability():
	for tower in tower_detecting_range_module.get_all_in_map_and_active_towers_in_range():
		if tower != null and tower.range_module != null and tower.range_module.is_an_enemy_in_range():
			tower.add_tower_effect(tower_target_priority_effect)



#

func _cast_grant_revive_ability():
	var enemies = range_module.get_targets_without_affecting_self_current_targets(int(revive_target_count * last_calculated_final_ability_potency) + 1)
	
	for enemy in enemies:
		if enemy != self:
			enemy._add_effect(revive_effect)




#

func _cast_knock_up_ability():
	for tower in tower_detecting_range_module.get_all_in_map_and_active_towers_in_range():
		if tower != null:
			tower.add_tower_effect(knock_up_effect)
	


#

func _physics_process(delta):
	_remove_max_health_if_surpassed_cross_marker()

func _remove_max_health_if_surpassed_cross_marker():
	if _if_surpassed_cross_marker() and _percent_base_health_id_effect_map.has(StoreOfEnemyEffectsUUID.DEITY_MAX_HEALTH_GAIN_EFFECT):
		_remove_effect(max_health_effect)

func _if_surpassed_cross_marker():
	return unit_offset > _current_cross_marker_unit_offset
