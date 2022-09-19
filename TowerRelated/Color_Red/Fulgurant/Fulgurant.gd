extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const Fulgurant_Beam_01 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/MainAttkSprite/Fulgurant_Beam_01.png")
const Fulgurant_Beam_02 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/MainAttkSprite/Fulgurant_Beam_02.png")
const Fulgurant_Beam_03 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/MainAttkSprite/Fulgurant_Beam_03.png")
const Fulgurant_Beam_04 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/MainAttkSprite/Fulgurant_Beam_04.png")
const Fulgurant_Beam_05 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/MainAttkSprite/Fulgurant_Beam_05.png")
const Fulgurant_Beam_06 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/MainAttkSprite/Fulgurant_Beam_06.png")
const Fulgurant_Beam_07 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/MainAttkSprite/Fulgurant_Beam_07.png")
const Fulgurant_Beam_08 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/MainAttkSprite/Fulgurant_Beam_08.png")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const Smite_Explosion_01 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_01.png")
const Smite_Explosion_02 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_02.png")
const Smite_Explosion_03 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_03.png")
const Smite_Explosion_04 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_04.png")
const Smite_Explosion_05 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_05.png")
const Smite_Explosion_06 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_06.png")
const Smite_Explosion_07 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_07.png")
const Smite_Explosion_08 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteExplosion/Fulgurant_Explosion_08.png")
const Smite_Beam_01 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteLightning/Fulgurant_SmiteLightning_01.png")
const Smite_Beam_02 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteLightning/Fulgurant_SmiteLightning_02.png")
const Smite_Beam_03 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteLightning/Fulgurant_SmiteLightning_03.png")
const Smite_Beam_04 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteLightning/Fulgurant_SmiteLightning_04.png")
const Smite_Beam_05 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteLightning/Fulgurant_SmiteLightning_05.png")
const Smite_Beam_06 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteLightning/Fulgurant_SmiteLightning_06.png")
const Smite_Beam_07 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteLightning/Fulgurant_SmiteLightning_07.png")
const Smite_Beam_08 = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/SmiteLightning/Fulgurant_SmiteLightning_08.png")
const Smite_Explosion_AMI = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/Fulgurant_SmiteExplosion_AMI.png")

const Fulgurant_SmiteBeam_Scene = preload("res://TowerRelated/Color_Red/Fulgurant/Fulgurant_SmiteBeam.tscn")

#

const smite_explosion_flat_dmg : float = 4.0
const smite_explosion_base_dmg_scale : float = 2.0
const smite_explosion_pierce : int = 3

var smite_ability : BaseAbility
var smite_ability_is_ready : bool = false
const smite_ability_base_cooldown : float = 10.0

var explosion_attack_module : AOEAttackModule

var smite_beam_attk_sprite_pool_component : AttackSpritePoolComponent

#

const cast_count_for_empowered_version : int = 3
var _current_cast_count : int
const smite_target_count_for_empowered : int = 3
const smite_target_count_for_normal : int = 1



func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.ENTROPY)
	
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
	range_module.set_range_shape(CircleShape2D.new())
	range_module.position.y += 24
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 24
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Fulgurant_Beam_01)
	beam_sprite_frame.add_frame("default", Fulgurant_Beam_02)
	beam_sprite_frame.add_frame("default", Fulgurant_Beam_03)
	beam_sprite_frame.add_frame("default", Fulgurant_Beam_04)
	beam_sprite_frame.add_frame("default", Fulgurant_Beam_05)
	beam_sprite_frame.add_frame("default", Fulgurant_Beam_06)
	beam_sprite_frame.add_frame("default", Fulgurant_Beam_07)
	beam_sprite_frame.add_frame("default", Fulgurant_Beam_08)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 8 / 0.25)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.25
	
	add_attack_module(attack_module)
	
	#
	
	_construct_and_register_ability()
	_construct_attk_sprite_pool_components()
	
	#
	
	_post_inherit_ready()

func _construct_and_add_smite_explosion_am():
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage_scale = smite_explosion_base_dmg_scale
	explosion_attack_module.base_damage = smite_explosion_flat_dmg / explosion_attack_module.base_damage_scale
	explosion_attack_module.base_damage_type = DamageType.PHYSICAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	explosion_attack_module.base_explosion_scale = 1.5
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Smite_Explosion_01)
	sprite_frames.add_frame("default", Smite_Explosion_02)
	sprite_frames.add_frame("default", Smite_Explosion_03)
	sprite_frames.add_frame("default", Smite_Explosion_04)
	sprite_frames.add_frame("default", Smite_Explosion_05)
	sprite_frames.add_frame("default", Smite_Explosion_06)
	sprite_frames.add_frame("default", Smite_Explosion_07)
	sprite_frames.add_frame("default", Smite_Explosion_08)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = smite_explosion_pierce
	explosion_attack_module.duration = 0.32
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(Smite_Explosion_AMI)
	
	add_attack_module(explosion_attack_module)
	


func _construct_and_register_ability():
	smite_ability = BaseAbility.new()
	
	smite_ability.is_timebound = true
	
	smite_ability.set_properties_to_usual_tower_based()
	smite_ability.tower = self
	
	smite_ability.connect("updated_is_ready_for_activation", self, "_can_cast_smite_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(smite_ability, false)

func _construct_attk_sprite_pool_components():
	smite_beam_attk_sprite_pool_component = AttackSpritePoolComponent.new()
	smite_beam_attk_sprite_pool_component.node_to_parent_attack_sprites = get_tree().get_root()
	smite_beam_attk_sprite_pool_component.node_to_listen_for_queue_free = self
	smite_beam_attk_sprite_pool_component.source_for_funcs_for_attk_sprite = self
	smite_beam_attk_sprite_pool_component.func_name_for_creating_attack_sprite = "_create_smite_lightning"
	


#

func _can_cast_smite_updated(arg_val):
	smite_ability_is_ready = arg_val
	_attempt_cast_smite()

func _attempt_cast_smite():
	if smite_ability_is_ready:
		_cast_smite()

func _cast_smite():
	var cd = _get_cd_to_use(smite_ability_base_cooldown)
	smite_ability.on_ability_before_cast_start(cd)
	
	#
	_current_cast_count += 1
	var is_empowered : bool = false
	
	if _current_cast_count >= cast_count_for_empowered_version:
		is_empowered = true
	
	var targets = _get_targets_for_smite(is_empowered)
	
	for target in targets:
		call_deferred("_summon_smite_lightning_onto_pos", target.global_position)
	
	#
	
	smite_ability.start_time_cooldown(cd)
	smite_ability.on_ability_after_cast_ended(cd)

#

func _get_targets_for_smite(arg_is_empowered : bool):
	var target_count : int = smite_target_count_for_normal
	if arg_is_empowered:
		target_count = smite_target_count_for_empowered
	
	if range_module != null:
		return range_module.get_all_targetable_enemies_outside_of_range(Targeting.RANDOM, target_count, false)
	else:
		return []


#

func _summon_smite_lightning_onto_pos(arg_pos):
	var smite_lightning = smite_beam_attk_sprite_pool_component.get_or_create_attack_sprite_from_pool()
	smite_lightning.lifetime = 0.3
	smite_lightning.frame = 0
	
	smite_lightning.global_position = arg_pos
	smite_lightning.visible = true
	

func _create_smite_lightning():
	var smite_lightning = Fulgurant_SmiteBeam_Scene.instance()
	
	smite_lightning.scale *= 2
	smite_lightning.offset.y -= smite_lightning.get_sprite_size().y / 2.0
	
	smite_lightning.queue_free_at_end_of_lifetime = false
	
	smite_lightning.connect("animation_finished", self, "_on_smite_lightning_animation_ended", [smite_lightning])
	
	return smite_lightning


func _on_smite_lightning_animation_ended(arg_lightning):
	pass




