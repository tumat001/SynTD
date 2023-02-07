

const TowerBaseEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd")

var tower_base_effect : TowerBaseEffect
var tower_id : int
var description # string or array (for TextFragmentInterpreter purposes)
var ignore_ingredient_limit : bool = false
var discard_after_absorb : bool = false

func _init(arg_tower_id : int,
		 arg_tower_base_effect : TowerBaseEffect):
	
	tower_id = arg_tower_id
	tower_base_effect = arg_tower_base_effect
	tower_base_effect.is_ingredient_effect = true
	description = tower_base_effect.description

#

func get_copy__deep_or_shallow():
	var effect_copy
	
	if tower_base_effect.has_method("_deep_copy"):
		effect_copy = tower_base_effect._deep_copy()
	elif tower_base_effect.has_method("_shallow_duplicate"):
		effect_copy = tower_base_effect._shallow_duplicate()
	
	var copy = get_script().new(tower_id, effect_copy)
	copy.description = description
	copy.ignore_ingredient_limit = ignore_ingredient_limit
	copy.discard_after_absorb = discard_after_absorb
	
	return copy
