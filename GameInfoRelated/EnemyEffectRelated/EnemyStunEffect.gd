extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"


const stun_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyStun.png")

func _init(arg_duration : float, 
		arg_effect_uuid : int).(EffectType.STUN, arg_effect_uuid):
	
	time_in_seconds = arg_duration
	is_timebound = true
	effect_icon = stun_icon
	
	_update_description()
	_can_be_scaled_by_yel_vio = true

func _update_description():
	description = "Stuns enemies for " + str(time_in_seconds * _current_additive_scale) + " seconds on hit.%s" % _generate_desc_for_persisting_total_additive_scaling(true)


func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale or force_apply_scale:
		scale = 1
	
	
	var copy = get_script().new(time_in_seconds, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	var scaled_stun = time_in_seconds * scale
	copy.time_in_seconds = scaled_stun
	
	return copy


func _reapply(copy):
	if time_in_seconds < copy.time_in_seconds:
		time_in_seconds = copy.time_in_seconds

#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_update_description()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	time_in_seconds *= _current_additive_scale
	_current_additive_scale = 1

