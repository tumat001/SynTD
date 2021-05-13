extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

# TODO REPLACE THIS SOON
#const SimpleObeliskBullet_pic = preload("res://GameHUDRelated/LeftSidePanel/SynergyInfoPanel/Pics/Syn_Compo_Ana_BlueVioletGreen.png")
const SimplexBeam01_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_01.png")
const SimplexBeam02_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_02.png")
const SimplexBeam03_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_03.png")
const SimplexBeam04_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_04.png")
const SimplexBeam05_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_05.png")
const SimplexBeam06_pic = preload("res://TowerRelated/Color_Gray/Simplex/SimplexBeam_06.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SIMPLEX)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = true
	attack_module.module_name = "Main"
	attack_module.position.y -= 18
	attack_module.base_on_hit_damage_internal_name = "name"
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.base_on_hit_affected_by_scale = false
	
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", SimplexBeam01_pic)
	beam_sprite_frame.add_frame("default", SimplexBeam02_pic)
	beam_sprite_frame.add_frame("default", SimplexBeam03_pic)
	beam_sprite_frame.add_frame("default", SimplexBeam04_pic)
	beam_sprite_frame.add_frame("default", SimplexBeam05_pic)
	beam_sprite_frame.add_frame("default", SimplexBeam06_pic)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	
	attack_modules_and_target_num[attack_module] = 1
	
	_post_inherit_ready()
