extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

const Amalgamator_Beam01 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam01.png") 
const Amalgamator_Beam02 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam02.png") 
const Amalgamator_Beam03 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam03.png") 
const Amalgamator_Beam04 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam04.png") 
const Amalgamator_Beam05 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam05.png") 
const Amalgamator_Beam06 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam06.png") 
const Amalgamator_Beam07 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam07.png") 
const Amalgamator_Beam08 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam08.png") 
const Amalgamator_Beam09 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam09.png") 
const Amalgamator_Beam10 = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_Beam10.png") 

const Amalgamator_Hit_Particle = preload("res://TowerRelated/Color_Black/Amalgamator/AmalAttks/Amalgamator_HitParticle.tscn")

onready var Shader_PureBlack = preload("res://MiscRelated/ShadersRelated/Shader_PureBlack.shader")

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.AMALGAMATOR)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 7
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 6
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 7
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.attack_sprite_scene = Amalgamator_Hit_Particle
	attack_module.attack_sprite_follow_enemy = true
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Amalgamator_Beam01)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam02)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam03)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam04)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam05)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam06)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam07)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam08)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam09)
	beam_sprite_frame.add_frame("default", Amalgamator_Beam10)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 10 / 0.2)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.2
	attack_module.show_beam_at_windup = true
	
	add_attack_module(attack_module)
	
	connect("on_round_end", self, "_on_round_end_a", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _on_round_end_a():
	if is_current_placable_in_map():
		var tower_to_convert = _get_random_non_black_in_map_tower()
		
		if tower_to_convert != null:
			_convert_tower_to_black(tower_to_convert)



func _get_random_non_black_in_map_tower():
	var non_black_towers : Array = tower_manager.get_all_active_towers_without_color(TowerColors.BLACK)
	
	if non_black_towers.size() != 0:
		var rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.RANDOM_TARGETING)
		var decided_num : int = rng.randi_range(0, non_black_towers.size() - 1)
		
		return non_black_towers[decided_num]

func _convert_tower_to_black(arg_tower):
	arg_tower.remove_all_colors_from_tower()
	arg_tower.add_color_to_tower(TowerColors.BLACK)
	
	arg_tower.tower_base.material.shader = Shader_PureBlack
