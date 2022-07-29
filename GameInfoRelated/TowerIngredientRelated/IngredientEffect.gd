

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

