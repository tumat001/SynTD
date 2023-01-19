extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Core_Yellow_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Core_Yellow.png")
const Core_Orange_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Core_Orange.png")
const Core_Blue_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Core_Blue.png")
const Core_Gray_NoHealth_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Core_Gray_NoHealth.png")

const MiddleTube_Yellow_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Tube_Middle_Yellow.png")
const MiddleTube_Orange_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Tube_Middle_Orange.png")
const MiddleTube_Blue_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Tube_Middle_Blue.png")
const MiddleTube_Gray_NoHealth_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Tube_Middle_Gray_NoHealth.png")

const LeftRightTube_Yellow_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Tube_LeftRight_Yellow.png")
const LeftRightTube_Orange_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Tube_LeftRight_Orange.png")
const LeftRightTube_Blue_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Tube_LeftRight_Blue.png")
const LeftRightTube_Gray_NoHealth_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Iota_Tube_LeftRight_Gray_NoHealth.png")

const Iota_MainProj_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Attks/Iota_NormalProj.png")

const Iota_StarCrashPic_01 = preload("res://TowerRelated/Color_Yellow/Iota/Attks/StarHitParticle/StarHitParticle_01.png")
const Iota_StarCrashPic_02 = preload("res://TowerRelated/Color_Yellow/Iota/Attks/StarHitParticle/StarHitParticle_02.png")
const Iota_StarCrashPic_03 = preload("res://TowerRelated/Color_Yellow/Iota/Attks/StarHitParticle/StarHitParticle_03.png")
const Iota_StarCrashPic_04 = preload("res://TowerRelated/Color_Yellow/Iota/Attks/StarHitParticle/StarHitParticle_04.png")
const Iota_StarCrashPic_05 = preload("res://TowerRelated/Color_Yellow/Iota/Attks/StarHitParticle/StarHitParticle_05.png")

const Iota_Star_Yellow_Pic = preload("res://TowerRelated/Color_Yellow/Iota/Attks/Stars/Iota_Stars_Yellow.png")
const Star_BeamPic_01 = preload("res://TowerRelated/Color_Yellow/Iota/Attks/StarBeam/Iota_StarBeam_Yellow.png")

const Iota_StarBullet = preload("res://TowerRelated/Color_Yellow/Iota/Attks/Stars/Iota_Star.gd")
const Iota_StarBullet_Scene = preload("res://TowerRelated/Color_Yellow/Iota/Attks/Stars/Iota_Star.tscn")

const BulletHomingComponent = preload("res://TowerRelated/CommonBehaviorRelated/BulletHomingComponent.gd")
const BulletHomingComponentPool = preload("res://MiscRelated/PoolRelated/Implementations/BulletHomingComponentPool.gd")
const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")


onready var core_sprite = $TowerBase/KnockUpLayer/CoreSprite
onready var middle_tube_sprite = $TowerBase/KnockUpLayer/MiddleTube
onready var left_tube_sprite = $TowerBase/KnockUpLayer/LeftTube
onready var right_tube_sprite = $TowerBase/KnockUpLayer/RightTube

#

signal on_current_target_for_stars_changed()
signal all_stars_crash_to_target()
signal all_stars_beam_to_target(arg_target)

const star_base_lifetime : float = 30.0
const star_beam_flat_dmg_amount : float = 0.5
const star_beam_base_dmg_scale : float = 0.5
const star_beam_attack_speed : float = 4.0 # 4 times per sec (just like attack speed)

const star_crash_flat_dmg_amount : float = 5.0
const star_crash_on_hit_dmg_scale : float = 7.5

const original_main_attacks_for_star_summon : int = 7
const energy_module_main_attacks_for_star_summon : int = 5
var main_attacks_for_star_summon : int = original_main_attacks_for_star_summon
var _current_main_attack_count : int

const star_last_enemy_curr_health_for_trigger_to_crash : float = 100.0


var star_bullet_attack_module : BulletAttackModule
var star_positioning_rng : RandomNumberGenerator

var star_homing_component_pool : BulletHomingComponentPool
const star_home_max_deg_turn_per_sec__for_effect : float = 200.0
const star_home_max_deg_turn_per_sec__for_crashing : float = 350.0


var star_beam_attack_module : InstantDamageAttackModule
const not_at_beam_state_can_be_commanded_clause : int = -10

var current_star_target
var current_star_at_beam_state_count : int

var _requested_enemy_manager_to_get_next_targetable_enemy : bool

var is_energy_module_on : bool = false
#var star_pierce_count_on_energy : int = 5

#

enum IotaState {
	Normal = 0,
	Beam = 1,
	AllCrash = 2,
}
var current_iota_state : int

var iota_state_to_star_state : Dictionary = {
	IotaState.Normal : Iota_StarBullet.StarState.Idle,
	IotaState.AllCrash : Iota_StarBullet.StarState.Crash,
	IotaState.Beam : Iota_StarBullet.StarState.Beam,
}

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.IOTA)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	
	var attk_module_y_shift_pos : float = 40
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attk_module_y_shift_pos
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 504 #420
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= attk_module_y_shift_pos
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 6
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Iota_MainProj_Pic)
	
	add_attack_module(attack_module)
	
	#
	
	_construct_and_add_star_bullet_attk_module()
	_construct_and_add_star_beam_attack_module()
	
	connect("on_main_attack", self, "_on_main_attack_i", [], CONNECT_PERSIST | CONNECT_DEFERRED)
	game_elements.enemy_manager.connect("number_of_enemies_remaining_changed", self, "_on_number_of_enemies_remaining_changed", [], CONNECT_PERSIST)
	_on_number_of_enemies_remaining_changed(game_elements.enemy_manager.get_number_of_enemies_remaining())
	
	connect("on_round_end", self, "_on_round_end_i", [], CONNECT_PERSIST)
	connect("targeting_changed", self, "_on_range_module_current_targeting_changed", [], CONNECT_PERSIST)
	game_elements.enemy_manager.connect("on_enemy_spawned_and_finished_ready_prep", self, "_on_enemy_spawned_and_finished_ready_prep", [], CONNECT_PERSIST)
	
	connect("changed_anim_from_alive_to_dead", self, "_on_changed_anim_from_alive_to_dead", [], CONNECT_PERSIST)
	connect("changed_anim_from_dead_to_alive", self, "_on_changed_anim_from_dead_to_alive", [], CONNECT_PERSIST)
	
	info_bar_layer.position.y -= 31
	
	core_sprite.use_parent_material = false
	
	#
	
	_post_inherit_ready()



func _construct_and_add_star_bullet_attk_module():
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = star_crash_flat_dmg_amount
	attack_module.base_damage_type = DamageType.PHYSICAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = false
	attack_module.base_pierce = 1
	attack_module.base_proj_speed = 480
	#attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.on_hit_damage_scale = star_crash_on_hit_dmg_scale
	attack_module.base_proj_inaccuracy = 95
	
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = true
	attack_module.benefits_from_bonus_on_hit_effect = false
	attack_module.benefits_from_bonus_pierce = true
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 7
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = Iota_StarBullet_Scene
	
	attack_module.can_be_commanded_by_tower = false
	
	attack_module.set_image_as_tracker_image(Iota_Star_Yellow_Pic)
	
	star_bullet_attack_module = attack_module
	
	add_attack_module(attack_module)
	
	#
	star_positioning_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.IOTA_STAR_POSITIONING)
	
	star_homing_component_pool = BulletHomingComponentPool.new()
	star_homing_component_pool.node_to_parent = CommsForBetweenScenes.current_game_elements__other_node_hoster
	star_homing_component_pool.source_of_create_resource = self
	star_homing_component_pool.func_name_for_create_resource = "_create_star_homing_component"

func _construct_and_add_star_beam_attack_module():
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage_scale = star_beam_base_dmg_scale
	attack_module.base_damage = star_beam_flat_dmg_amount / attack_module.base_damage_scale
	attack_module.base_damage_type = DamageType.ELEMENTAL
	attack_module.base_attack_speed = star_beam_attack_speed
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = false
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = 0
	
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = true
	attack_module.benefits_from_bonus_on_hit_damage = true
	attack_module.benefits_from_bonus_on_hit_effect = false
	
	star_beam_attack_module = attack_module
	
	star_beam_attack_module.is_displayed_in_tracker = true
	star_beam_attack_module.set_image_as_tracker_image(Star_BeamPic_01)
	
	star_beam_attack_module.can_be_commanded_by_tower = false
	#star_beam_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(not_at_beam_state_can_be_commanded_clause)
	
	add_attack_module(star_beam_attack_module)
	#
	
	star_beam_attack_module.connect("ready_to_attack", self, "_star_beam_attk_module_ready_to_attack", [null], CONNECT_PERSIST) # the null is needed
	star_beam_attack_module.connect("on_damage_instance_constructed", self, "_on_star_beam_damage_instance_constructed", [], CONNECT_PERSIST)


#

func _create_star_homing_component():
	var star_homing_component = BulletHomingComponent.new()
	
	return star_homing_component


func _on_round_end_i():
	_current_main_attack_count = 0
	
	set_iota_state(IotaState.Normal)
	current_star_at_beam_state_count = 0

#

func _on_main_attack_i(attk_speed_delay, enemies, module):
	_current_main_attack_count += 1
	
	if _current_main_attack_count >= main_attacks_for_star_summon and enemies.size() > 0:
		_shoot_star_towards_enemy(enemies[0])
		_current_main_attack_count = 0


func _shoot_star_towards_enemy(arg_enemy):
	var pos = _randomize_arg_enemy_pos(arg_enemy.global_position)
	var star : Iota_StarBullet = star_bullet_attack_module.construct_bullet(pos)
	
	star.decrease_life_distance = false
	star.decrease_life_duration = false
	
	star.current_star_lifetime = star_base_lifetime
	star.enemies_to_hit_only.append(arg_enemy)
	
	var star_state : int = iota_state_to_star_state[current_iota_state]
	star.current_star_state = star_state
	if star_state == Iota_StarBullet.StarState.Beam:
		star.current_target_for_beam = current_star_target
	
	star.iota_tower = self
	
	#if is_energy_module_on:
	#	star.pierce = star_pierce_count_on_energy
	
	var bullet_homing_component : BulletHomingComponent = star_homing_component_pool.get_or_create_resource_from_pool()
	bullet_homing_component.bullet = star
	bullet_homing_component.target_node_to_home_to = arg_enemy
	bullet_homing_component.max_deg_angle_turn_amount_per_sec = star_home_max_deg_turn_per_sec__for_effect
	
	star.connect("hit_an_enemy", self, "_on_star_hit_enemy", [bullet_homing_component], CONNECT_ONESHOT)
	star.connect("on_request_configure_self_for_crash", self, "_configure_crashing_star")
	
	if !bullet_homing_component.is_connected("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_non_crashing_star_tree_exiting"):
		bullet_homing_component.connect("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_non_crashing_star_tree_exiting", [star, bullet_homing_component])
		bullet_homing_component.connect("on_bullet_tree_exiting", self, "_on_star_tree_exiting", [bullet_homing_component])
	
	star.connect("on_star_state_changed", self, "_on_star_state_changed__for_beam_count_track")
	star.connect("tree_exiting", self, "_on_star_tree_exiting__for_beam_count_track", [star])
	
	connect("on_current_target_for_stars_changed", star, "_curr_star_target_changed")
	
	
	star_bullet_attack_module.set_up_bullet__add_child_and_emit_signals(star)
	
	if star.current_star_state == Iota_StarBullet.StarState.Beam:
		_on_star_state_changed__for_beam_count_track(star, star.current_star_state, -1)



func _randomize_arg_enemy_pos(arg_enemy_pos) -> Vector2:
	var random_mag = star_positioning_rng.randi_range(-50, 50)
	var random_deg_rot = star_positioning_rng.randi_range(0, 360)
	
	var vector = Vector2(random_mag, 0).rotated(deg2rad(random_deg_rot))
	
	return arg_enemy_pos + vector


func _on_star_hit_enemy(arg_star : Iota_StarBullet, arg_enemy, arg_bullet_homing_component : BulletHomingComponent):
	if arg_star.current_star_state != Iota_StarBullet.StarState.Crash:
		_slow_star_down_to_halt(arg_star)
		arg_bullet_homing_component.bullet = null
		star_homing_component_pool.declare_resource_as_available(arg_bullet_homing_component)
		arg_star.enemies_to_hit_only.clear()

func _slow_star_down_to_halt(arg_star):
	arg_star.speed_inc_per_sec = -2000
	


func _on_enemy_targeted_by_homing_non_crashing_star_tree_exiting(arg_star : Iota_StarBullet, arg_bullet_homing_component : BulletHomingComponent):
	if is_instance_valid(arg_star):
		_slow_star_down_to_halt(arg_star)
		arg_star.has_homing_component_attached = false
		arg_star.enemies_to_hit_only.clear()
	
	arg_bullet_homing_component.bullet = null
	star_homing_component_pool.declare_resource_as_available(arg_bullet_homing_component)
	
	if arg_bullet_homing_component.is_connected("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_non_crashing_star_tree_exiting"):
		arg_bullet_homing_component.disconnect("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_non_crashing_star_tree_exiting")
	
	if arg_bullet_homing_component.is_connected("on_bullet_tree_exiting", self, "_on_star_tree_exiting"):
		arg_bullet_homing_component.disconnect("on_bullet_tree_exiting", self, "_on_star_tree_exiting")



func _on_star_tree_exiting(arg_component : BulletHomingComponent):
	arg_component.bullet = null
	star_homing_component_pool.declare_resource_as_available(arg_component)
	
	if arg_component.is_connected("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_non_crashing_star_tree_exiting"):
		arg_component.disconnect("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_non_crashing_star_tree_exiting")
	
	if arg_component.is_connected("on_bullet_tree_exiting", self, "_on_star_tree_exiting"):
		arg_component.disconnect("on_bullet_tree_exiting", self, "_on_star_tree_exiting")
	
	if arg_component.is_connected("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_crashing_star_tree_exiting"):
		arg_component.disconnect("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_crashing_star_tree_exiting")
	


#

func _configure_crashing_star(arg_star : Iota_StarBullet):
	if !arg_star.has_homing_component_attached:
		var target = get_current_star_target()
		
		if is_instance_valid(target) and !target.is_queued_for_deletion():
			arg_star.speed_inc_per_sec = 150
			arg_star.speed_max = 350
			arg_star.speed += 2
			
			var star_homing_component = star_homing_component_pool.get_or_create_resource_from_pool()
			star_homing_component.bullet = arg_star
			star_homing_component.target_node_to_home_to = target
			star_homing_component.max_deg_angle_turn_amount_per_sec = star_home_max_deg_turn_per_sec__for_crashing
			
			if !star_homing_component.is_connected("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_crashing_star_tree_exiting"):
				star_homing_component.connect("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_crashing_star_tree_exiting", [arg_star, star_homing_component])
			
			if !star_homing_component.is_connected("on_bullet_tree_exiting", self, "_on_star_tree_exiting"):
				star_homing_component.connect("on_bullet_tree_exiting", self, "_on_star_tree_exiting", [star_homing_component])
			
			arg_star.has_homing_component_attached = true
			
		else:
			pass
			
			#if !is_connected("on_current_target_for_stars_changed", arg_star, "_curr_star_target_changed"):
			#	connect("on_current_target_for_stars_changed", arg_star, "_curr_star_target_changed", [], CONNECT_ONESHOT)



func _on_enemy_targeted_by_homing_crashing_star_tree_exiting(arg_star, arg_bullet_homing_component):
	if is_instance_valid(arg_star):
		arg_star.has_homing_component_attached = false
		arg_star.enemies_to_hit_only.clear()
	
	arg_bullet_homing_component.bullet = null
	star_homing_component_pool.declare_resource_as_available(arg_bullet_homing_component)
	
	if arg_bullet_homing_component.is_connected("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_crashing_star_tree_exiting"):
		arg_bullet_homing_component.disconnect("on_target_tree_exiting", self, "_on_enemy_targeted_by_homing_crashing_star_tree_exiting")
	
	if arg_bullet_homing_component.is_connected("on_bullet_tree_exiting", self, "_on_star_tree_exiting"):
		arg_bullet_homing_component.disconnect("on_bullet_tree_exiting", self, "_on_star_tree_exiting")



#


func get_current_star_target():
	return current_star_target

func set_current_star_target(arg_target):
	if is_instance_valid(current_star_target):
		if current_star_target.is_connected("cancel_all_lockons", self, "_on_current_star_target_cancel_all_lockons"):
			current_star_target.disconnect("cancel_all_lockons", self, "_on_current_star_target_cancel_all_lockons")
	
	current_star_target = arg_target
	
	if is_instance_valid(current_star_target):
		if !current_star_target.is_connected("cancel_all_lockons", self, "_on_current_star_target_cancel_all_lockons"):
			current_star_target.connect("cancel_all_lockons", self, "_on_current_star_target_cancel_all_lockons")
		
	else:
		game_elements.enemy_manager.request__get_next_targetable_enemy(self, "_on_requested__get_next_targetable_enemy__fulfilled", "_on_requested__get_next_targetable_enemy__cancelled")
		_requested_enemy_manager_to_get_next_targetable_enemy = true
	
	emit_signal("on_current_target_for_stars_changed", current_star_target)

#

func _on_requested__get_next_targetable_enemy__fulfilled(arg_enemy):
	game_elements.enemy_manager.disconnect_request_get_next_targetable_enemy(self, "_on_requested__get_next_targetable_enemy__fulfilled", "_on_requested__get_next_targetable_enemy__cancelled")
	#set_current_star_target(arg_enemy)
	call_deferred("set_current_star_target", arg_enemy)
	_requested_enemy_manager_to_get_next_targetable_enemy = false

func _on_requested__get_next_targetable_enemy__cancelled():
	game_elements.enemy_manager.disconnect_request_get_next_targetable_enemy(self, "_on_requested__get_next_targetable_enemy__fulfilled", "_on_requested__get_next_targetable_enemy__cancelled")
	_requested_enemy_manager_to_get_next_targetable_enemy = false

#

func _update_current_star_target():
	var all_enemies = game_elements.enemy_manager.get_all_enemies()
	var include_invis_enemies = true
	var targeting : int = Targeting.FIRST
	if is_instance_valid(range_module):
		targeting = range_module.get_current_targeting_option()
	
	var enemies = Targeting.enemies_to_target(all_enemies, targeting, 1, global_position, include_invis_enemies)
	
	if enemies.size() > 0:
		set_current_star_target(enemies[0])
	else:
		set_current_star_target(null)



#

func _on_number_of_enemies_remaining_changed(arg_val):
	if arg_val == 1:
		#call_deferred("set_iota_state", IotaState.AllCrash)
		
		if !game_elements.enemy_manager.is_connected("last_enemy_standing_current_health_changed", self, "_on_last_enemy_standing_current_health_changed"):
			game_elements.enemy_manager.connect("last_enemy_standing_current_health_changed", self, "_on_last_enemy_standing_current_health_changed", [], CONNECT_PERSIST)
		

func _on_last_enemy_standing_current_health_changed(arg_health_val, arg_enemy):
	if arg_health_val <= star_last_enemy_curr_health_for_trigger_to_crash:
		call_deferred("set_iota_state", IotaState.AllCrash)
		
		if game_elements.enemy_manager.is_connected("last_enemy_standing_current_health_changed", self, "_on_last_enemy_standing_current_health_changed"):
			game_elements.enemy_manager.disconnect("last_enemy_standing_current_health_changed", self, "_on_last_enemy_standing_current_health_changed")
		


func _on_enemy_spawned_and_finished_ready_prep(arg_enemy):
	if !_requested_enemy_manager_to_get_next_targetable_enemy:
		call_deferred("_update_current_star_target")
	
	_update_anims_based_on_enemies_spawned_ratio_from_ins__and_other_states()

#func _on_current_star_target_tree_exiting():
#	call_deferred("_update_current_star_target")
#	#_update_current_star_target()

func _on_range_module_current_targeting_changed():
	call_deferred("_update_current_star_target")
	#_update_current_star_target()

func _on_current_star_target_cancel_all_lockons():
	call_deferred("_update_current_star_target")

#

func set_iota_state(arg_state, arg_only_update_anim : bool = false):
	current_iota_state = arg_state
	
	if !is_dead_for_the_round:
		if current_iota_state == IotaState.AllCrash:
			if !arg_only_update_anim:
				emit_signal("all_stars_crash_to_target")
			
			core_sprite.texture = Core_Orange_Pic
			middle_tube_sprite.texture = MiddleTube_Orange_Pic
			left_tube_sprite.texture = LeftRightTube_Orange_Pic
			right_tube_sprite.texture = LeftRightTube_Orange_Pic
			#star_beam_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(not_at_beam_state_can_be_commanded_clause)
			
		elif current_iota_state == IotaState.Normal:
			_update_anims_based_on_enemies_spawned_ratio_from_ins__and_other_states()
#			core_sprite.texture = Core_Yellow_Pic
#			middle_tube_sprite.texture = MiddleTube_Yellow_Pic
#			left_tube_sprite.texture = LeftRightTube_Yellow_Pic
#			right_tube_sprite.texture = LeftRightTube_Yellow_Pic
			
			#star_beam_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(not_at_beam_state_can_be_commanded_clause)
			
		elif current_iota_state == IotaState.Beam:
			core_sprite.texture = Core_Blue_Pic
			middle_tube_sprite.texture = MiddleTube_Blue_Pic
			left_tube_sprite.texture = LeftRightTube_Blue_Pic
			right_tube_sprite.texture = LeftRightTube_Blue_Pic
			#star_beam_attack_module.can_be_commanded_by_tower_other_clauses.remove_clause(not_at_beam_state_can_be_commanded_clause)
			
			if !arg_only_update_anim:
				_star_beam_attk_module_ready_to_attack(current_star_target)
				
				_update_current_star_target()
				emit_signal("all_stars_beam_to_target", current_star_target)
		
		
	else:
		middle_tube_sprite.texture = MiddleTube_Gray_NoHealth_Pic
		left_tube_sprite.texture = LeftRightTube_Gray_NoHealth_Pic
		right_tube_sprite.texture = LeftRightTube_Gray_NoHealth_Pic
		core_sprite.texture = Core_Gray_NoHealth_Pic


################


func _update_anims_based_on_enemies_spawned_ratio_from_ins__and_other_states():
	if !is_dead_for_the_round:
		var ratio = game_elements.enemy_manager.get_percent_of_enemies_spawned_to_total_from_ins()
		
		if current_iota_state == IotaState.Normal:
			if ratio > 0.75:
				middle_tube_sprite.texture = MiddleTube_Blue_Pic
				left_tube_sprite.texture = LeftRightTube_Blue_Pic
				right_tube_sprite.texture = LeftRightTube_Blue_Pic
			elif ratio > 0.5:
				middle_tube_sprite.texture = MiddleTube_Yellow_Pic
				left_tube_sprite.texture = LeftRightTube_Blue_Pic
				right_tube_sprite.texture = LeftRightTube_Blue_Pic
			elif ratio > 0.25:
				middle_tube_sprite.texture = MiddleTube_Yellow_Pic
				left_tube_sprite.texture = LeftRightTube_Blue_Pic
				right_tube_sprite.texture = LeftRightTube_Yellow_Pic
			else:
				core_sprite.texture = Core_Yellow_Pic
				middle_tube_sprite.texture = MiddleTube_Yellow_Pic
				left_tube_sprite.texture = LeftRightTube_Yellow_Pic
				right_tube_sprite.texture = LeftRightTube_Yellow_Pic
		
		if is_equal_approx(ratio, 1.0):
			if current_iota_state != IotaState.AllCrash:
				set_iota_state(IotaState.Beam)
		
	else:
		middle_tube_sprite.texture = MiddleTube_Gray_NoHealth_Pic
		left_tube_sprite.texture = LeftRightTube_Gray_NoHealth_Pic
		right_tube_sprite.texture = LeftRightTube_Gray_NoHealth_Pic
		core_sprite.texture = Core_Gray_NoHealth_Pic


#

func _on_star_state_changed__for_beam_count_track(arg_star : Iota_StarBullet, arg_state : int, arg_old_state : int):
	if arg_state == Iota_StarBullet.StarState.Beam and arg_old_state != Iota_StarBullet.StarState.Beam:
		current_star_at_beam_state_count += 1


func _on_star_tree_exiting__for_beam_count_track(arg_star):
	if arg_star.current_star_state == Iota_StarBullet.StarState.Beam:
		current_star_at_beam_state_count -= 1
		if current_star_at_beam_state_count < 0:
			current_star_at_beam_state_count = 0



func _star_beam_attk_module_ready_to_attack(arg_target):
	if is_instance_valid(current_star_target) and current_iota_state == IotaState.Beam:
		if current_star_at_beam_state_count > 0:
			star_beam_attack_module.on_command_attack_enemies_and_attack_when_ready([current_star_target], 1)
		
	else:
		if !is_connected("on_current_target_for_stars_changed", self, "_star_beam_attk_module_ready_to_attack"):
			connect("on_current_target_for_stars_changed", self, "_star_beam_attk_module_ready_to_attack", [], CONNECT_ONESHOT)

func _on_star_beam_damage_instance_constructed(arg_dmg_instance, arg_module):
	if current_star_at_beam_state_count > 0:
		arg_dmg_instance.scale_only_damage_by(current_star_at_beam_state_count)



#

func _on_changed_anim_from_alive_to_dead():
	set_iota_state(current_iota_state, true)

func _on_changed_anim_from_dead_to_alive():
	set_iota_state(current_iota_state)
	#set_iota_state(current_iota_state)
	#_update_anims_based_on_enemies_spawned_ratio_from_ins__and_other_states()

#


#


func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			#"Crashing stars can now hit its target up to %s times." % str(star_pierce_count_on_energy)
			"%s main attacks are needed to summon a star instead of %s" % [str(original_main_attacks_for_star_summon), str(energy_module_main_attacks_for_star_summon)]
		]


func _module_turned_on(_first_time_per_round : bool):
	is_energy_module_on = true
	
	main_attacks_for_star_summon = energy_module_main_attacks_for_star_summon


func _module_turned_off():
	is_energy_module_on = false
	
	main_attacks_for_star_summon = original_main_attacks_for_star_summon
