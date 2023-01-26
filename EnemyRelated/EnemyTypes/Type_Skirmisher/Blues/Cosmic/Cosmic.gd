extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"

const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const AOEAttackModule = preload("res://TowerRelated/Modules/AOEAttackModule.gd")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")


const Cosmic_Beam01 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_01.png")
const Cosmic_Beam02 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_02.png")
const Cosmic_Beam03 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_03.png")
const Cosmic_Beam04 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_04.png")
const Cosmic_Beam05 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_05.png")
const Cosmic_Beam06 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_06.png")
const Cosmic_Beam07 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_07.png")
const Cosmic_Beam08 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_08.png")
const Cosmic_Beam09 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_09.png")
const Cosmic_Beam10 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_10.png")
const Cosmic_Beam11 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_11.png")
const Cosmic_Beam12 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Beam/Cosmic_Beam_12.png")

const Cosmic_Area01 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Area/Cosmic_Area01.png") 
const Cosmic_Area02 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Area/Cosmic_Area02.png")
const Cosmic_Area03 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Area/Cosmic_Area03.png")
const Cosmic_Area04 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Area/Cosmic_Area04.png")
const Cosmic_Area05 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Area/Cosmic_Area05.png")
const Cosmic_Area06 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Area/Cosmic_Area06.png")
const Cosmic_Area07 = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic_Area/Cosmic_Area07.png")


const _shield_cooldown : float = 12.0#15.0
const _shield_initial_cooldown : float = 7.0#10.0  # a range is used instead of just this value. this val is still used (indirectly) tho.
const _shield_refresh_cooldown : float = 2.0

const _shield_flat_amount : float = 40.0 #35.0
const _shield_duration : float = 10.0

var shield_ability : BaseAbility
var shield_effect : EnemyShieldEffect

#

const _aoe_dmg_receive_percent_amount : float = -30.0#-50.0
const _aoe_dmg_receive_scale_duration : float = _shield_duration

#

const _beam_single_duration : float = 0.3
var _cosmic_beam_sprite_frames : SpriteFrames


var cosmic_aoe_module : AOEAttackModule
const _cosmic_aoe_duration : float = 0.25
const _cosmic_modulate : Color = Color(1, 1, 1, 0.6)

var staff_w_position := Vector2(-10, -3)
var staff_e_position := Vector2(10, -3)

var shield_beam_targeting_rng : RandomNumberGenerator
const shield_beam_targeting_i_min : int = 1  # starting from 1, so don't make this 0
const shield_beam_targeting_i_max : int = 8

#
onready var staff_center_2dposition_node = $SpriteLayer/KnockUpLayer/StaffCenterPosition

#

func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.COSMIC))
	
	connect("anim_name_used_changed", self, "_on_anim_name_used_changed_c")
	is_blue_and_benefits_from_ap = true

func _ready():
	shield_beam_targeting_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SKIRMISHER_GEN_PURPOSE)
	
	_construct_beam_sprite_frames()
	
	_construct_and_add_cosmic_attack_module()
	_construct_effects()
	_construct_and_connect_ability()
	
	connect("final_ability_potency_changed", self, "_on_final_ap_changed_c")

func _on_finished_ready_prep():
	staff_w_position = get_position_added_pos_and_offset_modifiers(staff_w_position)
	staff_e_position = get_position_added_pos_and_offset_modifiers(staff_e_position)


func _construct_beam_sprite_frames():
	_cosmic_beam_sprite_frames = SpriteFrames.new()
	
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam01)
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam02)
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam03)
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam04)
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam05)
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam06)
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam07)
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam08)
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam09)
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam10)
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam11)
	_cosmic_beam_sprite_frames.add_frame("default", Cosmic_Beam12)


func _construct_and_connect_ability():
	shield_ability = BaseAbility.new()
	
	shield_ability.is_timebound = true
	shield_ability._time_current_cooldown = get_random_cd(_shield_initial_cooldown / 5.0, _shield_initial_cooldown)
	shield_ability.connect("updated_is_ready_for_activation", self, "_shield_ready_for_activation_updated")
	
	register_ability(shield_ability)

func _construct_effects():
	var modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.COSMIC_SHIELD_EFFECT)
	modi.flat_modifier = _shield_flat_amount * last_calculated_final_ability_potency
	
	shield_effect = EnemyShieldEffect.new(modi, StoreOfEnemyEffectsUUID.COSMIC_SHIELD_EFFECT)
	shield_effect.is_timebound = true
	shield_effect.time_in_seconds = _shield_duration
	shield_effect.is_from_enemy = true

func _construct_and_add_cosmic_attack_module():
	cosmic_aoe_module = AOEAttackModule_Scene.instance()
	
	cosmic_aoe_module.base_damage = 0
	cosmic_aoe_module.base_damage_type = DamageType.ELEMENTAL
	cosmic_aoe_module.base_attack_speed = 0
	cosmic_aoe_module.base_attack_wind_up = 0
	cosmic_aoe_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	cosmic_aoe_module.is_main_attack = true
	cosmic_aoe_module.module_id = StoreOfAttackModuleID.MAIN
	
	cosmic_aoe_module.benefits_from_bonus_explosion_scale = true
	cosmic_aoe_module.benefits_from_bonus_base_damage = false
	cosmic_aoe_module.benefits_from_bonus_attack_speed = false
	cosmic_aoe_module.benefits_from_bonus_on_hit_damage = false
	cosmic_aoe_module.benefits_from_bonus_on_hit_effect = false
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Cosmic_Area01)
	sprite_frames.add_frame("default", Cosmic_Area02)
	sprite_frames.add_frame("default", Cosmic_Area03)
	sprite_frames.add_frame("default", Cosmic_Area04)
	sprite_frames.add_frame("default", Cosmic_Area05)
	sprite_frames.add_frame("default", Cosmic_Area06)
	sprite_frames.add_frame("default", Cosmic_Area07)
	
	cosmic_aoe_module.aoe_sprite_frames = sprite_frames
	cosmic_aoe_module.sprite_frames_only_play_once = true
	cosmic_aoe_module.pierce = -1
	cosmic_aoe_module.duration = 0.2
	cosmic_aoe_module.damage_repeat_count = 1
	
	cosmic_aoe_module.absolute_z_index_of_aoe = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	
	cosmic_aoe_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	cosmic_aoe_module.base_aoe_scene = BaseAOE_Scene
	cosmic_aoe_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	cosmic_aoe_module.can_be_commanded_by_tower = false
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(cosmic_aoe_module)

#

func _shield_ready_for_activation_updated(is_ready):
	if is_ready:
		call_deferred("_shield_ability_activated")

func _shield_ability_activated():
	var enemies : Array = enemy_manager.get_all_enemies()
	enemies = Targeting.enemies_to_target(enemies, Targeting.FIRST, _get_rng_for_shield_beam_targeting(), global_position, false)
	
	if enemies.size() > 0:
		var cd = _shield_cooldown
		
		shield_ability.on_ability_before_cast_start(cd)
		_target_enemy_with_cosmic_shield_beam(enemies[-1])
		shield_ability.start_time_cooldown(_shield_cooldown)
		
		shield_ability.on_ability_after_cast_ended(cd)
		
	else:
		shield_ability.start_time_cooldown(_shield_refresh_cooldown)

func _get_rng_for_shield_beam_targeting() -> int:
	return shield_beam_targeting_rng.randi_range(shield_beam_targeting_i_min, shield_beam_targeting_i_max)

#

func _target_enemy_with_cosmic_shield_beam(enemy):
	var beam = _construct_and_get_cosmic_beam()
	
	beam.connect("time_visible_is_over", self, "_beam_in_sky", [beam, enemy.global_position], CONNECT_ONESHOT)
	
	beam.play("default", false)
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(beam)
	
	beam.visible = true
	beam.global_position = staff_center_2dposition_node.global_position
	beam.update_destination_position(Vector2(global_position.x, global_position.y - 150))


func _construct_and_get_cosmic_beam() -> BeamAesthetic:
	var beam : BeamAesthetic = BeamAesthetic_Scene.instance()
	beam.is_timebound = true
	beam.visible = false
	
	beam.set_sprite_frames(_cosmic_beam_sprite_frames)
	beam.frames.set_animation_loop("default", false)
	
	beam.frames.set_animation_speed("default", 12.0 / (_beam_single_duration))
	beam.frame = 0
	
	beam.time_visible = _beam_single_duration
	
	return beam

#

func _beam_in_sky(beam_in_sky, position_to_land):
	var landing_beam = _construct_and_get_cosmic_beam()
	
	landing_beam.connect("time_visible_is_over", self, "_sky_beam_landed", [position_to_land], CONNECT_ONESHOT)
	
	landing_beam.play("default", false)
	
	game_elements.get_tree().get_root().add_child(landing_beam)
	
	landing_beam.visible = true
	landing_beam.global_position = beam_in_sky.curr_destination_pos
	landing_beam.update_destination_position(position_to_land)


func _sky_beam_landed(beam_position):
	_construct_and_add_cosmic_shield_aoe(beam_position)

#

func _construct_and_add_cosmic_shield_aoe(aoe_position : Vector2):
	var aoe = cosmic_aoe_module.construct_aoe(aoe_position, aoe_position)
	
	aoe.connect("before_enemy_hit_aoe", self, "_on_aoe_hit_enemy")
	aoe.modulate = _cosmic_modulate
	aoe.scale *= 2.5
	
	cosmic_aoe_module.set_up_aoe__add_child_and_emit_signals(aoe)

func _on_aoe_hit_enemy(enemy_hit):
	enemy_hit._add_effect(shield_effect)
	_construct_aoe_dmg_receive_scale_effect_and_give_to_enemy(enemy_hit)

func _construct_aoe_dmg_receive_scale_effect_and_give_to_enemy(arg_enemy):
	var dmg_receive_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.COSMIC_AOE_DMG_RECEIVE_SCALE_EFFECT)
	dmg_receive_modi.percent_amount = _aoe_dmg_receive_percent_amount
	
	var aoe_dmg_receive_scale_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_AOE_DMG_RECEIVE_SCALE, dmg_receive_modi, StoreOfEnemyEffectsUUID.COSMIC_AOE_DMG_RECEIVE_SCALE_EFFECT)
	aoe_dmg_receive_scale_effect.respect_scale = true
	aoe_dmg_receive_scale_effect.is_timebound = true
	aoe_dmg_receive_scale_effect.time_in_seconds = _aoe_dmg_receive_scale_duration
	aoe_dmg_receive_scale_effect.is_from_enemy = true
	aoe_dmg_receive_scale_effect.status_bar_icon = preload("res://EnemyRelated/EnemyTypes/Type_Skirmisher/_FactionAssets/StatusBarIcons/Cosmic_AOEReducIcon.png")
	
	arg_enemy._add_effect__use_provided_effect(aoe_dmg_receive_scale_effect)


#

func _queue_free():
	.queue_free()
	
	if is_instance_valid(cosmic_aoe_module):
		cosmic_aoe_module.queue_free()

#

func _on_anim_name_used_changed_c(arg_prev_name, arg_curr_name):
	if arg_curr_name == "W":
		staff_center_2dposition_node.position = staff_w_position
	elif arg_curr_name == "E":
		staff_center_2dposition_node.position = staff_e_position
	

#

func _on_final_ap_changed_c(arg_potency):
	shield_effect.shield_as_modifier.flat_modifier = _shield_flat_amount * last_calculated_final_ability_potency
	
