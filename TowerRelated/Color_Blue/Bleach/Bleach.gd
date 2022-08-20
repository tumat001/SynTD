extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Bleach_NormalProj01 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_Bullet01.png")
const Bleach_NormalProj02 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_Bullet02.png")
const Bleach_NormalProj03 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_Bullet03.png")

const Bleach_EmpoweredProj01 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_PierceBullet01.png")
const Bleach_EmpoweredProj02 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_PierceBullet02.png")
const Bleach_EmpoweredProj03 = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_Attks/Bleach_PierceBullet03.png")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")

const toughness_remove_amount : float = -6.0
const toughness_debuff_duration : float = 8.0

var cycle : int = 0

var base_attack_count_for_buff : int = 3
var current_attack_count : int = 0

var toughness_shred_effect : EnemyAttributesEffect


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BLEACH)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 9
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 360
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= 9
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 4
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	attack_module.connect("before_bullet_is_shot", self, "_modify_bullet", [], CONNECT_PERSIST)
	connect("on_main_attack_finished", self, "_on_main_attack_finished_b", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_b", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	_construct_effect()
	
	_post_inherit_ready()


func _construct_effect():
	var tou_mod : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.BLEACH_SHREAD)
	tou_mod.flat_modifier = toughness_remove_amount
	
	toughness_shred_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_TOUGHNESS, tou_mod, StoreOfEnemyEffectsUUID.BLEACH_SHREAD)
	toughness_shred_effect.is_timebound = true
	toughness_shred_effect.time_in_seconds = toughness_debuff_duration


# Only Self module modify

func _modify_bullet(bullet : BaseBullet):
	if current_attack_count >= base_attack_count_for_buff:
		if cycle == 0:
			bullet.set_texture_as_sprite_frames(Bleach_EmpoweredProj01)
		elif cycle == 1:
			bullet.set_texture_as_sprite_frames(Bleach_EmpoweredProj02)
		elif cycle == 2:
			bullet.set_texture_as_sprite_frames(Bleach_EmpoweredProj03)
		
	else:
		if cycle == 0:
			bullet.set_texture_as_sprite_frames(Bleach_NormalProj01)
		elif cycle == 1:
			bullet.set_texture_as_sprite_frames(Bleach_NormalProj02)
		elif cycle == 2:
			bullet.set_texture_as_sprite_frames(Bleach_NormalProj03)
	
	cycle += 1
	if cycle >= 3:
		cycle = 0


# Modify

func _on_main_attack_finished_b(module):
	if current_attack_count >= base_attack_count_for_buff:
		current_attack_count = 0
	
	current_attack_count += 1
	if current_attack_count >= base_attack_count_for_buff:
		connect("on_main_attack_module_damage_instance_constructed", self, "_on_benefiting_attack_damage_inst_constructed", [], CONNECT_ONESHOT)


func _on_benefiting_attack_damage_inst_constructed(damage_instance, module):
	damage_instance.on_hit_effects[toughness_shred_effect.effect_uuid] = toughness_shred_effect._get_copy_scaled_by(1)


# Other signals

func _on_round_end_b():
	current_attack_count = 1
