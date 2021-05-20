extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

const EnemyBaseEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd")

var enemy_base_effect : EnemyBaseEffect

func _init(arg_enemy_base_effect : EnemyBaseEffect,
		arg_effect_uuid : int).(EffectType.ON_HIT_EFFECT, 
		arg_effect_uuid):
	
	enemy_base_effect = arg_enemy_base_effect
	effect_icon = enemy_base_effect.effect_icon
	description = enemy_base_effect.description