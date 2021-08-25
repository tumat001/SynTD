extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


var prevent_exit : bool = false

func _init(arg_effect_uuid : int).(EffectType.BEFORE_ENEMY_REACHING_END_PATH, arg_effect_uuid):
	pass


func before_enemy_reached_exit(enemy):
	pass


#

func _configure_copy_to_match_self(copy):
	._configure_copy_to_match_self(copy)
	
	copy.prevent_exit = prevent_exit

func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	var copy = get_script().new(effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy
