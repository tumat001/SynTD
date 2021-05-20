extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")


const Tesla_Bolt_01 = preload("res://TowerRelated/Color_Violet/Tesla/Tesla_Bolt_01.png")
const Tesla_Bolt_02 = preload("res://TowerRelated/Color_Violet/Tesla/Tesla_Bolt_02.png")
const Tesla_Bolt_03 = preload("res://TowerRelated/Color_Violet/Tesla/Tesla_Bolt_03.png")

const Tesla_Hit_Particle = preload("res://TowerRelated/Color_Violet/Tesla/TeslaHitParticle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.TESLA)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 30
	attack_module.base_on_hit_damage_internal_name = "tesla"
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.base_on_hit_affected_by_scale = false
	
	attack_module.attack_sprite_scene = Tesla_Hit_Particle
	attack_module.attack_sprite_follow_enemy = true
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Tesla_Bolt_01)
	beam_sprite_frame.add_frame("default", Tesla_Bolt_02)
	beam_sprite_frame.add_frame("default", Tesla_Bolt_03)
	beam_sprite_frame.set_animation_loop("default", true)
	beam_sprite_frame.set_animation_speed("default", 15)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.2
	
	attack_modules_and_target_num[attack_module] = 1
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	var enemy_effect : EnemyStunEffect = EnemyStunEffect.new(0.3, StoreOfEnemyEffectsUUID.TESLA_STUN)
	var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.TESLA_STUN)
	
	add_tower_effect(tower_effect)
