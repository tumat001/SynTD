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

signal on_death_by_any_cause
signal on_hit(me)
signal on_post_mitigated_damage_taken(damage, damage_type, is_lethal, me, damage_reg_id)
signal before_damage_instance_is_processed(damage_instance, me)

signal reached_end_of_path(me)
signal on_current_health_changed(current_health)
signal on_max_health_changed(max_health)


var base_health : float = 1
# NOT YET UPDATED TO MAKE USE OF EFFECTS
var _flat_base_health_effect_map = {}
var _percent_base_health_effect_map = {}
var current_health : float = 1
var _last_calculated_max_health : float

var active_effects = {}

var pierce_consumed_per_hit : float = 1

var base_armor : float = 0
var flat_armor_id_effect_map = {}
var percent_armor_id_effect_map = {}
var _last_calculated_final_armor : float

var base_toughness : float = 0
var flat_toughness_id_effect_map = {}
var percent_toughness_id_effect_map = {}
var _last_calculated_final_toughness : float

var base_resistance : float = 0
var flat_resistance_id_effect_map = {}
var percent_resistance_id_effect_map = {}
var _last_calculated_final_resistance : float

var base_player_damage : float = 1
var flat_player_damage_id_effect_map = {}
var percent_player_damage_id_effect_map = {}

var base_movement_speed : float
var flat_movement_speed_id_effect_map = {}
var percent_movement_speed_id_effect_map = {}
var _last_calculated_final_movement_speed

var distance_to_exit : float

#

onready var healthbar = $Healthbar


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
	
	healthbar.position.y -= round((_self_size.y / 2) + 15)
	healthbar.position.x -= round(healthbar.get_bar_fill_foreground_size().x / 2)
	
	connect("on_current_health_changed", healthbar, "set_current_value")
	
	calculate_final_armor()
	calculate_final_toughness()
	calculate_final_resistance()
	calculate_final_movement_speed()
	calculate_max_health()

func _post_ready():
	healthbar.max_value = base_health
	# TODO INSTEAD OF base_health, make it "calculate_..."
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
	for modifier in _percent_base_health_effect_map.values():
		max_health += modifier.get_modification_to_value(base_health)
	
	for flat in _flat_base_health_effect_map.values():
		max_health += flat.get_modification_to_value(max_health)
	
	_last_calculated_max_health = max_health
	return max_health

func heal_without_overhealing(heal_amount):
	var total_amount : float = current_health + heal_amount
	var max_health = calculate_max_health()
	if total_amount > max_health:
		current_health = max_health
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
func _take_unmitigated_damage(damage_amount : float, damage_type : int):
	current_health -= damage_amount
	if current_health <= 0:
		var effective_damage = damage_amount + current_health
		#call_deferred("emit_signal", "on_post_mitigated_damage_taken", effective_damage, damage_type, true, self)
		emit_signal("on_post_mitigated_damage_taken", effective_damage, damage_type, true, self)
		
		_destroy_self()
	else:
		#call_deferred("emit_signal", "on_post_mitigated_damage_taken", damage_amount, damage_type, false, self)
		emit_signal("on_post_mitigated_damage_taken", damage_amount, damage_type, false, self)
		
		emit_signal("on_current_health_changed", current_health)

func _destroy_self():
	$CollisionArea.set_deferred("monitorable", false)
	$CollisionArea.set_deferred("monitoring", false)
	queue_free()


func queue_free():
	emit_signal("on_death_by_any_cause")
	
	.queue_free()


func add_flat_base_health_modifier_with_heal(modifier_name : String, 
		modifier : FlatModifier):
	
	_flat_base_health_effect_map[modifier_name] = modifier
	var heal = modifier.get_modification_to_value(base_health)
	heal_without_overhealing(heal)

func add_percent_base_health_modifier_with_heal(modifier_name : String,
		modifier : PercentModifier):
	
	_percent_base_health_effect_map[modifier_name] = modifier
	var heal = modifier.get_modification_to_value(base_health)
	heal_without_overhealing(heal)

func remove_flat_base_health_preserve_percent(modifier_name : String):
	if _flat_base_health_effect_map.has(modifier_name):
		var flat_mod : FlatModifier = _flat_base_health_effect_map[modifier_name]
		var flat_remove = flat_mod.flat_modifier
		_set_current_health_to(PercentPreserver.removed_flat_amount(
				calculate_max_health(), current_health, flat_remove))
		
		_flat_base_health_effect_map.erase(modifier_name)

func remove_percent_base_health_preserve_percent(modifier_name : String):
	if _percent_base_health_effect_map.has(modifier_name):
		var percent_mod : PercentModifier = _percent_base_health_effect_map[modifier_name]
		var percent_remove = percent_mod.percent_modifier
		_set_current_health_to(PercentPreserver.removed_percent_amount(
				calculate_max_health(), current_health, percent_remove))
		
		_percent_base_health_effect_map.erase(modifier_name)

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
	
	_last_calculated_final_resistance = final_resistance
	return final_resistance

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
	generic_bullet.hit_by_enemy(self)
	generic_bullet.decrease_pierce(pierce_consumed_per_hit)
	if generic_bullet.attack_module_source != null:
		connect("on_hit", generic_bullet.attack_module_source, "on_enemy_hit", [generic_bullet.damage_register_id], CONNECT_ONESHOT)
		connect("on_post_mitigated_damage_taken", generic_bullet.attack_module_source, "on_post_mitigation_damage_dealt", [generic_bullet.damage_register_id], CONNECT_ONESHOT)
	
	hit_by_damage_instance(generic_bullet.damage_instance)
	generic_bullet.reduce_damage_by_beyond_first_multiplier()


func hit_by_aoe(base_aoe):
	if base_aoe.attack_module_source != null:
		connect("on_hit", base_aoe.attack_module_source, "on_enemy_hit", [base_aoe.damage_register_id], CONNECT_ONESHOT)
		connect("on_post_mitigated_damage_taken", base_aoe.attack_module_source, "on_post_mitigation_damage_dealt", [base_aoe.damage_register_id], CONNECT_ONESHOT)
	
	hit_by_damage_instance(base_aoe.damage_instance)


func hit_by_damage_instance(damage_instance : DamageInstance, emit_on_hit_signal : bool = true):
	#call_deferred("emit_signal", "on_hit", self)
	if emit_on_hit_signal:
		emit_signal("on_hit", self)
	
	emit_signal("before_damage_instance_is_processed", damage_instance, self)
	_process_on_hit_damages(damage_instance.on_hit_damages.duplicate(true))
	_process_effects(damage_instance.on_hit_effects.duplicate(true))


func _process_on_hit_damages(on_hit_damages : Dictionary):
	for on_hit_key in on_hit_damages.keys():
		var on_hit_damage : OnHitDamage = on_hit_damages[on_hit_key]
		if on_hit_damage.damage_as_modifier is FlatModifier:
			_process_flat_damage(on_hit_damage.damage_as_modifier, on_hit_damage.damage_type)
		elif on_hit_damage.damage_as_modifier is PercentModifier:
			_process_percent_damage(on_hit_damage.damage_as_modifier, on_hit_damage.damage_type)


func _process_percent_damage(damage_as_modifier: PercentModifier, damage_type : int):
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
	
	_process_direct_damage_and_type(damage_as_flat, damage_type)

func _process_flat_damage(damage_as_modifier : FlatModifier, damage_type : int):
	_process_direct_damage_and_type(damage_as_modifier.flat_modifier, damage_type)

func _process_direct_damage_and_type(damage : float, damage_type : int):
	var final_damage = damage
	if damage_type == DamageType.ELEMENTAL:
		final_damage *= _calculate_multiplier_from_total_toughness()
		final_damage *= _calculate_multiplier_from_total_resistance()
		
	elif damage_type == DamageType.PHYSICAL:
		final_damage *= _calculate_multiplier_from_total_armor()
		final_damage *= _calculate_multiplier_from_total_resistance()
		
	elif damage_type == DamageType.PURE:
		pass
		#final_damage *= 1
	
	_take_unmitigated_damage(final_damage, damage_type)

func _calculate_multiplier_from_total_armor() -> float:
	var total_armor = calculate_final_armor()
	if total_armor >= 0:
		return 20 / (20 + total_armor)
	else:
		return 2 - (20 / (20 - total_armor))

func _calculate_multiplier_from_total_toughness():
	var total_toughness = calculate_final_toughness()
	if total_toughness >= 0:
		return 20 / (20 + total_toughness)
	else:
		return 2 - (20 / (20 - total_toughness))

func _calculate_multiplier_from_total_resistance():
	return (100 - calculate_final_resistance()) / 100


# Process effects related

func _process_effects(effects : Dictionary):
	
	for effect in effects.values():
		_add_effect(effect)

func _add_effect(base_effect : EnemyBaseEffect):
	var to_use_effect = base_effect._get_copy_scaled_by(1)
	
	if to_use_effect is EnemyStunEffect:
		_stun_id_effects_map[to_use_effect.effect_uuid] = to_use_effect
		
	elif to_use_effect is EnemyClearAllEffects:
		_stun_id_effects_map.clear()
		_stack_id_effects_map.clear()
		_dmg_over_time_id_effects_map.clear()
		
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
		_dmg_over_time_id_effects_map[to_use_effect.effect_uuid] = to_use_effect
		
		
	elif to_use_effect is EnemyAttributesEffect:
		if to_use_effect.attribute_type == EnemyAttributesEffect.FLAT_MOV_SPEED:
			flat_movement_speed_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_final_movement_speed()
			
		elif to_use_effect.attribute_type == EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED:
			percent_movement_speed_id_effect_map[to_use_effect.effect_uuid] = to_use_effect
			calculate_final_movement_speed()


func _remove_effect(base_effect : EnemyBaseEffect):
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



# Timebounded related

func _decrease_time_of_timebounds(delta):
	
	# Stun related
	for stun_id in _stun_id_effects_map.keys():
		var stun_effect = _stun_id_effects_map[stun_id]
		
		if stun_effect.is_timebound:
			stun_effect.time_in_seconds -= delta
			
			if stun_effect.time_in_seconds <= 0:
				_remove_effect(stun_effect)
	
	_is_stunned = _stun_id_effects_map.size() != 0
	
	
	# Stack related
	for stack_id in _stack_id_effects_map.keys():
		var stack_effect = _stack_id_effects_map[stack_id]
		
		if stack_effect.is_timebound:
			stack_effect.time_in_seconds -= delta
			
			if stack_effect.time_in_seconds <= 0:
				_remove_effect(stack_effect)
	
	
	# Dmg over time related
	for dmg_time_id in _dmg_over_time_id_effects_map.keys():
		var dmg_time_effect = _dmg_over_time_id_effects_map[dmg_time_id]
		
		dmg_time_effect._curr_delay_per_tick -= delta
		if dmg_time_effect._curr_delay_per_tick <= 0:
			# does not cause self to emit "on hit" signal
			hit_by_damage_instance(dmg_time_effect.damage_instance, false)
			dmg_time_effect._curr_delay_per_tick += dmg_time_effect.delay_per_tick
		
		
		if dmg_time_effect.is_timebound:
			dmg_time_effect.time_in_seconds -= delta
			
			if dmg_time_effect.time_in_seconds <= 0:
				_remove_effect(dmg_time_effect)
	
	# Flat slow related
	for slow_id in flat_movement_speed_id_effect_map.keys():
		var slow_effect = flat_movement_speed_id_effect_map[slow_id]
		
		if slow_effect.is_timebound:
			slow_effect.time_in_seconds -= delta
			
			if slow_effect.time_in_seconds <= 0:
				_remove_effect(slow_effect)
	
	
	# Percent slow related
	for slow_id in percent_movement_speed_id_effect_map.keys():
		var slow_effect = percent_movement_speed_id_effect_map[slow_id]
		
		if slow_effect.is_timebound:
			slow_effect.time_in_seconds -= delta
			
			if slow_effect.time_in_seconds <= 0:
				_remove_effect(slow_effect)
	




# Coll

func _on_CollisionArea_body_entered(body):
	if body is BaseBullet:
		hit_by_bullet(body)

func get_enemy_parent():
	return self


# TODO TEST ONLY

func _on_CollisionArea_mouse_entered():
	_destroy_self()
