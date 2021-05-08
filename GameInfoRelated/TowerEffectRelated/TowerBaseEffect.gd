extends Reference


enum EffectType {
	
	ATTRIBUTES,
	ON_HIT_DAMAGE,
	ON_HIT_EFFECT,
	MODULES,
	
}

var effect_source_name: String
var effect_type : int
var description : String
var effect_icon : Texture

func _init(arg_effect_type : int,
		arg_effect_source_name : String):
	
	effect_type = arg_effect_type
	effect_source_name = arg_effect_source_name


