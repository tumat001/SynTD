
const Modifier = preload("res://GameInfoRelated/Modifier.gd")

enum {
	
	FLAT_ABILITY_POTENCY,
	PERCENT_ABILITY_POTENCY,
	
	FLAT_ABILITY_CDR
	PERCENT_ABILITY_CDR,
	
}

var attribute_type : int
var attribute_as_modifier : Modifier
var effect_uuid : int

func _init(arg_attribute_type : int, arg_modifier,
		arg_effect_uuid : int):
	
	attribute_type = arg_attribute_type
	attribute_as_modifier = arg_modifier
	effect_uuid = arg_effect_uuid
	
	attribute_as_modifier.internal_id = arg_effect_uuid
