extends "res://EnemyRelated/AbstractEnemy.gd"

enum ColorType {
	GRAY = 0,
	BLUE = 1,
	RED = 2
}

var skirmisher_faction_passive setget set_skirmisher_faction_passive
var skirmisher_path_color_type setget set_skirm_path_color_type

var cd_rng : RandomNumberGenerator

var _next_through_placable_data
var _method_name_to_call_on_entry_offset_passed   # accepts through_placable_data param
var _is_registed_to_listen_for_next_entry_offset : bool = false

#

func _ready():
	cd_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SKIRMISHER_RANDOM_CD)

func get_random_cd(arg_min_starting : float, arg_max_starting : float) -> float:
	return cd_rng.randf_range(arg_min_starting, arg_max_starting)

#

func set_skirm_path_color_type(color_type : int):
	skirmisher_path_color_type = color_type

func set_skirmisher_faction_passive(arg_passive):
	skirmisher_faction_passive = arg_passive

#

func register_self_to_offset_checkpoints_of_through_placable_data(arg_method_name_to_call_on_entry_offset_passed : String):
	if !_is_registed_to_listen_for_next_entry_offset:
		_is_registed_to_listen_for_next_entry_offset = true
		_method_name_to_call_on_entry_offset_passed = arg_method_name_to_call_on_entry_offset_passed
		_next_through_placable_data = skirmisher_faction_passive.get_next_through_placable_data_based_on_curr(offset, current_path)
		
		if _next_through_placable_data != null:
			connect("moved__from_process", self, "_on_moved__from_process")

func _on_moved__from_process(arg_has_moved_from_natural_means, arg_prev_angle_dir, arg_curr_angle_dir):
	_update_next_through_placable_data__entry_offset_for_dash()

func _update_next_through_placable_data__entry_offset_for_dash():
	if _next_through_placable_data != null and offset >= _next_through_placable_data.entry_offset:
		var prev_data = _next_through_placable_data
		_next_through_placable_data = skirmisher_faction_passive.get_next_through_placable_data_based_on_curr(offset, current_path)
		call(_method_name_to_call_on_entry_offset_passed, prev_data)


func unregister_self_to_offset_checkpoints_of_through_placable_data():
	if _is_registed_to_listen_for_next_entry_offset:
		_is_registed_to_listen_for_next_entry_offset = false
		
		disconnect("moved__from_process", self, "_on_moved__from_process")


