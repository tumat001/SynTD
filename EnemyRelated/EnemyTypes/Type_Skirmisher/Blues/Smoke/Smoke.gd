extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"



const _health_ratio_threshold = 0.5

const _invis_duration : float = 1.65
const _invis_range : float = 60.0


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.SMOKE))
	
	is_blue_and_benefits_from_ap = true

func _ready():
	connect("on_current_health_changed", self, "_on_curr_health_changed")
	


func _on_curr_health_changed(curr_health):
	if curr_health / _last_calculated_max_health <= _health_ratio_threshold:
		disconnect("on_current_health_changed", self, "_on_curr_health_changed")
		_perform_invis()

func _perform_invis():
	skirmisher_faction_passive.request_smoke_particles_to_play(global_position)
	
	# get all enemies within x range.
	var enemies = enemy_manager.get_enemies_within_distance_of_enemy(self, _invis_range)
	for enemy in enemies:
		_construct_effect_and_give_to_enemy(enemy)


#

func _construct_effect_and_give_to_enemy(arg_enemy):
	var invis_effect = EnemyInvisibilityEffect.new(_invis_duration * last_calculated_final_ability_potency, StoreOfEnemyEffectsUUID.SMOKE_INVIS_EFFECT)
	invis_effect.is_from_enemy = true
	
	arg_enemy._add_effect__use_provided_effect(invis_effect)

