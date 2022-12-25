extends "res://EnemyRelated/AbstractEnemy.gd"

enum ColorType {
	#GRAY = 0,
	BLUE = 0,
	RED = 1
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


onready var emp_particle_layer : Node2D = $SpriteLayer/KnockUpLayer/EmpParticleLayer
var show_emp_particle_layer : bool setget set_show_emp_particle_layer


# for emp particle layer
var custom_anim_dir_w_name : String
var custom_anim_dir_e_name : String

var _all_emp_particle_to_poses_in_layer_for_dir_e_map : Dictionary


#

var is_blue_and_benefits_from_ap : bool

#

func _ready():
	emp_particle_layer.modulate.a = 0.65
	
	cd_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SKIRMISHER_RANDOM_CD)
	set_show_emp_particle_layer(show_emp_particle_layer)
	_store_dir_e_poses_of_emp_particle_layer()
	connect("anim_name_used_changed", self, "_anim_name_used_changed_skirm_enemy_base_class")

func get_random_cd(arg_min_starting : float, arg_max_starting : float) -> float:
	return cd_rng.randf_range(arg_min_starting, arg_max_starting)

#

func set_skirm_path_color_type(color_type : int):
	skirmisher_path_color_type = color_type
	
	_on_skirm_path_color_determined()

func _on_skirm_path_color_determined(): # to be overriden if needed by inheriting class
	pass



func set_skirmisher_faction_passive(arg_passive):
	skirmisher_faction_passive = arg_passive



func set_show_emp_particle_layer(arg_val):
	show_emp_particle_layer = arg_val
	
	if is_inside_tree() and is_instance_valid(emp_particle_layer):
		emp_particle_layer.visible = show_emp_particle_layer

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

############

func _store_dir_e_poses_of_emp_particle_layer():
	for emp_particle in emp_particle_layer.get_children():
		_all_emp_particle_to_poses_in_layer_for_dir_e_map[emp_particle] = emp_particle.position


func _anim_name_used_changed_skirm_enemy_base_class(arg_prev_name, arg_curr_name):
	_update_poses_of_emp_particles(arg_curr_name)

func _update_poses_of_emp_particles(arg_curr_name):
	if arg_curr_name == AnimFaceDirComponent.dir_west_name or arg_curr_name == custom_anim_dir_w_name:
		for emp_particle in emp_particle_layer.get_children():
			var pos = _all_emp_particle_to_poses_in_layer_for_dir_e_map[emp_particle]
			pos.x *= -1
			emp_particle.position = pos
			emp_particle.visible = true
		
	elif arg_curr_name == AnimFaceDirComponent.dir_east_name or arg_curr_name == custom_anim_dir_e_name:
		for emp_particle in emp_particle_layer.get_children():
			var pos = _all_emp_particle_to_poses_in_layer_for_dir_e_map[emp_particle]
			emp_particle.position = pos
			emp_particle.visible = true
		
	else:
		for emp_particle in emp_particle_layer.get_children():
			emp_particle.visible = false
