extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const RealmdGlobule_Scene = preload("res://TowerRelated/Color_Violet/Realmd/Subs/RealmdGlobule.tscn")
const MultipleTrailsForNodeComponent = preload("res://MiscRelated/TrailRelated/MultipleTrailsForNodeComponent.gd")
const BeamAestheticPool = preload("res://MiscRelated/PoolRelated/Implementations/BeamAestheticPool.gd")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const TimerForTower = preload("res://TowerRelated/CommonBehaviorRelated/TimerForTower.gd")

const CircleDrawNode = preload("res://MiscRelated/DrawRelated/CircleDrawNode/CircleDrawNode.gd")

const Realmd_AnyBeamPic_01 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0001.png")
const Realmd_AnyBeamPic_02 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0002.png")
const Realmd_AnyBeamPic_03 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0003.png")
const Realmd_AnyBeamPic_04 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0004.png")
const Realmd_AnyBeamPic_05 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0005.png")
const Realmd_AnyBeamPic_06 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0006.png")
const Realmd_AnyBeamPic_07 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0007.png")
const Realmd_AnyBeamPic_08 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0008.png")
const Realmd_AnyBeamPic_09 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0009.png")
const Realmd_AnyBeamPic_10 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0010.png")
const Realmd_AnyBeamPic_11 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0011.png")
const Realmd_AnyBeamPic_12 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0012.png")
const Realmd_AnyBeamPic_13 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0013.png")
const Realmd_AnyBeamPic_14 = preload("res://TowerRelated/Color_Violet/Realmd/Assets/RealmdBeam/Realmd_AnyBeam_0014.png")

const Realmd_AMAssets_DOT = preload("res://TowerRelated/Color_Violet/Realmd/Assets/AMAssets/Realmd_AMAssets_DOT.png")
const Realmd_AMAssets_DomainExplosion = preload("res://TowerRelated/Color_Violet/Realmd/Assets/AMAssets/Realmd_AMAssets_DomainExplosion.png")

##

const beam_modulate__main_attack := Color(30/255.0, 1/255.0, 217/255.0)
const beam_modulate__for_domain_explosion := Color(111/255.0, 1/255.0, 84/255.0)

var realmd_any_beam_sprite_frames : SpriteFrames
var realmd_any_beam_time : float = 0.35


var domain_ability : BaseAbility
const domain_ability_base_cooldown : float = 15.0
var is_domain_ability_ready : bool
const domain_ability_is_during_cast_clause : int = -10


const domain_base_duration : float = 35.0

#

const domain_explosion_base_dmg_amount : float = 5.0
const domain_explosion_on_hit_scale : float = 1.5
const domain_explosion_duration : float = 0.6

var domain_beam_for_explosion_aesth_pool : BeamAestheticPool


var domain_beam_for_explosion_barrage_timer : TimerForTower
const domain_beam_for_explosion_barrage_delay : float = 0.2

#

const domain_area_baseline_radius_amount : float = 50.0
const domain_area_radius_ratio : float = 0.5

const domain_area_expansion_time : float = 1.0

#

const domain_DOT_base_dmg_amount : float = 1.0
const domain_DOT_base_dmg_ratio : float = 0.2
const domain_DOT_dmg_apply_rate_per_sec : float = 1.0

#

var globule_particle_attk_sprite_pool : AttackSpritePoolComponent

const globule_proj_initial_speed : float = 250.0
const globule_proj_speed_per_sec : float = 50.0

#########

var domain_dot_aoe_attack_module : AOEAttackModule
var domain_explosion_attack_module : AOEAttackModule

#


class DomainInfo:
	var center_pos : Vector2
	var radius : float
	var id : int
	
var _all_domain_coll_shape_id_to_info_map : Dictionary

##

var _atomic_coll_shape_infos_left : Array
var _atomic_cd : float
var _atomic_ap : float

#

onready var ground_sprite = $TowerBase/KnockUpLayer/Ground
onready var head_frame_sprite = $TowerBase/KnockUpLayer/Head

onready var circle_draw_node = $CircleDrawNode

##


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.REALMD)
	
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
	range_module.position.y += 17
	
	#
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1 / 0.18
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 17
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	attack_module.show_beam_at_windup = true
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_01)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_02)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_03)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_04)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_05)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_06)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_07)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_08)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_09)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_10)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_11)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_12)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_13)
	beam_sprite_frame.add_frame("default", Realmd_AnyBeamPic_14)
	
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 14 / 0.18)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.18
	
	attack_module.connect("beam_constructed_and_added", self, "_on_main_attack_beam_constructed_and_added_r", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	#
	
	domain_dot_aoe_attack_module = AOEAttackModule_Scene.instance()
	domain_dot_aoe_attack_module.base_damage_scale = domain_DOT_base_dmg_ratio
	domain_dot_aoe_attack_module.base_damage = domain_DOT_base_dmg_amount / domain_dot_aoe_attack_module.base_damage_scale
	domain_dot_aoe_attack_module.base_damage_type = DamageType.ELEMENTAL
	domain_dot_aoe_attack_module.base_attack_speed = 0
	domain_dot_aoe_attack_module.base_attack_wind_up = 0
	domain_dot_aoe_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	domain_dot_aoe_attack_module.is_main_attack = false
	domain_dot_aoe_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	domain_dot_aoe_attack_module.benefits_from_bonus_explosion_scale = false
	domain_dot_aoe_attack_module.benefits_from_bonus_base_damage = true
	domain_dot_aoe_attack_module.benefits_from_bonus_attack_speed = false
	domain_dot_aoe_attack_module.benefits_from_bonus_on_hit_damage = false
	domain_dot_aoe_attack_module.benefits_from_bonus_on_hit_effect = false
	
	domain_dot_aoe_attack_module.sprite_frames_only_play_once = false
	domain_dot_aoe_attack_module.pierce = -1
	domain_dot_aoe_attack_module.duration = domain_base_duration
	domain_dot_aoe_attack_module.damage_repeat_count = domain_base_duration * domain_DOT_dmg_apply_rate_per_sec
	
	domain_dot_aoe_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	domain_dot_aoe_attack_module.base_aoe_scene = BaseAOE_Scene
	domain_dot_aoe_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	domain_dot_aoe_attack_module.kill_all_created_aoe_at_round_end = false
	domain_dot_aoe_attack_module.pause_decrease_duration_of_aoe_at_round_end = true
	domain_dot_aoe_attack_module.unpause_decrease_duration_of_aoe_at_round_start = true
	
	domain_dot_aoe_attack_module.absolute_z_index_of_aoe = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	
	domain_dot_aoe_attack_module.can_be_commanded_by_tower = false
	domain_dot_aoe_attack_module.set_image_as_tracker_image(Realmd_AMAssets_DOT)
	
	
	add_attack_module(domain_dot_aoe_attack_module)
	
	######
	
	domain_explosion_attack_module = AOEAttackModule_Scene.instance()
	domain_explosion_attack_module.base_damage = domain_explosion_base_dmg_amount
	domain_explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	domain_explosion_attack_module.base_attack_speed = 0
	domain_explosion_attack_module.base_attack_wind_up = 0
	domain_explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	domain_explosion_attack_module.is_main_attack = false
	domain_explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	domain_explosion_attack_module.on_hit_damage_scale = domain_explosion_on_hit_scale
	
	domain_explosion_attack_module.benefits_from_bonus_explosion_scale = false
	domain_explosion_attack_module.benefits_from_bonus_base_damage = false
	domain_explosion_attack_module.benefits_from_bonus_attack_speed = false
	domain_explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	domain_explosion_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	domain_explosion_attack_module.pierce = -1
	domain_explosion_attack_module.duration = domain_explosion_duration
	domain_explosion_attack_module.damage_repeat_count = 1
	
	domain_explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	domain_explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	domain_explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	domain_explosion_attack_module.can_be_commanded_by_tower = false
	domain_explosion_attack_module.set_image_as_tracker_image(Realmd_AMAssets_DomainExplosion)
	
	domain_explosion_attack_module.connect("on_damage_instance_constructed", self, "_on_domain_explosion_damage_instance_constructed", [], CONNECT_PERSIST)
	
	add_attack_module(domain_explosion_attack_module)
	
	
	#
	
	_construct_realmd_any_beam_sprite_frames()
	_construct_domain_beam_for_explosion_aesth_pool()
	_construct_domain_beam_for_explosion_barrage_timer()
	
	_initialize_globule_particle_attk_sprite_pool()
	
	_construct_and_register_ability()
	
	circle_draw_node.z_as_relative = false
	circle_draw_node.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	
	connect("on_round_end", self, "_on_round_end_r", [], CONNECT_PERSIST)
	connect("on_round_start", self, "_on_round_start_r", [], CONNECT_PERSIST)
	
	#
	
	_post_inherit_ready()

func _on_main_attack_beam_constructed_and_added_r(beam):
	beam.modulate = beam_modulate__main_attack
	beam.playing = true
	beam.frame = 0

#

func _construct_realmd_any_beam_sprite_frames():
	realmd_any_beam_sprite_frames = SpriteFrames.new()
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_01)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_02)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_03)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_04)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_05)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_06)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_07)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_08)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_09)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_10)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_11)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_12)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_13)
	realmd_any_beam_sprite_frames.add_frame("default", Realmd_AnyBeamPic_14)
	

func _construct_domain_beam_for_explosion_aesth_pool():
	domain_beam_for_explosion_aesth_pool = BeamAestheticPool.new()
	domain_beam_for_explosion_aesth_pool.node_to_parent = CommsForBetweenScenes.current_game_elements__other_node_hoster
	domain_beam_for_explosion_aesth_pool.node_to_listen_for_queue_free = self
	domain_beam_for_explosion_aesth_pool.source_of_create_resource = self
	domain_beam_for_explosion_aesth_pool.func_name_for_create_resource = "_create_domain_any_beam"

func _create_domain_any_beam():
	var beam = BeamAesthetic_Scene.instance()
	beam.modulate.a = 0.75
	beam.set_sprite_frames(realmd_any_beam_sprite_frames)
	
	beam.frame = 0
	beam.time_visible = realmd_any_beam_time
	beam.is_timebound = true
	beam.queue_free_if_time_over = false
	beam.play_only_once(true)
	beam.set_frame_rate_based_on_lifetime()
	
	return beam


func _construct_domain_beam_for_explosion_barrage_timer():
	domain_beam_for_explosion_barrage_timer = TimerForTower.new()
	domain_beam_for_explosion_barrage_timer.one_shot = false
	domain_beam_for_explosion_barrage_timer.connect("timeout", self, "_on_domain_beam_for_explosion_barrage_timer_timeout", [], CONNECT_PERSIST)
	domain_beam_for_explosion_barrage_timer.connect("timer_stopped", self, "_on_domain_beam_for_explosion_barrage_timer_stopped", [], CONNECT_PERSIST)
	domain_beam_for_explosion_barrage_timer.set_tower_and_properties(self)
	add_child(domain_beam_for_explosion_barrage_timer)
	

#

func _construct_and_register_ability():
	domain_ability = BaseAbility.new()
	
	domain_ability.is_timebound = true
	
	domain_ability.set_properties_to_usual_tower_based()
	domain_ability.tower = self
	
	domain_ability.connect("updated_is_ready_for_activation", self, "_can_cast_domain_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(domain_ability, false)

func _can_cast_domain_updated(is_ready):
	is_domain_ability_ready = is_ready
	
	if is_domain_ability_ready:
		_attempt_cast_domain_ability()

func _attempt_cast_domain_ability():
	var targets : Array = get_random_enemy_in_map()
	
	if targets.size() > 0:
		_cast_domain_ability(targets)
		
	else:
		domain_ability.start_time_cooldown(3)

func get_random_enemy_in_map():
	return game_elements.enemy_manager.get_random_targetable_enemies(1, global_position)



#####

func _cast_domain_ability(targets):
	domain_ability.activation_conditional_clauses.attempt_insert_clause(domain_ability_is_during_cast_clause)
	
	_atomic_cd = _get_cd_to_use(domain_ability_base_cooldown)
	_atomic_ap = domain_ability.get_potency_to_use(last_calculated_final_ability_potency)
	
	domain_ability.on_ability_before_cast_start(_atomic_cd)
	var target = targets[0]
	_launch_globule_at_target_position(target.global_position)
	

func _launch_globule_at_target_position(arg_pos):
	var globule = globule_particle_attk_sprite_pool.get_or_create_attack_sprite_from_pool()
	
	globule.connect("reached_dest_pos__from_config", self, "_on_globule_reached_dest_pos__from_config", [globule], CONNECT_ONESHOT)
	globule.global_position = head_frame_sprite.global_position
	globule.set_go_to_dest_pos_based_on_properties(head_frame_sprite.global_position, arg_pos, globule_proj_initial_speed, globule_proj_speed_per_sec)

func _initialize_globule_particle_attk_sprite_pool():
	globule_particle_attk_sprite_pool = AttackSpritePoolComponent.new()
	globule_particle_attk_sprite_pool.node_to_parent_attack_sprites = CommsForBetweenScenes.current_game_elements__other_node_hoster
	globule_particle_attk_sprite_pool.node_to_listen_for_queue_free = self
	globule_particle_attk_sprite_pool.source_for_funcs_for_attk_sprite = self
	globule_particle_attk_sprite_pool.func_name_for_creating_attack_sprite = "_create_globule_particle"
	

func _create_globule_particle():
	var particle = RealmdGlobule_Scene.instance()
	
	particle.modulate.a = 0.6
	
	particle.has_lifetime = false
	
	particle.upper_limit_x_displacement_per_sec = 10000
	particle.upper_limit_y_displacement_per_sec = 10000
	
	return particle

#

func _on_globule_reached_dest_pos__from_config(arg_globule):
	var pos = arg_globule.global_position
	
	arg_globule.turn_invisible_from_simulated_lifetime_end()
	
	_create_domain_at_pos(pos)


func _create_domain_at_pos(arg_pos):
	var aoe = domain_dot_aoe_attack_module.construct_aoe(arg_pos, arg_pos)
	
	var shape = CircleShape2D.new()
	shape.radius = 1
	aoe.aoe_shape_to_set_on_ready = shape
	
	var final_radius = domain_area_baseline_radius_amount + (get_last_calculated_range_of_main_attk_module() * domain_area_radius_ratio)
	aoe.coll_shape_circle_inc_per_sec = final_radius / domain_area_expansion_time
	aoe.coll_shape_circle_max_val = final_radius
	
	var range_col_shape_id = range_module.add_extra_range_coll_shape(shape, arg_pos)
	aoe.connect("coll_shape_properties_changed", self, "_on_domain_coll_shape_properties_changed_r", [range_col_shape_id], CONNECT_PERSIST)
	aoe.connect("tree_exiting", self, "_on_domain_dot_aoe_tree_exiting_r", [range_col_shape_id], CONNECT_ONESHOT)
	aoe.connect("coll_shape_reached_max_val", self, "_on_domain_dot_aoe_reached_max_val", [range_col_shape_id], CONNECT_ONESHOT)
	
	var domain_info = DomainInfo.new()
	domain_info.center_pos = arg_pos
	domain_info.radius = final_radius
	domain_info.id = range_col_shape_id
	_all_domain_coll_shape_id_to_info_map[range_col_shape_id] = domain_info
	
	domain_dot_aoe_attack_module.set_up_aoe__add_child_and_emit_signals(aoe)
	
	#####
	
	var draw_params = circle_draw_node.DrawParams.new()
	draw_params.center_pos = arg_pos
	draw_params.current_radius = shape.radius
	draw_params.max_radius = final_radius
	draw_params.radius_per_sec = aoe.coll_shape_circle_inc_per_sec
	draw_params.fill_color = Color(21/255.0, 1/255.0, 157/255.0, 0.2)
	
	draw_params.outline_color = Color(12/255.0, 1/255.0, 86/255.0, 0.4)
	draw_params.outline_width = 3
	
	draw_params.lifetime_of_draw = domain_base_duration + 0.2
	draw_params.lifetime_to_start_transparency = domain_base_duration - 0.3
	
	draw_params.configure_self_to_pause_and_unpause_based_on_stage_status(game_elements)
	
	circle_draw_node.add_draw_param(draw_params)
	
	
	

func _on_domain_coll_shape_properties_changed_r(arg_coll_shape, arg_shape, range_col_shape_id):
	pass
	# no need to set since shape is shared between AOE and rangeModule

func _on_domain_dot_aoe_tree_exiting_r(arg_range_col_shape_id):
	range_module.remove_and_queue_free_extra_range_coll_shape(arg_range_col_shape_id)
	_all_domain_coll_shape_id_to_info_map.erase(arg_range_col_shape_id)
	

func _on_domain_dot_aoe_reached_max_val(arg_range_col_shape_id):
	_begin_domain_explosion_sequence__beam_barrage()
	


#######

func _begin_domain_explosion_sequence__charge_up():
	pass
	


func _begin_domain_explosion_sequence__beam_barrage():
	_atomic_coll_shape_infos_left = _all_domain_coll_shape_id_to_info_map.values().duplicate()
	
	_fire_beam_toward_coll_shape_info_in_list()
	if _atomic_coll_shape_infos_left.size() > 0:
		domain_beam_for_explosion_barrage_timer.start(domain_beam_for_explosion_barrage_delay)
	else:
		_end_domain_explosion_ability()

func _fire_beam_toward_coll_shape_info_in_list():
	var info = _atomic_coll_shape_infos_left.pop_back()
	
	var beam = domain_beam_for_explosion_aesth_pool.get_or_create_resource_from_pool()
	beam.connect("time_visible_is_over", self, "_on_beam_for_explosion_time_visible_is_over", [info], CONNECT_ONESHOT)
	beam.frame = 0
	beam.time_visible = realmd_any_beam_time
	beam.position = head_frame_sprite.global_position
	beam.update_destination_position(info.center_pos)
	
	beam.modulate = beam_modulate__for_domain_explosion
	beam.play_only_once(true)
	beam.set_frame_rate_based_on_lifetime()
	beam.visible = true
	beam.playing = true

func _on_beam_for_explosion_time_visible_is_over(arg_info):
	var pos = arg_info.center_pos
	var final_radius = arg_info.radius
	
	var aoe = domain_explosion_attack_module.construct_aoe(pos, pos)
	
	var shape = CircleShape2D.new()
	shape.radius = 1
	aoe.aoe_shape_to_set_on_ready = shape

	aoe.coll_shape_circle_inc_per_sec = final_radius / domain_explosion_duration
	aoe.coll_shape_circle_max_val = final_radius
	
	
	domain_explosion_attack_module.set_up_aoe__add_child_and_emit_signals(aoe)
	
	######
	
	var draw_params = circle_draw_node.DrawParams.new()
	draw_params.center_pos = pos
	draw_params.current_radius = shape.radius
	draw_params.radius_per_sec = aoe.coll_shape_circle_inc_per_sec
	draw_params.fill_color = Color(217/255.0, 2/255.0, 164/255.0, 0.4)
	
	draw_params.outline_color = Color(109/255.0, 1/255.0, 83/255.0, 0.6)
	draw_params.outline_width = 3
	
	draw_params.lifetime_of_draw = domain_explosion_duration
	draw_params.lifetime_to_start_transparency = domain_explosion_duration - 0.2
	
	circle_draw_node.add_draw_param(draw_params)


func _on_domain_beam_for_explosion_barrage_timer_timeout():
	_fire_beam_toward_coll_shape_info_in_list()
	if _atomic_coll_shape_infos_left.size() <= 0:
		domain_beam_for_explosion_barrage_timer.stop()

func _on_domain_beam_for_explosion_barrage_timer_stopped():
	_end_domain_explosion_ability()

func _end_domain_explosion_ability():
	if domain_ability.activation_conditional_clauses.has_clause(domain_ability_is_during_cast_clause):
		_atomic_coll_shape_infos_left.clear()
		domain_ability.start_time_cooldown(_atomic_cd)
		domain_ability.on_ability_after_cast_ended(_atomic_cd)
		
		domain_ability.activation_conditional_clauses.remove_clause(domain_ability_is_during_cast_clause)
		

#

func _on_domain_explosion_damage_instance_constructed(damage_instance, module):
	if _atomic_ap != 1:
		damage_instance.scale_only_damage_by(_atomic_ap)
	

##########

func _on_round_end_r():
	pass
	#circle_draw_node.pause_lifetime_of_all_draws = true
	
	

func _on_round_start_r():
	pass
	#circle_draw_node.pause_lifetime_of_all_draws = false
	

