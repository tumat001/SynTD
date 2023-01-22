extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

#signal shield_effect_added__not_refresh(enemy)
#signal shield_effect_removed(enemy)
#signal shield_effect_broken_and_removed(enemy)


# percent mod is based on health
var shield_as_modifier
var _current_shield

var absorb_overflow_damage : bool


func _init(arg_shield_as_modifier,
		arg_effect_uuid : int,
		arg_absorb_overlow_dmg : bool = false,
		arg_respect_scale : bool = true).(EffectType.SHIELD, arg_effect_uuid):
	
	shield_as_modifier = arg_shield_as_modifier
	absorb_overflow_damage = arg_absorb_overlow_dmg
	respect_scale = arg_respect_scale



func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale and !force_apply_scale:
		scale = 1
	
	var scaled_modifier = shield_as_modifier.get_copy_scaled_by(scale)
	
	var copy = get_script().new(scaled_modifier, effect_uuid)
	
	copy._current_shield = _current_shield
	copy.absorb_overflow_damage = absorb_overflow_damage
	
	_configure_copy_to_match_self(copy)
	
	return copy

############

#func shield_added_to_enemy__not_refresh(arg_enemy):
#	emit_signal("shield_effect_added__not_refresh", arg_enemy)
#
#
#func shield_removed_from_enemy(arg_enemy):
#	print("shield effect -- removed")
#	emit_signal("shield_effect_removed", arg_enemy)
#
#
#func shield_broken_by_dmg_and_removed_from_enemy(arg_enemy):
#	emit_signal("shield_effect_broken_and_removed", arg_enemy)
#



