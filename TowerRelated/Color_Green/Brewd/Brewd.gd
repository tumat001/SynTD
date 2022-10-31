extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const EnemyKnockUpEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyKnockUpEffect.gd")
const EnemyForcedPathOffsetMovementEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyForcedPathOffsetMovementEffect.gd")

const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

const Brewd_NormalProj_Pic = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Brewd_NormalProj.png")
const Brewd_SpecialProjPic = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Brewd_SpecialProj.png")

const Repel_Pic01 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Repel_Explosion/Repel_Explosion01.png")
const Repel_Pic02 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Repel_Explosion/Repel_Explosion02.png")
const Repel_Pic03 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Repel_Explosion/Repel_Explosion03.png")
const Repel_Pic04 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Repel_Explosion/Repel_Explosion04.png")
const Repel_Pic05 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Repel_Explosion/Repel_Explosion05.png")
const Repel_Pic06 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Repel_Explosion/Repel_Explosion06.png")
const Repel_Pic07 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Repel_Explosion/Repel_Explosion07.png")
const Repel_Pic08 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Repel_Explosion/Repel_Explosion08.png")
const Repel_Pic09 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Repel_Explosion/Repel_Explosion09.png")

const Implosion_Pic01 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Implosion_Explosion/Implosion_Sprites01.png")
const Implosion_Pic02 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Implosion_Explosion/Implosion_Sprites02.png")
const Implosion_Pic03 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Implosion_Explosion/Implosion_Sprites03.png")
const Implosion_Pic04 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Implosion_Explosion/Implosion_Sprites04.png")
const Implosion_Pic05 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Implosion_Explosion/Implosion_Sprites05.png")
const Implosion_Pic06 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Implosion_Explosion/Implosion_Sprites06.png")
const Implosion_Pic07 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Implosion_Explosion/Implosion_Sprites07.png")
const Implosion_Pic08 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Implosion_Explosion/Implosion_Sprites08.png")
const Implosion_Pic09 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Implosion_Explosion/Implosion_Sprites09.png")

const Shuffle_Pic01 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites01.png")
const Shuffle_Pic02 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites02.png")
const Shuffle_Pic03 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites03.png")
const Shuffle_Pic04 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites04.png")
const Shuffle_Pic05 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites05.png")
const Shuffle_Pic06 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites06.png")
const Shuffle_Pic07 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites07.png")
const Shuffle_Pic08 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites08.png")
const Shuffle_Pic09 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites09.png")
const Shuffle_Pic10 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites10.png")
const Shuffle_Pic11 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites11.png")
const Shuffle_Pic12 = preload("res://TowerRelated/Color_Green/Brewd/AttkAssets/Shuffle_Sprites/Shuffle_Sprites12.png")


signal selected_potion_type_changed(new_type)


enum PotionTypes {
	REPEL = 100,
	IMPLODE = 101,
	SHUFFLE = 102,
}


var _plain_fragment_stuns : PlainTextFragment = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stuns")

#

const attk_source_y_pos_shift : float = 15.0

# REPEL
const repel_knockup_accel : float = 40.0
const repel_knockup_time : float = 0.8
const repel_stun_duration : float = 2.25

const repel_mov_speed : float = 80.0
const repel_mov_speed_deceleration : float = 65.0

var repel_descriptions : Array = [
	"Throws a potion that creates a blast at impact.",
	["The blast knocks enemies away from its center. The blast also |0| enemies hit for %s seconds." % [str(repel_stun_duration)], [_plain_fragment_stuns]],
	"",
	"\"Enemies tend to be separated with this potion.\""
]
const repel_name : String = "Repel"

var repel_attk_module : AOEAttackModule

var repel_knockup_effect : EnemyKnockUpEffect
var repel_forced_path_mov_effect : EnemyForcedPathOffsetMovementEffect


# IMPLOSION
const implosion_knockup_accel : float = 20.0
const implosion_knockup_time : float = 0.4
const implosion_stun_duration : float = 1.75

const implosion_base_mov_speed : float = 50.0
const implosion_base_mov_speed_deceleration : float = 40.0

var implosion_descriptions : Array = [
	"Throws a potion that creates an void implosion at impact.",
	["The implosion knocks enemies towards its center, with enemies closer to the center knocked less. The implosion also |0| enemies hit for %s seconds." % [str(implosion_stun_duration)], [_plain_fragment_stuns]],
	"",
	"\"Enemies tend to clump up with this potion.\"",
]
const implosion_name : String = "Implosion"

var implosion_attk_module : AOEAttackModule

var implosion_knockup_effect : EnemyKnockUpEffect
var implosion_forced_path_mov_template_effect : EnemyForcedPathOffsetMovementEffect

# SHUFFLE
const shuffle_knockup_accel : float = 35.0
const shuffle_knockup_time : float = 0.75
const shuffle_stun_duration : float = 2.0

const shuffle_base_mov_speed : float = 120.0
const shuffle_base_mov_speed_deceleration : float = 60.0

var shuffle_descriptions : Array = [
	"Throws a potion that creates a shuffling implosion at impact.",
	["The implosion knocks enemies towards its center, with enemies farther from the center knocked more. The implosion also |0| enemies hit for %s seconds." % [str(shuffle_stun_duration)], [_plain_fragment_stuns]],
	"",
	"\"Enemies at the back tend to be sent forward, and vice versa, with this potion.\""
]
const shuffle_name : String = "Shuffle"


var shuffle_attk_module : AOEAttackModule

var shuffle_knockup_effect : EnemyKnockUpEffect
var shuffle_forced_path_mov_template_effect : EnemyForcedPathOffsetMovementEffect

#

const potion_throw_cooldown : float = 10.0
const potion_throw_ready_for_activation_cond_clause : int = -10

var potion_attk_module : BulletAttackModule
var potion_throw_ability : BaseAbility

var current_potion_type_selected : int setget select_potion_type


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.BREWD)
	
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
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attk_source_y_pos_shift
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 480#400
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= attk_source_y_pos_shift
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 4
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Brewd_NormalProj_Pic)
	
	add_attack_module(attack_module)
	
	#
	
	_construct_and_add_potion_throwing_attk_module(info)
	
	_construct_repel_attk_module_and_relateds()
	_construct_implosion_attk_module_and_relateds()
	_construct_shuffle_attk_module_and_relateds()
	
	_construct_and_register_potion_throw_ability()
	
	#
	
	_post_inherit_ready()
	
	select_potion_type(PotionTypes.IMPLODE)


# REPEL RELATED

func _construct_repel_attk_module_and_relateds():
	var attk_module = AOEAttackModule_Scene.instance()
	attk_module.base_damage = 0
	attk_module.base_damage_type = DamageType.ELEMENTAL
	attk_module.base_attack_speed = 0
	attk_module.base_attack_wind_up = 0
	attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attk_module.is_main_attack = false
	#potion_attk_module.base_pierce = 1
	#potion_attk_module.base_proj_speed = 680
	#potion_attk_module.base_proj_life_distance = info.base_range
	attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attk_module.on_hit_damage_scale = 0
	attk_module.position.y -= attk_source_y_pos_shift
	
	attk_module.benefits_from_bonus_attack_speed = false
	attk_module.benefits_from_bonus_base_damage = false
	attk_module.benefits_from_bonus_on_hit_damage = false
	attk_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Repel_Pic01)
	sprite_frames.add_frame("default", Repel_Pic02)
	sprite_frames.add_frame("default", Repel_Pic03)
	sprite_frames.add_frame("default", Repel_Pic04)
	sprite_frames.add_frame("default", Repel_Pic05)
	sprite_frames.add_frame("default", Repel_Pic06)
	sprite_frames.add_frame("default", Repel_Pic07)
	sprite_frames.add_frame("default", Repel_Pic08)
	sprite_frames.add_frame("default", Repel_Pic09)
	
	attk_module.aoe_sprite_frames = sprite_frames
	attk_module.sprite_frames_only_play_once = true
	attk_module.pierce = -1
	attk_module.duration = 0.35
	attk_module.damage_repeat_count = 1
	
	attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	attk_module.base_aoe_scene = BaseAOE_Scene
	attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	attk_module.can_be_commanded_by_tower = false
	
	attk_module.is_displayed_in_tracker = false
	
	add_attack_module(attk_module)
	
	repel_attk_module = attk_module
	
	#
	
	repel_knockup_effect = EnemyKnockUpEffect.new(repel_knockup_time, repel_knockup_accel, StoreOfEnemyEffectsUUID.BREWD_REPEL_KNOCKUP)
	repel_knockup_effect.custom_stun_duration = repel_stun_duration
	
	repel_forced_path_mov_effect = EnemyForcedPathOffsetMovementEffect.new(repel_mov_speed, repel_mov_speed_deceleration, StoreOfEnemyEffectsUUID.BREWD_REPEL_FORCED_PATH_MOV)
	repel_forced_path_mov_effect.is_timebound = true
	repel_forced_path_mov_effect.time_in_seconds = repel_stun_duration


func _before_repel_explosion_hit_enemy(enemy, explosion):
	if is_instance_valid(enemy) and is_instance_valid(explosion) and is_instance_valid(enemy.current_path):
		var knock_up_copy = repel_knockup_effect._get_copy_scaled_by(1)
		var forced_mov_copy = repel_forced_path_mov_effect._get_copy_scaled_by(1)
		
		var explosion_nearest_offset_path = enemy.current_path.curve.get_closest_offset(explosion.global_position)
		if explosion_nearest_offset_path >= enemy.offset:
			forced_mov_copy.reverse_movements()
		
		enemy._add_effect(knock_up_copy)
		enemy._add_effect(forced_mov_copy)


# IMPLOSION RELATED

func _construct_implosion_attk_module_and_relateds():
	var attk_module = AOEAttackModule_Scene.instance()
	attk_module.base_damage = 0
	attk_module.base_damage_type = DamageType.ELEMENTAL
	attk_module.base_attack_speed = 0
	attk_module.base_attack_wind_up = 0
	attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attk_module.is_main_attack = false
	#potion_attk_module.base_pierce = 1
	#potion_attk_module.base_proj_speed = 680
	#potion_attk_module.base_proj_life_distance = info.base_range
	attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attk_module.on_hit_damage_scale = 0
	attk_module.position.y -= attk_source_y_pos_shift
	
	attk_module.benefits_from_bonus_attack_speed = false
	attk_module.benefits_from_bonus_base_damage = false
	attk_module.benefits_from_bonus_on_hit_damage = false
	attk_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Implosion_Pic01)
	sprite_frames.add_frame("default", Implosion_Pic02)
	sprite_frames.add_frame("default", Implosion_Pic03)
	sprite_frames.add_frame("default", Implosion_Pic04)
	sprite_frames.add_frame("default", Implosion_Pic05)
	sprite_frames.add_frame("default", Implosion_Pic06)
	sprite_frames.add_frame("default", Implosion_Pic07)
	sprite_frames.add_frame("default", Implosion_Pic08)
	sprite_frames.add_frame("default", Implosion_Pic09)
	
	attk_module.aoe_sprite_frames = sprite_frames
	attk_module.sprite_frames_only_play_once = true
	attk_module.pierce = -1
	attk_module.duration = 0.25
	attk_module.damage_repeat_count = 1
	
	attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	attk_module.base_aoe_scene = BaseAOE_Scene
	attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	attk_module.can_be_commanded_by_tower = false
	
	attk_module.is_displayed_in_tracker = false
	
	add_attack_module(attk_module)
	
	implosion_attk_module = attk_module
	
	#
	
	implosion_knockup_effect = EnemyKnockUpEffect.new(implosion_knockup_time, implosion_knockup_accel, StoreOfEnemyEffectsUUID.BREWD_IMPLOSION_KNOCKUP)
	implosion_knockup_effect.custom_stun_duration = implosion_stun_duration
	
	implosion_forced_path_mov_template_effect = EnemyForcedPathOffsetMovementEffect.new(implosion_base_mov_speed, implosion_base_mov_speed_deceleration, StoreOfEnemyEffectsUUID.BREWD_IMPLOSION_FORCED_PATH_MOV)
	implosion_forced_path_mov_template_effect.is_timebound = true
	implosion_forced_path_mov_template_effect.time_in_seconds = implosion_stun_duration


func _before_implosion_explosion_hit_enemy(enemy, explosion):
	if is_instance_valid(enemy) and is_instance_valid(explosion) and is_instance_valid(enemy.current_path):
		var knock_up_copy = implosion_knockup_effect._get_copy_scaled_by(1)
		var forced_mov_copy = implosion_forced_path_mov_template_effect._get_copy_scaled_by(1)
		
		var explosion_nearest_offset_path = enemy.current_path.curve.get_closest_offset(explosion.global_position)
		var offset_diff = explosion_nearest_offset_path - enemy.offset
		
		var mov_scale = offset_diff / forced_mov_copy.initial_mov_speed
		
		forced_mov_copy.scale_movements(mov_scale)
		
		
		enemy._add_effect(knock_up_copy)
		enemy._add_effect(forced_mov_copy)


# SHUFFLE RELATED

func _construct_shuffle_attk_module_and_relateds():
	var attk_module = AOEAttackModule_Scene.instance()
	attk_module.base_damage = 0
	attk_module.base_damage_type = DamageType.ELEMENTAL
	attk_module.base_attack_speed = 0
	attk_module.base_attack_wind_up = 0
	attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attk_module.is_main_attack = false
	#potion_attk_module.base_pierce = 1
	#potion_attk_module.base_proj_speed = 680
	#potion_attk_module.base_proj_life_distance = info.base_range
	attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attk_module.on_hit_damage_scale = 0
	attk_module.position.y -= attk_source_y_pos_shift
	
	attk_module.benefits_from_bonus_attack_speed = false
	attk_module.benefits_from_bonus_base_damage = false
	attk_module.benefits_from_bonus_on_hit_damage = false
	attk_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Shuffle_Pic01)
	sprite_frames.add_frame("default", Shuffle_Pic02)
	sprite_frames.add_frame("default", Shuffle_Pic03)
	sprite_frames.add_frame("default", Shuffle_Pic04)
	sprite_frames.add_frame("default", Shuffle_Pic05)
	sprite_frames.add_frame("default", Shuffle_Pic06)
	sprite_frames.add_frame("default", Shuffle_Pic07)
	sprite_frames.add_frame("default", Shuffle_Pic08)
	sprite_frames.add_frame("default", Shuffle_Pic09)
	sprite_frames.add_frame("default", Shuffle_Pic10)
	sprite_frames.add_frame("default", Shuffle_Pic11)
	sprite_frames.add_frame("default", Shuffle_Pic12)
	
	attk_module.aoe_sprite_frames = sprite_frames
	attk_module.sprite_frames_only_play_once = true
	attk_module.pierce = -1
	attk_module.duration = 0.25
	attk_module.damage_repeat_count = 1
	
	attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	attk_module.base_aoe_scene = BaseAOE_Scene
	attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	attk_module.can_be_commanded_by_tower = false
	
	attk_module.is_displayed_in_tracker = false
	
	add_attack_module(attk_module)
	
	shuffle_attk_module = attk_module
	
	#
	
	shuffle_knockup_effect = EnemyKnockUpEffect.new(shuffle_knockup_time, shuffle_knockup_accel, StoreOfEnemyEffectsUUID.BREWD_SHUFFLE_KNOCKUP)
	shuffle_knockup_effect.custom_stun_duration = shuffle_stun_duration
	
	shuffle_forced_path_mov_template_effect = EnemyForcedPathOffsetMovementEffect.new(shuffle_base_mov_speed, shuffle_base_mov_speed_deceleration, StoreOfEnemyEffectsUUID.BREWD_SHUFFLE_FORCED_PATH_MOV)
	shuffle_forced_path_mov_template_effect.is_timebound = true
	shuffle_forced_path_mov_template_effect.time_in_seconds = shuffle_stun_duration

func _before_shuffle_explosion_hit_enemy(enemy, explosion):
	if is_instance_valid(enemy) and is_instance_valid(explosion) and is_instance_valid(enemy.current_path):
		var knock_up_copy = shuffle_knockup_effect._get_copy_scaled_by(1)
		var forced_mov_copy = shuffle_forced_path_mov_template_effect._get_copy_scaled_by(1)
		
		var explosion_nearest_offset_path = enemy.current_path.curve.get_closest_offset(explosion.global_position)
		var offset_diff = explosion_nearest_offset_path - enemy.offset
		
		var mov_scale = (offset_diff / forced_mov_copy.initial_mov_speed) * 2
		
		forced_mov_copy.scale_movements(mov_scale)
		
		
		enemy._add_effect(knock_up_copy)
		enemy._add_effect(forced_mov_copy)



#

func _construct_and_add_potion_throwing_attk_module(info):
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = 0
	attack_module.base_damage_type = DamageType.ELEMENTAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = 1
	attack_module.base_proj_speed = 700#640
	attack_module.base_proj_life_distance = info.base_range + 100
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.on_hit_damage_scale = 0
	attack_module.position.y -= attk_source_y_pos_shift
	
	attack_module.benefits_from_bonus_pierce = false
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = false
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(7, 5)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Brewd_SpecialProjPic)
	
	attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(potion_throw_ready_for_activation_cond_clause)
	
	attack_module.is_displayed_in_tracker = false
	
	add_attack_module(attack_module)
	
	potion_attk_module = attack_module
	potion_attk_module.connect("in_attack", self, "_potion_thrown_by_potion_attk_module", [], CONNECT_PERSIST)
	potion_attk_module.connect("on_enemy_hit", self, "_potion_thrown_hit_enemy", [], CONNECT_PERSIST)


func _construct_and_register_potion_throw_ability():
	potion_throw_ability = BaseAbility.new()
	
	potion_throw_ability.is_timebound = true
	
	potion_throw_ability.set_properties_to_usual_tower_based()
	potion_throw_ability.tower = self
	
	potion_throw_ability.connect("updated_is_ready_for_activation", self, "_can_cast_potion_throw_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(potion_throw_ability, false)

func _can_cast_potion_throw_updated(value):
	if !value:
		potion_attk_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(potion_throw_ready_for_activation_cond_clause)
	else:
		potion_attk_module.can_be_commanded_by_tower_other_clauses.remove_clause(potion_throw_ready_for_activation_cond_clause)


func _potion_thrown_by_potion_attk_module(attack_speed_delay, enemies_or_poses):
	var cd = _get_cd_to_use(potion_throw_cooldown)
	
	potion_throw_ability.on_ability_before_cast_start(cd)
	potion_throw_ability.start_time_cooldown(cd)
	potion_throw_ability.on_ability_after_cast_ended(cd)


func _potion_thrown_hit_enemy(enemy, damage_register_id, damage_instance, module):
	if current_potion_type_selected == PotionTypes.REPEL:
		var repel_explosion = repel_attk_module.construct_aoe(enemy.global_position, enemy.global_position)
		repel_explosion.connect("before_enemy_hit_aoe", self, "_before_repel_explosion_hit_enemy", [repel_explosion])
		repel_explosion.scale *= 1.75
		
		repel_attk_module.set_up_aoe__add_child_and_emit_signals(repel_explosion)
		
	#----------
	elif current_potion_type_selected == PotionTypes.IMPLODE:
		var implode_explosion = implosion_attk_module.construct_aoe(enemy.global_position, enemy.global_position)
		implode_explosion.connect("before_enemy_hit_aoe", self, "_before_implosion_explosion_hit_enemy", [implode_explosion])
		implode_explosion.scale *= 1.75
		
		implosion_attk_module.set_up_aoe__add_child_and_emit_signals(implode_explosion)
		
		
	#----------
	elif current_potion_type_selected == PotionTypes.SHUFFLE:
		var shuffle_explosion = shuffle_attk_module.construct_aoe(enemy.global_position, enemy.global_position)
		shuffle_explosion.connect("before_enemy_hit_aoe", self, "_before_shuffle_explosion_hit_enemy", [shuffle_explosion])
		shuffle_explosion.scale *= 1.75
		
		shuffle_attk_module.set_up_aoe__add_child_and_emit_signals(shuffle_explosion)




#

func select_potion_type(arg_pot_type : int):
	current_potion_type_selected = arg_pot_type
	emit_signal("selected_potion_type_changed", arg_pot_type)

func get_name_of_potion_type(arg_pot_type : int = current_potion_type_selected) -> String:
	if arg_pot_type == PotionTypes.REPEL:
		return repel_name
	elif arg_pot_type == PotionTypes.IMPLODE:
		return implosion_name
	elif arg_pot_type == PotionTypes.SHUFFLE:
		return shuffle_name
	
	return "err"

func get_descriptions_of_potion_type(arg_pot_type : int = current_potion_type_selected) -> Array:
	if arg_pot_type == PotionTypes.REPEL:
		return repel_descriptions
	elif arg_pot_type == PotionTypes.IMPLODE:
		return implosion_descriptions
	elif arg_pot_type == PotionTypes.SHUFFLE:
		return shuffle_descriptions
	
	return [
		"err"
	]


#

