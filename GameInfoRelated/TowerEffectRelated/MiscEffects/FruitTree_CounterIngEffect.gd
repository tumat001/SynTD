extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const _base_round_count_before_activation : int = 4

var _current_round_count_before_activation : int = _base_round_count_before_activation
var _attached_tower

func _init().(StoreOfTowerEffectsUUID.ING_FRUIT_TREE):
	pass


func _make_modifications_to_tower(tower):
	_attached_tower = tower
	
	if !tower.is_connected("on_round_end", self, "_on_round_end"):
		tower.connect("on_round_end", self, "_on_round_end", [], CONNECT_PERSIST)

#

func _on_round_end():
	if _attached_tower.is_current_placable_in_map():
		_current_round_count_before_activation -= 1
		
		if _current_round_count_before_activation <= 0:
			pass



#

func _undo_modifications_to_tower(tower):
	pass




#

func _shallow_duplicate():
	var copy = get_script().new(effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy
