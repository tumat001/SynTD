extends Reference


var combination_id : int  # same as id of source tower
var ingredient_effect
var tower_type_info

var tier_of_source_tower : int

func _init(arg_combination_id : int,
		arg_ing_effect,
		arg_tower_type_info):
	
	combination_id = arg_combination_id
	ingredient_effect = arg_ing_effect
	tower_type_info = arg_tower_type_info

