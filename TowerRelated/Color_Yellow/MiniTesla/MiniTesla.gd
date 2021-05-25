extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")
const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")

const mini_tesla_pic_01 = preload("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla_Bolt_01.png")
const mini_tesla_pic_02 = preload("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla_Bolt_02.png")
const mini_tesla_pic_03 = preload("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla_Bolt_03.png")
const mini_tesla_pic_04 = preload("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla_Bolt_04.png")

var attack_module : WithBeamInstantDamageAttackModule

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.MINI_TESLA)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 13
	attack_module.base_on_hit_damage_internal_name = "tesla"
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", mini_tesla_pic_01)
	beam_sprite_frame.add_frame("default", mini_tesla_pic_02)
	beam_sprite_frame.add_frame("default", mini_tesla_pic_03)
	beam_sprite_frame.add_frame("default", mini_tesla_pic_04)
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
	
	var enemy_final_effect : EnemyStunEffect = EnemyStunEffect.new(2, StoreOfEnemyEffectsUUID.MINI_TESLA_STUN)
	var enemy_effect : EnemyStackEffect = EnemyStackEffect.new(enemy_final_effect, 1, 5, StoreOfEnemyEffectsUUID.MINI_TESLA_STACK)
	enemy_effect.is_timebound = true
	enemy_effect.time_in_seconds = 3
	
	var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.MINI_TESLA_STACKING_STUN)
	
	add_tower_effect(tower_effect, [attack_module], false)
