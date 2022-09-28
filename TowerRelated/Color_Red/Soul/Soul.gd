extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")


const SoulEffigy = preload("res://TowerRelated/Color_Red/Soul/EffigyRelated/SoulEffigy.gd")
const SoulEffigy_Scene = preload("res://TowerRelated/Color_Red/Soul/EffigyRelated/SoulEffigy.tscn")

const SoulBullet_pic = preload("res://TowerRelated/Color_Red/Soul/Soul_BulletPic.png")
const Effigy_ExplosionPic01 = preload("res://TowerRelated/Color_Red/Soul/EffigyRelated/EffigyExplosion/EffigyExplosion_01.png")
const Effigy_ExplosionPic02 = preload("res://TowerRelated/Color_Red/Soul/EffigyRelated/EffigyExplosion/EffigyExplosion_02.png")
const Effigy_ExplosionPic03 = preload("res://TowerRelated/Color_Red/Soul/EffigyRelated/EffigyExplosion/EffigyExplosion_03.png")
const Effigy_ExplosionPic04 = preload("res://TowerRelated/Color_Red/Soul/EffigyRelated/EffigyExplosion/EffigyExplosion_04.png")
const Effigy_ExplosionPic05 = preload("res://TowerRelated/Color_Red/Soul/EffigyRelated/EffigyExplosion/EffigyExplosion_05.png")
const Effigy_ExplosionPic06 = preload("res://TowerRelated/Color_Red/Soul/EffigyRelated/EffigyExplosion/EffigyExplosion_06.png")
const Effigy_ExplosionPic07 = preload("res://TowerRelated/Color_Red/Soul/EffigyRelated/EffigyExplosion/EffigyExplosion_07.png")
const Effigy_ExplosionPic08 = preload("res://TowerRelated/Color_Red/Soul/EffigyRelated/EffigyExplosion/EffigyExplosion_08.png")

const SoulExplosion_AttackModule_Icon = preload("res://TowerRelated/Color_Red/Soul/AMAssets/SoulExplosion_AttackModule_Icon.png")


const base_effigy_position_shift : float = 170.0
const base_effigy_curr_health_scale : float = 0.5

const base_effigy_explosion_pierce : int = 5
const base_effigy_ability_cooldown : float = 1.0
const base_effigy_explosion_health_scale : float = 0.5

const effigy_exists_clause : int = -10


var _current_soul_effigy : SoulEffigy

var effigy_ability : BaseAbility
var effigy_activation_clauses : ConditionalClauses
var _can_cast_effigy_ability : bool = false

var effigy_explosion_attack_module : AOEAttackModule


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SOUL)
	
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
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 350
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(6, 3)
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(SoulBullet_pic)
	
	add_attack_module(attack_module)
	
	
	# effigy explosion am
	
	effigy_explosion_attack_module = AOEAttackModule_Scene.instance()
	effigy_explosion_attack_module.base_damage = 0
	effigy_explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	effigy_explosion_attack_module.base_attack_speed = 0
	effigy_explosion_attack_module.base_attack_wind_up = 0
	effigy_explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	effigy_explosion_attack_module.is_main_attack = false
	effigy_explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	effigy_explosion_attack_module.benefits_from_bonus_explosion_scale = true
	effigy_explosion_attack_module.benefits_from_bonus_base_damage = false
	effigy_explosion_attack_module.benefits_from_bonus_attack_speed = false
	effigy_explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	effigy_explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Effigy_ExplosionPic01)
	sprite_frames.add_frame("default", Effigy_ExplosionPic02)
	sprite_frames.add_frame("default", Effigy_ExplosionPic03)
	sprite_frames.add_frame("default", Effigy_ExplosionPic04)
	sprite_frames.add_frame("default", Effigy_ExplosionPic05)
	sprite_frames.add_frame("default", Effigy_ExplosionPic06)
	sprite_frames.add_frame("default", Effigy_ExplosionPic07)
	sprite_frames.add_frame("default", Effigy_ExplosionPic08)
	
	effigy_explosion_attack_module.aoe_sprite_frames = sprite_frames
	effigy_explosion_attack_module.sprite_frames_only_play_once = true
	effigy_explosion_attack_module.pierce = base_effigy_explosion_pierce
	effigy_explosion_attack_module.duration = 0.3
	effigy_explosion_attack_module.damage_repeat_count = 1
	
	effigy_explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	effigy_explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	effigy_explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	effigy_explosion_attack_module.can_be_commanded_by_tower = false
	
	effigy_explosion_attack_module.set_image_as_tracker_image(SoulExplosion_AttackModule_Icon)
	
	add_attack_module(effigy_explosion_attack_module)
	
	#
	
	_construct_ability()
	
	connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_enemy_hit_s", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_s", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _construct_ability():
	effigy_ability = BaseAbility.new()
	
	effigy_ability.is_timebound = true
	
	effigy_ability.set_properties_to_usual_tower_based()
	effigy_ability.tower = self
	
	effigy_activation_clauses = effigy_ability.activation_conditional_clauses
	effigy_ability.connect("updated_is_ready_for_activation", self, "_effigy_ability_ready_for_activation", [], CONNECT_PERSIST)
	
	register_ability_to_manager(effigy_ability, false)


func _effigy_ability_ready_for_activation(is_ready : bool):
	_can_cast_effigy_ability = is_ready


#

func _on_round_end_s():
	if effigy_ability != null:
		_kill_current_effigy(false, true)
		effigy_ability.remove_all_time_cooldown()


#

func _on_main_attack_enemy_hit_s(enemy, damage_register_id, damage_instance, module):
	if _can_cast_effigy_ability and enemy != null:
		_create_effigy_of_enemy(enemy)


func _create_effigy_of_enemy(enemy):
	var cd = _get_cd_to_use(base_effigy_ability_cooldown)
	effigy_ability.on_ability_before_cast_start(cd)
	
	_current_soul_effigy = SoulEffigy_Scene.instance()
	
	_current_soul_effigy.enemy_manager = game_elements.enemy_manager
	
	var final_offset = base_effigy_position_shift
	if range_module == null or range_module.get_current_targeting_option() != Targeting.FIRST:
		final_offset *= -1 # effigy spawns at behind
	
	var final_curr_health_percentage = base_effigy_curr_health_scale
	final_curr_health_percentage *= effigy_ability.get_potency_to_use(last_calculated_final_ability_potency)
	
	
	_current_soul_effigy.copy_enemy_stats_and_location(enemy, final_offset, final_curr_health_percentage)
	_current_soul_effigy.call_deferred("spawn_effigy_to_map")
	
	#
	
	_current_soul_effigy.connect("tree_exiting", self, "_effigy_tree_exiting", [], CONNECT_ONESHOT)
	_current_soul_effigy.connect("effigied_enemy_killed", self, "_effigied_enemy_killed_by_damage", [], CONNECT_ONESHOT)
	_current_soul_effigy.connect("effigied_enemy_queue_freeing", self, "_effigied_enemy_tree_exiting", [], CONNECT_ONESHOT)
	
	#
	
	effigy_activation_clauses.attempt_insert_clause(effigy_exists_clause)
	
	effigy_ability.on_ability_after_cast_ended(cd)


#

func _effigy_tree_exiting():
	_kill_current_effigy(true, false)

#

func _effigied_enemy_tree_exiting(enemy):
	_kill_current_effigy(true, true)

func _effigied_enemy_killed_by_damage(enemy):
	_create_explosion(enemy, _current_soul_effigy)
	_kill_current_effigy(true, true)


func _kill_current_effigy(start_cooldown : bool = true, queue_free_effigy : bool = true):
	if start_cooldown:
		effigy_ability.start_time_cooldown(_get_cd_to_use(base_effigy_ability_cooldown))
	
	effigy_activation_clauses.remove_clause(effigy_exists_clause)
	
	if queue_free_effigy and _current_soul_effigy != null:
		if !_current_soul_effigy.is_queued_for_deletion():
			_current_soul_effigy.queue_free()


# Explosion

func _create_explosion(enemy, effigy):
	if enemy != null and effigy != null and effigy.is_inside_tree():
		var explosion = effigy_explosion_attack_module.construct_aoe(effigy.global_position, effigy.global_position)
		
		var modi_of_dmg = explosion.damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE].damage_as_modifier
		modi_of_dmg.flat_modifier = effigy.current_health * base_effigy_explosion_health_scale
		
		effigy_explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)


#

func queue_free():
	if _current_soul_effigy != null:
		_kill_current_effigy(false, true)
	
	.queue_free()
