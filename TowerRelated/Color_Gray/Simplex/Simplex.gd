extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")


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
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 26
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 26
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	
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
	
	add_attack_module(attack_module)
	
	_post_inherit_ready()
