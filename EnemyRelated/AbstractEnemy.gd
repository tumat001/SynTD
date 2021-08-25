extends PathFollow2D

const Modifier = preload("res://GameInfoRelated/Modifier.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const EnemyBaseEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd")
const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const BaseAbility = preload("res://GameInfoRelated/AbilityRelated/BaseAbility.gd")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")
const EnemyClearAllEffects = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyClearAllEffects.gd")
const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")
const EnemyDmgOverTimeEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyDmgOverTimeEffect.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const EnemyHealEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyHealEffect.gd")
const EnemyHealOverTimeEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyHealOverTimeEffect.gd")
const EnemyShieldEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyShieldEffect.gd")
const EnemyInvisibilityEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyInvisibilityEffect.gd")
const EnemyReviveEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyReviveEffect.gd")
const EnemyKnockUpEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyKnockUpEffect.gd")
const BeforeEnemyReachEndPathBaseEffect = preload("res://GameInfoRelated/EnemyEffectRelated/BeforeEnemyReachEndPathBaseEffect.gd")

const OnHitDamageReport = preload("res://TowerRelated/DamageAndSpawnables/ReportsRelated/OnHitDamageReport.gd")
const DamageInstanceReport = preload("res://TowerRelated/DamageAndSpawnables/ReportsRelated/DamageInstanceReport.gd")

const BaseControlStatusBar = preload("res://MiscRelated/ControlStatusBarRelated/BaseControlStatusBar.gd")
const EnemyConstants = preload("res://EnemyRelated/EnemyConstants.gd")
const EnemyTypeInformation = preload("res://EnemyRelated/EnemyTypeInformation.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const DuringReviveParticle = preload("res://EnemyRelated/CommonParticles/ReviveParticle/DuringReviveParticle.gd")
const DuringReviveParticle_Scene = preload("res://EnemyRelated/CommonParticles/ReviveParticle/DuringReviveParticle.tscn")


signal on_death_by_any_cause
signal on_hit(me, damage_reg_id, damage_instance)
signal on_post_mitigated_damage_taken(damage_instance_report, is_lethal, me)
signal on_killed_by_damage(damage_instance_report, me)
signal before_damage_instance_is_processed(damage_instance, me)

signal reached_end_of_path(me)
signal on_current_health_changed(current_health)
signal on_current_shield_changed(current_shield)
signal on_max_health_changed(max_health)

signal shield_broken(shield_id)
signal all_shields_broken()

signal on_overheal(overheal_amount)

signal effect_removed(effect, me)
signal effect_added(effect, me)

signal on_starting_revive()
signal on_revive_completed()
signal cancel_all_lockons() # on death, reviving, etc


enum NoMovementClauses {
	IS_REVIVING = 100,
	
	CUSTOM_CLAUSE_01 = 200,
	CUSTOM_CLAUSE_02 = 201,
}

enum NoActionClauses {
	IS_REVIVING = 100,
}

enum UntargetabilityClauses {
	IS_REVIVING = 100,
	IS_INVISIBLE = 101,
}

var base_health : float = 1
var _flat_base_health_id_effect_map : Dictionary = {}
var _percent_base_health_id_effect_map : Dictionary = {}
var current_health : float = 1
var _last_calculated_max_health : float


var shield_id_effect_map : Dictionary = {}
var current_shield : float = 0

var pierce_consumed_per_hit : float = 1

var base_armor : float = 0
var flat_armor_id_effect_map : Dictionary = {}
var percent_armor_id_effect_map : Dictionary = {}
var _last_calculated_final_armor : float

var base_toughness : float = 0
var flat_toughness_id_effect_map : Dictionary = {}
var percent_toughness_id_effect_map : Dictionary = {}
var _last_calculated_final_toughness : float

var base_resistance : float = 0
var flat_resistance_id_effect_map : Dictionary = {}
var percent_resistance_id_effect_map : Dictionary= {}
var _last_calculated_final_resistance : float

var base_player_damage : float
var flat_player_damage_id_effect_map : Dictionary = {}
var percent_player_damage_id_effect_map : Dictionary = {}
# final player damage is calculated when enemy escapes

var base_movement_speed : float
var flat_movement_speed_id_effect_map : Dictionary = {}
var percent_movement_speed_id_effect_map : Dictionary = {}
var _last_calculated_final_movement_speed : float

var base_effect_vulnerability : float = 1
var flat_effect_vulnerability_id_effect_map : Dictionary = {}
var percent_effect_vulnerability_id_effect_map : Dictionary = {}
var last_calculated_final_effect_vulnerability : float = base_effect_vulnerability

var base_percent_health_hit_scale : float = 1
var flat_percent_health_hit_scale_id_effect_map : Dictionary = {}
var percent_percent_health_hit_scale_id_effect_map : Dictionary = {}
var last_calculated_percent_health_hit_scale : float = base_percent_health_hit_scale

var invisibility_id_effect_map : Dictionary = {}
var last_calculated_invisibility_status : bool = false

var revive_id_effect_map : Dictionary = {}
var current_revive_effect : EnemyReviveEffect
var is_reviving : bool = false


var distance_to_exit : float
var current_path_length : float

var no_movement_from_self_clauses : ConditionalClauses
var last_calculated_no_movement_from_self : bool = false

var no_action_from_self_clauses : ConditionalClauses
var last_calculated_no_action_from_self : bool = false

var untargetable_clauses : ConditionalClauses
var last_calculated_is_untargetable : bool = false


var all_abilities : Array = []


# Enemy properties

# makes the round not end when there is at least one of these enemies with this property on.
# does not update in real time (only before enemy is added to manager)
var blocks_from_round_ending : bool = true
var exits_when_at_map_end : bool = true

var respect_stage_round_health_scale : bool = true


# knock up related

# makes use of anim_sprite.offset.y
var _knock_up_current_acceleration : float
var _knock_up_current_acceleration_deceleration : float

#

onready var statusbar : BaseControlStatusBar = $Layer/EnemyInfoBar/VBoxContainer/EnemyStatusBar
onready var lifebar = $Layer/EnemyInfoBar/VBoxContainer/LifeBar
onready var infobar = $Layer/EnemyInfoBar
onready var layer_infobar = $Layer
onready var collision_area = $CollisionArea
onready var anim_sprite = $AnimatedSprite

#internals

var _self_size : Vector2

# Effects map

var _stack_id_effects_map : Dictionary = {}
var _stun_id_effects_map : Dictionary = {}
var _is_stunned : bool
var _dmg_over_time_id_effects_map : Dictionary = {}
var _heal_over_time_id_effects_map : Dictionary = {}
var _before_reaching_end_path_effects_map : Dictionary = {}

var _all_effects_map : Dictionary = {}


func _init():
	no_movement_from_self_clauses = ConditionalClauses.new()
	no_movement_from_self_clauses.connect("clause_inserted", self, "_no_movement_clause_added")
	no_movement_from_self_clauses.connect("clause_removed", self, "_no_movement_clause_removed")
	
	no_action_from_self_clauses = ConditionalClauses.new()
	no_action_from_self_clauses.connect("clause_inserted", self, "_no_action_clause_added")
	no_action_from_self_clauses.connect("clause_removed", self, "_no_action_clause_removed")
	
	untargetable_clauses = ConditionalClauses.new()
	untargetable_clauses.connect("clause_inserted", self, "_untargetability_clause_added")
	untargetable_clauses.connect("clause_removed", self, "_untargetability_clause_removed")


func _stats_initialize(info : EnemyTypeInformation):
	base_health = info.base_health
	base_movement_speed = info.base_movement_speed
	base_armor = info.base_armor
	base_toughness = info.base_toughness
	base_resistance = info.base_resistance
	base_player_damage = info.base_player_damage
	base_effect_vulnerability = info.base_effect_vulnerability



# Clauses related

func _no_movement_clause_added(clause):
	last_calculated_no_movement_from_self = true

func _no_movement_clause_removed(clause):
	last_calculated_no_movement_from_self = !no_movement_from_self_clauses.is_passed


func _no_action_clause_added(clause):
	last_calculated_no_action_from_self = true

func _no_action_clause_removed(clause):
	last_calculated_no_action_from_self = !no_action_from_self_clauses.is_passed


func _untargetability_clause_added(clause):
	last_calculated_is_untargetable = true

func _untargetability_clause_removed(clause):
	last_calculated_is_untargetable = !untargetable_clauses.is_passed

func is_untargetable_only_from_invisibility():
	return untargetable_clauses.has_clause(UntargetabilityClauses.IS_INVISIBLE) and untargetable_clauses._clauses.size() == 1


# Called when the node enters the scene tree for the first time.
func _ready():
	_self_size = get_current_anim_size()
	
	var scale_of_layer : float = _get_scale_for_layer_lifebar()
	layer_infobar.scale = Vector2(scale_of_layer, scale_of_layer)
	layer_infobar.z_index = ZIndexStore.ENEMY_INFO_BAR
	layer_infobar.z_as_relative = false
	#infobar.rect_position.y -= round((_self_size.y) + 11)
	#infobar.rect_position.x -= round(healthbar.get_bar_fill_foreground_size().x / 2)
	layer_infobar.position.y -= round((_self_size.y) + 11)
	layer_infobar.position.x -= round(lifebar.get_bar_fill_foreground_size().x / 4)
	
	
	var shift = (_self_size.y / 2) - 5
	anim_sprite.position.y -= shift
	collision_area.position.y -= shift
	$Layer.position.y -= shift
	
	connect("on_current_health_changed", lifebar, "set_current_health_value", [], CONNECT_PERSIST)
	connect("on_current_shield_changed", lifebar, "set_current_shield_value", [], CONNECT_PERSIST)
	connect("on_max_health_changed", lifebar, "set_max_value", [], CONNECT_PERSIST)
	
	
	
	# TEST
	
	#
	
	_post_inherit_ready()


func _post_inherit_ready():
	calculate_final_armor()
	calculate_final_toughness()
	calculate_final_resistance()
	calculate_final_movement_speed()
	calculate_max_health()
	calculate_effect_vulnerability()
	calculate_percent_health_hit_scale()
	calculate_current_shield()
	calculate_invisibility_status()
	
	#
#	var heal_modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.HEALER_HEAL_EFFECT)
#	heal_modi.flat_modifier = 10.0
#
#	var heal_effect = EnemyHealEffect.new(heal_modi, StoreOfEnemyEffectsUUID.HEALER_HEAL_EFFECT)
#	heal_effect.is_from_enemy = true
#
#	var revive_effect = EnemyReviveEffect.new(heal_effect, 9999, 5)
#	revive_effect.is_from_enemy = true
#	_add_effect(revive_effect)
	
	#
	current_health = _last_calculated_max_health
	
	lifebar.current_health_value = current_health
	lifebar.current_shield_value = current_shield
	lifebar.max_value = _last_calculated_max_health



func get_current_anim_size() -> Vector2:
	return anim_sprite.frames.get_frame(anim_sprite.animation, anim_sprite.frame).get_size()

func _get_scale_for_layer_lifebar() -> float:
	var threshold_health_for_inc : float = 100
	var base_scale : float = 0.5
	
	
	
	return base_scale


#

func _process(delta):
	_decrease_time_of_timebounds(delta)
	
	for ability in all_abilities:
		ability.time_decreased(delta)
	
	_decrease_time_of_current_revive_effect(delta)



func _physics_process(delta):
	_phy_process_knock_up(delta)
	
	if !_is_stunned and !last_calculated_no_movement_from_self:
		var distance_traveled = delta * _last_calculated_final_movement_speed
		offset += distance_traveled
		distance_to_exit -= distance_traveled
	
	if unit_offset == 1 and exits_when_at_map_end:
		var exit_prevented : bool = false
		var effects_consumed : Array = []
		for effect in _before_reaching_end_path_effects_map.values():
			if effect.prevent_exit:
				exit_prevented = true
			
			effect.before_enemy_reached_exit(self)
			#effect.call_deferred("before_enemy_reached_exit", self)
			
			effects_consumed.append(effect)
		
		for effect in effects_consumed:
			_remove_effect(effect)
		
		if !exit_prevented:
			call_deferred("emit_signal", "reached_end_of_path", self)



# Health related functions. Different from the norm
# because percentages must be preserved when removing
# flats and percentages. Also must heal when flats
# and percentages are added
func calculate_max_health() -> float:
	var max_health = base_health
	for effect in _percent_base_health_id_effect_map.values():
		max_health += effect.attribute_as_modifier.get_modification_to_value(base_health)
	
	for effect in _flat_base_health_id_effect_map.values():
		max_health += effect.attribute_as_modifier.flat_modifier
	
	_last_calculated_max_health = max_health
	emit_signal("on_max_health_changed", _last_calculated_max_health)
	if current_health > _last_calculated_max_health:
		current_health = _last_calculated_max_health
		emit_signal("on_current_health_changed", current_health)
	
	return max_health


# healing

func heal_from_effect(eff : EnemyHealEffect):
	var mod = eff.heal_as_modifier
	if mod is FlatModifier:
		if eff.allows_overhealing:
			flat_heal_with_overhealing(mod.flat_modifier)
		else:
			flat_heal_without_overhealing(mod.flat_modifier)
		
	elif mod is PercentModifier:
		if eff.allows_overhealing:
			percent_heal_with_overhealing(mod)
		else:
			percent_heal_without_overhealing(mod)


func flat_heal_without_overhealing(heal_amount):
	if heal_amount < 0:
		heal_amount = 0
	
	var total_amount : float = current_health + heal_amount
	var final_hp_set : float
	if total_amount > _last_calculated_max_health:
		var diff = _last_calculated_max_health - current_health
		final_hp_set = current_health + diff
	else:
		final_hp_set = current_health + heal_amount
	
	_set_current_health_to(final_hp_set)

func flat_heal_with_overhealing(heal_amount):
	if heal_amount < 0:
		heal_amount = 0
	
	_set_current_health_to(current_health + heal_amount, true)


func percent_heal_without_overhealing(heal_mod : PercentModifier):
	var total_amount : float
	
	if heal_mod.percent_based_on == PercentType.MAX:
		total_amount = heal_mod.get_modification_to_value(_last_calculated_max_health)
	elif heal_mod.percent_based_on == PercentType.BASE:
		total_amount = heal_mod.get_modification_to_value(base_health)
	elif heal_mod.percent_based_on == PercentType.CURRENT:
		total_amount = heal_mod.get_modification_to_value(current_health)
	elif heal_mod.percent_based_on == PercentType.MISSING:
		total_amount = heal_mod.get_modification_to_value(_last_calculated_max_health - current_health)
	
	flat_heal_without_overhealing(total_amount)

func percent_heal_with_overhealing(heal_mod : PercentModifier):
	var total_amount : float
	
	if heal_mod.percent_based_on == PercentType.MAX:
		total_amount = heal_mod.get_modification_to_value(_last_calculated_max_health)
	elif heal_mod.percent_based_on == PercentType.BASE:
		total_amount = heal_mod.get_modification_to_value(base_health)
	elif heal_mod.percent_based_on == PercentType.CURRENT:
		total_amount = heal_mod.get_modification_to_value(current_health)
	elif heal_mod.percent_based_on == PercentType.MISSING:
		total_amount = heal_mod.get_modification_to_value(_last_calculated_max_health - current_health)
	
	flat_heal_with_overhealing(total_amount)

#

func _set_current_health_to(health_amount, from_overheal : bool = false):
	current_health = health_amount
	
	if current_health > _last_calculated_max_health:
		if from_overheal:
			emit_signal("on_overheal", current_health - _last_calculated_max_health)
		current_health = _last_calculated_max_health
	
	emit_signal("on_current_health_changed", current_health)


func execute_self_by(source_id : int):
	_take_unmitigated_damages([[current_health, DamageType.PURE, source_id]], null)

# The only function that should handle taking
# damage and health deduction. Also where
# death is handled
func _take_unmitigated_damages(damages_and_types : Array, dmg_instance):
	if !is_reviving:
		var damage_instance_report : DamageInstanceReport = DamageInstanceReport.new()
		damage_instance_report.dmg_instance_ref = weakref(dmg_instance)
		
		for damage_and_type in damages_and_types: #on hit id in third index
			var damage_amount = damage_and_type[0]
			var on_hit_id = damage_and_type[2]
			
			var on_hit_report := OnHitDamageReport.new(damage_amount, damage_and_type[1], on_hit_id)
			var effective_on_hit_report : OnHitDamageReport
			
			if current_health > 0:
				effective_on_hit_report = on_hit_report
				
				_take_unmitigated_damage_to_life(damage_amount)
				
				if current_health <= 0:
					var effective_damage = damage_amount + current_health
					effective_on_hit_report = effective_on_hit_report.duplicate()
					effective_on_hit_report.damage = effective_damage
			
			damage_instance_report.all_post_mitigated_on_hit_damages[on_hit_id] = on_hit_report
			if effective_on_hit_report != null:
				damage_instance_report.all_effective_on_hit_damages[on_hit_id] = effective_on_hit_report
		
		
		if current_health <= 0:
			emit_signal("on_post_mitigated_damage_taken", damage_instance_report, true, self)
			emit_signal("on_killed_by_damage", damage_instance_report, self)
			_destroy_self()
			
		else:
			emit_signal("on_post_mitigated_damage_taken", damage_instance_report, false, self)



# see _take_unmitigated_damages()
func _take_unmitigated_damage_to_life(damage_amount : float):
	var overflow_damage : float = damage_amount
	var had_shields : bool = false
	var shield_effects_id_to_remove : Array = []
	
	for i in range(shield_id_effect_map.size() - 1, -1, -1):
		had_shields = true
		
		if overflow_damage <= 0:
			break
		
		var effect : EnemyShieldEffect = shield_id_effect_map.values()[i]
		
		effect._current_shield -= overflow_damage
		if effect._current_shield <= 0:
			shield_effects_id_to_remove.append(effect.effect_uuid)
			
			if effect.absorb_overflow_damage:
				overflow_damage = 0
			else:
				overflow_damage = -effect._current_shield
		else:
			overflow_damage = 0
	
	
	for shield_uuid in shield_effects_id_to_remove:
		remove_shield_effect(shield_uuid, false)
	
	if had_shields:
		calculate_current_shield()
	
	if overflow_damage > 0:
		_set_current_health_to(current_health - overflow_damage)



#

func _destroy_self():
	collision_area.set_deferred("monitorable", false)
	collision_area.set_deferred("monitoring", false)
	
	if revive_id_effect_map.size() == 0:
		queue_free()
	else:
		_trigger_start_of_revive()


func queue_free():
	emit_signal("on_death_by_any_cause")
	emit_signal("cancel_all_lockons")
	
	.queue_free()



func add_flat_base_health_effect(effect : EnemyAttributesEffect, with_heal : bool = true):
	_flat_base_health_id_effect_map[effect.effect_uuid] = effect
	var old_max_health = _last_calculated_max_health
	calculate_max_health()
	
	if with_heal:
		var heal = _last_calculated_max_health - old_max_health
		if heal > 0:
			flat_heal_without_overhealing(heal)

func add_percent_base_health_effect(effect : EnemyAttributesEffect, with_heal : bool = true):
	_percent_base_health_id_effect_map[effect.effect_uuid] = effect
	var old_max_health = _last_calculated_max_health
	calculate_max_health()
	
	if with_heal:
		var heal = _last_calculated_max_health - old_max_health
		if heal > 0:
			flat_heal_without_overhealing(heal)

func remove_flat_base_health_effect_preserve_percent(effect_uuid : int):
	if _flat_base_health_id_effect_map.has(effect_uuid):
		var flat_mod : FlatModifier = _flat_base_health_id_effect_map[effect_uuid].attribute_as_modifier
		var flat_remove = flat_mod.flat_modifier
		
		var old_max = _last_calculated_max_health
		_flat_base_health_id_effect_map.erase(effect_uuid)
		calculate_max_health()
		var new_max = _last_calculated_max_health
		
		_set_current_health_to(preserve_percent(old_max, new_max, current_health))


func remove_percent_base_health_effect_preserve_percent(effect_uuid : int):
	if _percent_base_health_id_effect_map.has(effect_uuid):
		var percent_mod : PercentModifier = _percent_base_health_id_effect_map[effect_uuid].attribute_as_modifier
		
		var old_max = _last_calculated_max_health
		_percent_base_health_id_effect_map.erase(effect_uuid)
		calculate_max_health()
		var new_max = _last_calculated_max_health
		
		_set_current_health_to(preserve_percent(old_max, new_max, current_health))


static func preserve_percent(old_max : float, new_max : float, current : float) -> float:
	var old_ratio = current / old_max
	return new_max * old_ratio


# Calc of shield

func calculate_current_shield() -> float:
	var final_shield : float
	for effect in shield_id_effect_map.values():
		final_shield += effect._current_shield
	
	current_shield = final_shield
	
	emit_signal("on_current_shield_changed", current_shield)
	
	return current_shield


func add_shield_effect(shield_effect : EnemyShieldEffect):
	shield_id_effect_map[shield_effect.effect_uuid] = shield_effect
	var mod = shield_effect.shield_as_modifier
	var curr_shield : float
	
	if mod is FlatModifier:
		curr_shield = mod.flat_modifier
	elif mod is PercentModifier:
		if mod.percent_based_on == PercentType.MAX:
			curr_shield = mod.get_modification_to_value(_last_calculated_max_health)
		elif mod.percent_based_on == PercentType.BASE:
			curr_shield = mod.get_modification_to_value(base_health)
		elif mod.percent_based_on == PercentType.CURRENT:
			curr_shield = mod.get_modification_to_value(current_health)
		elif mod.percent_based_on == PercentType.MISSING:
			curr_shield = mod.get_modification_to_value(_last_calculated_max_health - current_health)
	
	shield_effect._current_shield = curr_shield
	
	calculate_current_shield()


func remove_shield_effect(effect_uuid : int, cause_calculate : bool = true):
	shield_id_effect_map.erase(effect_uuid)
	emit_signal("shield_broken", effect_uuid)
	
	if cause_calculate:
		calculate_current_shield()



# Calculation of attributes

func calculate_final_armor() -> float:
	#All percent modifiers here are to BASE armor only
	var final_armor = base_armor
	for effect in percent_armor_id_effect_map.values():
		final_armor += effect.attribute_as_modifier.get_modification_to_value(base_armor)
	
	for effect in flat_armor_id_effect_map.values():
		final_armor += effect.attribute_as_modifier.get_modification_to_value(base_armor)
	
	_last_calculated_final_armor = final_armor
	return final_armor

func calculate_final_toughness() -> float:
	#All percent modifiers here are to BASE toughness only
	var final_toughness = base_toughness
	for effect in percent_toughness_id_effect_map.values():
		final_toughness += effect.attribute_as_modifier.get_modification_to_value(base_toughness)
	
	for effect in flat_toughness_id_effect_map.values():
		final_toughness += effect.attribute_as_modifier.get_modification_to_value(base_toughness)
	
	_last_calculated_final_toughness = final_toughness
	return final_toughness


func calculate_final_resistance() -> float:
	#All percent modifiers here are to BASE resistance only
	var final_resistance = base_resistance
	for effect in percent_resistance_id_effect_map.values():
		final_resistance = _get_add_resistance_to_total_resistance(effect.attribute_as_modifier.get_modification_to_value(base_resistance), final_resistance)
	
	for effect in flat_resistance_id_effect_map.values():
		final_resistance = _get_add_resistance_to_total_resistance(effect.attribute_as_modifier.get_modification_to_value(base_resistance), final_resistance)
	
	
	if final_resistance < 0:
		final_resistance = 0
	elif final_resistance > 100: # should not reach here
		final_resistance = 100
	
	_last_calculated_final_resistance = final_resistance
	return final_resistance

func _get_add_resistance_to_total_resistance(arg_res, arg_total_res) -> float:
	var missing = 100 - arg_total_res
	
	return arg_total_res + (arg_res * (1 - ((100 - missing) / 100)))


func calculate_effect_vulnerability() -> float:
	#All percent modifiers here are to BASE values only
	var final_effect_vul = base_effect_vulnerability
	for effect in percent_effect_vulnerability_id_effect_map.values():
		final_effect_vul += effect.attribute_as_modifier.get_modification_to_value(base_effect_vulnerability)
	
	for effect in flat_effect_vulnerability_id_effect_map.values():
		final_effect_vul += effect.attribute_as_modifier.flat_modifier
	
	last_calculated_final_effect_vulnerability = final_effect_vul
	return final_effect_vul

func calculate_percent_health_hit_scale() -> float:
	#All percent modifiers here are to BASE values only
	var final_scale = base_percent_health_hit_scale
	for effect in percent_percent_health_hit_scale_id_effect_map.values():
		final_scale += effect.attribute_as_modifier.get_modification_to_value(base_percent_health_hit_scale)
	
	for effect in flat_percent_health_hit_scale_id_effect_map.values():
		final_scale += effect.attribute_as_modifier.flat_modifier
	
	last_calculated_percent_health_hit_scale = final_scale
	return final_scale

func calculate_invisibility_status() -> bool:
	last_calculated_invisibility_status = invisibility_id_effect_map.size() != 0
	
	if last_calculated_invisibility_status:
		modulate.a = 0.4
		emit_signal("cancel_all_lockons")
		untargetable_clauses.attempt_insert_clause(UntargetabilityClauses.IS_INVISIBLE)
	else:
		modulate.a = 1
		untargetable_clauses.remove_clause(UntargetabilityClauses.IS_INVISIBLE)
	
	return last_calculated_invisibility_status


# damage multiplier

func _calculate_multiplier_from_total_armor(armor_pierce : float, percent_self_armor_pierce : float) -> float:
	var total_armor = _last_calculated_final_armor - (percent_self_armor_pierce * _last_calculated_final_armor / 100)
	total_armor = total_armor - armor_pierce
	if total_armor >= 0:
		return 20 / (20 + total_armor)
	else:
		return 2 - (40 / (40 - total_armor))

func _calculate_multiplier_from_total_toughness(toughness_pierce : float, percent_self_toughness_pierce : float):
	var total_toughness = _last_calculated_final_toughness - (percent_self_toughness_pierce * _last_calculated_final_toughness / 100)
	total_toughness = total_toughness - toughness_pierce
	if total_toughness >= 0:
		return 20 / (20 + total_toughness)
	else:
		return 2 - (40 / (40 - total_toughness))

func _calculate_multiplier_from_total_resistance(resistance_pierce : float, percent_self_resistance_pierce : float):
	var total_resistance = _last_calculated_final_resistance - (percent_self_resistance_pierce * _last_calculated_final_resistance / 100)
	total_resistance = total_resistance - resistance_pierce
	
	var multiplier = (100 - total_resistance) / 100
	if multiplier < 0:
		multiplier = 0
	return multiplier

func _subtract_but_result_above_negative(num : float, subtractor : float):
	var value = num - subtractor
	if value < 0:
		value = 0
	
	return value


# calc final values prt2

func calculate_final_player_damage() -> float:
	#All percent modifiers here are to BASE player damage only
	var final_player_damage = base_player_damage
	for effect in percent_player_damage_id_effect_map.values():
		final_player_damage += effect.attribute_as_modifier.get_modification_to_value(base_player_damage)
	
	for effect in flat_player_damage_id_effect_map.values():
		final_player_damage += effect.attribute_as_modifier.get_modification_to_value(base_player_damage)
	
	if final_player_damage < 0:
		final_player_damage = 0
	
	return final_player_damage

func calculate_final_movement_speed() -> float:
	#All percent modifiers here are to BASE mvnt speed only
	var highest_slow : float
	var excess_slow : float
	var highest_speed : float
	var excess_speed : float
	
	for effect in percent_movement_speed_id_effect_map.values():
		var speed_change = effect.attribute_as_modifier.get_modification_to_value(base_movement_speed)
		if speed_change > 0:
			if highest_speed < speed_change:
				excess_speed += highest_speed
				highest_speed = speed_change
			else:
				excess_speed += speed_change
			
		elif speed_change < 0:
			if highest_slow > speed_change:
				excess_slow += highest_slow
				highest_slow = speed_change
			else:
				excess_slow += speed_change
	
	for effect in flat_movement_speed_id_effect_map.values():
		var speed_change = effect.attribute_as_modifier.get_modification_to_value(base_movement_speed)
		if speed_change > 0:
			if highest_speed < speed_change:
				excess_speed += highest_speed
				highest_speed = speed_change
			else:
				excess_speed += speed_change
			
		elif speed_change < 0:
			if highest_slow > speed_change:
				excess_slow += highest_slow
				highest_slow = speed_change
			else:
				excess_slow += speed_change
	
	var final_change = highest_speed + highest_slow
	if final_change > 0:
		final_change -= excess_slow
		
		if final_change < 0:
			final_change = 0
		
		
	elif final_change < 0:
		final_change += excess_speed
		
		if final_change > 0:
			final_change = 0
		
	
	var final_movement_speed = base_movement_speed + final_change
	if final_change < 0 and final_movement_speed < 1:
		final_movement_speed = 1
	
	_last_calculated_final_movement_speed = final_movement_speed
	return final_movement_speed


#Process damages
# hit by things functions here. Processes
# on hit damages and effects.
func hit_by_bullet(generic_bullet : BaseBullet):
	if !is_reviving:
		if !generic_bullet.enemies_ignored.has(self):
			generic_bullet.hit_by_enemy(self)
			generic_bullet.decrease_pierce(pierce_consumed_per_hit)
			if generic_bullet.attack_module_source != null:
				connect("on_hit", generic_bullet.attack_module_source, "on_enemy_hit", [], CONNECT_ONESHOT)
				connect("on_post_mitigated_damage_taken", generic_bullet.attack_module_source, "on_post_mitigation_damage_dealt", [generic_bullet.damage_register_id], CONNECT_ONESHOT)
			
			hit_by_damage_instance(generic_bullet.damage_instance, generic_bullet.damage_register_id)
			generic_bullet.reduce_damage_by_beyond_first_multiplier()


func hit_by_aoe(base_aoe):
	if !is_reviving:
		if base_aoe.attack_module_source != null:
			connect("on_hit", base_aoe.attack_module_source, "on_enemy_hit", [], CONNECT_ONESHOT)
			connect("on_post_mitigated_damage_taken", base_aoe.attack_module_source, "on_post_mitigation_damage_dealt", [base_aoe.damage_register_id], CONNECT_ONESHOT)
		
		hit_by_damage_instance(base_aoe.damage_instance, base_aoe.damage_register_id)


func hit_by_damage_instance(damage_instance : DamageInstance, damage_reg_id : int = 0, emit_on_hit_signal : bool = true):
	if !is_reviving:
		# no need for copy since we don't make changes to it
		#damage_instance = damage_instance.get_copy_scaled_by(1)
		
		if emit_on_hit_signal:
			emit_signal("on_hit", self, damage_reg_id, damage_instance)
		
		emit_signal("before_damage_instance_is_processed", damage_instance, self)
		_process_on_hit_damages(damage_instance.on_hit_damages, damage_instance)
		_process_effects(damage_instance.on_hit_effects, damage_instance.on_hit_effect_multiplier)


func _process_on_hit_damages(on_hit_damages : Dictionary, damage_instance):
	var damages : Array = []
	
	for on_hit_key in on_hit_damages.keys():
		var on_hit_damage : OnHitDamage = on_hit_damages[on_hit_key]
		
		if on_hit_damage.damage_as_modifier is FlatModifier:
			damages.append(_process_flat_damage(on_hit_damage.damage_as_modifier, on_hit_damage.damage_type, damage_instance, on_hit_damage.internal_id))
		elif on_hit_damage.damage_as_modifier is PercentModifier:
			damages.append(_process_percent_damage(on_hit_damage.damage_as_modifier, on_hit_damage.damage_type, damage_instance, on_hit_damage.internal_id))
	
	_take_unmitigated_damages(damages, damage_instance)

func _process_percent_damage(damage_as_modifier: PercentModifier, damage_type : int, damage_instance, on_hit_id) -> Array:
	var percent_type = damage_as_modifier.percent_based_on
	var damage_as_flat : float
	
	if percent_type == PercentType.MAX:
		damage_as_flat = damage_as_modifier.get_modification_to_value(_last_calculated_max_health)
	elif percent_type == PercentType.BASE:
		damage_as_flat = damage_as_modifier.get_modification_to_value(base_health)
	elif percent_type == PercentType.CURRENT:
		damage_as_flat = damage_as_modifier.get_modification_to_value(current_health)
	elif percent_type == PercentType.MISSING:
		damage_as_flat = damage_as_modifier.get_modification_to_value(_last_calculated_max_health - current_health)
	
	damage_as_flat *= last_calculated_percent_health_hit_scale
	
	return _process_direct_damage_and_type(damage_as_flat, damage_type, damage_instance, on_hit_id)

func _process_flat_damage(damage_as_modifier : FlatModifier, damage_type : int, damage_instance, on_hit_id) -> Array:
	return _process_direct_damage_and_type(damage_as_modifier.flat_modifier, damage_type, damage_instance, on_hit_id)

func _process_direct_damage_and_type(damage : float, damage_type : int, damage_instance : DamageInstance, on_hit_id) -> Array:
	var final_damage = damage
	
	if on_hit_id == StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE:
		final_damage *= damage_instance.base_damage_multiplier
	else:
		final_damage *= damage_instance.on_hit_damage_multiplier
	
	
	if damage_type == DamageType.ELEMENTAL:
		final_damage *= _calculate_multiplier_from_total_toughness(damage_instance.final_toughness_pierce, damage_instance.final_percent_enemy_toughness_pierce)
		final_damage *= _calculate_multiplier_from_total_resistance(damage_instance.final_resistance_pierce, damage_instance.final_percent_enemy_resistance_pierce)
		
	elif damage_type == DamageType.PHYSICAL:
		final_damage *= _calculate_multiplier_from_total_armor(damage_instance.final_armor_pierce, damage_instance.final_percent_enemy_armor_pierce)
		final_damage *= _calculate_multiplier_from_total_resistance(damage_instance.final_resistance_pierce, damage_instance.final_percent_enemy_resistance_pierce)
		
	elif damage_type == DamageType.PURE:
		pass
	
	if final_damage < 0:
		final_damage = 0
	
	return [final_damage, damage_type, on_hit_id]


# Process effects related

func _process_effects(effects : Dictionary, multiplier : float = 1):
	for effect in effects.values():
		_add_effect(effect, multiplier)


# WHEN ADDING NEW EFFECT, LOOK AT:
# _remove_effect(), copy_enemy_stats(), decrease_timebounds()
func _add_effect(base_effect : EnemyBaseEffect, multiplier : float = 1, ignore_multiplier : bool = false) -> EnemyBaseEffect:
	if !base_effect.is_from_enemy:
		multiplier *= last_calculated_final_effect_vulnerability
	
	if ignore_multiplier:
		multiplier = 1
	
	var to_use_effect = base_effect._get_copy_scaled_by(multiplier)
	
	if to_use_effect.status_bar_icon != null:
		statusbar.add_status_icon(to_use_effect.effect_uuid, to_use_effect.status_bar_icon)
	
	if to_use_effect.should_map_in_all_effects_map:
		_all_effects_map[to_use_effect.effect_uuid] = to_use_effect
	
	
	if to_use_effect is EnemyStunEffect:
		if !_stun_id_effects_map.has(to_use_effect.effect_uuid):
			_stun_id_effects_map[to_use_effect.effect_uuid] = to_use_effect
		else:
			_stun_id_effects_map[to_use_effect.effect_uuid]._reapply(to_use_effect)
		
	elif to_use_effect is EnemyClearAllEffects:
		# When adding effects, update this
		_clear_effects_from_clear_effect()
		
	elif to_use_effect is EnemyStackEffect:
		
		if !_stack_id_effects_map.has(to_use_effect.effect_uuid):
			_stack_id_effects_map[to_use_effect.effect_uuid] = to_use_effect
			_stack_id_effects_map[to_use_effect.effect_uuid]._current_stack += to_use_effect.num_of_stacks_per_apply
		else:
			var stored_effect = _stack_id_effects_map[to_use_effect.effect_uuid]
			
			stored_effect._current_stack += to_use_effect.num_of_stacks_per_apply
			if stored_effect._current_stack >= stored_effect.stack_cap:
				if stored_effect.consume_all_stacks_on_cap:
					_remove_effect(stored_effect)
				else:
					stored_effect._current_stack -= stored_effect.stack_cap
				
				if stored_effect.base_effect != null:
					_add_effect(stored_effect.base_effect)
			else:
				if stored_effect.duration_refresh_per_apply:
					stored_effect.time_in_seconds = to_use_effect.time_in_seconds
		
	elif to_use_effect is EnemyDmgOverTimeEffect:
		if !_dmg_over_time_id_effects_map.has(to_use_effect.effect_uuid):
			_dmg_over_time_id_effects_map[to_use_effect.effect_uuid] = to_use_effect
			to_use_effect.connect_to_enemy(self)
		else:
			_dmg_over_time_id_effects_map[to_use_effect.effect_uuid]._reapply(to_use_effect)
		
	elif to_use_effect is EnemyAttributesEffect:
		if to_use_effect.attribute_type == EnemyAttributesEffect.FLAT_MOV_SPEED:
			flat_movement_speed_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_final_movement_speed()
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED:
			percent_movement_speed_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_final_movement_speed()
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.FLAT_ARMOR:
			flat_armor_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_final_armor()
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_ARMOR:
			percent_armor_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_final_armor()
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.FLAT_TOUGHNESS:
			flat_toughness_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_final_toughness()
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_TOUGHNESS:
			percent_toughness_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_final_toughness()
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.FLAT_RESISTANCE:
			flat_resistance_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_final_resistance()
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_RESISTANCE:
			percent_resistance_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_final_resistance()
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.FLAT_HEALTH:
			add_flat_base_health_effect(to_use_effect)
		elif to_use_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_HEALTH:
			add_percent_base_health_effect(to_use_effect)
			
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.FLAT_EFFECT_VULNERABILITY:
			flat_effect_vulnerability_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_effect_vulnerability()
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_EFFECT_VULNERABILITY:
			percent_effect_vulnerability_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_effect_vulnerability()
			
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.FLAT_PERCENT_HEALTH_HIT_SCALE:
			flat_percent_health_hit_scale_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_percent_health_hit_scale()
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_PERCENT_HEALTH_HIT_SCALE:
			percent_percent_health_hit_scale_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_percent_health_hit_scale()
		
		
		
	elif to_use_effect is EnemyHealOverTimeEffect:
		_heal_over_time_id_effects_map[to_use_effect.effect_uuid] = to_use_effect
		
	elif to_use_effect is EnemyHealEffect:
		heal_from_effect(to_use_effect)
		
	elif to_use_effect is EnemyShieldEffect:
		add_shield_effect(to_use_effect)
		
	elif to_use_effect is EnemyInvisibilityEffect:
		invisibility_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
		calculate_invisibility_status()
		
		
	elif to_use_effect is EnemyReviveEffect:
		revive_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
		
	elif to_use_effect is EnemyKnockUpEffect:
		knock_up_from_effect(to_use_effect)
		
	elif to_use_effect is BeforeEnemyReachEndPathBaseEffect:
		_before_reaching_end_path_effects_map[to_use_effect.effect_uuid] = to_use_effect
	
	
	
	emit_signal("effect_added", to_use_effect, self)
	return to_use_effect


func _remove_effect(base_effect : EnemyBaseEffect):
	if base_effect.status_bar_icon != null:
		statusbar.remove_status_icon(base_effect.effect_uuid)
	
	
	if base_effect is EnemyStunEffect:
		_stun_id_effects_map.erase(base_effect.effect_uuid)
		
	elif base_effect is EnemyStackEffect:
		_stack_id_effects_map.erase(base_effect.effect_uuid)
		
	elif base_effect is EnemyDmgOverTimeEffect:
		var dmg_effect = _dmg_over_time_id_effects_map[base_effect.effect_uuid]
		dmg_effect.disconnect_from_enemy(self)
		
		_dmg_over_time_id_effects_map.erase(base_effect.effect_uuid)
		
	elif base_effect is EnemyAttributesEffect:
		if base_effect.attribute_type == EnemyAttributesEffect.FLAT_MOV_SPEED:
			flat_movement_speed_id_effect_map.erase(base_effect.effect_uuid)
			calculate_final_movement_speed()
			
		elif base_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED:
			percent_movement_speed_id_effect_map.erase(base_effect.effect_uuid)
			calculate_final_movement_speed()
			
		elif base_effect.attribute_type == EnemyAttributesEffect.FLAT_ARMOR:
			flat_armor_id_effect_map.erase(base_effect.effect_uuid)
			calculate_final_armor()
			
		elif base_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_ARMOR:
			percent_armor_id_effect_map.erase(base_effect.effect_uuid)
			calculate_final_armor()
			
		elif base_effect.attribute_type == EnemyAttributesEffect.FLAT_TOUGHNESS:
			flat_toughness_id_effect_map.erase(base_effect.effect_uuid)
			calculate_final_toughness()
			
		elif base_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_TOUGHNESS:
			percent_toughness_id_effect_map.erase(base_effect.effect_uuid)
			calculate_final_toughness()
			
		elif base_effect.attribute_type == EnemyAttributesEffect.FLAT_RESISTANCE:
			flat_resistance_id_effect_map.erase(base_effect.effect_uuid)
			calculate_final_resistance()
			
		elif base_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_RESISTANCE:
			percent_resistance_id_effect_map.erase(base_effect.effect_uuid)
			calculate_final_resistance()
			
		elif base_effect.attribute_type == EnemyAttributesEffect.FLAT_HEALTH:
			remove_flat_base_health_effect_preserve_percent(base_effect.effect_uuid)
		elif base_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_HEALTH:
			remove_percent_base_health_effect_preserve_percent(base_effect.effect_uuid)
			
		elif base_effect.attribute_type == EnemyAttributesEffect.FLAT_EFFECT_VULNERABILITY:
			flat_effect_vulnerability_id_effect_map.erase(base_effect.effect_uuid)
			calculate_effect_vulnerability()
			
		elif base_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_EFFECT_VULNERABILITY:
			percent_effect_vulnerability_id_effect_map.erase(base_effect.effect_uuid)
			calculate_effect_vulnerability()
			
			
		elif base_effect.attribute_type == EnemyAttributesEffect.FLAT_PERCENT_HEALTH_HIT_SCALE:
			flat_percent_health_hit_scale_id_effect_map.erase(base_effect.effect_uuid)
			calculate_percent_health_hit_scale()
			
		elif base_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_PERCENT_HEALTH_HIT_SCALE:
			percent_percent_health_hit_scale_id_effect_map.erase(base_effect.effect_uuid)
			calculate_percent_health_hit_scale()
			
		
	elif base_effect is EnemyHealOverTimeEffect:
		_heal_over_time_id_effects_map.erase(base_effect.effect_uuid)
		
	elif base_effect is EnemyShieldEffect:
		remove_shield_effect(base_effect.effect_uuid)
		
	elif base_effect is EnemyInvisibilityEffect:
		invisibility_id_effect_map.erase(base_effect.effect_uuid)
		calculate_invisibility_status()
		
	elif base_effect is EnemyReviveEffect:
		revive_id_effect_map.erase(base_effect.effect_uuid)
		
	elif base_effect is BeforeEnemyReachEndPathBaseEffect:
		_before_reaching_end_path_effects_map.erase(base_effect.effect_uuid)
	
	
	if base_effect != null:
		_all_effects_map.erase(base_effect.effect_uuid)
		emit_signal("effect_removed", base_effect, self)



func _clear_effects_from_clear_effect():
	for effect in _all_effects_map.values():
		if effect.is_clearable:
			_remove_effect(effect)
#	for effect in _stun_id_effects_map.values():
#		_remove_effect(effect)
#
#	for effect in _stack_id_effects_map.values():
#		_remove_effect(effect)
#
#	for effect in _dmg_over_time_id_effects_map.values():
#		_remove_effect(effect)
#
#
#	# Attributes
#	for effect in flat_movement_speed_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in percent_movement_speed_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in flat_armor_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in percent_armor_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in flat_toughness_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in percent_toughness_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in flat_resistance_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in percent_resistance_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in _flat_base_health_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in _percent_base_health_id_effect_map.values():
#		_remove_effect(effect)
#
#
#	for effect in flat_effect_vulnerability_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in percent_effect_vulnerability_id_effect_map.values():
#		_remove_effect(effect)
#
#
#	for effect in flat_percent_health_hit_scale_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in percent_percent_health_hit_scale_id_effect_map.values():
#		_remove_effect(effect)
#
#
#	for effect in _heal_over_time_id_effects_map.values():
#		_remove_effect(effect)
#
#	for effect in shield_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in invisibility_id_effect_map.values():
#		_remove_effect(effect)
#
#	for effect in revive_id_effect_map.values():
#		_remove_effect(effect)
	

# Timebounded related

func _decrease_time_of_timebounds(delta):
	
	# Stun related
	_is_stunned = _stun_id_effects_map.size() != 0
	for stun_effect in _stun_id_effects_map.values():
		_decrease_time_of_effect(stun_effect, delta)
	
	
	# Stack related
	for stack_effect in _stack_id_effects_map.values():
		_decrease_time_of_effect(stack_effect, delta)
	
	
	# Dmg over time related
	for dmg_time_effect in _dmg_over_time_id_effects_map.values():
		dmg_time_effect._curr_delay_per_tick -= delta
		if dmg_time_effect._curr_delay_per_tick <= 0:
			# does not cause self to emit "on hit" signal
			hit_by_damage_instance(dmg_time_effect.damage_instance, 0, false)
			dmg_time_effect._curr_delay_per_tick += dmg_time_effect.delay_per_tick
		
		_decrease_time_of_effect(dmg_time_effect, delta)
	
	
	# Flat slow related
	for slow_effect in flat_movement_speed_id_effect_map.values():
		_decrease_time_of_effect(slow_effect, delta)
	
	# Percent slow related
	for slow_effect in percent_movement_speed_id_effect_map.values():
		_decrease_time_of_effect(slow_effect, delta)
	
	
	# Armor
	for armor_eff in flat_armor_id_effect_map.values():
		_decrease_time_of_effect(armor_eff, delta)
	
	for armor_eff in percent_armor_id_effect_map.values():
		_decrease_time_of_effect(armor_eff, delta)
	
	
	# Toughness
	for tou_eff in flat_toughness_id_effect_map.values():
		_decrease_time_of_effect(tou_eff, delta)
	
	for tou_eff in percent_toughness_id_effect_map.values():
		_decrease_time_of_effect(tou_eff, delta)
	
	
	# Resistance
	for res_eff in flat_resistance_id_effect_map.values():
		_decrease_time_of_effect(res_eff, delta)
	
	for res_eff in percent_resistance_id_effect_map.values():
		_decrease_time_of_effect(res_eff, delta)
	
	
	# Health
	for res_eff in _flat_base_health_id_effect_map.values():
		_decrease_time_of_effect(res_eff, delta)
	
	for res_eff in _percent_base_health_id_effect_map.values():
		_decrease_time_of_effect(res_eff, delta)
	
	for res_eff in flat_effect_vulnerability_id_effect_map.values():
		_decrease_time_of_effect(res_eff, delta)
	
	for res_eff in percent_effect_vulnerability_id_effect_map.values():
		_decrease_time_of_effect(res_eff, delta)
	
	
	for res_eff in flat_percent_health_hit_scale_id_effect_map.values():
		_decrease_time_of_effect(res_eff, delta)
	
	for res_eff in percent_percent_health_hit_scale_id_effect_map.values():
		_decrease_time_of_effect(res_eff, delta)
	
	
	for res_eff in _heal_over_time_id_effects_map.values():
		res_eff._curr_delay_per_tick -= delta
		if res_eff._curr_delay_per_tick <= 0:
			heal_from_effect(res_eff)
			res_eff._curr_delay_per_tick += res_eff.delay_per_tick
		
		_decrease_time_of_effect(res_eff, delta)
	
	for res_eff in shield_id_effect_map.values():
		_decrease_time_of_effect(res_eff, delta)
	
	
	for res_eff in invisibility_id_effect_map.values():
		_decrease_time_of_effect(res_eff, delta)
	
	
	for res_eff in revive_id_effect_map.values():
		_decrease_time_of_effect(res_eff, delta)
	
	for res_eff in _before_reaching_end_path_effects_map.values():
		_decrease_time_of_effect(res_eff, delta)


func _decrease_time_of_effect(effect, delta : float):
	if effect.is_timebound:
		effect.time_in_seconds -= delta
		
		if effect.time_in_seconds <= 0:
			_remove_effect(effect)


# Special effects

func shift_position(shift : float):
	var final_shift = shift
	#if offset + shift < 0:
	#	final_shift = -offset
	
	offset += final_shift
	distance_to_exit -= final_shift
	
	if distance_to_exit < current_path_length:
		distance_to_exit = current_path_length

func shift_unit_position(unit_shift : float):
	var final_unit_shift = unit_shift
	#if offset + shift < 0:
	#	final_shift = -offset
	
	unit_offset += final_unit_shift
	
	distance_to_exit -= final_unit_shift * current_path_length
	if distance_to_exit < current_path_length:
		distance_to_exit = current_path_length


# Coll

func _on_CollisionArea_body_entered(body):
	if body is BaseBullet:
		hit_by_bullet(body)

func get_enemy_parent():
	return self


#

func register_ability(ability : BaseAbility):
	ability.activation_conditional_clauses.attempt_insert_clause(no_action_from_self_clauses)
	all_abilities.append(ability)


# Revive related

func _trigger_start_of_revive():
	is_reviving = true
	
	anim_sprite.visible = false
	no_movement_from_self_clauses.attempt_insert_clause(NoMovementClauses.IS_REVIVING)
	no_action_from_self_clauses.attempt_insert_clause(NoActionClauses.IS_REVIVING)
	untargetable_clauses.attempt_insert_clause(UntargetabilityClauses.IS_REVIVING)
	
	current_revive_effect = revive_id_effect_map.values()[revive_id_effect_map.size() - 1]
	_remove_effect(current_revive_effect)
	
	_construct_during_revive_particle(current_revive_effect.time_before_revive)
	emit_signal("on_starting_revive")
	emit_signal("cancel_all_lockons")

func _construct_during_revive_particle(lifetime : float):
	var particle = DuringReviveParticle_Scene.instance()
	particle.lifetime = lifetime
	particle.position = global_position
	
	get_tree().get_root().add_child(particle)



func _decrease_time_of_current_revive_effect(delta):
	if current_revive_effect != null:
		current_revive_effect._current_time_before_revive -= delta
		if current_revive_effect._current_time_before_revive <= 0:
			_trigger_end_of_revive()


func _trigger_end_of_revive():
	_add_effect(current_revive_effect.heal_effect_upon_revival)
	for effect in current_revive_effect.other_effects_upon_revival:
		_add_effect(effect)
	
	
	call_deferred("_after_end_of_revive")

func _after_end_of_revive():
	anim_sprite.visible = true
	collision_area.set_deferred("monitorable", true)
	collision_area.set_deferred("monitoring", true)
	
	current_revive_effect = null
	is_reviving = false
	no_movement_from_self_clauses.remove_clause(NoMovementClauses.IS_REVIVING)
	no_action_from_self_clauses.remove_clause(NoActionClauses.IS_REVIVING)
	untargetable_clauses.remove_clause(UntargetabilityClauses.IS_REVIVING)
	
	emit_signal("on_revive_completed")


# Knock up effect related

func knock_up_from_effect(effect : EnemyKnockUpEffect):
	_knock_up_current_acceleration += effect.knock_up_y_acceleration
	_knock_up_current_acceleration_deceleration += _knock_up_current_acceleration * effect.time_in_seconds
	
	_add_effect(effect.generate_stun_effect_from_self())


func _phy_process_knock_up(delta):
	if _knock_up_current_acceleration != 0:
		anim_sprite.offset.y -= _knock_up_current_acceleration * delta
		_knock_up_current_acceleration -= _knock_up_current_acceleration_deceleration * delta
		
		if anim_sprite.offset.y >= 0:
			_knock_up_current_acceleration = 0
			_knock_up_current_acceleration_deceleration = 0
			anim_sprite.offset.y = 0


# 

func copy_enemy_stats(arg_enemy,
		including_curr_health : bool = false,
		update_last_calcs : bool = true):
	
	# Base stats
	base_health = arg_enemy.base_health
	pierce_consumed_per_hit = arg_enemy.pierce_consumed_per_hit
	base_armor = arg_enemy.base_armor
	base_toughness = arg_enemy.base_toughness
	base_resistance = arg_enemy.base_resistance
	base_player_damage = arg_enemy.base_player_damage
	base_movement_speed = arg_enemy.base_movement_speed
	base_effect_vulnerability = arg_enemy.base_effect_vulnerability
	base_percent_health_hit_scale = arg_enemy.base_percent_health_hit_scale
	
	if update_last_calcs:
		calculate_max_health()
		calculate_final_armor()
		calculate_final_toughness()
		calculate_final_resistance()
		calculate_final_movement_speed()
		calculate_effect_vulnerability()
		calculate_percent_health_hit_scale()
	
	# Health
	if including_curr_health:
		#current_health = arg_enemy.current_health
		_set_current_health_to(arg_enemy.current_health)


func copy_enemy_stats_and_effects(arg_enemy,
		including_curr_health : bool = false):
	
	copy_enemy_stats(arg_enemy, including_curr_health, false)
	
	# Effects
	for effect in _all_effects_map:
		_add_effect(effect, 1, true)


func copy_enemy_location_and_offset(arg_enemy):
	unit_offset = arg_enemy.unit_offset
	offset = arg_enemy.offset
	
	if is_inside_tree():
		global_position = arg_enemy.global_position
	else:
		position = arg_enemy.global_position
	
	distance_to_exit = arg_enemy.distance_to_exit

#

# spawned from something else than spawn instructions
func set_properties_to_spawned_from_entity():
	respect_stage_round_health_scale = false

