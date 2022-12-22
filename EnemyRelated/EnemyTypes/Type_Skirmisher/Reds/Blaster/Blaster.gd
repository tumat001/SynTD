extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"

const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")


# NOTE: range is in faction passive

const bullet_count_per_barrage : int = 3
const delta_per_bullet_in_barrage : float = 0.22

var targeting_for_barrage : int = Targeting.CLOSE

var tower_detecting_range_module : TowerDetectingRangeModule


var barrage_ability : BaseAbility
const _barrage_cooldown : float = 9.0
const no_valid_targets_in_range_clause : int = -10
const in_barrage_clause : int = -11

#

var _barrage_timer : TimerForEnemy
var _current_barrage_target
var _current_barrage_bullet_count : int

#

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.BLASTER))


func _ready():
	_construct_and_connect_ability()
	
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.can_display_range = false
	tower_detecting_range_module.detection_range = skirmisher_faction_passive.blaster_range
	add_child(tower_detecting_range_module)
	
	tower_detecting_range_module.connect("on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health", self, "_on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health")
	tower_detecting_range_module.connect("on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health", self, "_on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health")
	
	#
	
	_barrage_timer = TimerForEnemy.new()
	_barrage_timer.one_shot = false
	_barrage_timer.pauses_when_stunned = false
	_barrage_timer.connect("timeout_and_cleared_prevention", self, "_on_barrage_timer_timeout_and_cleared_prevention")
	_barrage_timer.set_enemy(self)
	
	add_child(_barrage_timer)


func _on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health(arg_tower):
	barrage_ability.activation_conditional_clauses.remove_clause(no_valid_targets_in_range_clause)

func _on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health(arg_tower):
	if tower_detecting_range_module.all_towers_in_range__in_map__with_non_zero_health.size() == 0:
		barrage_ability.activation_conditional_clauses.attempt_insert_clause(no_valid_targets_in_range_clause)
	
	if is_instance_valid(_current_barrage_target) and _current_barrage_target == arg_tower:
		_current_barrage_target_exited_range_or_lost_all_health()

#

func _construct_and_connect_ability():
	barrage_ability = BaseAbility.new()
	
	barrage_ability.is_timebound = true
	barrage_ability._time_current_cooldown = get_random_cd(0, _barrage_cooldown / 8.0)
	barrage_ability.connect("updated_is_ready_for_activation", self, "_barrage_ready_for_activation_updated")
	
	register_ability(barrage_ability)

func _barrage_ready_for_activation_updated(arg_val):
	if arg_val:
		_cast_barrage()

func _cast_barrage():
	var targets = tower_detecting_range_module.get_targets_based_on_params(tower_detecting_range_module.all_towers_in_range__in_map__with_non_zero_health, targeting_for_barrage, 1, global_position, false)
	
	if targets.size() > 0:
		var target = targets[0]
		if is_instance_valid(target):
			_start_barrage_against_target(target)


func _start_barrage_against_target(arg_target):
	var cd = _barrage_cooldown
	barrage_ability.on_ability_before_cast_start(cd)
	
	_current_barrage_target = arg_target
	
	_current_barrage_bullet_count = bullet_count_per_barrage
	barrage_ability.activation_conditional_clauses.attempt_insert_clause(in_barrage_clause)
	barrage_ability.counter_decrease_clauses.attempt_insert_clause(in_barrage_clause)
	
	barrage_ability.start_time_cooldown(cd)
	barrage_ability.on_ability_after_cast_ended(cd)
	no_movement_from_self_clauses.attempt_insert_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
	
	#
	_fire_bullet_at_current_barrage_target()
	
	_barrage_timer.start(delta_per_bullet_in_barrage)

func _current_barrage_target_exited_range_or_lost_all_health():
	_end_barrage()

func _end_barrage():
	_current_barrage_target = null
	
	_current_barrage_bullet_count = 0
	barrage_ability.activation_conditional_clauses.remove_clause(in_barrage_clause)
	barrage_ability.counter_decrease_clauses.remove_clause(in_barrage_clause)
	no_movement_from_self_clauses.remove_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
	
	_barrage_timer.stop()

#####

func _on_barrage_timer_timeout_and_cleared_prevention():
	_fire_bullet_at_current_barrage_target()
	
	if _current_barrage_bullet_count <= 0:
		_end_barrage()

func _fire_bullet_at_current_barrage_target():
	_current_barrage_bullet_count -= 1
	
	if is_instance_valid(_current_barrage_target):
		skirmisher_faction_passive.request_blaster_bullet_to_shoot(self, global_position, _current_barrage_target.global_position)
		_change_animation_to_face_position(_current_barrage_target.global_position)
	else:
		_end_barrage()
