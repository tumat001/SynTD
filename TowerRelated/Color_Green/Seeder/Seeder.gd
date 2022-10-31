extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Seeder_NormalProj = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_NormalAttk.png")
const Seeder_Stage01 = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_ExplodingSeed_Stage0.png")
const Seeder_Explosion01 = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_Explosion/Seeder_Explosion01.png")
const Seeder_Explosion02 = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_Explosion/Seeder_Explosion02.png")
const Seeder_Explosion03 = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_Explosion/Seeder_Explosion03.png")
const Seeder_Explosion04 = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_Explosion/Seeder_Explosion04.png")
const Seeder_Explosion05 = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_Explosion/Seeder_Explosion05.png")
const Seeder_Explosion06 = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_Explosion/Seeder_Explosion06.png")

const Seeder_ExplodingSeed_Scene = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_ExplodingSeed.tscn")
const Seeder_ExplodingSeed = preload("res://TowerRelated/Color_Green/Seeder/Seeder_Attks/Seeder_ExplodingSeed.gd")

const SeederExplosion_AttackModule_Icon = preload("res://TowerRelated/Color_Green/Seeder/AMAssets/SeederExplosion_AttackModule_Icon.png")


const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")



const base_implant_cooldown : float = 10.0
var implant_ability : BaseAbility
var implant_ability_is_ready : bool = false

var exploding_seed_am : BulletAttackModule
var explosion_attack_module : AOEAttackModule

const dmg_ratio_per_stage = 0.25

const dmg_reg_to_detect = Towers.SEEDER


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.SEEDER)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var attack_module_y_shift : float = 9
	
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attack_module_y_shift
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 504#420
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= attack_module_y_shift
	attack_module.damage_register_id = dmg_reg_to_detect
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 6
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Seeder_NormalProj)
	
	add_attack_module(attack_module)
	
	
	# Exploding Seed
	
	exploding_seed_am = BulletAttackModule_Scene.instance()
	exploding_seed_am.base_damage = 0
	exploding_seed_am.base_damage_type = DamageType.PHYSICAL
	exploding_seed_am.base_attack_speed = 0
	exploding_seed_am.base_attack_wind_up = 0
	exploding_seed_am.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	exploding_seed_am.is_main_attack = false
	exploding_seed_am.base_pierce = info.base_pierce
	exploding_seed_am.base_proj_speed = 740#680
	exploding_seed_am.base_proj_life_distance = info.base_range
	exploding_seed_am.module_id = StoreOfAttackModuleID.PART_OF_SELF
	exploding_seed_am.on_hit_damage_scale = info.on_hit_multiplier
	exploding_seed_am.position.y -= attack_module_y_shift
	
	exploding_seed_am.benefits_from_bonus_attack_speed = false
	exploding_seed_am.benefits_from_bonus_base_damage = false
	exploding_seed_am.benefits_from_bonus_on_hit_damage = false
	exploding_seed_am.benefits_from_bonus_on_hit_effect = false
	exploding_seed_am.benefits_from_bonus_pierce = false
	
	var exploding_seed_shape = CircleShape2D.new()
	exploding_seed_shape.radius = 6
	
	exploding_seed_am.bullet_shape = exploding_seed_shape
	exploding_seed_am.bullet_scene = Seeder_ExplodingSeed_Scene
	
	exploding_seed_am.can_be_commanded_by_tower = false
	
	exploding_seed_am.connect("before_bullet_is_shot", self, "_on_exploding_seed_before_shot", [], CONNECT_PERSIST)
	
	exploding_seed_am.is_displayed_in_tracker = false
	
	add_attack_module(exploding_seed_am)
	
	
	# Explosion
	
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage_scale = 4
	explosion_attack_module.base_damage = 8 / explosion_attack_module.base_damage_scale
	explosion_attack_module.base_damage_type = DamageType.PHYSICAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attack_module.on_hit_damage_scale = 2
	explosion_attack_module.on_hit_effect_scale = 1
	explosion_attack_module.base_explosion_scale = 1.5
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	explosion_attack_module.benefits_from_bonus_on_hit_effect = true
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Seeder_Explosion01)
	sprite_frames.add_frame("default", Seeder_Explosion02)
	sprite_frames.add_frame("default", Seeder_Explosion03)
	sprite_frames.add_frame("default", Seeder_Explosion04)
	sprite_frames.add_frame("default", Seeder_Explosion05)
	sprite_frames.add_frame("default", Seeder_Explosion06)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = 5
	explosion_attack_module.duration = 0.25
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(SeederExplosion_AttackModule_Icon)
	
	add_attack_module(explosion_attack_module)
	
	
	#
	
	_construct_and_register_ability()
	
	connect("on_main_post_mitigation_damage_dealt" , self, "_on_main_post_mitigated_dmg_dealt", [], CONNECT_PERSIST)
	
	_post_inherit_ready()


func _construct_and_register_ability():
	implant_ability = BaseAbility.new()
	
	implant_ability.is_timebound = true
	
	implant_ability.set_properties_to_usual_tower_based()
	implant_ability.tower = self
	
	implant_ability.connect("updated_is_ready_for_activation", self, "_can_cast_implant_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(implant_ability, false)

func _can_cast_implant_updated(value):
	implant_ability_is_ready = value


# On post mitigation

func _on_main_post_mitigated_dmg_dealt(damage_instance_report, killed, enemy, damage_register_id, module):
	if !killed and implant_ability_is_ready:
		var cd = _get_cd_to_use(base_implant_cooldown)
		implant_ability.on_ability_before_cast_start(cd)
		
		exploding_seed_am.call_deferred("_attack_enemies", [enemy])
		_change_animation_to_face_position(enemy.global_position)
		
		implant_ability.start_time_cooldown(cd)
		implant_ability.on_ability_after_cast_ended(cd)


# seed explosion related

func _on_exploding_seed_before_shot(bullet : Seeder_ExplodingSeed):
	bullet.connect("seed_to_explode", self, "_seed_to_explode", [], CONNECT_ONESHOT)
	bullet.damage_reg_to_detect = dmg_reg_to_detect



func _seed_to_explode(bullet : Seeder_ExplodingSeed):
	var final_pos = bullet.global_position - Seeder_ExplodingSeed.bullet_attach_shift
	var final_potency = implant_ability.get_potency_to_use(last_calculated_final_ability_potency) * (1 + (float(bullet.stage) * dmg_ratio_per_stage))
	
	var explosion = explosion_attack_module.construct_aoe(final_pos, final_pos)
	#explosion.damage_instance = explosion.damage_instance.get_copy_damage_only_scaled_by(final_potency)
	explosion.damage_instance.scale_only_damage_by(final_potency)
	
	explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)
	bullet.queue_free()
	
