extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")

const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")


const NightWatcher_SkyBeam_01 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/BeamToGround/NightWatcher_BeamToGround_01.png")
const NightWatcher_SkyBeam_02 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/BeamToGround/NightWatcher_BeamToGround_02.png")
const NightWatcher_SkyBeam_03 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/BeamToGround/NightWatcher_BeamToGround_03.png")
const NightWatcher_SkyBeam_04 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/BeamToGround/NightWatcher_BeamToGround_04.png")
const NightWatcher_SkyBeam_05 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/BeamToGround/NightWatcher_BeamToGround_05.png")
const NightWatcher_SkyBeam_06 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/BeamToGround/NightWatcher_BeamToGround_06.png")
const NightWatcher_SkyBeam_07 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/BeamToGround/NightWatcher_BeamToGround_07.png")
const NightWatcher_SkyBeam_08 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/BeamToGround/NightWatcher_BeamToGround_08.png")

const NightWatcher_AOE_01 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/Aoe/Chaos_Nightwatcher_Aoe_01.png")
const NightWatcher_AOE_02 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/Aoe/Chaos_Nightwatcher_Aoe_02.png")
const NightWatcher_AOE_03 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/Aoe/Chaos_Nightwatcher_Aoe_03.png")
const NightWatcher_AOE_04 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/Aoe/Chaos_Nightwatcher_Aoe_04.png")
const NightWatcher_AOE_05 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/Aoe/Chaos_Nightwatcher_Aoe_05.png")
const NightWatcher_AOE_06 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/Aoe/Chaos_Nightwatcher_Aoe_06.png")
const NightWatcher_AOE_07 = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/Aoe/Chaos_Nightwatcher_Aoe_07.png")

const NightWatcher_BeamFromSelfToLamp = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/NightWatcher_BeamTo_EyeWatch.png")
const NightWatcher_Lamp_Pic = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/NightWatcher_EyeWatch.png")

const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")



const lamp_to_range_module_y_pos_shift : float = -20.0
const beam_offset_from_lamp_y_shift : float = -4.0
const self_to_beam_anchor_y_pos_shift : float = -25.0

var sky_attack_sprite_frames : SpriteFrames

var lamp_sprite_2d : Sprite
var lamp_beam_connection : BeamAesthetic

var stun_effect : EnemyStunEffect

var aoe_attk_module : AOEAttackModule


var stun_duration : float
var explosion_flat_dmg_amount : float
var explosion_pierce : int
var lifetime : float = 2.0 setget set_lifetime # this is set so that it doesnt disappear immediately

var _current_lifetime : float = lifetime


func set_lifetime(arg_val):
	lifetime = arg_val
	_current_lifetime = arg_val


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.NIGHTWATCHER)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = 0
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_range_shape(CircleShape2D.new())
	
	lamp_sprite_2d = Sprite.new()
	lamp_sprite_2d.texture = NightWatcher_Lamp_Pic
	lamp_sprite_2d.offset.y += lamp_to_range_module_y_pos_shift
	
	lamp_sprite_2d.z_index = ZIndexStore.PARTICLE_EFFECTS
	lamp_sprite_2d.z_as_relative = false
	range_module.add_child(lamp_sprite_2d)
	
	#add_child(range_module)
	
	
	#
	
	
	aoe_attk_module = AOEAttackModule_Scene.instance()
	aoe_attk_module.base_damage = explosion_flat_dmg_amount
	aoe_attk_module.base_damage_type = DamageType.ELEMENTAL
	aoe_attk_module.base_attack_speed = 0
	aoe_attk_module.base_attack_wind_up = 0
	aoe_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	aoe_attk_module.is_main_attack = false
	aoe_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	aoe_attk_module.base_explosion_scale = 2.0
	
	aoe_attk_module.benefits_from_bonus_explosion_scale = false
	aoe_attk_module.benefits_from_bonus_base_damage = false
	aoe_attk_module.benefits_from_bonus_attack_speed = false
	aoe_attk_module.benefits_from_bonus_on_hit_damage = false
	aoe_attk_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", NightWatcher_AOE_01)
	sprite_frames.add_frame("default", NightWatcher_AOE_02)
	sprite_frames.add_frame("default", NightWatcher_AOE_03)
	sprite_frames.add_frame("default", NightWatcher_AOE_04)
	sprite_frames.add_frame("default", NightWatcher_AOE_05)
	sprite_frames.add_frame("default", NightWatcher_AOE_06)
	sprite_frames.add_frame("default", NightWatcher_AOE_07)
	
	aoe_attk_module.aoe_sprite_frames = sprite_frames
	aoe_attk_module.sprite_frames_only_play_once = true
	aoe_attk_module.pierce = explosion_pierce
	aoe_attk_module.duration = 0.4
	aoe_attk_module.damage_repeat_count = 1
	
	aoe_attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	aoe_attk_module.base_aoe_scene = BaseAOE_Scene
	aoe_attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	aoe_attk_module.can_be_commanded_by_tower = false
	
	aoe_attk_module.set_image_as_tracker_image(NightWatcher_Lamp_Pic)
	
	add_attack_module(aoe_attk_module)
	
	
	
	# sky attack
	
	sky_attack_sprite_frames = SpriteFrames.new()
	sky_attack_sprite_frames.add_frame("default", NightWatcher_SkyBeam_01)
	sky_attack_sprite_frames.add_frame("default", NightWatcher_SkyBeam_02)
	sky_attack_sprite_frames.add_frame("default", NightWatcher_SkyBeam_03)
	sky_attack_sprite_frames.add_frame("default", NightWatcher_SkyBeam_04)
	sky_attack_sprite_frames.add_frame("default", NightWatcher_SkyBeam_05)
	sky_attack_sprite_frames.add_frame("default", NightWatcher_SkyBeam_06)
	sky_attack_sprite_frames.add_frame("default", NightWatcher_SkyBeam_07)
	sky_attack_sprite_frames.add_frame("default", NightWatcher_SkyBeam_08)
	
	#
	
	connect("global_position_changed", self, "_on_global_pos_changed", [], CONNECT_PERSIST)
	
	range_module.connect("enemy_entered_range", self, "_on_enemy_entered_map", [], CONNECT_PERSIST)
	
	can_absorb_ingredient_conditonal_clauses.attempt_insert_clause(CanAbsorbIngredientClauses.CAN_NOT_ABSORB_INGREDIENT_GENERIC_TAG)
	#contributing_to_synergy_clauses.attempt_insert_clause(ContributingToSynergyClauses.GENERIC_DOES_NOT_CONTRIBUTE)
	tower_limit_slots_taken = 0
	is_a_summoned_tower = true
	
	#
	
	stun_effect = EnemyStunEffect.new(stun_duration, StoreOfEnemyEffectsUUID.CHAOS_NIGHT_WATCHER_STUN_EFFECT)
	
	#
	
	_post_inherit_ready()
	
	#
	
	_create_connection_to_lamp()
	

###



func _update_range_module_position():
	var path_point_nearest_to_self = game_elements.map_manager.get_path_point_closest_to_point(global_position)
	
	range_module.global_position = path_point_nearest_to_self
	
	_update_connection_to_lamp()


##


func _create_connection_to_lamp():
	lamp_beam_connection = _construct_beam()
	lamp_beam_connection.visible = true
	
	_update_connection_to_lamp()

func _construct_beam():
	var beam = BeamAesthetic_Scene.instance()
	beam.time_visible = 0
	beam.is_timebound = false
	beam.set_texture_as_default_anim(NightWatcher_BeamFromSelfToLamp)
	beam.global_position = global_position
	
	beam.z_index = ZIndexStore.PARTICLE_EFFECTS
	beam.z_as_relative = false
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(beam)
	return beam

func _update_connection_to_lamp():
	lamp_beam_connection.update_destination_position(lamp_sprite_2d.global_position + Vector2(0, lamp_to_range_module_y_pos_shift + beam_offset_from_lamp_y_shift))
	lamp_beam_connection.global_position = global_position + Vector2(0.5, self_to_beam_anchor_y_pos_shift)



func _on_global_pos_changed(old_pos, new_pos):
	_update_range_module_position()
	
	_update_connection_to_lamp()

##


func _on_enemy_entered_map(arg_enemy):
	if is_current_placable_in_map():
		if !arg_enemy.last_calculated_invisibility_status:
			_on_enemy_entered_lamp__deal_stun_and_dmg(arg_enemy)
		else:
			arg_enemy.connect("on_invisibility_status_changed", self, "_on_enemy_visibility_changed", [arg_enemy])


func _on_enemy_visibility_changed(arg_val, arg_enemy):
	if arg_val:
		if range_module.is_enemy_in_range(arg_enemy):
			_on_enemy_entered_lamp__deal_stun_and_dmg(arg_enemy)
		
		arg_enemy.disconnect("on_invisibility_status_changed", self, "_on_enemy_visibility_changed")


func _on_enemy_entered_lamp__deal_stun_and_dmg(arg_enemy):
	arg_enemy._add_effect(stun_effect)
	
	_summon_sky_attk_at_pos(arg_enemy.global_position)


func _summon_sky_attk_at_pos(arg_pos):
	_construct_sky_attk(arg_pos)


func _construct_sky_attk(arg_enemy_pos):
	var beam : BeamAesthetic = BeamAesthetic_Scene.instance()
	
	beam.visible = false
	beam.time_visible = 0.25
	beam.is_timebound = true
	
	beam.set_sprite_frames(sky_attack_sprite_frames)
	beam.play_only_once(true)
	beam.queue_free_if_time_over = true
	
	
	beam.connect("time_visible_is_over", self, "_on_sky_attk_time_visible_over", [arg_enemy_pos], CONNECT_ONESHOT)
	
	
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(beam)
	
	beam.set_frame_rate_based_on_lifetime()
	beam.global_position = lamp_sprite_2d.global_position + Vector2(0, lamp_sprite_2d.offset.y)
	beam.update_destination_position(arg_enemy_pos)
	beam.visible = true


func _on_sky_attk_time_visible_over(arg_pos_of_explosion):
	_summon_explosion_at_pos(arg_pos_of_explosion)

func _summon_explosion_at_pos(arg_pos):
	var aoe = aoe_attk_module.construct_aoe(arg_pos, arg_pos)
	
	aoe_attk_module.set_up_aoe__add_child_and_emit_signals(aoe)


#

func _process(delta):
	if is_round_started and is_inside_tree():
		_current_lifetime -= delta
		
		if _current_lifetime < 0:
			queue_free()

func queue_free():
	.queue_free()
	
	if is_instance_valid(lamp_beam_connection) and !lamp_beam_connection.is_queued_for_deletion():
		lamp_beam_connection.queue_free()

