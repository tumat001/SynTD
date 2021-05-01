
const EffectType = preload("res://GameInfoRelated/EffectType.gd")
const Modifier = preload("res://GameInfoRelated/Modifier.gd")

var effect_type : int
var effect_strength_modifier : Modifier
var internal_name : String
var duration_in_seconds : float
var is_timebound : bool

func _init(arg_internal_name : String, effect_strength_modifier : Modifier, 
		arg_effect_type : int):
	internal_name = arg_internal_name
	effect_strength_modifier = effect_strength_modifier
	effect_type = arg_effect_type
	duration_in_seconds = 5
	is_timebound = true

func duplicate():
	var clone = get_script().new(internal_name, effect_strength_modifier, effect_type)
	clone.duration_in_seconds = duration_in_seconds
	clone.is_timebound = is_timebound
