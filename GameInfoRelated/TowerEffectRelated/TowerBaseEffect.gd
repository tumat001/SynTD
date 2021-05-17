

enum EffectType {
	
	ATTRIBUTES,
	ON_HIT_DAMAGE,
	ON_HIT_EFFECT,
	MODULES,
	RESET,
	
}

var effect_uuid: int
var effect_type : int
var description : String
var effect_icon : Texture

var is_timebound : bool
var time_in_seconds : float

# NOT USED FOR NOW
var is_countbound : bool
var count : int

var is_ingredient_effect : bool


func _init(arg_effect_type : int,
		arg_effect_uuid : int):
	
	effect_type = arg_effect_type
	effect_uuid = arg_effect_uuid


