extends Node2D

const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const Modifier = preload("res://GameInfoRelated/Modifier.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const Targeting = preload("res://GameInfoRelated/Targeting.gd")
const RangeModule = preload("res://TowerRelated/Modules/RangeModule.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const ConditionalClauses = preload("res://MiscRelated/ClauseRelated/ConditionalClauses.gd")

const AttackSprite = preload("res://MiscRelated/AttackSpriteRelated/AttackSprite.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

const MainAttack_DefaultIcon = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/AttackModuleStatsPanel/Assets/Defaults/MainAttack_IconDefault.png")


signal in_attack_windup(windup_time, enemies_or_poses)
signal in_attack(attack_speed_delay, enemies_or_poses)
signal in_attack_end()

signal on_round_end()

signal on_post_mitigation_damage_dealt(damage_instance_report, killed, enemy, damage_register_id, module)
signal on_enemy_hit(enemy, damage_register_id, damage_instance, module)

signal on_damage_instance_constructed(damage_instance, module)

signal before_attack_sprite_is_shown(attack_sprite)

signal ready_to_attack()

signal can_be_commanded_changed(can_be_commanded)

signal on_in_round_total_dmg_changed(new_total)
signal on_in_round_pure_dmg_dealt_changed(new_total)
signal on_in_round_elemental_dmg_dealt_changed(new_total)
signal on_in_round_physical_dmg_dealt_changed(new_total)


enum CanBeCommandedByTower_ClauseId {
	CHAOS_TAKEOVER = 1
	ACCUMULAE_DISABLE = 2
	NUCLEUS_DISABLE = 3
	
	SELF_DEFINED_CLAUSE_01 = 100
	
	
}

enum Disabled_ClauseId {
	IS_IN_DRAG,
	
	IS_STUNNED,
}


var module_id : int
var parent_tower setget set_parent_tower

var is_main_attack : bool = false # OBSELETE


var number_of_unique_targets : int = 1

var can_be_commanded_by_tower : bool = true setget _set_can_be_commanded_by_tower, _get_can_be_commanded_by_tower
var can_be_commanded_by_tower_other_clauses : ConditionalClauses
var last_calculated_can_be_commanded_by_tower : bool

var benefits_from_bonus_attack_speed : bool = true
var benefits_from_bonus_on_hit_damage : bool = true
var benefits_from_bonus_base_damage : bool = true
var benefits_from_bonus_on_hit_effect : bool = true
var benefits_from_bonus_armor_pierce : bool = true
var benefits_from_bonus_toughness_pierce : bool = true
var benefits_from_bonus_resistance_pierce : bool = true

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
var base_on_hit_damage_internal_id : int
var on_hit_damage_adder_effects : Dictionary


var base_armor_pierce : float
var flat_base_armor_pierce_effects : Dictionary = {}

var base_toughness_pierce : float
var flat_base_toughness_pierce_effects : Dictionary = {}

var base_resistance_pierce : float
var flat_base_resistance_pierce_effects : Dictionary = {}


var damage_register_id : int

var on_hit_effect_scale : float = 1
# uuid to effect map
var on_hit_effects : Dictionary

# used by on command attack and attack when ready
var queued_attack_count : int = 0


# Managed by abstracttower completely
var _all_countbound_effects : Dictionary = {}

var range_module : RangeModule setget _set_range_module
var use_self_range_module : bool = false # used for range displaying

var use_own_targeting : bool = false
var own_targeting_option : int

# Attack sprites

var attack_sprite_scene
var attack_sprite_follow_enemy : bool

var attack_sprite_show_in_windup : bool
var attack_sprite_match_lifetime_to_windup : bool = true
var attack_sprite_show_in_attack : bool = true


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


#var _disabled : bool = false
var is_disabled_clauses : ConditionalClauses
var _last_calculated_is_disabled : bool = false

# last calculated vars

var last_calculated_final_damage : float
var last_calculated_final_attk_speed : float

var last_calculated_final_armor_pierce : float
#var last_calculated_final_percent_enemy_armor_pierce : float

var last_calculated_final_toughness_pierce : float
#var last_calculated_final_percent_enemy_toughness_pierce : float

var last_calculated_final_resistance_pierce : float
#var last_calculated_final_percent_enemy_resistance_pierce : float


var _last_calculated_attack_wind_up : float 
var _last_calculated_burst_pause : float
var _last_calculated_attack_speed_as_delay : float


# Damage tracker

var in_round_total_damage_dealt : float setget set_in_round_total_damage_dealt
var in_round_pure_damage_dealt : float setget set_in_round_pure_damage_dealt
var in_round_elemental_damage_dealt : float setget set_in_round_elemental_damage_dealt
var in_round_physical_damage_dealt : float setget set_in_round_physical_damage_dealt

#
var tracker_image : Texture
var is_displayed_in_tracker : bool = true
const image_size := Vector2(18, 18) # size of texture is 18x18

#

func set_parent_tower(arg_parent_tower):
	parent_tower = arg_parent_tower

# Can be commanded related

func _init():
	can_be_commanded_by_tower_other_clauses = ConditionalClauses.new()
	
	can_be_commanded_by_tower_other_clauses.connect("clause_inserted", self, "_can_be_commanded_clause_inserted", [], CONNECT_PERSIST)
	can_be_commanded_by_tower_other_clauses.connect("clause_removed", self, "_can_be_commanded_clause_removed", [], CONNECT_PERSIST)
	
	_calculate_can_be_commanded_by_tower_clause()
	
	#
	
	is_disabled_clauses = ConditionalClauses.new()
	
	is_disabled_clauses.connect("clause_inserted", self, "_is_disabled_clause_inserted", [], CONNECT_PERSIST)
	is_disabled_clauses.connect("clause_removed", self, "_is_disabled_clause_removed", [], CONNECT_PERSIST)
	
	_calculate_is_disabled_clause()
	
	#
	
	set_image_as_tracker_image(MainAttack_DefaultIcon)
	
	#
	
	own_targeting_option = Targeting.FIRST


# can be commanded clause

func _can_be_commanded_clause_inserted(inserted):
	_calculate_can_be_commanded_by_tower_clause()

func _can_be_commanded_clause_removed(removed):
	_calculate_can_be_commanded_by_tower_clause()

func _calculate_can_be_commanded_by_tower_clause():
	last_calculated_can_be_commanded_by_tower = _if_can_be_commanded_by_tower()


func _if_can_be_commanded_by_tower() -> bool:
	if can_be_commanded_by_tower == false:
		return false
	
	return can_be_commanded_by_tower_other_clauses.is_passed

# is disabled clauses

func _is_disabled_clause_inserted(inserted):
	_calculate_is_disabled_clause()

func _is_disabled_clause_removed(removed):
	_calculate_is_disabled_clause()

func _calculate_is_disabled_clause():
	_last_calculated_is_disabled = !is_disabled_clauses.is_passed



# for compatibility stuffs
func _get_can_be_commanded_by_tower() -> bool:
	return _if_can_be_commanded_by_tower()

func _set_can_be_commanded_by_tower(val):
	can_be_commanded_by_tower = val
	_calculate_can_be_commanded_by_tower_clause()

# Misc

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
	calculate_final_armor_pierce()
	calculate_final_toughness_pierce()
	calculate_final_resistance_pierce()


func _set_range_module(new_module):
	if range_module != null:
		if get_children().has(range_module):
			remove_child(range_module)
		range_module.attack_modules_using_this.erase(self)
	
	if new_module != null:
		if new_module.get_parent() == null:
			add_child(new_module)
		new_module.attack_modules_using_this.append(self)
	
	range_module = new_module

# Time passed


func time_passed(delta):
	if !_last_calculated_is_disabled:
		_current_attack_wait -= delta
		
		if (range_module != null and range_module.enemies_in_range.size() != 0) or (commit_to_targets_of_windup and _is_in_windup):#_targets_during_windup.size() > 0):
			_current_wind_up_wait -= delta
		
		if _is_bursting:
			_current_burst_delay -= delta
	
	
	if is_ready_to_attack():
		emit_signal("ready_to_attack")


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

# Calculate res/arm/tou pierce

func calculate_final_armor_pierce() -> float:
	var final_armor_pierce = base_armor_pierce
	
	var totals_bucket : Array = []
	
	for effect in flat_base_armor_pierce_effects.values():
		final_armor_pierce += effect.attribute_as_modifier.get_modification_to_value(base_armor_pierce)
	
	last_calculated_final_armor_pierce = final_armor_pierce
	return final_armor_pierce


func calculate_final_toughness_pierce() -> float:
	var final_toughness_pierce = base_toughness_pierce
	
	var totals_bucket : Array = []
	
	for effect in flat_base_toughness_pierce_effects.values():
		final_toughness_pierce += effect.attribute_as_modifier.get_modification_to_value(base_toughness_pierce)
	
	last_calculated_final_toughness_pierce = final_toughness_pierce
	return final_toughness_pierce


func calculate_final_resistance_pierce() -> float:
	var final_resistance_pierce = base_resistance_pierce
	
	var totals_bucket : Array = []
	
	for effect in flat_base_resistance_pierce_effects.values():
		final_resistance_pierce += effect.attribute_as_modifier.get_modification_to_value(base_resistance_pierce)
	
	last_calculated_final_resistance_pierce = final_resistance_pierce
	return final_resistance_pierce



# Calculates attack speed, and returns attack delay
func calculate_all_speed_related_attributes():
	calculate_final_attack_speed()
	calculate_final_attack_wind_up()
	calculate_final_burst_attack_speed()


func calculate_final_attack_speed() -> float:
	var final_attack_speed = base_attack_speed
	
	#if benefits_from_bonus_attack_speed:
	var totals_bucket : Array = []
	
	for effect in percent_attack_speed_effects.values():
		if effect.attribute_as_modifier.percent_based_on != PercentType.MAX:
			final_attack_speed += effect.attribute_as_modifier.get_modification_to_value(base_attack_speed)
		else:
			totals_bucket.append(effect)
	
	for effect in flat_attack_speed_effects.values():
		final_attack_speed += effect.attribute_as_modifier.get_modification_to_value(base_attack_speed)
	
	var final_base_attk_speed = final_attack_speed
	for effect in totals_bucket:
		final_base_attk_speed += effect.attribute_as_modifier.get_modification_to_value(final_base_attk_speed)
	
	final_attack_speed = final_base_attk_speed

	
	if final_attack_speed != 0:
		last_calculated_final_attk_speed = final_attack_speed
		_last_calculated_attack_speed_as_delay = (1 / last_calculated_final_attk_speed) - (_last_calculated_attack_wind_up + (burst_amount * _last_calculated_burst_pause))
		return _last_calculated_attack_speed_as_delay
	else:
		last_calculated_final_attk_speed = 0.0
		return last_calculated_final_attk_speed


func calculate_final_attack_wind_up() -> float:
	if base_attack_wind_up == 0:
		return 0.0
	
	#All percent modifiers here are to BASE attk wind up only
	var final_attack_wind_up = base_attack_wind_up
	
	#if benefits_from_bonus_attack_speed:
	var totals_bucket : Array = []
	
	for effect in percent_attack_speed_effects.values():
		if effect.attribute_as_modifier.percent_based_on != PercentType.MAX:
			final_attack_wind_up += effect.attribute_as_modifier.get_modification_to_value(base_attack_wind_up)
		else:
			totals_bucket.append(effect)
	
	for effect in flat_attack_speed_effects.values():
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
	
	#if benefits_from_bonus_attack_speed:
	var totals_bucket : Array = []
	
	for effect in percent_attack_speed_effects.values():
		if effect.attribute_as_modifier.percent_based_on != PercentType.MAX:
			final_burst_pause += effect.attribute_as_modifier.get_modification_to_value(burst_attack_speed)
		else:
			totals_bucket.append(effect)
	
	for effect in flat_attack_speed_effects.values():
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
	
	var targets : Array = _get_enemies_found_by_range_module(num)
	
	return on_command_attack_enemies(targets, num)


func _get_enemies_found_by_range_module(arg_num_of_targets : int):
	if range_module == null:
		return null
	
	var targets : Array
	if range_module.is_an_enemy_in_range():
		if !use_own_targeting:
			targets = range_module.get_targets(arg_num_of_targets)
		else:
			targets = range_module.get_targets(arg_num_of_targets, own_targeting_option)
	
	return targets


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

#

func on_command_attack_enemies_and_attack_when_ready(arg_enemies : Array, num_of_targets : int = number_of_unique_targets, attack_count : int = 1, default_to_enemies_in_range : bool = false):
	var success = false
	
	#if !_is_bursting:
	success = on_command_attack_enemies(arg_enemies, num_of_targets)
	
	queued_attack_count += attack_count
	
	if arg_enemies.size() <= 0:
		#queued_attack_count = 0
		
		if is_connected("ready_to_attack", self, "on_command_attack_enemies_and_attack_when_ready"):
			disconnect("ready_to_attack", self, "on_command_attack_enemies_and_attack_when_ready")
		
		if default_to_enemies_in_range:
			on_command_attack_enemies_in_range_and_attack_when_ready(num_of_targets, 0)
		#queued_attack_count = 0
		return
	
	if !success:
		_connect_attack_enemies_when_ready(arg_enemies, num_of_targets, default_to_enemies_in_range)
	else:
		queued_attack_count -= 1
		
		if queued_attack_count <= 0:
			queued_attack_count = 0
			if is_connected("ready_to_attack", self, "on_command_attack_enemies_and_attack_when_ready"):
				disconnect("ready_to_attack", self, "on_command_attack_enemies_and_attack_when_ready")
		else:
			_connect_attack_enemies_when_ready(arg_enemies, num_of_targets, default_to_enemies_in_range)


func _connect_attack_enemies_when_ready(arg_enemies, num_of_targets, default_to_enemies_in_range):
	if !is_connected("ready_to_attack", self, "on_command_attack_enemies_and_attack_when_ready"):
		connect("ready_to_attack", self, "on_command_attack_enemies_and_attack_when_ready", [arg_enemies, num_of_targets, 0, default_to_enemies_in_range])

#

func on_command_attack_enemies_in_range_and_attack_when_ready(num_of_targets : int = number_of_unique_targets, attack_count : int = 1):
	var success = false
	var enemies : Array
	
	#if !_is_bursting:
	enemies = _get_enemies_found_by_range_module(num_of_targets)
	success = on_command_attack_enemies(enemies, num_of_targets)
	
	queued_attack_count += attack_count
	
	if enemies.size() <= 0:
		queued_attack_count = 0
		
		if is_connected("ready_to_attack", self, "on_command_attack_enemies_in_range_and_attack_when_ready"):
			disconnect("ready_to_attack", self, "on_command_attack_enemies_in_range_and_attack_when_ready")
		return
	
	if !success:
		_connect_attack_enemies_in_range_when_ready(enemies, num_of_targets)
	else:
		queued_attack_count -= 1
		
		if queued_attack_count <= 0:
			queued_attack_count = 0
			if is_connected("ready_to_attack", self, "on_command_attack_enemies_in_range_and_attack_when_ready"):
				disconnect("ready_to_attack", self, "on_command_attack_enemies_in_range_and_attack_when_ready")
		else:
			_connect_attack_enemies_in_range_when_ready(enemies, num_of_targets)

func _connect_attack_enemies_in_range_when_ready(arg_enemies, num_of_targets):
	if !is_connected("ready_to_attack", self, "on_command_attack_enemies_in_range_and_attack_when_ready"):
		connect("ready_to_attack", self, "on_command_attack_enemies_in_range_and_attack_when_ready", [num_of_targets, 0])



#


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
	
	#
	
	var to_delete : Array = []
	for enemy in enemies:
		if enemy == null or enemy.is_queued_for_deletion():
			to_delete.append(enemy)
	
	for enemy in to_delete:
		enemies.erase(enemy)
	
	#
	
	if enemies.size() == 0 and !_is_attacking:
		return false
	
	
	#while enemies.has(null):
	#	enemies.erase(null)
	
	
	if !_is_attacking:
		if _last_calculated_attack_wind_up == 0:
			_check_attack_enemies(enemies)
			
			if has_burst:
				_is_attacking = true
				_current_burst_count += 1
				_current_burst_delay = _last_calculated_burst_pause
				_is_bursting = true
				return false #wdad
			else:
				_current_attack_wait = _last_calculated_attack_speed_as_delay
				_is_attacking = false
				_is_in_windup = false
				_finished_attacking()
				return true #dwad
			
			#return true
		else:
			_current_wind_up_wait = _last_calculated_attack_wind_up
			_is_attacking = true
			_is_in_windup = true
			_during_windup_multiple(enemies)
			return false
		
	else:
		if !has_burst:
			_check_attack_enemies(enemies)
			_current_attack_wait = _last_calculated_attack_speed_as_delay
			_is_attacking = false
			_is_in_windup = false
			_finished_attacking()
			return true
		else:
			if _current_burst_count < burst_amount - 1:
				_check_attack_enemies(enemies)
				_current_burst_delay = _last_calculated_burst_pause
				_is_bursting = true
				_current_burst_count += 1
				#return true
				return false #wdadwad
			else:
				_check_attack_enemies(enemies)
				_is_in_windup = false
				_current_attack_wait = _last_calculated_attack_speed_as_delay
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
		# moved above to on command attack func
		#while enemies.has(null):
		#	enemies.erase(null)
		
		_attack_enemies(enemies)

func _attack_enemies(enemies : Array):
	#if !_is_bursting:
	emit_signal("in_attack", _last_calculated_attack_speed_as_delay, enemies)
	
	if attack_sprite_show_in_attack:
		for enemy in enemies:
			if attack_sprite_scene != null and enemy != null:
				var attack_sprite = attack_sprite_scene.instance()
				emit_signal("before_attack_sprite_is_shown", attack_sprite)
				
				if attack_sprite_follow_enemy:
					enemy.add_child(attack_sprite)
				else:
					attack_sprite.position = enemy.position
					get_tree().get_root().add_child(attack_sprite)


#func _attack_at_position(_pos : Vector2):
#	pass

# IMPLEMENT SOON IF NEEDED
func _check_attack_positions(positions : Array):
	if positions.size() != 0:
		_attack_at_positions(positions)

func _attack_at_positions(positions : Array):
	#if !_is_bursting:
	emit_signal("in_attack", _last_calculated_attack_speed_as_delay, positions)



#func _during_windup(enemy_or_pos):
#	emit_signal("in_attack_windup", _last_calculated_attack_wind_up, enemy_or_pos)

func _during_windup_multiple(enemies_or_poses : Array = []):
	if commit_to_targets_of_windup:
		for enemy in enemies_or_poses:
			_targets_during_windup.append(enemy)
	
	if attack_sprite_show_in_windup:
		for enemy in enemies_or_poses:
			if attack_sprite_scene != null and enemy != null:
				var attack_sprite = attack_sprite_scene.instance()
				
				if attack_sprite_match_lifetime_to_windup:
					attack_sprite.lifetime = _last_calculated_attack_wind_up
					attack_sprite.has_lifetime = true
					attack_sprite.frames_based_on_lifetime = true
				
				emit_signal("before_attack_sprite_is_shown", attack_sprite)
				
				if attack_sprite_follow_enemy:
					enemy.add_child(attack_sprite)
				else:
					attack_sprite.position = enemy.position
					get_tree().get_root().add_child(attack_sprite)
	
	
	emit_signal("in_attack_windup", _last_calculated_attack_wind_up, enemies_or_poses)


func _finished_attacking():
	emit_signal("in_attack_end")
	_targets_during_windup.clear()


# Disabling and Enabling

func disable_module(disabled_clause_id : int):
	#_disabled = true
	is_disabled_clauses.attempt_insert_clause(disabled_clause_id)

func enable_module(disabled_clause_id : int):
	#_disabled = false
	is_disabled_clauses.remove_clause(disabled_clause_id)


# On Hit Damages

func calculate_final_base_damage():
	var final_base_damage = base_damage
	
	#if benefits_from_bonus_base_damage:
	var totals_bucket : Array = []
	
	for effect in percent_base_damage_effects.values():
		if effect.attribute_as_modifier.percent_based_on != PercentType.MAX:
			final_base_damage += effect.attribute_as_modifier.get_modification_to_value(base_damage)
		else:
			totals_bucket.append(effect)
	
	for effect in flat_base_damage_effects.values():
		final_base_damage += effect.attribute_as_modifier.get_modification_to_value(base_damage)
	
	var final_base_base_damage = final_base_damage
	for effect in totals_bucket:
		final_base_base_damage += effect.attribute_as_modifier.get_modification_to_value(final_base_base_damage)
	final_base_damage = final_base_base_damage
	
	last_calculated_final_damage = final_base_damage
	return final_base_damage

func _get_base_damage_as_on_hit_damage() -> OnHitDamage:
	var modifier : FlatModifier = FlatModifier.new(base_on_hit_damage_internal_id)
	modifier.flat_modifier = last_calculated_final_damage #calculate_final_base_damage()
	
	if base_damage_scale != 1:
		modifier = modifier.get_copy_scaled_by(base_damage_scale)
	
	return OnHitDamage.new(base_on_hit_damage_internal_id, modifier, base_damage_type)

func _get_scaled_extra_on_hit_damages() -> Dictionary:
	var scaled_on_hit_damages = {}
	
	#if benefits_from_bonus_on_hit_damage:
	# EXTRA ON HITS
	for extra_on_hit_key_as_effect in on_hit_damage_adder_effects.keys():
		var tower_effect = on_hit_damage_adder_effects[extra_on_hit_key_as_effect]
		var extra_on_hit = tower_effect.on_hit_damage
		var duplicate = extra_on_hit.duplicate()
		
		if tower_effect.should_respect_attack_module_scale:
			duplicate.damage_as_modifier = extra_on_hit.damage_as_modifier.get_copy_scaled_by(on_hit_damage_scale)
		
		scaled_on_hit_damages[extra_on_hit_key_as_effect] = duplicate
	
	return scaled_on_hit_damages


func _get_all_scaled_on_hit_damages() -> Dictionary:
	
	var scaled_on_hit_damages = {}
	
	# BASE ON HIT
	scaled_on_hit_damages[base_on_hit_damage_internal_id] = _get_base_damage_as_on_hit_damage()
	
	var extras = _get_scaled_extra_on_hit_damages()
	for extra_on_hit_uuid in extras.keys():
		scaled_on_hit_damages[extra_on_hit_uuid] = extras[extra_on_hit_uuid]
	
	return scaled_on_hit_damages


# On Hit Effects / EnemyBaseEffect

func _get_all_scaled_on_hit_effects() -> Dictionary:
	var scaled_on_hit_effects = {}
	
	for on_hit_effect_id in on_hit_effects.keys():
		
		var tower_effect = on_hit_effects[on_hit_effect_id]
		var scale_to_use = 1
		
		if tower_effect.should_respect_attack_module_scale:
			scale_to_use = on_hit_effect_scale
		
		var enemy_effect = tower_effect.enemy_base_effect._get_copy_scaled_by(scale_to_use)
		
		scaled_on_hit_effects[enemy_effect.effect_uuid] = enemy_effect
	
	return scaled_on_hit_effects


# Damage related

func construct_damage_instance() -> DamageInstance:
	var damage_instance : DamageInstance = DamageInstance.new()
	damage_instance.on_hit_damages = _get_all_scaled_on_hit_damages()
	damage_instance.on_hit_effects = _get_all_scaled_on_hit_effects()
	
	damage_instance.final_armor_pierce = last_calculated_final_armor_pierce
	damage_instance.final_toughness_pierce = last_calculated_final_toughness_pierce
	damage_instance.final_resistance_pierce = last_calculated_final_resistance_pierce
	
	return damage_instance


# On round end

func on_round_end():
	call_deferred("emit_signal", "on_round_end")
	
	_all_countbound_effects.clear()
	reset_attack_timers()
	
	queued_attack_count = 0
	
	if is_connected("ready_to_attack", self, "on_command_attack_enemies_and_attack_when_ready"):
		disconnect("ready_to_attack", self, "on_command_attack_enemies_and_attack_when_ready")
	if is_connected("ready_to_attack", self, "on_command_attack_enemies_in_range_and_attack_when_ready"):
		disconnect("ready_to_attack", self, "on_command_attack_enemies_in_range_and_attack_when_ready")
	
	
	if range_module != null:
		range_module.clear_all_target_effects()


# Damage report related

func on_post_mitigation_damage_dealt(damage_instance_report, killed_enemy : bool, enemy, damage_register_id : int):
	emit_signal("on_post_mitigation_damage_dealt", damage_instance_report, killed_enemy, enemy, damage_register_id, self)

func on_enemy_hit(enemy, damage_register_id, damage_instance):
	emit_signal("on_enemy_hit", enemy, damage_register_id, damage_instance, self)


# Damage Tracking related

func reset_damage_track_in_round():
	set_in_round_total_damage_dealt(0)
	set_in_round_pure_damage_dealt(0)
	set_in_round_elemental_damage_dealt(0)
	set_in_round_physical_damage_dealt(0)


func set_in_round_total_damage_dealt(arg_total):
	in_round_total_damage_dealt = arg_total
	emit_signal("on_in_round_total_dmg_changed", arg_total)

func set_in_round_pure_damage_dealt(arg_total):
	in_round_pure_damage_dealt = arg_total
	emit_signal("on_in_round_pure_dmg_dealt_changed", arg_total)

func set_in_round_elemental_damage_dealt(arg_total):
	in_round_elemental_damage_dealt = arg_total
	emit_signal("on_in_round_elemental_dmg_dealt_changed", arg_total)

func set_in_round_physical_damage_dealt(arg_total):
	in_round_physical_damage_dealt = arg_total
	emit_signal("on_in_round_physical_dmg_dealt_changed", arg_total)


# Image related

static func _generate_module_image_icon_atlas_texture(module_sprite) -> AtlasTexture:
	var module_image_icon_atlas_texture := AtlasTexture.new()
	
	module_image_icon_atlas_texture.atlas = module_sprite
	module_image_icon_atlas_texture.region = _get_atlas_region(module_sprite)
	module_image_icon_atlas_texture.filter_clip = true
	
	return module_image_icon_atlas_texture


static func _get_atlas_region(module_sprite) -> Rect2:
	var center = _get_default_center_for_atlas(module_sprite)
	var size = _get_default_region_size_for_atlas()
	
	#return Rect2(0, 0, size.x, size.y)
	return Rect2(center.x, center.y, size.x, size.y)

static func _get_default_center_for_atlas(module_sprite) -> Vector2:
	#var highlight_sprite_size = module_sprite.get_size()
	
	#return Vector2(highlight_sprite_size.x / 4, highlight_sprite_size.y / 4)
	return Vector2(0, 0)

static func _get_default_region_size_for_atlas() -> Vector2:
	return image_size



func set_image_as_tracker_image(image : Texture):
	tracker_image = image#_generate_module_image_icon_atlas_texture(image)
