extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const Paroxysm_NormalProjPic = preload("res://TowerRelated/Color_Orange/Paroxysm/Attks/Paroxysm_NormalProj.png")
const Outburst_BigRocketPic = preload("res://TowerRelated/Color_Orange/Paroxysm/Attks/Outburst_BigRocket.png")
const Outburst_SpewOrangePic = preload("res://TowerRelated/Color_Orange/Paroxysm/Attks/Outburst_SpewProj_Orange.png")
const Outburst_SpewYellowPic = preload("res://TowerRelated/Color_Orange/Paroxysm/Attks/Outburst_SpewProj_Yellow.png")
const Outburst_AOEPic_01 = preload("res://TowerRelated/Color_Orange/Paroxysm/Attks/BigRocket_Explosion/Outburst_BigRocket_AOE_01.png")
const Outburst_AOEPic_02 = preload("res://TowerRelated/Color_Orange/Paroxysm/Attks/BigRocket_Explosion/Outburst_BigRocket_AOE_02.png")
const Outburst_AOEPic_03 = preload("res://TowerRelated/Color_Orange/Paroxysm/Attks/BigRocket_Explosion/Outburst_BigRocket_AOE_03.png")
const Outburst_AOEPic_04 = preload("res://TowerRelated/Color_Orange/Paroxysm/Attks/BigRocket_Explosion/Outburst_BigRocket_AOE_04.png")
const Outburst_AOEPic_05 = preload("res://TowerRelated/Color_Orange/Paroxysm/Attks/BigRocket_Explosion/Outburst_BigRocket_AOE_05.png")
const Outburst_AOEPic_06 = preload("res://TowerRelated/Color_Orange/Paroxysm/Attks/BigRocket_Explosion/Outburst_BigRocket_AOE_06.png")
const Paroxysm_BigRocket_AOE_AMI = preload("res://TowerRelated/Color_Orange/Paroxysm/AMAssets/Paroxysm_BigRocket_AOE_AttackModuleIcon.png")
const Paroxysm_BigRocket_AMI = preload("res://TowerRelated/Color_Orange/Paroxysm/AMAssets/Paroxysm_BigRocket_AttackModuleIcon.png")


const BulletHomingComponent = preload("res://TowerRelated/CommonBehaviorRelated/BulletHomingComponent.gd")
const BulletHomingComponentPool = preload("res://MiscRelated/PoolRelated/Implementations/BulletHomingComponentPool.gd")

const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")

#

var outburst_ability : BaseAbility
const outburst_base_cooldown : float = 18.0
var outburst_ability_is_ready : bool = false
var is_an_enemy_in_range : bool = false


#
const enemy_min_flat_health_needed_for_big_missle_cast : float = 50.0
const enemy_min_distance_needed_for_big_missle_cast : float = 60.0

var big_missle_bullet_attk_module : BulletAttackModule
const big_missle__direct_hit__flat_dmg : float = 70.0
const big_missle__direct_hit__base_damage_ratio : float = 15.0

var big_missle_small_explosion_attk_module : AOEAttackModule
const big_missle__small_aoe__flat_dmg : float = 15.0
const big_missle__small_aoe__pierce : int = 3

var bullet_homing_component_pool : BulletHomingComponentPool
#

var spew_attack_module : BulletAttackModule
const spew_disabled_from_attacking_custom_clause : int = -10

const spew_base_count : int = 16
const spew_on_hit_dmg_scale : float = 0.75
const spew_flat_dmg_amount : float = 3.0

var _current_spew_count : int
var non_essential_rng : RandomNumberGenerator

#

func _ready():
	var info = Towers.get_tower_info(Towers.PAROXYSM)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	
	var attack_module_y_shift : float = 16.0
	
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
	attack_module.base_proj_speed = 550#350
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= attack_module_y_shift
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents.x = 13
	bullet_shape.extents.y = 5
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Paroxysm_NormalProjPic)
	
	add_attack_module(attack_module)
	
	#
	
	_construct_and_add_big_missle_attk_module(attack_module_y_shift)
	_construct_and_add_spew_attack_module()
	
	_construct_and_register_ability()
	
	connect("on_range_module_enemy_entered", self, "_on_enemy_entered_range_p", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited", self, "_on_enemy_exited_range_p", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_p", [], CONNECT_PERSIST)
	
	#
	
	_post_inherit_ready()



func _construct_and_add_big_missle_attk_module(attack_module_y_shift):
	big_missle_bullet_attk_module = BulletAttackModule_Scene.instance()
	big_missle_bullet_attk_module.base_damage_scale = big_missle__direct_hit__base_damage_ratio
	big_missle_bullet_attk_module.base_damage = big_missle__direct_hit__flat_dmg / big_missle_bullet_attk_module.base_damage_scale 
	big_missle_bullet_attk_module.base_damage_type = DamageType.PHYSICAL
	big_missle_bullet_attk_module.base_attack_speed = 0
	big_missle_bullet_attk_module.base_attack_wind_up = 0
	big_missle_bullet_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	big_missle_bullet_attk_module.is_main_attack = false
	big_missle_bullet_attk_module.base_pierce = 1
	big_missle_bullet_attk_module.base_proj_speed = 120
	#big_missle_bullet_attk_module.base_proj_life_distance = info.base_range
	big_missle_bullet_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	big_missle_bullet_attk_module.on_hit_damage_scale = 1
	big_missle_bullet_attk_module.position.y -= attack_module_y_shift
	
	big_missle_bullet_attk_module.benefits_from_bonus_attack_speed = false
	big_missle_bullet_attk_module.benefits_from_bonus_base_damage = true
	big_missle_bullet_attk_module.benefits_from_bonus_on_hit_damage = false
	big_missle_bullet_attk_module.benefits_from_bonus_on_hit_effect = false
	big_missle_bullet_attk_module.benefits_from_bonus_pierce = false
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(16, 8)
	
	big_missle_bullet_attk_module.bullet_shape = bullet_shape
	big_missle_bullet_attk_module.bullet_scene = BaseBullet_Scene
	big_missle_bullet_attk_module.set_texture_as_sprite_frame(Outburst_BigRocketPic)
	
	big_missle_bullet_attk_module.can_be_commanded_by_tower = false
	
	big_missle_bullet_attk_module.set_image_as_tracker_image(Paroxysm_BigRocket_AMI)
	
	add_attack_module(big_missle_bullet_attk_module)
	
	#
	
	bullet_homing_component_pool = BulletHomingComponentPool.new()
	bullet_homing_component_pool.node_to_parent = CommsForBetweenScenes.current_game_elements__other_node_hoster
	bullet_homing_component_pool.source_of_create_resource = self
	bullet_homing_component_pool.func_name_for_create_resource = "_create_bullet_homing_component"
	
	
	#
	
	big_missle_small_explosion_attk_module = AOEAttackModule_Scene.instance()
	big_missle_small_explosion_attk_module.base_damage = big_missle__small_aoe__flat_dmg
	big_missle_small_explosion_attk_module.base_damage_type = DamageType.PHYSICAL
	big_missle_small_explosion_attk_module.base_attack_speed = 0
	big_missle_small_explosion_attk_module.base_attack_wind_up = 0
	big_missle_small_explosion_attk_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	big_missle_small_explosion_attk_module.is_main_attack = false
	big_missle_small_explosion_attk_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	big_missle_small_explosion_attk_module.base_explosion_scale = 2.25
	
	big_missle_small_explosion_attk_module.benefits_from_bonus_explosion_scale = true
	big_missle_small_explosion_attk_module.benefits_from_bonus_base_damage = false
	big_missle_small_explosion_attk_module.benefits_from_bonus_attack_speed = false
	big_missle_small_explosion_attk_module.benefits_from_bonus_on_hit_damage = false
	big_missle_small_explosion_attk_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Outburst_AOEPic_01)
	sprite_frames.add_frame("default", Outburst_AOEPic_02)
	sprite_frames.add_frame("default", Outburst_AOEPic_03)
	sprite_frames.add_frame("default", Outburst_AOEPic_04)
	sprite_frames.add_frame("default", Outburst_AOEPic_05)
	sprite_frames.add_frame("default", Outburst_AOEPic_06)
	
	big_missle_small_explosion_attk_module.aoe_sprite_frames = sprite_frames
	big_missle_small_explosion_attk_module.sprite_frames_only_play_once = true
	big_missle_small_explosion_attk_module.pierce = big_missle__small_aoe__pierce
	big_missle_small_explosion_attk_module.duration = 0.3
	big_missle_small_explosion_attk_module.damage_repeat_count = 1
	
	big_missle_small_explosion_attk_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	big_missle_small_explosion_attk_module.base_aoe_scene = BaseAOE_Scene
	big_missle_small_explosion_attk_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	big_missle_small_explosion_attk_module.can_be_commanded_by_tower = false
	
	big_missle_small_explosion_attk_module.set_image_as_tracker_image(Paroxysm_BigRocket_AOE_AMI)
	
	add_attack_module(big_missle_small_explosion_attk_module)
	

func _construct_and_add_spew_attack_module():
	spew_attack_module = BulletAttackModule_Scene.instance()
	spew_attack_module.base_damage_scale = 1
	spew_attack_module.base_damage = spew_flat_dmg_amount / spew_attack_module.base_damage_scale 
	spew_attack_module.base_damage_type = DamageType.ELEMENTAL
	spew_attack_module.base_attack_speed = 10
	spew_attack_module.base_attack_wind_up = 0
	spew_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	spew_attack_module.is_main_attack = false
	spew_attack_module.base_pierce = 1
	spew_attack_module.base_proj_speed = 250
	#spew_attack_module.base_proj_life_distance = info.base_range
	spew_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	spew_attack_module.on_hit_damage_scale = spew_on_hit_dmg_scale
	spew_attack_module.position.y -= 10
	
	spew_attack_module.base_proj_inaccuracy = 25
	
	spew_attack_module.benefits_from_bonus_attack_speed = false
	spew_attack_module.benefits_from_bonus_base_damage = false
	spew_attack_module.benefits_from_bonus_on_hit_damage = true
	spew_attack_module.benefits_from_bonus_on_hit_effect = false
	spew_attack_module.benefits_from_bonus_pierce = false
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(5, 5)
	
	spew_attack_module.bullet_shape = bullet_shape
	spew_attack_module.bullet_scene = BaseBullet_Scene
	
	spew_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(spew_disabled_from_attacking_custom_clause)
	
	spew_attack_module.set_image_as_tracker_image(Outburst_SpewOrangePic)
	
	
	spew_attack_module.connect("before_bullet_is_shot", self, "_on_spew_attk_module_before_bullet_is_shot", [], CONNECT_PERSIST)
	
	add_attack_module(spew_attack_module)
	
	non_essential_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.NON_ESSENTIAL)
	
	configure_self_to_change_direction_on_attack_module_when_commanded(spew_attack_module)


#

func _create_bullet_homing_component():
	var bullet_homing_component = BulletHomingComponent.new()
	bullet_homing_component.max_deg_angle_turn_amount_per_sec = 60
	
	return bullet_homing_component


#

func _construct_and_register_ability():
	outburst_ability = BaseAbility.new()
	
	outburst_ability.is_timebound = true
	
	outburst_ability.set_properties_to_usual_tower_based()
	outburst_ability.tower = self
	
	outburst_ability.connect("updated_is_ready_for_activation", self, "_can_cast_outburst_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(outburst_ability, false)


func _can_cast_outburst_updated(is_ready):
	outburst_ability_is_ready = is_ready
	_attempt_cast_outburst()


func _on_enemy_entered_range_p(enemy, arg_module, arg_range_module):
	if is_instance_valid(main_attack_module) and arg_range_module == main_attack_module.range_module:
		is_an_enemy_in_range = true
		_attempt_cast_outburst()

func _on_enemy_exited_range_p(enemy, arg_module, arg_range_module):
	if is_instance_valid(main_attack_module) and arg_range_module == main_attack_module.range_module:
		is_an_enemy_in_range = arg_range_module.is_an_enemy_in_range()


func _attempt_cast_outburst():
	if outburst_ability_is_ready and is_an_enemy_in_range:
		_cast_outburst()

func _cast_outburst():
	var cd = _get_cd_to_use(outburst_base_cooldown)
	outburst_ability.on_ability_before_cast_start(cd)
	outburst_ability.start_time_cooldown(cd)
	
	var curr_target = range_module.get_targets_without_affecting_self_current_targets(1)
	if curr_target.size() > 0:
		curr_target = curr_target[0]
		_call_right_ability_type_based_on_curr_target(curr_target, outburst_ability.get_potency_to_use(last_calculated_final_ability_potency))
	
	outburst_ability.on_ability_after_cast_ended(cd)


func _call_right_ability_type_based_on_curr_target(arg_curr_target, arg_potency_to_use : float):
	if _passes_big_missle_conditions(arg_curr_target):
		_fire_big_rocket_at_target(arg_curr_target, arg_potency_to_use)
	else:
		_start_spew()

func _passes_big_missle_conditions(arg_curr_target):
	return arg_curr_target.current_health >= enemy_min_flat_health_needed_for_big_missle_cast and global_position.distance_to(arg_curr_target.global_position) >= enemy_min_distance_needed_for_big_missle_cast


func _fire_big_rocket_at_target(arg_enemy, arg_potency_to_use : float):
	var rocket = big_missle_bullet_attk_module.construct_bullet(arg_enemy.global_position)
	rocket.enemies_to_hit_only.append(arg_enemy)
	rocket.damage_instance.scale_only_damage_by(arg_potency_to_use)
	rocket.decrease_life_distance = false
	rocket.speed_inc_per_sec = 80
	
	var bullet_homing_component : BulletHomingComponent = bullet_homing_component_pool.get_or_create_resource_from_pool()
	bullet_homing_component.bullet = rocket
	bullet_homing_component.target_node_to_home_to = arg_enemy
	
	rocket.connect("hit_an_enemy", self, "_on_rocket_hit_enemy", [], CONNECT_ONESHOT)
	
	if !bullet_homing_component.is_connected("on_bullet_tree_exiting", self, "_on_rocket_tree_exiting"):
		bullet_homing_component.connect("on_bullet_tree_exiting", self, "_on_rocket_tree_exiting", [bullet_homing_component])
		bullet_homing_component.connect("on_target_tree_exiting", self, "_on_bullet_homing_compo_target_lost", [rocket, bullet_homing_component])
	
	big_missle_bullet_attk_module.set_up_bullet__add_child_and_emit_signals(rocket)
	
	_change_animation_to_face_position(arg_enemy.global_position)


func _on_rocket_tree_exiting(arg_bullet_homing_compo):
	if arg_bullet_homing_compo.is_connected("on_bullet_tree_exiting", self, "_on_rocket_tree_exiting"):
		arg_bullet_homing_compo.disconnect("on_bullet_tree_exiting", self, "_on_rocket_tree_exiting")
		arg_bullet_homing_compo.disconnect("on_target_tree_exiting", self, "_on_bullet_homing_compo_target_lost")
	
	bullet_homing_component_pool.declare_resource_as_available(arg_bullet_homing_compo)


func _on_bullet_homing_compo_target_lost(arg_bullet, arg_bullet_homing_compo : BulletHomingComponent):
	if is_instance_valid(range_module):
		var targets = range_module.get_targets_without_affecting_self_current_targets(1, Targeting.HEALTHIEST)
		if targets.size() > 0:
			arg_bullet_homing_compo.target_node_to_home_to = targets[0]
			arg_bullet.enemies_to_hit_only.clear()
			arg_bullet.enemies_to_hit_only.append(targets[0])
			return
		
		var map_targets = game_elements.enemy_manager.get_all_targetable_enemies()
		map_targets = Targeting.enemies_to_target(map_targets, Targeting.HEALTHIEST, 1, global_position)
		if map_targets.size() > 0:
			arg_bullet_homing_compo.target_node_to_home_to = map_targets[0]
			arg_bullet.enemies_to_hit_only.clear()
			arg_bullet.enemies_to_hit_only.append(map_targets[0])
			return
	
	arg_bullet.trigger_on_death_events()


func _on_rocket_hit_enemy(arg_bullet, arg_enemy):
	var pos = arg_enemy.global_position
	var aoe = big_missle_small_explosion_attk_module.construct_aoe(pos, pos)
	
	big_missle_small_explosion_attk_module.set_up_aoe__add_child_and_emit_signals(aoe)

######

func _start_spew():
	var spew_count = ceil(spew_base_count * outburst_ability.get_potency_to_use(last_calculated_final_ability_potency))
	
	_set_current_spew_count(spew_count)



func _decrement_spew_count():
	_set_current_spew_count(_current_spew_count - 1)

func _set_current_spew_count(arg_count):
	_current_spew_count = arg_count
	
	if _current_spew_count <= 0:
		_current_spew_count = 0
		spew_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(spew_disabled_from_attacking_custom_clause)
	else:
		spew_attack_module.can_be_commanded_by_tower_other_clauses.remove_clause(spew_disabled_from_attacking_custom_clause)


func _on_spew_attk_module_before_bullet_is_shot(arg_bullet):
	_decrement_spew_count()
	
	arg_bullet.speed_inc_per_sec = -240
	arg_bullet.decrease_life_duration = true
	arg_bullet.current_life_duration = 4.0
	arg_bullet.decrease_pierce = false
	arg_bullet.modulate.a = 0.75
	
	arg_bullet.connect("tree_entered", self, "_on_bullet_tree_entered", [arg_bullet], CONNECT_ONESHOT)
	arg_bullet.visible = false


func _on_bullet_tree_entered(arg_bullet):
	#arg_bullet.bullet_sprite.frames.set_frame("default", 0, _get_texture_to_use__random())
	arg_bullet.set_texture_as_sprite_frames(_get_texture_to_use__random())
	arg_bullet.visible = true


func _get_texture_to_use__random():
	var rng_i = non_essential_rng.randi_range(0, 1)
	if rng_i == 0:
		return Outburst_SpewOrangePic
	else:
		return Outburst_SpewYellowPic


func _on_round_end_p():
	_set_current_spew_count(0)



# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 2
	.set_heat_module(module)

func _construct_heat_effect():
	var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	attr_mod.flat_modifier = 0.5
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)


func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	_calculate_final_ability_potency()
