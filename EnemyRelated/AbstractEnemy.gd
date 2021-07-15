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

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")
const EnemyClearAllEffects = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyClearAllEffects.gd")
const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")
const EnemyDmgOverTimeEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyDmgOverTimeEffect.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

const OnHitDamageReport = preload("res://TowerRelated/DamageAndSpawnables/ReportsRelated/OnHitDamageReport.gd")
const DamageInstanceReport = preload("res://TowerRelated/DamageAndSpawnables/ReportsRelated/DamageInstanceReport.gd")

const BaseControlStatusBar = preload("res://MiscRelated/ControlStatusBarRelated/BaseControlStatusBar.gd")


signal on_death_by_any_cause
signal on_hit(me, damage_reg_id, damage_instance)
signal on_post_mitigated_damage_taken(damage_instance_report, is_lethal, me)
signal before_damage_instance_is_processed(damage_instance, me)

signal reached_end_of_path(me)
signal on_current_health_changed(current_health)
signal on_max_health_changed(max_health)

signal effect_removed(effect, me)


var base_health : float = 1
var _flat_base_health_id_effect_map : Dictionary = {}
var _percent_base_health_id_effect_map : Dictionary = {}
var current_health : float = 1
var _last_calculated_max_health : float

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

var base_player_damage : float = 1
var flat_player_damage_id_effect_map : Dictionary = {}
var percent_player_damage_id_effect_map : Dictionary = {}

var base_movement_speed : float
var flat_movement_speed_id_effect_map : Dictionary = {}
var percent_movement_speed_id_effect_map : Dictionary = {}
var _last_calculated_final_movement_speed

var distance_to_exit : float

#

onready var statusbar : BaseControlStatusBar = $EnemyInfoBar/VBoxContainer/EnemyStatusBar
onready var healthbar = $EnemyInfoBar/VBoxContainer/EnemyHealthBar
onready var infobar = $EnemyInfoBar

#internals

var _self_size : Vector2

# Effects map

var _stack_id_effects_map : Dictionary = {}
var _stun_id_effects_map : Dictionary = {}
var _is_stunned : bool
var _dmg_over_time_id_effects_map : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	_self_size = _get_current_anim_size()
	
	infobar.rect_position.y -= round((_self_size.y) + 11)
	infobar.rect_position.x -= round(healthbar.get_bar_fill_foreground_size().x / 2)
	
	connect("on_current_health_changed", healthbar, "set_current_value")
	
	calculate_final_armor()
	calculate_final_toughness()
	calculate_final_resistance()
	calculate_final_movement_speed()
	calculate_max_health()

func _post_ready():
	healthbar.current_value = current_health
	
	# TODO INSTEAD OF base_health, make it "calculate_..."
	healthbar.max_value = base_health
	healthbar.redraw_chunks()


func _get_current_anim_size() -> Vector2:
	return $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame).get_size()


func _process(delta):
	_decrease_time_of_timebounds(delta)


func _physics_process(delta):
	if !_is_stunned:
		var distance_traveled = delta * _last_calculated_final_movement_speed
		offset += distance_traveled
		distance_to_exit -= distance_traveled
	
	if unit_offset == 1:
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
		max_health += effect.attribute_as_modifier.get_modification_to_value(max_health)
	
	_last_calculated_max_health = max_health
	return max_health

func heal_without_overhealing(heal_amount):
	var total_amount : float = current_health + heal_amount
	if total_amount > _last_calculated_max_health:
		current_health = _last_calculated_max_health
	else:
		current_health += heal_amount
	
	emit_signal("on_current_health_changed", current_health)

func heal_with_overhealing(heal_amount):
	current_health += heal_amount
	
	emit_signal("on_current_health_changed", current_health)

func _set_current_health_to(health_amount):
	current_health = health_amount
	
	emit_signal("on_current_health_changed", current_health)


# The only function that should handle taking
# damage and health deduction. Also where
# death is handled
func _take_unmitigated_damages(damages_and_types : Array):
	
	var damage_instance_report : DamageInstanceReport = DamageInstanceReport.new()
	
	for damage_and_type in damages_and_types: #on hit id in third index
		var damage_amount = damage_and_type[0]
		var on_hit_id = damage_and_type[2]
		
		var on_hit_report := OnHitDamageReport.new(damage_amount, damage_and_type[1], on_hit_id)
		var effective_on_hit_report : OnHitDamageReport
		
		if current_health > 0:
			effective_on_hit_report = on_hit_report
			
			current_health -= damage_amount
			
			if current_health <= 0:
				var effective_damage = damage_amount + current_health
				effective_on_hit_report = effective_on_hit_report.duplicate()
				effective_on_hit_report.damage = effective_damage
		
		damage_instance_report.all_post_mitigated_on_hit_damages[on_hit_id] = on_hit_report
		if effective_on_hit_report != null:
			damage_instance_report.all_effective_on_hit_damages[on_hit_id] = effective_on_hit_report
	
	
	if current_health <= 0:
		emit_signal("on_post_mitigated_damage_taken", damage_instance_report, true, self)
		_destroy_self()
		
	else:
		emit_signal("on_post_mitigated_damage_taken", damage_instance_report, false, self)
		emit_signal("on_current_health_changed", current_health)



func _destroy_self():
	$CollisionArea.set_deferred("monitorable", false)
	$CollisionArea.set_deferred("monitoring", false)
	queue_free()


func queue_free():
	emit_signal("on_death_by_any_cause")
	
	.queue_free()



func add_flat_base_health_effect(effect : EnemyAttributesEffect, with_heal : bool = true):
	_flat_base_health_id_effect_map[effect.effect_uuid] = effect
	var old_max_health = _last_calculated_max_health
	calculate_max_health()
	if current_health > _last_calculated_max_health:
		current_health = _last_calculated_max_health
	
	if with_heal:
		var heal = _last_calculated_max_health - old_max_health
		if heal > 0:
			heal_without_overhealing(heal)

func add_percent_base_health_effect(effect : EnemyAttributesEffect, with_heal : bool = true):
	_percent_base_health_id_effect_map[effect.effect_uuid] = effect
	var old_max_health = _last_calculated_max_health
	calculate_max_health()
	if current_health > _last_calculated_max_health:
		current_health = _last_calculated_max_health
	
	if with_heal:
		var heal = old_max_health - _last_calculated_max_health
		if heal > 0:
			heal_without_overhealing(heal)

func remove_flat_base_health_effect_preserve_percent(effect_uuid : int):
	if _flat_base_health_id_effect_map.has(effect_uuid):
		var flat_mod : FlatModifier = _flat_base_health_id_effect_map[effect_uuid]
		var flat_remove = flat_mod.flat_modifier
		_set_current_health_to(PercentPreserver.removed_flat_amount(
				_last_calculated_max_health, current_health, flat_remove))
		
		_flat_base_health_id_effect_map.erase(effect_uuid)
		calculate_max_health()

func remove_percent_base_health_effect_preserve_percent(effect_uuid : int):
	if _percent_base_health_id_effect_map.has(effect_uuid):
		var percent_mod : PercentModifier = _percent_base_health_id_effect_map[effect_uuid]
		var percent_remove = percent_mod.percent_modifier
		_set_current_health_to(PercentPreserver.removed_percent_amount(
				_last_calculated_max_health, current_health, percent_remove))
		
		_percent_base_health_id_effect_map.erase(effect_uuid)
		calculate_max_health()

class PercentPreserver:
	
	static func removed_flat_amount(max_arg : float, 
			current : float, flat_remove : float) -> float:
		
		var initial_ratio = current / max_arg
		var reduced = max_arg - flat_remove
		return reduced * initial_ratio
	
	static func removed_percent_amount(max_arg : float,
			current : float, percent_remove : float) -> float:
		
		var initial_ratio = current / max_arg
		var reduced = max_arg * (1 - (percent_remove / 100))
		return reduced * initial_ratio


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
		final_resistance += effect.attribute_as_modifier.get_modification_to_value(base_resistance)
	
	for effect in flat_resistance_id_effect_map.values():
		final_resistance += effect.attribute_as_modifier.get_modification_to_value(base_resistance)
	
	
	if final_resistance < 0:
		final_resistance = 0
	elif final_resistance > 100:
		final_resistance = 100
	
	_last_calculated_final_resistance = final_resistance
	return final_resistance


# damage multiplier

func _calculate_multiplier_from_total_armor(armor_pierce : float, percent_self_armor_pierce : float) -> float:
	var total_armor = _last_calculated_final_armor - (percent_self_armor_pierce * _last_calculated_final_armor / 100)
	total_armor = total_armor - armor_pierce
	if total_armor >= 0:
		return 20 / (20 + total_armor)
	else:
		return 2 - (20 / (20 - total_armor))

func _calculate_multiplier_from_total_toughness(toughness_pierce : float, percent_self_toughness_pierce : float):
	var total_toughness = _last_calculated_final_toughness - (percent_self_toughness_pierce * _last_calculated_final_toughness / 100)
	total_toughness = total_toughness - toughness_pierce
	if total_toughness >= 0:
		return 20 / (20 + total_toughness)
	else:
		return 2 - (20 / (20 - total_toughness))

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
	if !generic_bullet.enemies_ignored.has(self):
		generic_bullet.hit_by_enemy(self)
		generic_bullet.decrease_pierce(pierce_consumed_per_hit)
		if generic_bullet.attack_module_source != null:
			connect("on_hit", generic_bullet.attack_module_source, "on_enemy_hit", [], CONNECT_ONESHOT)
			connect("on_post_mitigated_damage_taken", generic_bullet.attack_module_source, "on_post_mitigation_damage_dealt", [generic_bullet.damage_register_id], CONNECT_ONESHOT)
		
		hit_by_damage_instance(generic_bullet.damage_instance, generic_bullet.damage_register_id)
		generic_bullet.reduce_damage_by_beyond_first_multiplier()


func hit_by_aoe(base_aoe):
	if base_aoe.attack_module_source != null:
		connect("on_hit", base_aoe.attack_module_source, "on_enemy_hit", [], CONNECT_ONESHOT)
		connect("on_post_mitigated_damage_taken", base_aoe.attack_module_source, "on_post_mitigation_damage_dealt", [base_aoe.damage_register_id], CONNECT_ONESHOT)
	
	hit_by_damage_instance(base_aoe.damage_instance, base_aoe.damage_register_id)


func hit_by_damage_instance(damage_instance : DamageInstance, damage_reg_id : int = 0, emit_on_hit_signal : bool = true):
	if emit_on_hit_signal:
		emit_signal("on_hit", self, damage_reg_id, damage_instance)
	
	emit_signal("before_damage_instance_is_processed", damage_instance, self)
	_process_on_hit_damages(damage_instance.on_hit_damages.duplicate(true), damage_instance)
	_process_effects(damage_instance.on_hit_effects.duplicate(true))


func _process_on_hit_damages(on_hit_damages : Dictionary, damage_instance):
	var damages : Array = []
	
	for on_hit_key in on_hit_damages.keys():
		var on_hit_damage : OnHitDamage = on_hit_damages[on_hit_key]
		
		if on_hit_damage.damage_as_modifier is FlatModifier:
			damages.append(_process_flat_damage(on_hit_damage.damage_as_modifier, on_hit_damage.damage_type, damage_instance, on_hit_damage.internal_id))
		elif on_hit_damage.damage_as_modifier is PercentModifier:
			damages.append(_process_percent_damage(on_hit_damage.damage_as_modifier, on_hit_damage.damage_type, damage_instance, on_hit_damage.internal_id))
	
	_take_unmitigated_damages(damages)

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
		var missing_health = _last_calculated_max_health - current_health
		if missing_health < 0:
			missing_health = 0
		damage_as_flat = damage_as_modifier.get_modification_to_value(missing_health)
	
	return _process_direct_damage_and_type(damage_as_flat, damage_type, damage_instance, on_hit_id)

func _process_flat_damage(damage_as_modifier : FlatModifier, damage_type : int, damage_instance, on_hit_id) -> Array:
	return _process_direct_damage_and_type(damage_as_modifier.flat_modifier, damage_type, damage_instance, on_hit_id)

func _process_direct_damage_and_type(damage : float, damage_type : int, damage_instance : DamageInstance, on_hit_id) -> Array:
	var final_damage = damage
	if damage_type == DamageType.ELEMENTAL:
		final_damage *= _calculate_multiplier_from_total_toughness(damage_instance.final_toughness_pierce, damage_instance.final_percent_enemy_toughness_pierce)
		final_damage *= _calculate_multiplier_from_total_resistance(damage_instance.final_resistance_pierce, damage_instance.final_percent_enemy_resistance_pierce)
		
	elif damage_type == DamageType.PHYSICAL:
		final_damage *= _calculate_multiplier_from_total_armor(damage_instance.final_armor_pierce, damage_instance.final_percent_enemy_armor_pierce)
		final_damage *= _calculate_multiplier_from_total_resistance(damage_instance.final_resistance_pierce, damage_instance.final_percent_enemy_resistance_pierce)
		
	elif damage_type == DamageType.PURE:
		pass
		#final_damage *= 1
	
	#_take_unmitigated_damage(final_damage, damage_type)
	return [final_damage, damage_type, on_hit_id]


# Process effects related

func _process_effects(effects : Dictionary):
	for effect in effects.values():
		_add_effect(effect)


func _add_effect(base_effect : EnemyBaseEffect):
	var to_use_effect = base_effect._get_copy_scaled_by(1)
	
	if to_use_effect.status_bar_icon != null:
		statusbar.add_status_icon(to_use_effect.effect_uuid, to_use_effect.status_bar_icon)
	
	
	if to_use_effect is EnemyStunEffect:
		if !_stun_id_effects_map.has(to_use_effect.effect_uuid):
			_stun_id_effects_map[to_use_effect.effect_uuid] = to_use_effect
		else:
			_stun_id_effects_map[to_use_effect.effect_uuid]._reapply(to_use_effect)
		
	elif to_use_effect is EnemyClearAllEffects:
		# When adding effects, update this
		_clear_effects()
		
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
				
				_add_effect(stored_effect.base_effect)
			else:
				if stored_effect.duration_refresh_per_apply:
					stored_effect.time_in_seconds = to_use_effect.time_in_seconds
		
	elif to_use_effect is EnemyDmgOverTimeEffect:
		if !_dmg_over_time_id_effects_map.has(to_use_effect.effect_uuid):
			_dmg_over_time_id_effects_map[to_use_effect.effect_uuid] = to_use_effect
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
		


func _remove_effect(base_effect : EnemyBaseEffect):
	if base_effect.status_bar_icon != null:
		statusbar.remove_status_icon(base_effect.effect_uuid)
	
	
	if base_effect is EnemyStunEffect:
		_stun_id_effects_map.erase(base_effect.effect_uuid)
		
	elif base_effect is EnemyStackEffect:
		_stack_id_effects_map.erase(base_effect.effect_uuid)
		
	elif base_effect is EnemyDmgOverTimeEffect:
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
		
		
	
	if base_effect != null:
		emit_signal("effect_removed", base_effect, self)



func _clear_effects():
	for effect in _stun_id_effects_map.values():
		_remove_effect(effect)
	
	for effect in _stack_id_effects_map.values():
		_remove_effect(effect)
	
	for effect in _dmg_over_time_id_effects_map.values():
		_remove_effect(effect)
	
	
	# Attributes
	for effect in flat_movement_speed_id_effect_map.values():
		_remove_effect(effect)
	
	for effect in percent_movement_speed_id_effect_map.values():
		_remove_effect(effect)
	
	for effect in flat_armor_id_effect_map.values():
		_remove_effect(effect)
	
	for effect in percent_armor_id_effect_map.values():
		_remove_effect(effect)
	
	for effect in flat_toughness_id_effect_map.values():
		_remove_effect(effect)
	
	for effect in percent_toughness_id_effect_map.values():
		_remove_effect(effect)
	
	for effect in flat_resistance_id_effect_map.values():
		_remove_effect(effect)
	
	for effect in percent_resistance_id_effect_map.values():
		_remove_effect(effect)
	


# Timebounded related

func _decrease_time_of_timebounds(delta):
	
	# Stun related
	for stun_effect in _stun_id_effects_map.values():
		_decrease_time_of_effect(stun_effect, delta)
	
	_is_stunned = _stun_id_effects_map.size() != 0
	
	
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



func _decrease_time_of_effect(effect, delta : float):
	if effect.is_timebound:
		effect.time_in_seconds -= delta
		
		if effect.time_in_seconds <= 0:
			_remove_effect(effect)


# Special effects

func shift_position(shift : float):
	var final_shift = shift
	if offset + shift < 0:
		final_shift = -offset
	
	offset += final_shift
	distance_to_exit -= final_shift


# Coll

func _on_CollisionArea_body_entered(body):
	if body is BaseBullet:
		hit_by_bullet(body)

func get_enemy_parent():
	return self

