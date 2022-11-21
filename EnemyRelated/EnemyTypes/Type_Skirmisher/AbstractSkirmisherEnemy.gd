extends "res://EnemyRelated/AbstractEnemy.gd"

enum ColorType {
	GRAY = 0,
	BLUE = 1,
	RED = 2
}

var skirmisher_faction_passive setget set_skirmisher_faction_passive
var skirmisher_path_color_type setget set_skirm_path_color_type

var cd_rng : RandomNumberGenerator

# shared by danseur and finisher. Intended to be used only by one
var _next_through_placable_data
var _method_name_to_call_on_entry_offset_passed   # accepts through_placable_data param

# Designed to only cater to one (only one can be true)
var _is_registed_to_listen_for_next_entry_offset__as_danseur : bool = false
var _is_registed_to_listen_for_next_entry_offset__as_finisher : bool = false

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

func register_self_to_offset_checkpoints_of_through_placable_data__as_danseur(arg_method_name_to_call_on_entry_offset_passed : String):
	if !_is_registed_to_listen_for_next_entry_offset__as_danseur:
		_is_registed_to_listen_for_next_entry_offset__as_danseur = true
		_method_name_to_call_on_entry_offset_passed = arg_method_name_to_call_on_entry_offset_passed
		_next_through_placable_data = skirmisher_faction_passive.get_next_through_placable_data_based_on_curr__as_danseur(offset, current_path)
		
		if _next_through_placable_data != null:
			connect("moved__from_process", self, "_on_moved__from_process__as_danseur")

func _on_moved__from_process__as_danseur(arg_has_moved_from_natural_means, arg_prev_angle_dir, arg_curr_angle_dir):
	_update_next_through_placable_data__entry_offset_for_dash__as_danseur()

func _update_next_through_placable_data__entry_offset_for_dash__as_danseur():
	if _next_through_placable_data != null and offset >= _next_through_placable_data.entry_offset:
		var prev_data = _next_through_placable_data
		_next_through_placable_data = skirmisher_faction_passive.get_next_through_placable_data_based_on_curr__as_danseur(offset, current_path)
		call(_method_name_to_call_on_entry_offset_passed, prev_data)


func unregister_self_to_offset_checkpoints_of_through_placable_data__as_danseur():
	if _is_registed_to_listen_for_next_entry_offset__as_danseur:
		_is_registed_to_listen_for_next_entry_offset__as_danseur = false
		
		disconnect("moved__from_process", self, "_on_moved__from_process__as_danseur")

#

func register_self_to_offset_checkpoints_of_through_placable_data__as_finisher(arg_method_name_to_call_on_entry_offset_passed : String):
	if !_is_registed_to_listen_for_next_entry_offset__as_finisher:
		_is_registed_to_listen_for_next_entry_offset__as_finisher = true
		_method_name_to_call_on_entry_offset_passed = arg_method_name_to_call_on_entry_offset_passed
		_next_through_placable_data = skirmisher_faction_passive.get_next_through_placable_data_based_on_curr__as_finisher(offset, current_path)
		
		if _next_through_placable_data != null:
			connect("moved__from_process", self, "_on_moved__from_process__as_finisher")

func _on_moved__from_process__as_finisher(arg_has_moved_from_natural_means, arg_prev_angle_dir, arg_curr_angle_dir):
	_update_next_through_placable_data__entry_offset_for_dash__as_finisher()

func _update_next_through_placable_data__entry_offset_for_dash__as_finisher():
	if _next_through_placable_data != null and offset >= _next_through_placable_data.entry_offset:
		var prev_data = _next_through_placable_data
		_next_through_placable_data = skirmisher_faction_passive.get_next_through_placable_data_based_on_curr__as_finisher(offset, current_path)
		call(_method_name_to_call_on_entry_offset_passed, prev_data)


func unregister_self_to_offset_checkpoints_of_through_placable_data__as_finisher():
	if _is_registed_to_listen_for_next_entry_offset__as_finisher:
		_is_registed_to_listen_for_next_entry_offset__as_finisher = false
		
		disconnect("moved__from_process", self, "_on_moved__from_process__as_finisher")


