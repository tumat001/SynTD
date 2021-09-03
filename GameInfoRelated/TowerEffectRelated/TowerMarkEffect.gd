extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"


var metadata_map : Dictionary = {}


func _init(arg_effect_uuid : int).(EffectType.MARK_EFFECT,
			arg_effect_uuid):
	
	pass


func _shallow_duplicate():
	var copy = get_script().new(effect_uuid)
	_configure_copy_to_match_self(copy)
	
	copy.metadata_map.clear()
	for data_key in metadata_map.keys():
		copy.metadata_map[data_key] = metadata_map[data_key]
	
	return copy
