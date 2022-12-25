extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"


var skirmisher_gen_purpose_rng : RandomNumberGenerator

const initial_dash_count : int = 2
var _curr_dash_left : int

const base_chance_for_dashing_at_next_offset : float = 0.33
var _curr_chance_for_dashing_at_next_offset : float = base_chance_for_dashing_at_next_offset
var _chance_multiplier_per_next_entry_offset_skipped : float = 1.5
var _chance_multiplier_per_successful_dash : float = 0.8

#const tower_min_inc_count_at_exit_pos_for_trigger : int = 2

#

var center_based_detection_range_for_towers : float   # value is in faction passive

const base_bullet_count : int = 8
var _current_bullet_count : int

const delta_per_bullet : float = 0.2

var _dance_timer : TimerForEnemy

var _is_during_dash_or_dance : bool

#

const spinning_animation_name : String = "Spinning"

#

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.DANSEUR))

func _ready():
	skirmisher_gen_purpose_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SKIRMISHER_GEN_PURPOSE)
	
	_dance_timer = TimerForEnemy.new()
	_dance_timer.one_shot = false
	_dance_timer.pauses_when_stunned = false
	_dance_timer.connect("timeout_and_cleared_prevention", self, "_on_dance_timer_timeout_and_cleared_prevention")
	_dance_timer.set_enemy(self)
	add_child(_dance_timer)
	
	#
	
	center_based_detection_range_for_towers = skirmisher_faction_passive.danseur_proj_and_detection_range

func _on_finished_ready_prep():
	._on_finished_ready_prep()
	
	_set_curr_dash_left(initial_dash_count)

func _set_curr_dash_left(arg_val):
	_curr_dash_left = arg_val
	
	if _curr_dash_left > 0:
		register_self_to_offset_checkpoints_of_through_placable_data__as_danseur("_on_next_entry_offset_reached")
	else:
		unregister_self_to_offset_checkpoints_of_through_placable_data__as_danseur()

#

func _on_next_entry_offset_reached(arg_through_placable_data):
	if !arg_through_placable_data.entry_higher_than_exit and !_is_during_dash_or_dance and _if_chance_passed():
		_perform_dash(arg_through_placable_data)
		
	else:
		_increase_curr_chance_for_next()
	

#

#func _if_destination_pos_has_required_tower_count(arg_data):
#	var towers_in_map = game_elements.tower_manager.get_all_in_map_and_alive_towers_except_in_queue_free()
#	return game_elements.tower_manager.get_towers_in_range_of_pos(towers_in_map, arg_data.exit_position, center_based_detection_range_for_towers).size() >= 

func _if_chance_passed() -> bool:
	return skirmisher_gen_purpose_rng.randi_range(0, 100) < _curr_chance_for_dashing_at_next_offset * 100

func _increase_curr_chance_for_next():
	_curr_chance_for_dashing_at_next_offset *= _chance_multiplier_per_next_entry_offset_skipped

#

func _perform_dash(arg_through_placable_data):
	_set_curr_dash_left(_curr_dash_left - 1)
	
	_is_during_dash_or_dance = true
	_curr_chance_for_dashing_at_next_offset *= _chance_multiplier_per_successful_dash
	#
	
	#var pull_effect = EnemyForcedPositionalMovementEffect.new(arg_through_placable_data.exit_position, EnemyForcedPositionalMovementEffect.TIME_BASED_MOVEMENT_SPEED, true, StoreOfEnemyEffectsUUID.DANSEUR_DASH_EFFECT)
	var pull_effect = EnemyForcedPositionalMovementEffect.new(arg_through_placable_data.exit_position, 300, true, StoreOfEnemyEffectsUUID.DANSEUR_DASH_EFFECT)
	pull_effect.is_from_enemy = true
	pull_effect.connect("movement_is_done", self, "_on_pull_effect_movement_done", [], CONNECT_ONESHOT)
	_add_effect__use_provided_effect(pull_effect)


func _on_pull_effect_movement_done(arg_has_new_replacing : bool):
	_perform_dance()

##

func _perform_dance():
	_is_during_dash_or_dance = true
	_current_bullet_count = base_bullet_count
	
	skirmisher_faction_passive.request_add_enemy_effect_shield_on_self__as_danseur(self)
	_fire_dance_bullet_at_tower_in_range()
	_dance_timer.start(delta_per_bullet)
	
	no_movement_from_self_clauses.attempt_insert_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
	
	anim_sprite.play(spinning_animation_name)

func _on_dance_timer_timeout_and_cleared_prevention():
	_fire_dance_bullet_at_tower_in_range()

func _fire_dance_bullet_at_tower_in_range():
	if _current_bullet_count > 0:
		_current_bullet_count -= 1
		
		var rand_tower = _get_random_tower_in_range()
		if is_instance_valid(rand_tower):
			skirmisher_faction_passive.request_danseur_proj_to_shoot(self, global_position, rand_tower.global_position)
			#_change_animation_to_face_position(rand_tower.global_position)
		
	else:
		_end_dance()

func _get_random_tower_in_range():
	var alive_towers_in_map = game_elements.tower_manager.get_all_in_map_and_alive_towers_except_in_queue_free()
	var candidates = game_elements.tower_manager.get_random_towers_in_range_of_pos(alive_towers_in_map, global_position, center_based_detection_range_for_towers)
	
	if candidates.size() > 0:
		return candidates[0]
	else:
		return null


func _end_dance():
	_is_during_dash_or_dance = false
	no_movement_from_self_clauses.remove_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
	_dance_timer.stop()
	
	skirmisher_faction_passive.request_remove_enemy_effect_shield_on_self__as_danseur(self)
	
	_give_self_slow()

func _give_self_slow():
	var slow_modifier : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.DANSEUR_SELF_SLOW_EFFECT)
	slow_modifier.percent_amount = -75
	slow_modifier.percent_based_on = PercentType.CURRENT
	
	var enemy_attr_eff : EnemyAttributesEffect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.DANSEUR_SELF_SLOW_EFFECT)
	enemy_attr_eff.is_timebound = true
	enemy_attr_eff.time_in_seconds = 7
	
	_add_effect__use_provided_effect(enemy_attr_eff)

#

