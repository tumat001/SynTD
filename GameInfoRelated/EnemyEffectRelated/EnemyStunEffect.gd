extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


const stun_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyStun.png")

func _init(arg_duration : float, 
		arg_effect_uuid : int).(EffectType.STUN, arg_effect_uuid):
	
	time_in_seconds = arg_duration
	is_timebound = true
	effect_icon = stun_icon
	description = "Stuns enemies for " + str(time_in_seconds) + " seconds on hit."


func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale and !force_apply_scale:
		scale = 1
	
	var scaled_stun = time_in_seconds * scale
	
	var copy = get_script().new(scaled_stun, effect_uuid)
	
	_configure_copy_to_match_self(copy)
	
	return copy


func _reapply(copy):
	if time_in_seconds < copy.time_in_seconds:
		time_in_seconds = copy.time_in_seconds
