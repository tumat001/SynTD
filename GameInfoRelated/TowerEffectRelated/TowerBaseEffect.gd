

enum EffectType {
	
	ATTRIBUTES,
	ON_HIT_DAMAGE,
	ON_HIT_EFFECT,
	MODULE_ADDER,
	CHAOS_TAKEOVER,
	RESET,
	FULL_SELLBACK,
	
}

var effect_uuid: int
var effect_type : int
var description : String
var effect_icon : Texture

var is_timebound : bool
var time_in_seconds : float

var is_countbound : bool
var count : int
var count_reduced_by_main_attack_only : bool

var force_apply : bool = false

var is_ingredient_effect : bool


func _init(arg_effect_type : int,
		arg_effect_uuid : int):
	
	effect_type = arg_effect_type
	effect_uuid = arg_effect_uuid


func _shallow_duplicate():
	pass
