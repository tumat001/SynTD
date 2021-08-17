extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const EnemyHealEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyHealEffect.gd")
const ReviveStatusIcon = preload("res://EnemyRelated/CommonParticles/ReviveParticle/Revive_StatusIcon.png")

var heal_effect_upon_revival : EnemyHealEffect
var time_before_revive : float

var other_effects_upon_revival : Array = []

#

var _current_time_before_revive : float


func _init(arg_heal_effect : EnemyHealEffect,
		arg_effect_uuid : int,
		arg_time_before_revive : float = 3.0).(EffectType.REVIVE, arg_effect_uuid):
	
	heal_effect_upon_revival = arg_heal_effect
	
	is_timebound = false
	
	time_before_revive = arg_time_before_revive
	_current_time_before_revive = time_before_revive
	status_bar_icon = ReviveStatusIcon


func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale and !force_apply_scale:
		scale = 1
	
	var scaled_effect = heal_effect_upon_revival._get_copy_scaled_by(scale)
	var copy = get_script().new(scaled_effect, effect_uuid, time_before_revive)
	
	for effect in other_effects_upon_revival:
		copy.other_effects_upon_revival.append(effect.get_copy_scaled_by(scale))
	
	_configure_copy_to_match_self(copy)
	
	return copy
