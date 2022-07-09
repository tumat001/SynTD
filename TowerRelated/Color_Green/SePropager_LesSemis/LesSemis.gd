extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")
const BaseBullet = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.gd")

const BulletProj_Pic = preload("res://TowerRelated/Color_Green/SePropager_LesSemis/Assets/LesSemis_Proj.png")

#

signal on_reached_golden_state()


const ratio_of_parent_ad_to_inherit : float = 0.5
const gold_worth_increase_on_kill_count_achieved : int = 2
const kill_count_needed : int = 3
const ad_increase_per_gold_worth : float = 0.75

const animation_default_name : String = "default"
const animation_golden_name : String = "golden"


var ad_of_parent : float
var total_kill_count : int

var is_golden : bool = false

var base_damage_effect : TowerAttributesEffect

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.LES_SEMIS)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = 0#info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 6
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = ad_of_parent * ratio_of_parent_ad_to_inherit
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 375
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 6
	
	attack_module.benefits_from_bonus_pierce = true
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(8, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	var sp = SpriteFrames.new()
	sp.add_frame("default", BulletProj_Pic)
	attack_module.bullet_sprite_frames = sp
	
	add_attack_module(attack_module)
	
	#
	
	can_contribute_to_synergy_color_count = false
	tower_limit_slots_taken = 0
	
	connect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_miti_dmg_dealt", [], CONNECT_PERSIST)
	connect("on_sellback_value_changed", self, "_on_sellback_value_changed_l", [], CONNECT_PERSIST)
	
	tower_base_sprites.animation = animation_default_name
	
	#
	_construct_and_add_base_dmg_effect()
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	add_tower_effect(base_damage_effect)


func _construct_and_add_base_dmg_effect():
	var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.LES_SEMIS_BONUS_BASE_DAMAGE_EFFECT)
	base_dmg_attr_mod.flat_modifier = 0
	
	base_damage_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.LES_SEMIS_BONUS_BASE_DAMAGE_EFFECT)


#

func _on_any_post_miti_dmg_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	if killed:
		total_kill_count += 1
		
		if (total_kill_count >= kill_count_needed):
			is_golden = true
			set_base_gold_cost(_base_gold_cost + gold_worth_increase_on_kill_count_achieved)
			disconnect("on_any_post_mitigation_damage_dealt", self, "_on_any_post_miti_dmg_dealt")
			call_deferred("emit_signal", "on_reached_golden_state")
			tower_base_sprites.animation = animation_golden_name

#

func _on_sellback_value_changed_l(new_val):
	base_damage_effect.attribute_as_modifier.flat_modifier = new_val * ad_increase_per_gold_worth
	
	recalculate_final_base_damage()


