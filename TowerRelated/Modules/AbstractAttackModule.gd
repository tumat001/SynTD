extends Node2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const Modifier = preload("res://GameInfoRelated/Modifier.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const RangeModule = preload("res://TowerRelated/Modules/RangeModule.gd")

const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")

enum Time_Metadata {
	TIME_AS_SECONDS,
	TIME_AS_NUM_OF_ATTACKS
}

signal final_attack_speed_changed
signal final_base_damage_changed
signal in_attack_windup(windup_time, enemies_or_poses)
signal in_attack(attack_speed_delay, enemies_or_poses)
signal in_attack_end()

var module_name : String
# These are used to help differentiate attacks
# that happer per second(s) and attacks
# per 5th attack (of "main attack")
var current_time_metadata = Time_Metadata.TIME_AS_SECONDS
var original_time_metadata = Time_Metadata.TIME_AS_SECONDS
var is_main_attack : bool = false

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
var base_on_hit_affected_by_scale : bool = false

var base_damage : float
var base_damage_type : int
# map of uuid (internal name) to effect
var flat_base_damage_effects : Dictionary = {}
var percent_base_damage_effects : Dictionary = {}
var base_on_hit_damage_internal_name : String
var on_hit_damage_adder_effects : Dictionary

var on_hit_effect_scale : float = 1
# uuid to effect map
var on_hit_effects : Dictionary

var range_module : RangeModule setget _set_range_module
var use_self_range_module : bool = false

var modifications : Array

# Attack sprites

var attack_sprite_scene
var attack_sprite_follow_enemy : bool

# internal stuffs
var _current_attack_wait : float
var _current_wind_up_wait : float
var _is_attacking : bool

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
	_current_wind_up_wait = false
	_is_attacking = false


func _ready():
	last_calculated_final_attk_speed = base_attack_speed
	last_calculated_final_damage = base_damage

func _set_range_module(new_module):
	if range_module != null:
		remove_child(range_module)
	
	if new_module != null and use_self_range_module:
		add_child(new_module)
	
	range_module = new_module

# Time passed

func time_passed(delta):
	
	if !_disabled:
		_current_attack_wait -= delta
		
		if range_module.enemies_in_range.size() != 0:
			_current_wind_up_wait -= delta
		
		if _is_bursting:
			_current_burst_delay -= delta
		
		decrease_time_of_timebounded(delta)
	


func decrease_time_of_timebounded(delta):
	var bucket = []
	
	# Extra On Hit damages
	for key in on_hit_damage_adder_effects.keys():
		if on_hit_damage_adder_effects[key].is_timebound:
			on_hit_damage_adder_effects[key].time_in_seconds -= delta
			var time_left = on_hit_damage_adder_effects[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
				
	for key_to_delete in bucket:
		on_hit_damage_adder_effects.erase(key_to_delete)
	bucket.clear()
	
	# On Hit effects
	for key in on_hit_effects.keys():
		if on_hit_effects[key].is_timebound:
			on_hit_effects[key].time_in_seconds -= delta
			var time_left = on_hit_effects[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	for key_to_delete in bucket:
		on_hit_effects.erase(key_to_delete)
	bucket.clear()
	
	
	#For attack speed
	var attack_speed_changed : bool = false
	#For percent attk speed mods
	for key in percent_attack_speed_effects.keys():
		if percent_attack_speed_effects[key].is_timebound:
			percent_attack_speed_effects[key].time_in_seconds -= delta
			var time_left = percent_attack_speed_effects[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
				attack_speed_changed = true
	
	for key_to_delete in bucket:
		percent_attack_speed_effects.erase(key_to_delete)
	
	bucket.clear()
	
	#For flat attk speed mods
	for key in flat_attack_speed_effects.keys():
		if flat_attack_speed_effects[key].is_timebound:
			flat_attack_speed_effects[key].time_in_seconds -= delta
			var time_left = flat_attack_speed_effects[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
				attack_speed_changed = true
	
	for key_to_delete in bucket:
		flat_attack_speed_effects.erase(key_to_delete)
	
	bucket.clear()
	
	if attack_speed_changed:
		call_deferred("emit_signal", "final_attack_speed_changed")
	
	
	#For base damage
	var base_damage_changed : bool = false
	#For percent attk speed mods
	for key in percent_base_damage_effects.keys():
		if percent_base_damage_effects[key].is_timebound:
			percent_base_damage_effects[key].time_in_seconds -= delta
			var time_left = percent_base_damage_effects[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
				base_damage_changed = true
	
	for key_to_delete in bucket:
		percent_base_damage_effects.erase(key_to_delete)
	
	bucket.clear()
	
	#For flat attk speed mods
	for key in flat_base_damage_effects.keys():
		if flat_base_damage_effects[key].is_timebound:
			flat_base_damage_effects[key].time_in_seconds -= delta
			var time_left = flat_base_damage_effects[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
				base_damage_changed = true
	
	for key_to_delete in bucket:
		flat_base_damage_effects.erase(key_to_delete)
	
	bucket.clear()
	
	if base_damage_changed:
		call_deferred("emit_signal", "final_base_damage_changed")
	
# Calculating final values


# Calculates attack speed, and returns attack delay
func calculate_final_attack_speed() -> float:
	if original_time_metadata == Time_Metadata.TIME_AS_NUM_OF_ATTACKS:
		return base_attack_speed
	
	#All percent modifiers here are to BASE attk speed only
	var final_attack_speed = base_attack_speed
	
	if benefits_from_bonus_attack_speed:
		for effect in percent_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_attack_speed += effect.attribute_as_modifier.get_modification_to_value(base_attack_speed)
		
		for effect in flat_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_attack_speed += effect.attribute_as_modifier.get_modification_to_value(base_attack_speed)
	
	if final_attack_speed != 0:
		last_calculated_final_attk_speed = final_attack_speed
		_last_calculated_attack_speed_as_delay = (1 / last_calculated_final_attk_speed) - (_last_calculated_attack_wind_up + (burst_amount * _last_calculated_burst_pause))
		return _last_calculated_attack_speed_as_delay
	else:
		last_calculated_final_attk_speed = 0.0
		return 0.0

func calculate_final_attack_wind_up() -> float:
	#All percent modifiers here are to BASE attk wind up only
	var final_attack_wind_up = base_attack_wind_up
	
	if benefits_from_bonus_attack_speed:
		for effect in percent_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_attack_wind_up += effect.attribute_as_modifier.get_modification_to_value(base_attack_wind_up)
		
		for effect in flat_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_attack_wind_up += effect.attribute_as_modifier.get_modification_to_value(base_attack_wind_up)
	
	
	if final_attack_wind_up != 0:
		_last_calculated_attack_wind_up = 1 / final_attack_wind_up
		return _last_calculated_attack_wind_up
	else:
		_last_calculated_attack_wind_up = 0.0
		return 0.0

func calculate_final_burst_attack_speed() -> float:
	#All percent modifiers here are to BASE in between burst only
	var final_burst_pause = burst_attack_speed
	
	if benefits_from_bonus_attack_speed:
		for effect in percent_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_burst_pause += effect.attribute_as_modifier.get_modification_to_value(burst_attack_speed)
		
		for effect in flat_attack_speed_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_burst_pause += effect.attribute_as_modifier.get_modification_to_value(burst_attack_speed)
	
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


func attempt_find_then_attack_enemies(num : int) -> bool:
	if range_module == null or !use_self_range_module:
		return false
	
#	if num == 1:
#		return attempt_find_then_attack_enemy()
	
	var targets : Array
	if range_module.is_an_enemy_in_range():
		targets = range_module.get_targets(num)
	
	return on_command_attack_enemies(targets)


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


func on_command_attack_enemies(enemies : Array) -> bool:
	if enemies.size() == 0:
		return false
	
	if !_is_attacking:
		if calculate_final_attack_wind_up() == 0:
			_attack_enemies(enemies)
			
			if has_burst:
				_is_attacking = true
				_current_burst_count += 1
				_current_burst_delay = calculate_final_burst_attack_speed()
				_is_bursting = true
			else:
				_current_attack_wait = calculate_final_attack_speed()
				_finished_attacking()
			
			return true
		else:
			_current_wind_up_wait = calculate_final_attack_wind_up()
			_is_attacking = true
			_during_windup_multiple(enemies)
			_during_attack()
			return false
		
	else:
		if !has_burst:
			_attack_enemies(enemies)
			_current_attack_wait = calculate_final_attack_speed()
			_is_attacking = false
			_finished_attacking()
			return true
		else:
			if _current_burst_count < burst_amount - 1:
				_attack_enemies(enemies)
				_current_burst_delay = calculate_final_burst_attack_speed()
				_is_bursting = true
				_current_burst_count += 1
				_during_attack()
				return true
			else:
				_attack_enemies(enemies)
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
				_finished_attacking()
			
			return true
		else:
			_current_wind_up_wait = calculate_final_attack_wind_up()
			_is_attacking = true
			_during_windup_multiple(positions)
			_during_attack()
		
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
				_during_attack()
			else:
				_attack_at_positions(positions)
				_current_attack_wait = calculate_final_attack_speed()
				_is_bursting = false
				_is_attacking = false
				_current_burst_count = 0
				_finished_attacking()


#func _attack_enemy(enemy : AbstractEnemy):
#	pass

func _attack_enemies(enemies : Array):
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
	emit_signal("in_attack", _last_calculated_attack_speed_as_delay, positions)


func _modify_attack(to_modify):
	for mod in modifications:
		mod._modify_attack(to_modify)


#func _during_windup(enemy_or_pos):
#	emit_signal("in_attack_windup", _last_calculated_attack_wind_up, enemy_or_pos)

func _during_windup_multiple(enemies_or_poses : Array = []):
	emit_signal("in_attack_windup", _last_calculated_attack_wind_up, enemies_or_poses)


func _during_attack():
	if original_time_metadata == Time_Metadata.TIME_AS_NUM_OF_ATTACKS:
		current_time_metadata = Time_Metadata.TIME_AS_SECONDS

func _finished_attacking():
	current_time_metadata = original_time_metadata
	
	emit_signal("in_attack_end")

# Disabling and Enabling

func disable_module():
	_disabled = true

func enable_module():
	_disabled = false


# On Hit Damages

func calculate_final_base_damage():
	#All percent modifiers here are to BASE damage only
	var final_base_damage = base_damage
	
	if benefits_from_bonus_base_damage:
		for effect in percent_base_damage_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_base_damage += effect.attribute_as_modifier.get_modification_to_value(base_damage)
		
		for effect in flat_base_damage_effects.values():
			if effect.is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			final_base_damage += effect.attribute_as_modifier.get_modification_to_value(base_damage)
	
	last_calculated_final_damage = final_base_damage
	return final_base_damage

func _get_base_damage_as_on_hit_damage() -> OnHitDamage:
	var modifier : FlatModifier = FlatModifier.new(base_on_hit_damage_internal_name)
	modifier.flat_modifier = calculate_final_base_damage()
	
	if on_hit_damage_scale != 1 and base_on_hit_affected_by_scale:
		modifier = modifier.get_copy_scaled_by(on_hit_damage_scale)
	
	return OnHitDamage.new(base_on_hit_damage_internal_name, modifier, base_damage_type)

func _get_scaled_extra_on_hit_damages() -> Dictionary:
	var scaled_on_hit_damages = {}
	
	if benefits_from_bonus_on_hit_damage:
		# EXTRA ON HITS
		for extra_on_hit_key_as_effect in on_hit_damage_adder_effects.keys():
			if on_hit_damage_adder_effects[extra_on_hit_key_as_effect].is_ingredient_effect and !benefits_from_ingredient_effect:
				continue
			
			var extra_on_hit = on_hit_damage_adder_effects[extra_on_hit_key_as_effect].on_hit_damage
			var duplicate = extra_on_hit
			
			if on_hit_damage_scale != 1:
				duplicate = duplicate.duplicate()
				duplicate.damage_as_modifier = extra_on_hit.damage_as_modifier.get_copy_scaled_by(on_hit_damage_scale)
			
			scaled_on_hit_damages[extra_on_hit_key_as_effect] = duplicate
	
	return scaled_on_hit_damages


func _get_all_scaled_on_hit_damages() -> Dictionary:
	if !benefits_from_bonus_on_hit_effect:
		return {}
	
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

