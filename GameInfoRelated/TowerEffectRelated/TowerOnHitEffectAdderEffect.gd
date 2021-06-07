extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

const EnemyBaseEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd")

var enemy_base_effect : EnemyBaseEffect

func _init(arg_enemy_base_effect : EnemyBaseEffect,
		arg_effect_uuid : int).(EffectType.ON_HIT_EFFECT, 
		arg_effect_uuid):
	
	enemy_base_effect = arg_enemy_base_effect
	effect_icon = enemy_base_effect.effect_icon
	description = enemy_base_effect.description


func _shallow_copy():
	var copy = get_script().new(enemy_base_effect, effect_uuid)
	
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	copy.is_ingredient_effect = is_ingredient_effect
	
	copy.is_countbound = is_countbound
	copy.count = count
	copy.count_reduced_by_main_attack_only = count_reduced_by_main_attack_only
	
	copy.force_apply = force_apply
	copy.should_respect_attack_module_scale = should_respect_attack_module_scale
	
	return copy
