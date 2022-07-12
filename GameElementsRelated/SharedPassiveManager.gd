extends Node

const AbstractSharedTowerPassive = preload("res://GameInfoRelated/SharedTowerPassiveRelated/AbstractSharedTowerPassive.gd")

var game_elements

var _all_shared_passive_ids_to_passive : Dictionary = {}

#

func if_shared_passive_id_exists(arg_shared_passive_id : int):
	return _all_shared_passive_ids_to_passive.keys().has(arg_shared_passive_id)

#

func attempt_apply_shared_passive(arg_shared_passive : AbstractSharedTowerPassive):
	if !if_shared_passive_id_exists(arg_shared_passive.passive_id):
		_apply_shared_passive(arg_shared_passive)

func _apply_shared_passive(arg_shared_passive : AbstractSharedTowerPassive):
	_all_shared_passive_ids_to_passive[arg_shared_passive.passive_id] = arg_shared_passive
	
	arg_shared_passive._apply_passive_to_game_elements(game_elements)

#

func attempt_remove_shared_passive_id(arg_shared_passive_id : int):
	if _all_shared_passive_ids_to_passive.keys().has(arg_shared_passive_id):
		attempt_remove_shared_passive_id(arg_shared_passive_id)

func _remove_shared_passive_id(arg_shared_passive_id : int):
	var passive : AbstractSharedTowerPassive = _all_shared_passive_ids_to_passive[arg_shared_passive_id]
	_all_shared_passive_ids_to_passive.erase(arg_shared_passive_id)
	
	passive._remove_passive_from_game_elements(game_elements)

#
