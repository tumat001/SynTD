extends Reference

#const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")

# Bunch of comments was caused an attempt to squish a memory leak, but it didn't come from here anyway..
var combination_id : int  # same as id of source tower
var ingredient_effect #setget set_ing_effect, get_ing_effect
var tower_type_info #setget set_tower_type_info, get_tower_type_info

var tier_of_source_tower : int

func _init(arg_combination_id : int,
		arg_ing_effect,
		arg_tower_type_info):

	combination_id = arg_combination_id
	ingredient_effect = arg_ing_effect
	tower_type_info = arg_tower_type_info
	
	#set_ing_effect(arg_ing_effect)
	#set_tower_type_info(arg_tower_type_info)

#func _init(arg_combination_id : int):
#
#	combination_id = arg_combination_id
#	#set_ing_effect(arg_ing_effect)
#	#set_tower_type_info(arg_tower_type_info)


#func set_tower_type_info(arg_info):
#	if !arg_info is WeakRef:
#		tower_type_info = weakref(arg_info)
#	else:
#		tower_type_info = arg_info
#
#func get_tower_type_info():
#	if tower_type_info != null:
#		return tower_type_info.get_ref()
#
##
#
#func set_ing_effect(arg_info):
#	if !arg_info is WeakRef:
#		ingredient_effect = weakref(arg_info)
#	else:
#		ingredient_effect = arg_info
#
#func get_ing_effect():
#	if ingredient_effect != null:
#		return ingredient_effect.get_ref()

#


