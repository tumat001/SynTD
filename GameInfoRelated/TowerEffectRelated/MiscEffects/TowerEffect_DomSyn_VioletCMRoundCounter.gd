extends "res://GameInfoRelated/TowerEffectRelated/TowerMarkEffect.gd"


var _target_round_count : int
var current_round_count : int

func _init(arg_target_round_count : int).(StoreOfTowerEffectsUUID.VIOLET_COLOR_MASTERY_ROUND_COUNTDOWN_MARKER):
	_target_round_count = arg_target_round_count


func is_target_round_met() -> bool:
	return current_round_count >= _target_round_count
