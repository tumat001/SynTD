extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Duned_ProjPic = preload("res://TowerRelated/Color__Others/Duned/Attks/Duned_NormalProj.png")


const stage_to_bonus_base_damage_map : Dictionary = {
	0 : 1.5,
	1 : 2.0,
	2 : 2.5,
	3 : 3.0,
	4 : 3.5,
	5 : 4.0,
	6 : 4.5,
	7 : 5.0,
	8 : 5.5,
	9 : 6.0,
}

var base_dmg_effect : TowerAttributesEffect


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.DUNED)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var y_shift_of_attack_module : float = 25
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	#range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += y_shift_of_attack_module
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 725
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= y_shift_of_attack_module
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 6
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Duned_ProjPic)
	
	add_attack_module(attack_module)
	
	
	tower_limit_slots_taken = 0
	
	#
	
	_construct_and_add_effect()
	connect("on_round_end", self, "_on_round_end_d", [], CONNECT_PERSIST)
	
	#
	
	_post_inherit_ready()

#

func _construct_and_add_effect():
	var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.DUNED_BONUS_BASE_DMG_EFFECT)
	base_dmg_attr_mod.flat_modifier = 0
	
	base_dmg_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.DUNED_BONUS_BASE_DMG_EFFECT)
	add_tower_effect(base_dmg_effect)


func _on_round_end_d():
	_update_bonus_base_dmg()

func _update_bonus_base_dmg():
	var current_stage_num = game_elements.stage_round_manager.current_stageround.stage_num
	var dmg_at_stage : float = stage_to_bonus_base_damage_map[current_stage_num]
	
	base_dmg_effect.attribute_as_modifier.flat_modifier = dmg_at_stage
	recalculate_final_base_damage()


