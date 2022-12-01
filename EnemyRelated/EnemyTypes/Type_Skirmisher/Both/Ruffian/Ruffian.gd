extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"


const FactionEmpoweredParticle_Blue_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/_FactionAssets/Textures/FactionEmpowerParticle_Blue.png")
const FactionEmpoweredParticle_Red_Pic = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/_FactionAssets/Textures/FactionEmpowerParticle_Red.png")

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


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.RUFFIAN))

#
func _ready():
	if skirmisher_path_color_type == ColorType.BLUE:
		for particle in emp_particle_layer.get_children():
			particle.texture = FactionEmpoweredParticle_Blue_Pic
	elif skirmisher_path_color_type == ColorType.RED:
		for particle in emp_particle_layer.get_children():
			particle.texture = FactionEmpoweredParticle_Red_Pic


func _on_skirm_path_color_determined():
	if skirmisher_path_color_type == ColorType.BLUE:
		_anim_face__custom_dir_name_to_primary_rad_angle_map = blue_dir_name_to_primary_rad_angle_map
		_anim_face__custom_anim_names_to_use = blue_dir_name_to_primary_rad_angle_map.keys()
		#_anim_face__custom_initial_dir_hierarchy = blue_dir_name_initial_hierarchy
		current_E_anim_name = blue_E_anim_name
		current_W_anim_name = blue_W_anim_name
		
		custom_anim_dir_w_name = blue_W_anim_name
		custom_anim_dir_e_name = blue_E_anim_name
		
	elif skirmisher_path_color_type == ColorType.RED:
		_anim_face__custom_dir_name_to_primary_rad_angle_map = red_dir_name_to_primary_rad_angle_map
		_anim_face__custom_anim_names_to_use = red_dir_name_to_primary_rad_angle_map.keys()
		#_anim_face__custom_initial_dir_hierarchy = blue_dir_name_initial_hierarchy 
		current_E_anim_name = red_E_anim_name
		current_W_anim_name = red_W_anim_name
		
		custom_anim_dir_w_name = red_W_anim_name
		custom_anim_dir_e_name = red_E_anim_name

