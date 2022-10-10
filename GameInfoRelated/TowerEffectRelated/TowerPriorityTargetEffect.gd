extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"


signal on_target_tree_exiting(target)

var target
var is_priority_regardless_of_range : bool

func _init(arg_target,
		arg_effect_uuid : int,
		arg_is_priority_regardless_of_range : bool = false).(EffectType.PRIORITY_TARGET,
		arg_effect_uuid):
	
	target = arg_target
	is_priority_regardless_of_range = arg_is_priority_regardless_of_range
	

func set_up_signal_with_target():
	if is_instance_valid(target):
		if !target.is_connected("tree_exiting", self, "_on_target_tree_exiting"):
			target.connect("tree_exiting", self, "_on_target_tree_exiting", [target])


func _on_target_tree_exiting(target):
	emit_signal("on_target_tree_exiting", target)


#

func _shallow_duplicate():
	var copy = get_script().new(target, effect_uuid, is_priority_regardless_of_range)
	_configure_copy_to_match_self(copy)
	
	return copy

func _get_copy_scaled_by(scale):
	var copy = get_script().new(target, effect_uuid, is_priority_regardless_of_range)
	_configure_copy_to_match_self(copy)
	
	copy.time_in_seconds = time_in_seconds * scale
	
	return copy
