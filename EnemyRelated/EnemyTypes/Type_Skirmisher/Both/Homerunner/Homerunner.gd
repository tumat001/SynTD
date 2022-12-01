extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"


signal flag_implanted(arg_flag_pos_plus_offset, arg_flag_facing_w, arg_color_type)


const Homerunner_BlueFlag_E_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Flag/Homerunner_BlueFlag_ForE.png")
const Homerunner_BlueFlag_W_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Flag/Homerunner_BlueFlag_ForW.png")
const Homerunner_RedFlag_E_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Flag/Homerunner_RedFlag_ForE.png")
const Homerunner_RedFlag_W_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Flag/Homerunner_RedFlag_ForW.png")

const FactionEmpoweredParticle_Blue_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/_FactionAssets/Textures/FactionEmpowerParticle_Blue.png")
const FactionEmpoweredParticle_Red_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/_FactionAssets/Textures/FactionEmpowerParticle_Red.png")


const unit_offset_for_flag_trigger : float = 0.45

const time_for_flag_raise : float = 0.75    # up
const time_for_flag_implant : float = 0.35  # down

const y_disp_for_flag_raise : float = -6.0
const y_disp_for_flag_implant : float = 11.0 - y_disp_for_flag_raise

onready var flag_sprite = $SpriteLayer/KnockUpLayer/Flag

const flag_w_position := Vector2(-3, -11)
const flag_e_position := Vector2(3, -11)

var _is_flag_implanted : bool
var _current_flag_y_offset_per_second : float
var _current_flag_y_disp : float

# anim names and textures related

const blue_E_anim_name : String = "Blue_E"
const blue_W_anim_name : String = "Blue_W"

const red_E_anim_name : String = "Red_E"
const red_W_anim_name : String = "Red_W"

var current_E_anim_name : String
var current_W_anim_name : String


const blue_dir_name_to_primary_rad_angle_map : Dictionary = {
	#dir_omni_name : PI / 2,
	#animation_normal_N_name : PI / 2,
	blue_E_anim_name : PI,
	#animation_normal_S_name : -PI / 2,
	blue_W_anim_name : 0,
}
#const blue_dir_name_initial_hierarchy : Array = [
#	blue_E_anim_name
#]

const red_dir_name_to_primary_rad_angle_map : Dictionary = {
	#dir_omni_name : PI / 2,
	#animation_normal_N_name : PI / 2,
	red_E_anim_name : PI,
	#animation_normal_S_name : -PI / 2,
	red_W_anim_name : 0,
}
#const red_dir_name_initial_hierarchy : Array = [
#	red_E_anim_name
#]

# flag textures related

var current_flag_w_texture : Texture
var current_flag_e_texture : Texture

#
func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.HOMERUNNER))

#

func _on_skirm_path_color_determined():
	if skirmisher_path_color_type == ColorType.BLUE:
		_anim_face__custom_dir_name_to_primary_rad_angle_map = blue_dir_name_to_primary_rad_angle_map
		_anim_face__custom_anim_names_to_use = blue_dir_name_to_primary_rad_angle_map.keys()
		#_anim_face__custom_initial_dir_hierarchy = blue_dir_name_initial_hierarchy
		current_E_anim_name = blue_E_anim_name
		current_W_anim_name = blue_W_anim_name
		
		current_flag_w_texture = Homerunner_BlueFlag_W_Pic
		current_flag_e_texture = Homerunner_BlueFlag_E_Pic
		
		custom_anim_dir_w_name = blue_W_anim_name
		custom_anim_dir_e_name = blue_E_anim_name
		
	elif skirmisher_path_color_type == ColorType.RED:
		_anim_face__custom_dir_name_to_primary_rad_angle_map = red_dir_name_to_primary_rad_angle_map
		_anim_face__custom_anim_names_to_use = red_dir_name_to_primary_rad_angle_map.keys()
		#_anim_face__custom_initial_dir_hierarchy = blue_dir_name_initial_hierarchy 
		current_E_anim_name = red_E_anim_name
		current_W_anim_name = red_W_anim_name
		
		current_flag_w_texture = Homerunner_RedFlag_W_Pic
		current_flag_e_texture = Homerunner_RedFlag_E_Pic
		
		custom_anim_dir_w_name = red_W_anim_name
		custom_anim_dir_e_name = red_E_anim_name
		

#

func _ready():
	connect("moved__from_process", self, "_on_moved_from_process_h")
	connect("anim_name_used_changed", self, "_on_anim_name_used_changed_h")
	
	if skirmisher_path_color_type == ColorType.BLUE:
		for particle in emp_particle_layer.get_children():
			particle.texture = FactionEmpoweredParticle_Blue_Pic
	elif skirmisher_path_color_type == ColorType.RED:
		for particle in emp_particle_layer.get_children():
			particle.texture = FactionEmpoweredParticle_Red_Pic


func _on_moved_from_process_h(arg_has_moved_from_natural_means, arg_prev_angle_dir, arg_curr_angle_dir):
	if unit_offset >= unit_offset_for_flag_trigger:
		if is_connected("moved__from_process", self, "_on_moved_from_process_h"):
			disconnect("moved__from_process", self, "_on_moved_from_process_h")
		
		_start_flag_raise()


############ flag related

func _process(delta):
	var y_delta_change : float = _current_flag_y_offset_per_second * delta
	_current_flag_y_disp += y_delta_change
	
	flag_sprite.offset.y += y_delta_change
	
	if flag_sprite.offset.y <= y_disp_for_flag_raise:
		_start_flag_implant()
	elif flag_sprite.offset.y >= y_disp_for_flag_implant and !_is_flag_implanted:
		_on_flag_implanted()

#

func _start_flag_raise():
	_current_flag_y_offset_per_second = y_disp_for_flag_raise / time_for_flag_raise
	
	no_movement_from_self_clauses.attempt_insert_clause(NoMovementClauses.CUSTOM_CLAUSE_01)


#

func _start_flag_implant():
	_current_flag_y_offset_per_second = y_disp_for_flag_implant / time_for_flag_implant
	flag_sprite.offset.y = y_disp_for_flag_raise

func _on_flag_implanted():
	_is_flag_implanted = true
	flag_sprite.visible = false
	no_movement_from_self_clauses.remove_clause(NoMovementClauses.CUSTOM_CLAUSE_01)
	
	var flag_facing_w : bool
	flag_facing_w = anim_face_dir_component.get_current_dir_as_name() == current_W_anim_name
	emit_signal("flag_implanted", flag_sprite.global_position + flag_sprite.offset, flag_facing_w, skirmisher_path_color_type)


##########

func _on_anim_name_used_changed_h(arg_prev_name, arg_curr_name):
	if !_is_flag_implanted:
		if arg_curr_name == current_E_anim_name:
			flag_sprite.position = flag_e_position
			flag_sprite.texture = current_flag_e_texture
			
		elif arg_curr_name == current_W_anim_name:
			flag_sprite.position = flag_w_position
			flag_sprite.texture = current_flag_w_texture


