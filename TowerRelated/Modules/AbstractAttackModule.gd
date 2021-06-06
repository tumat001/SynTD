extends Node2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const Modifier = preload("res://GameInfoRelated/Modifier.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const RangeModule = preload("res://TowerRelated/Modules/RangeModule.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")

const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")


signal in_attack_windup(windup_time, enemies_or_poses)
signal in_attack(attack_speed_delay, enemies_or_poses)
signal in_attack_end()

signal on_round_end()

signal on_post_mitigation_damage_dealt(damage, damage_type, killed, enemy, damage_register_id, module)
signal on_enemy_hit(enemy, damage_register_id, module)

signal on_damage_instance_constructed(damage_instance, module)


var module_id : int
# OBSELETE
var is_main_attack : bool = false
var number_of_unique_targets : int = 1

var can_be_commanded_by_tower : bool = true

var benefits_from_bonus_attack_speed : bool = true
var benefits_from_bonus_on_hit_damage : bool = true
var benefits_from_bonus_base_damage : bool = true
var benefits_from_bonus_on_hit_effect : bool = true

var benefits_from_ingredient_effect : bool = true

var base_attack_speed : float = 1
var base_attack_wind_up : float = 0
# map of uuid (internal name) to effect
var flat_attack_speed_effects : Dictionary = {} 
var percent_attack_speed_effects : Dictionary = {}

var has_burst : bool = false
var burst_amount : int
var burst_attack_speed : float = 1

var on_hit_damage_scale : float = 1

var base_damage : float
var base_damage_scale : float = 1.0  # Scales final damage calculated 
var base_damage_type : int
# map of uuid (internal name) to effect
var flat_base_damage_effects : Dictionary = {}
var percent_base_damage_effects : Dictionary = {}
var base_on_hit_damage_internal_name : String
var on_hit_damage_adder_effects : Dictionary

var damage_register_id : int


var on_hit_effect_scale : float = 1
# uuid to effect map
var on_hit_effects : Dictionary

# Managed by abstracttower completely
var _all_countbound_effects : Dictionary = {}

var range_module : RangeModule setget _set_range_module
var use_self_range_module : bool = false

var modifications : Array

# Attack sprites

var attack_sprite_scene
var attack_sprite_follow_enemy : bool


# Windup enemy targets

var commit_to_targets_of_windup : bool = false
var _targets_during_windup : Array = []
var fill_empty_windup_target_slots : bool = true

# internal stuffs
var _current_attack_wait : float
var _current_wind_up_wait : float
var _is_attacking : bool
var _is_in_windup : bool = false

var _current_burst_count : int
var _current_burst_delay : float
var _is_bursting : bool

var _disabled : bool = false

# last calculated vars

var last_calculated_final_damage : float
var last_calculated_final_attk_speed : float

var _last_calculated_attack_wind_up : float
var _last_calculated_burst_pause : float
var _last_calculated_attack_speed_as_delay : float


# MISC

func reset_attack_timers():
	_is_bursting = false
	_current_burst_count = 0
	_current_burst_delay = 0
	
	_current_attack_wait = 0
	_current_wind_up_wait = 0
	_is_attacking = false
	_is_in_windup = false


func _ready():
	calculate_all_speed_related_attributes()
	calculate_final_base_damage()
	

func _set_range_module(new_module):
	if range_module != null:
		if get_children().has(range_module):
			remove_child(range_module)
	
	if new_module != null and new_module.get_parent() == null:
		add_child(new_module)
	
	range_module = new_module

# Time passed


func time_passed(delta):
	
	if !_disabled:
		_current_attack_wait -= delta
		
		if range_module.enemies_in_range.size() != 0 or (commit_to_targets_of_windup and _is_in_windup):#_targets_during_windup.size() > 0):
			_current_wind_up_wait -= delta
		
		if _is_bursting:
			_current_burst_delay -= delta
		
#		decrease_time_of_timebounded(delta)


#
#func decrease_time_of_timebounded(delta):
#	var bucket = []
#
#	# Extra On Hit damages
#	for key in on_hit_damage_adder_effects.keys():
#		if on_hit_damage_adder_effects[key].is_timebound:
#			on_hit_damage_adder_effects[key].time_in_seconds -= delta
#			var time_left = on_hit_damage_adder_effects[key].time_in_seconds
#			if time_left <= 0:
#				bucket.append(key)
#
#	for key_to_delete in bucket:
#		on_hit_damage_adder_effects.erase(key_to_delete)
#	bucket.clear()
#
#	# On Hit effects
#	for key in on_hit_effects.keys():
#		if on_hit_effects[key].is_timebound:
#			on_hit_effects[key].time_in_seconds -= delta
#			var time_left = on_hit_effects[key].time_in_seconds
#			if time_left <= 0:
#				bucket.append(key)
#	for key_to_delete in bucket:
#		on_hit_effects.erase(key_to_delete)
#	bucket.clear()
#
#
#	#For attack speed
#	var attack_speed_changed : bool = false
#	#For percent attk speed mods
#	for key in percent_attack_speed_effects.keys():
#		if percent_attack_speed_effects[key].is_timebound:
#			percent_attack_speed_effects[key].time_in_seconds -= delta
#			var time_left = percent_attack_speed_effects[key].time_in_seconds
#			if time_left <= 0:
#				bucket.append(key)
#				attack_speed_changed = true
#
#	for key_to_delete in bucket:
#		percent_attack_speed_effects.erase(key_to_delete)
#
#	bucket.clear()
#
#	#For flat attk speed mods
#	for key in flat_attack_speed_effects.keys():
#		if flat_attack_speed_effects[key].is_timebound:
#			flat_attack_speed_effects[key].time_in_seconds -= delta
#			var time_left = flat_attack_speed_effects[key].time_in_seconds
#			if time_left <= 0:
#				bucket.append(key)
#				attack_speed_changed = true
#
#	for key_to_delete in bucket:
#		flat_attack_speed_effects.erase(key_to_delete)
#
#	bucket.clear()
#
#	if attack_speed_changed:
#		call_deferred("emit_signal", "final_attack_speed_changed")
#
#
#	#For base damage
#	var base_damage_changed : bool = false
#	#For percent attk speed mods
#	for key in percent_base_damage_effects.keys():
#		if percent_base_damage_effects[key].is_timebound:
#			percent_base_damage_effects[key].time_in_seconds -= delta
#			var time_left = percent_base_damage_effects[key].time_in_seconds
#			if time_left <= 0:
#				bucket.append(key)
#				base_damage_changed = true
#
#	for key_to_delete in bucket:
#		percent_base_damage_effects.erase(key_to_delete)
#
#	bucket.clear()
#
#	#For flat attk speed mods
#	for key in flat_base_damage_effects.keys():
#		if flat_base_damage_effects[key].is_timebound:
#			flat_base_damage_effects[key].time_in_seconds -= delta
#			var time_left = flat_base_damage_effects[key].time_in_seconds
#			if time_left <= 0:
#				bucket.append(key)
#				base_damage_changed = true
#
#	for key_to_delete in bucket:
#		flat_base_damage_effects.erase(key_to_delete)
#
#	bucket.clear()
#
#	if base_damage_changed:
#		call_deferred("emit_signal", "final_base_damage_changed")
#
# Calculating final values


# Calculates attack speed, and returns attack delay
func calculate_all_speed_related_attributes():
	calculate_final_attack_speed()
	calculate_final_attack_wind_up()
	calculate_final_burst_attack_speed()


func calculate_final_attack_speed() -> float:
	var final_attack_speed = base_attack_speed
	
	if benefits_from_bonus_attack_speed:
		var totals_bucket : Array = []
		
		for effect in percent_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			
			if effect.attribute_as_modifier.percent_based_on != PercentType.MAX:
				final_attack_speed += effect.attribute_as_modifier.get_modification_to_value(base_attack_speed)
			else:
				totals_bucket.append(effect)
		
		for effect in flat_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_attack_speed += effect.attribute_as_modifier.get_modification_to_value(base_attack_speed)
		
		var final_base_attk_speed = final_attack_speed
		for effect in totals_bucket:
			final_base_attk_speed += effect.attribute_as_modifier.get_modification_to_value(final_attack_speed)
		
		final_attack_speed = final_base_attk_speed
	
	
	if final_attack_speed != 0:
		last_calculated_final_attk_speed = final_attack_speed
		_last_calculated_attack_speed_as_delay = (1 / last_calculated_final_attk_speed) - (_last_calculated_attack_wind_up + (burst_amount * _last_calculated_burst_pause))
		return _last_calculated_attack_speed_as_delay
	else:
		last_calculated_final_attk_speed = 0.0
		return 0.0

func calculate_final_attack_wind_up() -> float:
	if base_attack_wind_up == 0:
		return 0.0
	
	#All percent modifiers here are to BASE attk wind up only
	var final_attack_wind_up = base_attack_wind_up
	
	if benefits_from_bonus_attack_speed:
		var totals_bucket : Array = []
		
		for effect in percent_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			
			if effect.attribute_as_modifier.percent_based_on != PercentType.MAX:
				final_attack_wind_up += effect.attribute_as_modifier.get_modification_to_value(base_attack_wind_up)
			else:
				totals_bucket.append(effect)
		
		for effect in flat_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_attack_wind_up += effect.attribute_as_modifier.get_modification_to_value(base_attack_wind_up)
		
		var final_base_attk_wind_up = final_attack_wind_up
		for effect in totals_bucket:
			final_base_attk_wind_up += effect.attribute_as_modifier.get_modification_to_value(final_attack_wind_up)
		
		final_attack_wind_up = final_base_attk_wind_up
	
	if final_attack_wind_up != 0:
		_last_calculated_attack_wind_up = 1 / final_attack_wind_up
		return _last_calculated_attack_wind_up
	else:
		_last_calculated_attack_wind_up = 0.0
		return 0.0

func calculate_final_burst_attack_speed() -> float:
	if burst_attack_speed == 0:
		return 0.0
	
	#All percent modifiers here are to BASE in between burst only
	var final_burst_pause = burst_attack_speed
	
	if benefits_from_bonus_attack_speed:
		var totals_bucket : Array = []
		
		for effect in percent_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			
			if effect.attribute_as_modifier.percent_based_on != PercentType.MAX:
				final_burst_pause += effect.attribute_as_modifier.get_modification_to_value(burst_attack_speed)
			else:
				totals_bucket.append(effect)
		
		for effect in flat_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_burst_pause += effect.attribute_as_modifier.get_modification_to_value(burst_attack_speed)
		
		
		var final_base_attk_burst_speed = final_burst_pause
		for effect in totals_bucket:
			final_base_attk_burst_speed += effect.attribute_as_modifier.get_modification_to_value(final_burst_pause)
		
		final_burst_pause = final_base_attk_burst_speed
		
	
	if final_burst_pause != 0:
		_last_calculated_burst_pause = 1 / final_burst_pause
		return _last_calculated_burst_pause
	else:
		_last_calculated_burst_pause = 0.0
		return _last_calculated_burst_pause


# Attack related


func is_ready_to_attack() -> bool:
	if !_is_attacking:
		return _current_attack_wait <= 0
	else:
		if _is_bursting:
			return _current_burst_delay <= 0
		else:
			return _current_wind_up_wait <= 0


#func attempt_find_then_attack_enemy() -> bool:
#	if range_module == null or !use_self_range_module:
#		return false
#
#	var target : AbstractEnemy
#	if range_module.is_an_enemy_in_range():
#		target = range_module.get_target()
#
#	return on_command_attack_enemy(target)


func attempt_find_then_attack_enemies(num : int = number_of_unique_targets) -> bool:
	if range_module == null:
		return false
	
	var targets : Array
	if range_module.is_an_enemy_in_range():
		targets = range_module.get_targets(num)
	
	return on_command_attack_enemies(targets, num)


#func on_command_attack_enemy(enemy : AbstractEnemy) -> bool:
#	if enemy == null:
#		return false
#
#	if !_is_attacking:
#		if calculate_final_attack_wind_up() == 0:
#			_attack_enemy(enemy)
#
#			if has_burst:
#				_is_attacking = true
#				_current_burst_count += 1
#				_current_burst_delay = calculate_final_burst_attack_speed()
#				_is_bursting = true
#			else:
#				_current_attack_wait = calculate_final_attack_speed()
#				_finished_attacking()
#
#			return true
#		else:
#			_current_wind_up_wait = calculate_final_attack_wind_up()
#			_is_attacking = true
#			_during_windup(enemy)
#			_during_attack()
#			return false
#
#	else:
#		if !has_burst:
#			_attack_enemy(enemy)
#			_current_attack_wait = calculate_final_attack_speed()
#			_is_attacking = false
#			_finished_attacking()
#			return true
#		else:
#			if _current_burst_count < burst_amount - 1:
#				_attack_enemy(enemy)
#				_current_burst_delay = calculate_final_burst_attack_speed()
#				_is_bursting = true
#				_current_burst_count += 1
#				_during_attack()
#				return true
#			else:
#				_attack_enemy(enemy)
#				_current_attack_wait = calculate_final_attack_speed()
#				_is_bursting = false
#				_is_attacking = false
#				_current_burst_count = 0
#				_finished_attacking()
#				return true
#
#
#func on_command_attack_at_position(pos : Vector2):
#	if !_is_attacking:
#		if calculate_final_attack_wind_up() == 0:
#			_attack_at_position(pos)
#
#			if has_burst:
#				_is_attacking = true
#				_current_burst_count += 1
#				_current_burst_delay = calculate_final_burst_attack_speed()
#				_is_bursting = true
#			else:
#				_current_attack_wait = calculate_final_attack_speed()
#				_finished_attacking()
#
#			return true
#		else:
#			_current_wind_up_wait = calculate_final_attack_wind_up()
#			_is_attacking = true
#			_during_windup(null)
#			_during_attack()
#
#	else:
#		if !has_burst:
#			_attack_at_position(pos)
#			_current_attack_wait = calculate_final_attack_speed()
#			_is_attacking = false
#			_finished_attacking()
#		else:
#			if _current_burst_count < burst_amount - 1:
#				_attack_at_position(pos)
#				_current_burst_delay = calculate_final_burst_attack_speed()
#				_is_bursting = true
#				_current_burst_count += 1
#				_during_attack()
#			else:
#				_attack_at_position(pos)
#				_current_attack_wait = calculate_final_attack_speed()
#				_is_bursting = false
#				_is_attacking = false
#				_current_burst_count = 0
#				_finished_attacking()


func on_command_attack_enemies(arg_enemies : Array, num_of_targets : int = number_of_unique_targets) -> bool:
	var enemies : Array
	
	if commit_to_targets_of_windup and _is_in_windup:
		for target in _targets_during_windup:
			if target == null or !is_instance_valid(target):
				_targets_during_windup.erase(target)
		
		if fill_empty_windup_target_slots and _targets_during_windup.size() < num_of_targets:
			var slots_to_fill = num_of_targets - _targets_during_windup.size()
			
			for i in range(0, slots_to_fill):
				if arg_enemies.size() > i:
					_targets_during_windup.append(arg_enemies[i])
		
		enemies = _targets_during_windup
		
	else:
		enemies = arg_enemies
	
	if enemies.size() == 0 and !_is_attacking:
#		if !fill_empty_windup_target_slots:
#			_is_in_windup = false
#
		return false
	
	if !_is_attacking:
		if calculate_final_attack_wind_up() == 0:
			_check_attack_enemies(enemies)
			
			if has_burst:
				_is_attacking = true
				_current_burst_count += 1
				_current_burst_delay = calculate_final_burst_attack_speed()
				_is_bursting = true
			else:
				_current_attack_wait = calculate_final_attack_speed()
				_is_attacking = false
				_is_in_windup = false
				_finished_attacking()
			
			return true
		else:
			_current_wind_up_wait = calculate_final_attack_wind_up()
			_is_attacking = true
			_is_in_windup = true
			_during_windup_multiple(enemies)
			return false
		
	else:
		if !has_burst:
			_check_attack_enemies(enemies)
			_current_attack_wait = calculate_final_attack_speed()
			_is_attacking = false
			_is_in_windup = false
			_finished_attacking()
			return true
		else:
			if _current_burst_count < burst_amount - 1:
				_check_attack_enemies(enemies)
				_current_burst_delay = calculate_final_burst_attack_speed()
				_is_bursting = true
				_current_burst_count += 1
				return true
			else:
				_check_attack_enemies(enemies)
				_is_in_windup = false
				_current_attack_wait = calculate_final_attack_speed()
				_is_bursting = false
				_is_attacking = false
				_current_burst_count = 0
				_finished_attacking()
				return true


func on_command_attack_at_positions(positions : Array):
	if !_is_attacking:
		if calculate_final_attack_wind_up() == 0:
			_attack_at_positions(positions)
			
			if has_burst:
				_is_attacking = true
				_current_burst_count += 1
				_current_burst_delay = calculate_final_burst_attack_speed()
				_is_bursting = true
			else:
				_current_attack_wait = calculate_final_attack_speed()
				_is_attacking = false
				_is_in_windup = false
				_finished_attacking()
			
			return true
		else:
			_current_wind_up_wait = calculate_final_attack_wind_up()
			_is_attacking = true
			_is_in_windup = true
			_during_windup_multiple(positions)
			return false
		
	else:
		if !has_burst:
			_attack_at_positions(positions)
			_current_attack_wait = calculate_final_attack_speed()
			_is_attacking = false
			_finished_attacking()
		else:
			if _current_burst_count < burst_amount - 1:
				_attack_at_positions(positions)
				_current_burst_delay = calculate_final_burst_attack_speed()
				_is_bursting = true
				_current_burst_count += 1
			else:
				_attack_at_positions(positions)
				_current_attack_wait = calculate_final_attack_speed()
				_is_bursting = false
				_is_attacking = false
				_current_burst_count = 0
				_is_in_windup = false
				_finished_attacking()


#func _attack_enemy(enemy : AbstractEnemy):
#	pass

func _check_attack_enemies(enemies : Array):
	if enemies.size() != 0:
		_attack_enemies(enemies)

func _attack_enemies(enemies : Array):
	#if !_is_bursting:
	emit_signal("in_attack", _last_calculated_attack_speed_as_delay, enemies)
	
	for enemy in enemies:
		if attack_sprite_scene != null:
			var attack_sprite = attack_sprite_scene.instance()
			if attack_sprite_follow_enemy:
				enemy.add_child(attack_sprite)
			else:
				attack_sprite.position = enemy.position
				get_tree().get_root().add_child(attack_sprite)


#func _attack_at_position(_pos : Vector2):
#	pass

func _attack_at_positions(positions : Array):
	#if !_is_bursting:
	emit_signal("in_attack", _last_calculated_attack_speed_as_delay, positions)


func _modify_attack(to_modify):
	for mod in modifications:
		mod._modify_attack(to_modify)


#func _during_windup(enemy_or_pos):
#	emit_signal("in_attack_windup", _last_calculated_attack_wind_up, enemy_or_pos)

func _during_windup_multiple(enemies_or_poses : Array = []):
	if commit_to_targets_of_windup:
		for enemy in enemies_or_poses:
			_targets_during_windup.append(enemy)
	
	emit_signal("in_attack_windup", _last_calculated_attack_wind_up, enemies_or_poses)


func _finished_attacking():
	emit_signal("in_attack_end")
	_targets_during_windup.clear()

# Disabling and Enabling

func disable_module():
	_disabled = true

func enable_module():
	_disabled = false


# On Hit Damages

func calculate_final_base_damage():
	var final_base_damage = base_damage
	
	#if benefits_from_bonus_base_damage:
	var totals_bucket : Array = []
	
	for effect in percent_base_damage_effects.values():
		if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
			continue
		
		if effect.attribute_as_modifier.percent_based_on != PercentType.MAX:
			final_base_damage += effect.attribute_as_modifier.get_modification_to_value(base_damage)
		else:
			totals_bucket.append(effect)
	
	for effect in flat_base_damage_effects.values():
		if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
			continue
		final_base_damage += effect.attribute_as_modifier.get_modification_to_value(base_damage)
	
	var final_base_base_damage = final_base_damage
	for effect in totals_bucket:
		final_base_base_damage += effect.attribute_as_modifier.get_modification_to_value(final_base_damage)
	final_base_damage = final_base_base_damage
	
	last_calculated_final_damage = final_base_damage
	return final_base_damage

func _get_base_damage_as_on_hit_damage() -> OnHitDamage:
	var modifier : FlatModifier = FlatModifier.new(base_on_hit_damage_internal_name)
	modifier.flat_modifier = calculate_final_base_damage()
	
	if base_damage_scale != 1:
		modifier = modifier.get_copy_scaled_by(base_damage_scale)
	
	return OnHitDamage.new(base_on_hit_damage_internal_name, modifier, base_damage_type)

func _get_scaled_extra_on_hit_damages() -> Dictionary:
	var scaled_on_hit_damages = {}
	
	#if benefits_from_bonus_on_hit_damage:
	# EXTRA ON HITS
	for extra_on_hit_key_as_effect in on_hit_damage_adder_effects.keys():
		if on_hit_damage_adder_effects[extra_on_hit_key_as_effect].is_ingredient_effect and !benefits_from_ingredient_effect:
			continue
		
		var extra_on_hit = on_hit_damage_adder_effects[extra_on_hit_key_as_effect].on_hit_damage
		var duplicate = extra_on_hit
		
		duplicate = duplicate.duplicate()
		duplicate.damage_as_modifier = extra_on_hit.damage_as_modifier.get_copy_scaled_by(on_hit_damage_scale)
		
		scaled_on_hit_damages[extra_on_hit_key_as_effect] = duplicate
	
	return scaled_on_hit_damages


func _get_all_scaled_on_hit_damages() -> Dictionary:
	
	var scaled_on_hit_damages = {}
	
	# BASE ON HIT
	scaled_on_hit_damages[base_on_hit_damage_internal_name] = _get_base_damage_as_on_hit_damage()
	
	var extras = _get_scaled_extra_on_hit_damages()
	for extra_on_hit_uuid in extras.keys():
		scaled_on_hit_damages[extra_on_hit_uuid] = extras[extra_on_hit_uuid]
	
	return scaled_on_hit_damages


# On Hit Effects / EnemyBaseEffect

func _get_all_scaled_on_hit_effects() -> Dictionary:
	var scaled_on_hit_effects = {}
	
	for on_hit_effect_id in on_hit_effects.keys():
		var effect = on_hit_effects[on_hit_effect_id].enemy_base_effect._get_copy_scaled_by(on_hit_effect_scale)
		
		scaled_on_hit_effects[effect.effect_uuid] = effect
	
	return scaled_on_hit_effects

# On round end

func on_round_end():
	call_deferred("emit_signal", "on_round_end")
	
	_all_countbound_effects.clear()
	reset_attack_timers()


# Damage report related

func on_post_mitigation_damage_dealt(damage : float, damage_type : int, killed_enemy : bool, enemy, damage_register_id : int):
	emit_signal("on_post_mitigation_damage_dealt", damage, damage_type, killed_enemy, enemy, damage_register_id, self)

func on_enemy_hit(enemy, damage_register_id):
	emit_signal("on_enemy_hit", enemy, damage_register_id, self)


