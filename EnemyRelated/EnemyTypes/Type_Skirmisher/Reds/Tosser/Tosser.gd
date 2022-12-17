extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"

const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")

var tower_detecting_range_module : TowerDetectingRangeModule


var toss_ability : BaseAbility
const _toss_cooldown : float = 14.0
const no_valid_targets_in_range_clause : int = -10

var targeting_for_toss : int = Targeting.CLOSE

var _atomic_cd_to_use : float
const bombs_active_clause : int = -12

#
func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.TOSSER))

#

func _ready():
	_construct_and_connect_ability()
	
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.can_display_range = false
	tower_detecting_range_module.detection_range = skirmisher_faction_passive.blaster_range
	add_child(tower_detecting_range_module)
	
	tower_detecting_range_module.connect("on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health", self, "_on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health")
	tower_detecting_range_module.connect("on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health", self, "_on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health")
	
	#
	


func _construct_and_connect_ability():
	toss_ability = BaseAbility.new()
	
	toss_ability.is_timebound = true
	toss_ability._time_current_cooldown = get_random_cd(_toss_cooldown, _toss_cooldown / 1.5)
	toss_ability.connect("updated_is_ready_for_activation", self, "_toss_ready_for_activation_updated")
	
	register_ability(toss_ability)

#


func _on_tower_entered_range_while_in_map_or_entered_map_while_in_range__with_non_zero_health(arg_tower):
	toss_ability.activation_conditional_clauses.remove_clause(no_valid_targets_in_range_clause)

func _on_tower_exited_range_or_exited_map_while_in_range_or_lost_all_health(arg_tower):
	if tower_detecting_range_module.all_towers_in_range__in_map__with_non_zero_health.size() == 0:
		toss_ability.activation_conditional_clauses.attempt_insert_clause(no_valid_targets_in_range_clause)
	

#

func _toss_ready_for_activation_updated(arg_val):
	if arg_val:
		_cast_toss()
	

func _cast_toss():
	var targets = tower_detecting_range_module.get_targets_based_on_params(tower_detecting_range_module.all_towers_in_range__in_map__with_non_zero_health, targeting_for_toss, 1, global_position, false)
	
	if targets.size() > 0:
		var target = targets[0]
		if is_instance_valid(target):
			_toss_tower(target)

func _toss_tower(arg_tower):
	toss_ability.activation_conditional_clauses.attempt_insert_clause(bombs_active_clause)
	
	var cd = _toss_cooldown
	toss_ability.on_ability_before_cast_start(cd)
	
	skirmisher_faction_passive.request_tosser_bomb_cluster_to_shoot(self, global_position, arg_tower.global_position, arg_tower.current_placable, "_before_tower_is_knocked")
	
	_atomic_cd_to_use = cd
	toss_ability.on_ability_after_cast_ended(cd)

func _before_tower_is_knocked(arg_placable):
	toss_ability.activation_conditional_clauses.remove_clause(bombs_active_clause)
	
	toss_ability.start_time_cooldown(_atomic_cd_to_use)


#
