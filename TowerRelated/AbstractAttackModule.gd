extends Node2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const Modifier = preload("res://GameInfoRelated/Modifier.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const Targeting = preload("res://GameInfoRelated/Targeting.gd")

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

var base_attack_speed : float
var base_attack_wind_up : float
var flat_attack_speed_modifiers = {}
var percent_attack_speed_modifiers = {}

var has_burst : bool
var burst_amount : int
var between_burst_delay : float

var on_hit_damage_scale : float

var base_damage : float
var base_damage_type : int
var flat_base_damage_modifiers = {}
var percent_base_damage_modifiers = {}
var base_on_hit_damage_internal_name
var extra_on_hit_damages : Dictionary

var on_hit_effect_scale : float
var on_hit_effects : Dictionary

var base_range_radius : float
var flat_range_modifiers = {}
var percent_range_modifiers = {}

var displaying_range : bool = false

# internal stuffs
var _current_attack_wait : float
var _current_wind_up_wait : float
var _is_attacking : bool

var _current_burst_count : int
var _current_burst_delay : float
var _is_bursting : bool

var enemies_in_range : Array = []

var current_targeting_option : int
var last_used_targeting_option : int
var all_targeting_options = {}

# MISC

func _ready():
	all_targeting_options["First"] = Targeting.FIRST
	current_targeting_option = Targeting.FIRST
	last_used_targeting_option = Targeting.FIRST


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
	
	#For percent range mods
	for key in percent_range_modifiers.keys():
		if percent_range_modifiers[key].is_timebound:
			percent_range_modifiers[key].time_in_seconds -= delta
			var time_left = percent_range_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		percent_range_modifiers.erase(key_to_delete)
	
	if bucket.size() > 0:
		_update_range()
	
	bucket.clear()
	
	#For flat range mods
	for key in flat_range_modifiers.keys():
		if flat_range_modifiers[key].is_timebound:
			flat_range_modifiers[key].time_in_seconds -= delta
			var time_left = flat_range_modifiers[key].time_in_seconds
			if time_left <= 0:
				bucket.append(key)
	
	for key_to_delete in bucket:
		flat_range_modifiers.erase(key_to_delete)
	
	if bucket.size() > 0:
		_update_range()
	
	bucket.clear()


# Range Related

func _toggle_show_range():
	displaying_range = !displaying_range
	update() #calls _draw()

func _draw():
	var final_range = calculate_final_range_radius()
	var color : Color = Color.gray
	color.a = 0.1
	
	if displaying_range:
		draw_circle(Vector2(0, 0), final_range, color)


func _update_range():
	var final_range = calculate_final_range_radius()
	
	$Range/RangeShape.shape.set_deferred("radius", final_range)
	update()


func _on_Range_area_shape_entered(area_id, area, area_shape, self_shape):
	_on_enemy_enter_range(area.get_parent())

func _on_Range_area_shape_exited(area_id, area, area_shape, self_shape):
	if area != null:
		_on_enemy_leave_range(area.get_parent())

#Enemy Detection Related
func _on_enemy_enter_range(enemy : AbstractEnemy):
	enemies_in_range.append(enemy)

func _on_enemy_leave_range(enemy : AbstractEnemy):
	enemies_in_range.erase(enemy)

func _is_an_enemy_in_range():
	var to_remove = []
	for target in enemies_in_range:
		if target == null:
			to_remove.append(target)
	
	for removal in to_remove:
		enemies_in_range.erase(removal)
	
	return enemies_in_range.size() > 0

func _get_current_target() -> AbstractEnemy:
	return Targeting.enemy_to_target(enemies_in_range, current_targeting_option)


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

func calculate_final_range_radius() -> float:
	#All percent modifiers here are to BASE range only
	var final_range = base_range_radius
	for modifier in percent_range_modifiers.values():
		final_range += modifier.get_modification_to_value(base_range_radius)
	
	for flat in flat_range_modifiers.values():
		final_range += flat.get_modification_to_value(base_range_radius)
	
	return final_range
	

# Attack related


func is_ready_to_attack() -> bool:
	return ((_current_attack_wait <= 0 and !_is_bursting) 
	or (_current_burst_delay <= 0 and _is_bursting)
	or (_current_wind_up_wait <= 0 and !_is_bursting))


func attempt_find_then_attack_enemy() -> bool:
	var target : AbstractEnemy
	if _is_an_enemy_in_range():
		target = _get_current_target()
	
	if target != null:
		return on_command_attack_enemy(target)
	
	return false


func on_command_attack_enemy(enemy : AbstractEnemy) -> bool:
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


func _attack_enemy(enemy : AbstractEnemy):
	pass

func _attack_at_position(pos : Vector2):
	pass


func _during_attack():
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

