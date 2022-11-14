extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


func _init(arg_effect_uuid : int).(EffectType.BASE_MODIFYING_EFFECT,
		arg_effect_uuid):
	
	pass


func _make_modifications_to_enemy(enemy):
	pass

func _undo_modifications_to_enemy(enemy):
	pass


func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	#var copy = get_script().new(effect_uuid)
	var copy = get_script().new()
	copy.effect_uuid = effect_uuid
	_configure_copy_to_match_self(copy)
	
	return copy
