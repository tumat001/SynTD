

enum EffectType {
	ATTRIBUTES,
	DAMAGE_OVER_TIME,
	HEAL_OVER_TIME,
	STACK_EFFECT,
	MISC,
}

var effect_uuid : int
var effect_type : int
var description : String
var effect_icon : Texture

var is_timebound : bool
var time_in_seconds : float

func _init(arg_effect_type : int,
		arg_effect_uuid : int):
	
	effect_type = arg_effect_type
	effect_uuid = arg_effect_uuid

