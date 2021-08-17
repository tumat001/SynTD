extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


func _init(arg_effect_uuid : int).(EffectType.CLEAR_ALL_EFFECTS, arg_effect_uuid):
	pass

func _get_copy_scaled_by(_scale : float):
	var copy = get_script().new(effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy
