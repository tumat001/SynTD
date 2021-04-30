extends Node2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const Modifier = preload("res://GameInfoRelated/Modifier.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const RangeModule = preload("res://TowerRelated/RangeModule.gd")

enum Time_Metadata {
	TIME_AS_SECONDS,
	TIME_AS_NUM_OF_ATTACKS
}


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


var base_attack_speed : float = 1
var base_attack_wind_up : float = 0
var flat_attack_speed_modifiers : Dictionary = {} 
var percent_attack_speed_modifiers : Dictionary = {}

var has_burst : bool = false
var burst_amount : int
var between_burst_delay : float = 1

var on_hit_damage_scale : float = 1

var base_damage : float
var base_damage_type : int
var flat_base_damage_modifiers : Dictionary = {}
var percent_base_damage_modifiers : Dictionary = {}
var base_on_hit_damage_internal_name
var extra_on_hit_damages : Dictionary

var on_hit_effect_scale : float = 1
var on_hit_effects : Dictionary

var range_module : RangeModule

# internal stuffs
var _current_attack_wait : float
var _current_wind_up_wait : float
var _is_attacking : bool

var _current_burst_count : int
var _current_burst_delay : float
var _is_bursting : bool


# MISC

func _ready():
	if range_module != null:
		add_child(range_module)


# Time passed

func time_passed(delta):
	_current_attack_wait -= delta
	_current_wind_up_wait -= delta
	if _is_bursting:
		_current_burst_delay -= delta
	
	decrease_time_of_timebounded(delta)


func decrease_time_of_timebounded(delta):
	var bucket = []
	
	# Extra On Hit damages
	for key in extra_on_hit_damages.keys():
		if extra_on_hit_damages[key].is_timebound:
			extra_on_hit_damages[key].time_in_seconds -= delta
			var time_left = extra_on_hit_damages[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
				
	for key_to_delete in bucket:
		extra_on_hit_damages.erase(key_to_delete)
	bucket.clear()
	
	# On Hit effects
	for key in on_hit_effects.keys():
		if on_hit_effects[key].is_timebound:
			on_hit_effects[key].time_in_seconds -= delta
			var time_left = on_hit_effects[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	for key_to_delete in bucket:
		extra_on_hit_damages.erase(key_to_delete)
	bucket.clear()
	
	#For percent attk speed mods
	for key in percent_attack_speed_modifiers.keys():
		if percent_attack_speed_modifiers[key].is_timebound:
			percent_attack_speed_modifiers[key].time_in_seconds -= delta
			var time_left = percent_attack_speed_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		percent_attack_speed_modifiers.erase(key_to_delete)
	
	bucket.clear()
	
	#For flat attk speed mods
	for key in flat_attack_speed_modifiers.keys():
		if flat_attack_speed_modifiers[key].is_timebound:
			flat_attack_speed_modifiers[key].time_in_seconds -= delta
			var time_left = flat_attack_speed_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		flat_attack_speed_modifiers.erase(key_to_delete)
	
	bucket.clear()
	

# Calculating final values

func calculate_final_attack_speed() -> float:
	if original_time_metadata == Time_Metadata.TIME_AS_NUM_OF_ATTACKS:
		return base_attack_speed
	
	#All percent modifiers here are to BASE attk speed only
	var final_attack_speed = base_attack_speed
	for modifier in percent_attack_speed_modifiers.values():
		final_attack_speed += modifier.get_modification_to_value(base_attack_speed)
	
	for flat in flat_attack_speed_modifiers.values():
		final_attack_speed += flat.get_modification_to_value(base_attack_speed)
	
	return final_attack_speed

func calculate_final_attack_wind_up() -> float:
	#All percent modifiers here are to BASE attk wind up only
	var final_attack_wind_up = base_attack_wind_up
	for modifier in percent_attack_speed_modifiers.values():
		final_attack_wind_up += modifier.get_modification_to_value(base_attack_wind_up)
	
	for flat in flat_attack_speed_modifiers.values():
		final_attack_wind_up += flat.get_modification_to_value(base_attack_wind_up)
	
	return final_attack_wind_up

func calculate_final_in_between_burst() -> float:
	#All percent modifiers here are to BASE in between burst only
	var final_burst_pause = between_burst_delay
	for modifier in percent_attack_speed_modifiers.values():
		final_burst_pause += modifier.get_modification_to_value(between_burst_delay)
	
	for flat in flat_attack_speed_modifiers.values():
		final_burst_pause += flat.get_modification_to_value(between_burst_delay)
	
	return final_burst_pause


# Attack related


func is_ready_to_attack() -> bool:
	if !_is_attacking:
		return _current_attack_wait <= 0
	else:
		if _is_bursting:
			return _current_burst_delay <= 0
		else:
			return _current_wind_up_wait <= 0


func attempt_find_then_attack_enemy() -> bool:
	if range_module == null:
		return false
	
	var target : AbstractEnemy
	if range_module.is_an_enemy_in_range():
		target = range_module.get_target()
	
	return on_command_attack_enemy(target)


func attempt_find_then_attack_enemies(num : int) -> bool:
	if range_module == null:
		return false
	
	if num == 1:
		return attempt_find_then_attack_enemy()
	
	var targets : Array
	if range_module.is_an_enemy_in_range():
		targets = range_module.get_targets(num)
	
	return on_command_attack_enemies(targets)


func on_command_attack_enemy(enemy : AbstractEnemy) -> bool:
	if enemy == null:
		return false
	
	if !_is_attacking:
		if calculate_final_attack_wind_up() == 0:
			_attack_enemy(enemy)
			_current_attack_wait = calculate_final_attack_speed()
			_finished_attacking()
			return true
		else:
			_current_wind_up_wait = calculate_final_attack_wind_up()
			_is_attacking = true
			_during_attack()
			return false
		
	else:
		if !has_burst:
			_attack_enemy(enemy)
			_current_attack_wait = calculate_final_attack_speed()
			_is_attacking = false
			_finished_attacking()
			return true
		else:
			if _current_burst_count < burst_amount - 1:
				_attack_enemy(enemy)
				_current_burst_delay = calculate_final_attack_wind_up()
				_is_bursting = true
				_during_attack()
				return true
			else:
				_attack_enemy(enemy)
				_current_attack_wait = calculate_final_attack_speed()
				_is_bursting = false
				_is_attacking = false
				_finished_attacking()
				return true


func on_command_attack_at_position(pos : Vector2):
	if !_is_attacking:
		if calculate_final_attack_wind_up() == 0:
			_attack_at_position(pos)
			_current_attack_wait = calculate_final_attack_speed()
			_finished_attacking()
		else:
			_current_wind_up_wait = calculate_final_attack_wind_up()
			_is_attacking = true
			_during_attack()
		
	else:
		if !has_burst:
			_attack_at_position(pos)
			_current_attack_wait = calculate_final_attack_speed()
			_is_attacking = false
			_finished_attacking()
		else:
			if _current_burst_count < burst_amount - 1:
				_attack_at_position(pos)
				_current_burst_delay = calculate_final_in_between_burst()
				_is_bursting = true
				_during_attack()
			else:
				_attack_at_position(pos)
				_current_attack_wait = calculate_final_attack_speed()
				_is_bursting = false
				_finished_attacking()


func on_command_attack_enemies(enemies : Array) -> bool:
	if enemies.size() == 0:
		return false
	
	if !_is_attacking:
		if calculate_final_attack_wind_up() == 0:
			_attack_enemies(enemies)
			_current_attack_wait = calculate_final_attack_speed()
			_finished_attacking()
			return true
		else:
			_current_wind_up_wait = calculate_final_attack_wind_up()
			_is_attacking = true
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
				_current_burst_delay = calculate_final_attack_wind_up()
				_is_bursting = true
				_during_attack()
				return true
			else:
				_attack_enemies(enemies)
				_current_attack_wait = calculate_final_attack_speed()
				_is_bursting = false
				_is_attacking = false
				_finished_attacking()
				return true


func on_command_attack_at_positions(positions : Array):
	if !_is_attacking:
		if calculate_final_attack_wind_up() == 0:
			_attack_at_positions(positions)
			_current_attack_wait = calculate_final_attack_speed()
			_finished_attacking()
		else:
			_current_wind_up_wait = calculate_final_attack_wind_up()
			_is_attacking = true
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
				_current_burst_delay = calculate_final_in_between_burst()
				_is_bursting = true
				_during_attack()
			else:
				_attack_at_positions(positions)
				_current_attack_wait = calculate_final_attack_speed()
				_is_bursting = false
				_finished_attacking()


func _attack_enemy(enemy : AbstractEnemy):
	pass

func _attack_enemies(enemies : Array):
	pass

func _attack_at_position(pos : Vector2):
	pass

func _attack_at_positions(positions : Array):
	pass


func _during_attack():
	if original_time_metadata == Time_Metadata.TIME_AS_NUM_OF_ATTACKS:
		current_time_metadata = Time_Metadata.TIME_AS_SECONDS

func _finished_attacking():
	current_time_metadata = original_time_metadata


# On Hit Damages

func calculate_final_base_damage():
	#All percent modifiers here are to BASE damage only
	var final_base_damage = base_damage
	for modifier in percent_base_damage_modifiers.values():
		final_base_damage += modifier.get_modification_to_value(base_damage)
	
	for flat in flat_base_damage_modifiers.values():
		final_base_damage += flat.get_modification_to_value(base_damage)
	
	return final_base_damage

func _get_base_damage_as_on_hit_damage() -> OnHitDamage:
	var modifier : FlatModifier = FlatModifier.new(base_on_hit_damage_internal_name)
	modifier.flat_modifier = calculate_final_base_damage()

	return OnHitDamage.new(base_on_hit_damage_internal_name, modifier, base_damage_type)


func _get_all_scaled_on_hit_damages() -> Dictionary:
	var scaled_on_hit_damages = {}
	
	# BASE ON HIT
	scaled_on_hit_damages[base_on_hit_damage_internal_name] = _get_base_damage_as_on_hit_damage().damage_as_modifier.get_copy_scaled_by(on_hit_damage_scale)
	
	# EXTRA ON HITS
	for extra_on_hit_key in extra_on_hit_damages.keys():
		scaled_on_hit_damages[extra_on_hit_key] = extra_on_hit_damages[extra_on_hit_key].damage_as_modifier.get_copy_scaled_by(on_hit_damage_scale)
	
	return scaled_on_hit_damages

# On Hit Effects

func _get_all_scaled_on_hit_effects() -> Dictionary:
	var scaled_on_hit_effects = {}
	
	for on_hit_effect_key in on_hit_effects.keys():
		scaled_on_hit_effects[on_hit_effect_key] = on_hit_effects[on_hit_effect_key].effect_strength_modifier.get_copy_scaled_by(on_hit_effect_scale)
	
	return scaled_on_hit_effects

