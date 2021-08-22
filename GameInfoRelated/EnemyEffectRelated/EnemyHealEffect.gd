extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

var heal_as_modifier
var allows_overhealing : bool

func _init(arg_heal_as_modifier,
		arg_effect_uuid : int,
		arg_allow_overhealing : bool = false,
		arg_respect_scale : bool = true).(EffectType.HEAL, arg_effect_uuid):
	
	heal_as_modifier = arg_heal_as_modifier
	allows_overhealing = arg_allow_overhealing
	respect_scale = arg_respect_scale
	
	should_map_in_all_effects_map = false
	
	is_timebound = false


func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale and !force_apply_scale:
		scale = 1
	
	var scaled_modifier = heal_as_modifier.get_copy_scaled_by(scale)
	
	var copy = get_script().new(scaled_modifier, effect_uuid, allows_overhealing)
	
	_configure_copy_to_match_self(copy)
	
	return copy

