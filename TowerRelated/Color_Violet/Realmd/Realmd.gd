extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")


const Realmd_AnyBeamPic_01 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_02 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_03 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_04 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_05 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_06 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_07 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_08 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_09 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_10 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_11 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_12 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_13 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_14 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")

##

const beam_modulate__main_attack := Color(30/255.0, 1/255.0, 217/255.0)


var domain_ability : BaseAbility
const domain_ability_base_cooldown : float = 25.0
var is_domain_ability_ready : bool


const domain_base_duration : float = 35.0

const domain_explosion_base_dmg_amount : float = 5.0
const domain_explosion_on_hit_scale : float = 1.5


##


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.L_ASSAUT)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 17
	
	#
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1 / 0.18
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 17
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	attack_module.show_beam_at_windup = true
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_01)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_02)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_03)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_04)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_05)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_06)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_07)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_08)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_09)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_10)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_11)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_12)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_13)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_14)
	
	
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 14 / 0.18)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.18
	
	attack_module.connect("beam_constructed_and_added", self, "_on_main_attack_beam_constructed_and_added_r", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	#
	
	_construct_and_register_ability()
	
	#
	
	_post_inherit_ready()

#

func _on_main_attack_beam_constructed_and_added_r(beam):
	beam.modulate = beam_modulate__main_attack

#

func _construct_and_register_ability():
	domain_ability = BaseAbility.new()
	
	domain_ability.is_timebound = true
	
	domain_ability.set_properties_to_usual_tower_based()
	domain_ability.tower = self
	
	domain_ability.connect("updated_is_ready_for_activation", self, "_can_cast_domain_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(domain_ability, false)

func _can_cast_domain_updated(is_ready):
	is_domain_ability_ready = is_ready
	
	_attempt_cast_domain_ability()

func _attempt_cast_domain_ability():
	var targets : Array = get_random_enemy_in_map()
	
	if targets.size() > 0:
		var target = targets[0]
		_launch_globule_at_target_position(target.global_position)
		
	else:
		pass


func get_random_enemy_in_map():
	return game_elements.enemy_manager.get_random_targetable_enemies(1, global_position)



#####

func _launch_globule_at_target_position(arg_pos):
	pass
	
	


