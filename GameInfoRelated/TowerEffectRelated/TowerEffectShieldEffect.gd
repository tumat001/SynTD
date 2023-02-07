extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"


var blocks_tower_effects : bool = false
var blocks_enemy_effects : bool = true

func _init(arg_effect_uuid : int,
		arg_duration : float = -1,
		arg_count : int = -1).(EffectType.EFFECT_SHIELD,
		arg_effect_uuid):
	
	time_in_seconds = arg_duration
	is_timebound = time_in_seconds > 0
	
	count = arg_count
	is_countbound = count > 0


func _shallow_duplicate():
	return _get_copy_scaled_by(1)

func _get_copy_scaled_by(scale : float):
	var copy = get_script().new(effect_uuid, time_in_seconds * scale, count * int(scale + 0.5))
	_configure_copy_to_match_self(copy)
	
	copy.blocks_tower_effects = blocks_tower_effects
	copy.blocks_enemy_effects = blocks_enemy_effects
	
	return copy

