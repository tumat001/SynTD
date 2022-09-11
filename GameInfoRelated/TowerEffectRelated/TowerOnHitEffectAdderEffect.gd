extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

const EnemyBaseEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd")

var enemy_base_effect : EnemyBaseEffect
var source_ref setget set_source

func _init(arg_enemy_base_effect : EnemyBaseEffect,
		arg_effect_uuid : int).(EffectType.ON_HIT_EFFECT, 
		arg_effect_uuid):
	
	enemy_base_effect = arg_enemy_base_effect
	effect_icon = enemy_base_effect.effect_icon
	_update_description()
	
	_can_be_scaled_by_yel_vio = enemy_base_effect._can_be_scaled_by_yel_vio

func _update_description():
	description = enemy_base_effect.description


func set_source(arg_source):
	if arg_source is WeakRef:
		source_ref = arg_source
	else:
		source_ref = weakref(arg_source)
	
	if source_ref.get_ref() != null:
		enemy_base_effect.set_effect_source(source_ref)


func _shallow_copy():
	var copy = get_script().new(enemy_base_effect, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy

func _deep_copy():
	var copy = get_script().new(enemy_base_effect._get_copy_scaled_by(1), effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy

#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	if enemy_base_effect != null:
		enemy_base_effect.add_additive_scaling_by_amount(arg_amount)
		_update_description()

# to be implemented by classes
func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	if enemy_base_effect != null:
		enemy_base_effect._consume_current_additive_scaling_for_actual_scaling_in_stats()

