extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"


func _init(arg_effect_uuid : int).(EffectType.MODULE_ADDER, arg_effect_uuid):
	pass


func _make_modifications_to_tower(tower):
	pass

func _undo_modifications_to_tower(tower):
	pass


func _shallow_duplicate():
	#var copy = get_script().new(effect_uuid)
	var copy = get_script().new()
	_configure_copy_to_match_self(copy)
	
	return copy
