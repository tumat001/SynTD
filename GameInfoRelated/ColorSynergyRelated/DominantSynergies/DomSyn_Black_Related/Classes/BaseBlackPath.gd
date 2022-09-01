extends Reference


var black_path_name : String
var black_path_tier_to_descriptions_map : Dictionary
var black_path_icon : Texture

func _init(arg_name : String, arg_tier_to_descriptions : Dictionary,
		arg_icon : Texture):
	
	black_path_name = arg_name
	black_path_tier_to_descriptions_map = arg_tier_to_descriptions
	black_path_icon = arg_icon

