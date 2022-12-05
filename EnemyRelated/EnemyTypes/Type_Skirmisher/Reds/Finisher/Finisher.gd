extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"


const initial_dash_count : int = 10
var _curr_dash_left : int

const base_chance_for_dashing_at_next_offset : float = 0.20
var _curr_chance_for_dashing_at_next_offset : float = base_chance_for_dashing_at_next_offset
var _chance_multiplier_per_next_entry_offset_skipped : float = 1.3
var _chance_multiplier_per_successful_dash : float = 0.75

var skirmisher_gen_purpose_rng : RandomNumberGenerator

var _is_during_windup_or_dash : bool


const finisher_execute_health_ratio : float = 0.35

#

var _windup_before_dash_timer : TimerForEnemy
const windup_duration : float = 0.5

var _atomic_through_placable_data
var _bullet_to_follow

#

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.FINISHER))

#

func _ready():
	skirmisher_gen_purpose_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SKIRMISHER_GEN_PURPOSE)
	
	_windup_before_dash_timer = TimerForEnemy.new()
	_windup_before_dash_timer.one_shot = false
	_windup_before_dash_timer.pauses_when_stunned = false
	_windup_before_dash_timer.connect("timeout_and_cleared_prevention", self, "_on_windup_before_dash_timer_timeout_and_cleared_prevention")
	_windup_before_dash_timer.set_enemy(self)
	add_child(_windup_before_dash_timer)
	
	connect("on_death_by_any_cause", self, "_on_death_by_any_cause_f", [], CONNECT_ONESHOT)

func _on_finished_ready_prep():
	._on_finished_ready_prep()
	
	_set_curr_dash_left(initial_dash_count)

func _set_curr_dash_left(arg_val):
	_curr_dash_left = arg_val
	
	if _curr_dash_left > 0:
		register_self_to_offset_checkpoints_of_through_placable_data__as_finisher("_on_next_entry_offset_reached")
	else:
		unregister_self_to_offset_checkpoints_of_through_placable_data__as_finisher()

#

func _on_next_entry_offset_reached(arg_through_placable_data):
	var tower = _get_tower_on_placable_data(arg_through_placable_data)
	var is_within_execute_range : bool = false
	var placable_has_tower : bool = false
	if is_instance_valid(tower):
		placable_has_tower = true
		is_within_execute_range = is_tower_within_execute_range(tower)
	
	if !_is_during_windup_or_dash and placable_has_tower and is_tower_alive(tower) and (is_within_execute_range or _if_chance_passed()):
		_perform_windup_before_dash(arg_through_placable_data, !is_within_execute_range)
		
	else:
		_increase_curr_chance_for_next()

func _if_chance_passed() -> bool:
	return skirmisher_gen_purpose_rng.randi_range(0, 100) < _curr_chance_for_dashing_at_next_offset * 100

func _if_placable_data_has_tower(arg_through_placable_data):
	var tower = _get_tower_on_placable_data(arg_through_placable_data)
	return is_instance_valid(tower)

func _get_tower_on_placable_data(arg_through_placable_data):
	if is_instance_valid(arg_through_placable_data.placable):
		return arg_through_placable_data.placable.tower_occupying


func _increase_curr_chance_for_next():
	_curr_chance_for_dashing_at_next_offset *= _chance_multiplier_per_next_entry_offset_skipped


#

func _perform_windup_before_dash(arg_through_placable_data, arg_decrease_chance_of_next_dash : bool):
	_atomic_through_placable_data = arg_through_placable_data
	_is_during_windup_or_dash = true
	
	_windup_before_dash_timer.start(windup_duration)
	no_movement_from_self_clauses.attempt_insert_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
	
	if arg_decrease_chance_of_next_dash:
		_curr_chance_for_dashing_at_next_offset *= _chance_multiplier_per_successful_dash

func _on_windup_before_dash_timer_timeout_and_cleared_prevention():
	var tower = _get_tower_on_placable_data(_atomic_through_placable_data)
	_windup_before_dash_timer.stop()
	
	if is_instance_valid(tower):
		if is_tower_within_execute_range(tower):
			_perform_dash__execute(_atomic_through_placable_data, tower)
		else:
			_perform_dash__normal(_atomic_through_placable_data, tower)
		
	else:
		_end_dash_or_windup()

func is_tower_within_execute_range(tower):
	return (tower.current_health / tower.last_calculated_max_health) <= finisher_execute_health_ratio

func is_tower_alive(tower):
	return !tower.is_dead_for_the_round


#

func _perform_dash__normal(arg_through_placable_data, arg_tower):
	var bullet = skirmisher_faction_passive.request_finisher_normal_bullet_to_shoot(self, get_position_subtracted_pos_and_offset_modifiers(global_position), arg_tower.global_position, _get_distance_between_self_and_through_placable_data(arg_through_placable_data))
	
	_perform_dash__any(arg_through_placable_data, bullet)

func _perform_dash__execute(arg_through_placable_data, arg_tower):
	var bullet = skirmisher_faction_passive.request_finisher_execute_bullet_to_shoot(self, get_position_subtracted_pos_and_offset_modifiers(global_position), arg_tower.global_position, _get_distance_between_self_and_through_placable_data(arg_through_placable_data))
	bullet.connect("hit_a_tower", self, "_on_finisher_execute_bullet_hit_tower")
	
	_perform_dash__any(arg_through_placable_data, bullet)
	

func _perform_dash__any(arg_through_placable_data, arg_bullet):
	_set_curr_dash_left(_curr_dash_left - 1)
	
	_is_during_windup_or_dash = true
	
	#
	
	var pull_effect = EnemyForcedPositionalMovementEffect.new(arg_through_placable_data.exit_position, arg_bullet.speed, true, StoreOfEnemyEffectsUUID.FINISHER_DASH_EFFECT)
	pull_effect.is_from_enemy = true
	pull_effect.connect("movement_is_done", self, "_on_pull_effect_movement_done", [], CONNECT_ONESHOT)
	_add_effect__use_provided_effect(pull_effect)
	
	set_sprite_layer_modulate(EnemyModulateIds.FINISHER_DURING_DASH, Color(1, 1, 1, 0))
	
	skirmisher_faction_passive.request_add_enemy_effect_shield_on_self__as_finisher(self)

func _on_pull_effect_movement_done(arg_has_new_replacing : bool):
	_end_dash_or_windup()
	
	remove_sprite_layer_modulate(EnemyModulateIds.FINISHER_DURING_DASH)
	_give_self_slow()
	skirmisher_faction_passive.request_remove_enemy_effect_shield_on_self__as_finisher(self)

func _end_dash_or_windup():
	_is_during_windup_or_dash = false
	
	no_movement_from_self_clauses.remove_clause(NoMovementClauses.CUSTOM_CLAUSE_01)

func _give_self_slow():
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.FINISHER_SELF_SLOW_EFFECT)
	slow_modifier.percent_amount = -75
	slow_modifier.percent_based_on = PercentType.CURRENT
	
	var enemy_attr_eff : EnemyAttributesEffect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.FINISHER_SELF_SLOW_EFFECT)
	enemy_attr_eff.is_timebound = true
	enemy_attr_eff.time_in_seconds = 2
	
	_add_effect__use_provided_effect(enemy_attr_eff)


# execute specific

func _on_finisher_execute_bullet_hit_tower(bullet, arg_tower):
	if is_tower_within_execute_range(arg_tower):
		arg_tower.execute_self(self)

#

func _get_distance_between_self_and_through_placable_data(arg_through_placable_data):
	return global_position.distance_to(arg_through_placable_data.exit_position)
	

########

#
#func _start_follow_bullet(arg_bullet):
#	_bullet_to_follow = arg_bullet
#
#	set_physics_process(true)
#
#func _end_follow_bullet():
#	_bullet_to_follow = null
#	set_physics_process(false)
#
#
#func _physics_process(delta):
#	if is_instance_valid(_bullet_to_follow):
#		global_position = _bullet_to_follow.global_position

func _on_death_by_any_cause_f():
	if is_instance_valid(_bullet_to_follow):
		_bullet_to_follow.queue_free()

