extends Reference

const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")


var combination_id : int  # same as id of source tower
var ingredient_effect : IngredientEffect
var tower_type_info

var applicable_to_tower_tiers : Array  # the tiers that can be affected by the effect

func _init(arg_combination_id : int,
		arg_ing_effect : IngredientEffect,
		arg_tower_type_info):
	
	combination_id = arg_combination_id
	ingredient_effect = arg_ing_effect
	tower_type_info = arg_tower_type_info


