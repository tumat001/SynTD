extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

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
const Smite_Explosion_AMI = preload("res://TowerRelated/Color_Red/Fulgurant/Assets/Fulgurant_SmiteExplosion_AMI.png")
const Fulgurant_SmiteBeam_Scene = preload("res://TowerRelated/Color_Red/Fulgurant/Fulgurant_SmiteBeam.tscn")
const Fulgurant_SmiteLaunch_Scene = preload("res://TowerRelated/Color_Red/Fulgurant/Fulgurant_SmiteLaunch.tscn")

#

const smite_explosion_flat_dmg : float = 6.0
const smite_explosion_base_dmg_scale : float = 2.0
const smite_explosion_pierce : int = 3

var smite_ability : BaseAbility
var smite_ability_is_ready : bool = false
const smite_ability_base_cooldown : float = 10.0
const smite_ability_cooldown_on_no_targets : float = 2.0

var explosion_attack_module : AOEAttackModule

var smite_beam_attk_sprite_pool_component : AttackSpritePoolComponent
var smite_launch_fx_attk_sprite_pool_component : AttackSpritePoolComponent

var smite_stun_effect : EnemyStunEffect
const smite_stun_duration : float = 1.0

const y_shift_of_attk_module : float = 37.0

#

const cast_count_for_empowered_version : int = 3
var _current_cast_count : int
const smite_target_count_for_empowered : int = 3
const smite_target_count_for_normal : int = 1

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.FULGURANT)
	
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
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += y_shift_of_attk_module
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= y_shift_of_attk_module
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
	_construct_and_add_smite_explosion_am()
	
	smite_stun_effect = EnemyStunEffect.new(smite_stun_duration, StoreOfEnemyEffectsUUID.FULGURANT_SMITE_STUN_EFFECT)
	
	#
	
	_post_inherit_ready()

func _construct_and_add_smite_explosion_am():
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage_scale = smite_explosion_base_dmg_scale
	explosion_attack_module.base_damage = smite_explosion_flat_dmg / explosion_attack_module.base_damage_scale
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
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
	smite_beam_attk_sprite_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	smite_beam_attk_sprite_pool_component.node_to_listen_for_queue_free = self
	smite_beam_attk_sprite_pool_component.source_for_funcs_for_attk_sprite = self
	smite_beam_attk_sprite_pool_component.func_name_for_creating_attack_sprite = "_create_smite_lightning"
	
	smite_launch_fx_attk_sprite_pool_component = AttackSpritePoolComponent.new()
	smite_launch_fx_attk_sprite_pool_component.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	smite_launch_fx_attk_sprite_pool_component.node_to_listen_for_queue_free = self
	smite_launch_fx_attk_sprite_pool_component.source_for_funcs_for_attk_sprite = self
	smite_launch_fx_attk_sprite_pool_component.func_name_for_creating_attack_sprite = "_create_smite_launch"
	


#

func _can_cast_smite_updated(arg_val):
	smite_ability_is_ready = arg_val
	_attempt_cast_smite()

func _attempt_cast_smite():
	if smite_ability_is_ready:
		_cast_smite()

func _cast_smite():
	var targets = _get_targets_for_smite()
	
	if targets.size() > 0:
		var cd = _get_cd_to_use(smite_ability_base_cooldown)
		smite_ability.on_ability_before_cast_start(cd)
		
		#
		
		_current_cast_count += 1
		var is_empowered : bool = false
		
		if _current_cast_count >= cast_count_for_empowered_version:
			is_empowered = true
			_current_cast_count = 0
		
		var target_count : int = smite_target_count_for_normal
		if is_empowered:
			target_count = smite_target_count_for_empowered
		
		for target in targets:
			call_deferred("_summon_smite_launch_particle", target.global_position)
			target_count -= 1
			if target_count <= 0:
				break
		
		#
		
		smite_ability.start_time_cooldown(cd)
		smite_ability.on_ability_after_cast_ended(cd)
		
	else:
		smite_ability.start_time_cooldown(smite_ability_cooldown_on_no_targets)

#

func _get_targets_for_smite():
	if is_instance_valid(range_module):
		return range_module.get_all_targetable_enemies_outside_of_range(Targeting.RANDOM, smite_target_count_for_empowered, false)
	else:
		return []


#

func _summon_smite_launch_particle(arg_pos):
	var launch_particle = smite_launch_fx_attk_sprite_pool_component.get_or_create_attack_sprite_from_pool()
	launch_particle.lifetime = 0.25
	launch_particle.frame = 0
	
	launch_particle.global_position = global_position - Vector2(0, y_shift_of_attk_module)
	launch_particle.visible = true
	
	if launch_particle.is_connected("animation_finished", self, "_on_smite_launch_animation_ended"):
		launch_particle.disconnect("animation_finished", self, "_on_smite_launch_animation_ended")
	launch_particle.connect("animation_finished", self, "_on_smite_launch_animation_ended", [arg_pos], CONNECT_ONESHOT)


func _create_smite_launch():
	var launch_sprite = Fulgurant_SmiteLaunch_Scene.instance()
	launch_sprite.modulate.a = 0.6
	
	launch_sprite.queue_free_at_end_of_lifetime = false
	
	return launch_sprite

func _on_smite_launch_animation_ended(arg_pos):
	_summon_smite_lightning_onto_pos(arg_pos)



func _summon_smite_lightning_onto_pos(arg_pos):
	var smite_lightning = smite_beam_attk_sprite_pool_component.get_or_create_attack_sprite_from_pool()
	smite_lightning.lifetime = 0.25
	smite_lightning.frame = 0
	
	smite_lightning.global_position = arg_pos
	smite_lightning.visible = true
	

func _create_smite_lightning():
	var smite_lightning = Fulgurant_SmiteBeam_Scene.instance()
	
	smite_lightning.scale *= 2
	smite_lightning.offset.y -= smite_lightning.get_sprite_size().y / 2.0
	smite_lightning.modulate.a = 0.6
	
	smite_lightning.queue_free_at_end_of_lifetime = false
	
	smite_lightning.connect("animation_finished", self, "_on_smite_lightning_animation_ended", [smite_lightning])
	
	return smite_lightning


func _on_smite_lightning_animation_ended(arg_lightning):
	var pos = arg_lightning.global_position
	var explosion = explosion_attack_module.construct_aoe(pos, pos)
	explosion.modulate.a = 0.6
	explosion.damage_instance.on_hit_effects[smite_stun_effect.effect_uuid] = smite_stun_effect
	explosion.damage_instance.scale_only_damage_by(smite_ability.get_potency_to_use(last_calculated_final_ability_potency))
	
	explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)


##


func set_heat_module(module):
	module.heat_per_attack = 1
	.set_heat_module(module)

func _construct_heat_effect():
	var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_dmg_attr_mod.flat_modifier = 2.5
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	for module in all_attack_modules:
		if module.benefits_from_bonus_base_damage:
			module.calculate_final_base_damage()
	
	emit_signal("final_base_damage_changed")


