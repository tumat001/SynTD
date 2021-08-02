extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"


func _init(arg_effect_uuid : int).(EffectType.MARK_EFFECT,
			arg_effect_uuid):
	
	pass


func _shallow_duplicate():
	var copy = get_script().new(effect_uuid)
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	copy.is_ingredient_effect = is_ingredient_effect
	
	copy.is_countbound = is_countbound
	copy.count = count
	copy.count_reduced_by_main_attack_only = count_reduced_by_main_attack_only
	
	copy.effect_icon = effect_icon
	copy.status_bar_icon = status_bar_icon
	
	copy.force_apply = force_apply
	copy.should_respect_attack_module_scale = should_respect_attack_module_scale
	
	return copy
