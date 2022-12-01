extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"


const _health_ratio_threshold = 0.5

const _speed_range : float = 60.0
const _speed_duration : float = 0.75
const _speed_flat_amount : float = 50.0

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.RALLIER))
	
	is_blue_and_benefits_from_ap = true

func _ready():
	connect("on_current_health_changed", self, "_on_curr_health_changed")
	

#

func _on_curr_health_changed(curr_health):
	if curr_health / _last_calculated_max_health <= _health_ratio_threshold:
		disconnect("on_current_health_changed", self, "_on_curr_health_changed")
		_perform_speed_boost()

func _perform_speed_boost():
	skirmisher_faction_passive.request_rallier_speed_particle_to_play(global_position)
	
	# get all enemies within x range.
	var enemies = enemy_manager.get_enemies_within_distance_of_enemy(self, _speed_range)
	for enemy in enemies:
		_construct_effect_and_give_to_enemy(enemy)


func _construct_effect_and_give_to_enemy(arg_enemy):
	var speed_bonus_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.RALLIER_SPEED_EFFECT)
	speed_bonus_modi.flat_modifier = _speed_flat_amount * last_calculated_final_ability_potency
	
	var speed_bonus_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_MOV_SPEED, speed_bonus_modi, StoreOfEnemyEffectsUUID.RALLIER_SPEED_EFFECT)
	speed_bonus_effect.respect_scale = true
	speed_bonus_effect.is_timebound = true
	speed_bonus_effect.time_in_seconds = _speed_duration
	speed_bonus_effect.is_from_enemy = true
	
	arg_enemy._add_effect__use_provided_effect(speed_bonus_effect)

