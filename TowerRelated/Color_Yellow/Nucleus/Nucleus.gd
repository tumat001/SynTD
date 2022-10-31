extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOE = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.gd")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

#const TD_AOEAttackModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TD_AOEAttackModule.gd")
#const TD_AOEAttackModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TD_AOEAttackModule.tscn")

const Nucleus_AlphaProj = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/Projs/Nucleus_AlphaProj.png")
const Nucleus_BetaProj = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/Projs/Nucleus_BetaProj.png")

const Nucleus_Gamma_Pic01 = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/BigBeam/Nucleus_BigBeam_01.png")
const Nucleus_Gamma_Pic02 = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/BigBeam/Nucleus_BigBeam_02.png")
const Nucleus_Gamma_Pic03 = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/BigBeam/Nucleus_BigBeam_03.png")
const Nucleus_Gamma_Pic04 = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/BigBeam/Nucleus_BigBeam_04.png")
const Nucleus_Gamma_Pic05 = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/BigBeam/Nucleus_BigBeam_05.png")
const Nucleus_Gamma_Pic06 = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/BigBeam/Nucleus_BigBeam_06.png")
const Nucleus_Gamma_Pic07 = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/BigBeam/Nucleus_BigBeam_07.png")
const Nucleus_Gamma_Pic08 = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/BigBeam/Nucleus_BigBeam_08.png")

const NucleusGamma_AbilityIcon = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/Ability/NucleusGamma_AbilityIcon.png")
const NucleusGamma_AttackModule_Icon = preload("res://TowerRelated/Color_Yellow/Nucleus/Assets/AMAssets/NucleusGamma_AttackModule_Icon.png")


enum Phase {
	ALPHA,
	BETA,
}

const percent_armor_ignore : float = 40.0

const beta_bonus_pierce : int = 3
const alpha_empowered_base_damage_ratio : float = 2.0
const alpha_bonus_dmg_type : int = DamageType.PHYSICAL

const attacks_before_cycle : int = 5
var current_attack_index_in_cycle : int = 0
var current_phase : int

var nucleus_original_attk_module : BulletAttackModule


var gamma_ability : BaseAbility
var gamma_ability_flat_damage_amount : float = 1
var gamma_ability_percent_base_dmg_amount : float = 0.75
var gamma_ability_duration : float = 8.0
var gamma_ability_damage_repeat_count : int = 16
var gamma_ability_base_cooldown : float = 65.0

var gamma_ability_activation_clauses : ConditionalClauses
const _no_enemies_in_range_clause : int = -10

var _attk_module_disabled_by_gamma : AbstractAttackModule


#

var gamma_attack_module : AOEAttackModule
var _current_gamma_beam : BaseAOE
var _current_direction_of_beam : Vector2
var _current_angle_of_beam : float
const _beam_rotation_per_sec : float = 0.5 * PI

var _is_in_gamma_mode : bool = false
var _gamma_duration_timer : Timer

const _base_gamma_length : float = 350.0

var _tower_info : TowerTypeInformation

#

var _is_energy_module_on : bool = false
const _base_gamma_length_energy_module_on : float = _base_gamma_length * 2


func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.NUCLEUS)
	_tower_info = info
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	var attack_module_y_shift : float = 12
	
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
	attack_module.base_proj_speed = 480 #400
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= attack_module_y_shift
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 4
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	nucleus_original_attk_module = attack_module
	
	add_attack_module(attack_module)
	
	
	# Gamma
	
	gamma_attack_module = AOEAttackModule_Scene.instance()
	gamma_attack_module.base_damage_scale = gamma_ability_percent_base_dmg_amount
	gamma_attack_module.base_damage = gamma_ability_flat_damage_amount / gamma_attack_module.base_damage_scale 
	gamma_attack_module.base_damage_type = DamageType.ELEMENTAL
	gamma_attack_module.base_attack_speed = 0
	gamma_attack_module.base_attack_wind_up = 0
	gamma_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	gamma_attack_module.is_main_attack = false
	gamma_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	gamma_attack_module.position.y -= attack_module_y_shift
	gamma_attack_module.position.x += 0.5
	
	gamma_attack_module.benefits_from_bonus_explosion_scale = true
	gamma_attack_module.benefits_from_bonus_base_damage = true
	gamma_attack_module.benefits_from_bonus_attack_speed = false
	gamma_attack_module.benefits_from_bonus_on_hit_damage = false
	gamma_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var gamma_sprite_frames = SpriteFrames.new()
	gamma_sprite_frames.add_frame("default", Nucleus_Gamma_Pic01)
	gamma_sprite_frames.add_frame("default", Nucleus_Gamma_Pic02)
	gamma_sprite_frames.add_frame("default", Nucleus_Gamma_Pic03)
	gamma_sprite_frames.add_frame("default", Nucleus_Gamma_Pic04)
	gamma_sprite_frames.add_frame("default", Nucleus_Gamma_Pic05)
	gamma_sprite_frames.add_frame("default", Nucleus_Gamma_Pic06)
	gamma_sprite_frames.add_frame("default", Nucleus_Gamma_Pic07)
	gamma_sprite_frames.add_frame("default", Nucleus_Gamma_Pic08)
	gamma_sprite_frames.set_animation_speed("default", 8 / 0.4)
	
	
	gamma_attack_module.aoe_sprite_frames = gamma_sprite_frames
	gamma_attack_module.sprite_frames_only_play_once = false
	gamma_attack_module.pierce = -1
	gamma_attack_module.duration = gamma_ability_duration
	gamma_attack_module.damage_repeat_count = gamma_ability_damage_repeat_count
	
	gamma_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.RECTANGLE
	gamma_attack_module.base_aoe_scene = BaseAOE_Scene
	gamma_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.STRECHED_AS_BEAM
	
	gamma_attack_module.absolute_z_index_of_aoe = ZIndexStore.PARTICLE_EFFECTS
	
	gamma_attack_module.can_be_commanded_by_tower = false
	
	gamma_attack_module.set_image_as_tracker_image(NucleusGamma_AttackModule_Icon)
	
	add_attack_module(gamma_attack_module)
	
	
	#
	
	connect("on_main_bullet_attack_module_before_bullet_is_shot", self, "_before_bullet_is_shot_n", [], CONNECT_PERSIST)
	connect("on_main_attack_finished", self, "_on_main_attack_finished_n", [], CONNECT_PERSIST)
	connect("on_main_attack_module_damage_instance_constructed", self, "_on_main_dmg_instance_constructed_n", [], CONNECT_PERSIST)
	
	connect("on_range_module_enemy_entered", self, "_on_range_module_enemy_entered_n", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited", self, "_on_range_module_enemy_exited_n", [], CONNECT_PERSIST)
	
	connect("on_round_end", self, "_on_round_end_n", [], CONNECT_PERSIST)
	connect("on_tower_no_health", self, "_on_tower_health_reached_zero", [], CONNECT_PERSIST)
	
	connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy_n", [], CONNECT_PERSIST)
	
	_construct_and_connect_ability()
	
	_gamma_duration_timer = Timer.new()
	_gamma_duration_timer.one_shot = true
	add_child(_gamma_duration_timer)
	
	_post_inherit_ready()
	


# alpha beta phase assignment

func _update_current_phase():
	if current_attack_index_in_cycle < attacks_before_cycle:
		current_phase = Phase.ALPHA
	elif current_attack_index_in_cycle < attacks_before_cycle * 2:
		current_phase = Phase.BETA

func _increase_step_in_cycle(arg_increment : int):
	current_attack_index_in_cycle += arg_increment
	
	if current_attack_index_in_cycle >= Phase.values().size() * attacks_before_cycle:
		current_attack_index_in_cycle = 0
	
	_update_current_phase()


func _before_bullet_is_shot_n(bullet : BaseBullet, module):
	if current_phase == Phase.ALPHA:
		if module == nucleus_original_attk_module:
			bullet.set_texture_as_sprite_frames(Nucleus_AlphaProj)
	elif current_phase == Phase.BETA:
		if module == nucleus_original_attk_module:
			bullet.set_texture_as_sprite_frames(Nucleus_BetaProj)
		
		bullet.pierce += beta_bonus_pierce


func _on_main_dmg_instance_constructed_n(damage_instance, module):
	if current_phase == Phase.ALPHA:
		damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE].damage_as_modifier.flat_modifier *= alpha_empowered_base_damage_ratio
	elif current_phase == Phase.BETA:
		pass


func _on_main_attack_finished_n(module):
	_increase_step_in_cycle(1)

#

func _construct_and_connect_ability():
	gamma_ability = BaseAbility.new()
	
	gamma_ability.is_timebound = true
	gamma_ability.connect("ability_activated", self, "_gamma_ability_activated", [], CONNECT_PERSIST)
	gamma_ability.icon = NucleusGamma_AbilityIcon
	
	gamma_ability.set_properties_to_usual_tower_based()
	gamma_ability.tower = self
	
	gamma_ability.descriptions = _tower_info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION]
	gamma_ability.simple_descriptions = _tower_info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_SIMPLE_DESCRIPTION]
	
#	gamma_ability.descriptions = [
#		"Ability: Gamma. Fires a constant beam towards its current target for %s seconds." % [str(gamma_ability_duration)],
#		"Gamma deals %s + %s of Nucleus's bonus base damage as elemental damage every %s seconds." % [str(gamma_ability_flat_damage_amount), str(gamma_ability_percent_base_dmg_amount * 100) + "%", str(gamma_ability_duration / gamma_ability_damage_repeat_count)],
#		"Cooldown: %s s" % [str(gamma_ability_base_cooldown)],
#		"Ability potency increases damage dealt by Gamma. Nucleus rotates the beam towards its current target.",
#	]
	gamma_ability.display_name = "Gamma"
	
	gamma_ability_activation_clauses = gamma_ability.activation_conditional_clauses
	gamma_ability_activation_clauses.attempt_insert_clause(_no_enemies_in_range_clause)
	
	register_ability_to_manager(gamma_ability)


func _on_range_module_enemy_entered_n(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		gamma_ability_activation_clauses.remove_clause(_no_enemies_in_range_clause)

func _on_range_module_enemy_exited_n(enemy, module, arg_range_module):
	if range_module == arg_range_module:
		if range_module.enemies_in_range.size() > 0:
			gamma_ability_activation_clauses.remove_clause(_no_enemies_in_range_clause)
		else:
			gamma_ability_activation_clauses.attempt_insert_clause(_no_enemies_in_range_clause)


#

func _gamma_ability_activated():
	var target = _get_single_targetable_enemy()
	if is_instance_valid(target):
		var cd = _get_cd_to_use(gamma_ability_base_cooldown)
		gamma_ability.on_ability_before_cast_start(cd)
		
		_start_gamma_mode(target, cd)
		
		gamma_ability.on_ability_after_cast_ended(cd)

func _get_single_targetable_enemy():
#	var curr_enemies = range_module._current_enemies
#	if curr_enemies.size() > 0:
#		return curr_enemies[0]
#
	var targets = range_module.get_targets(1)
	for target in targets:
		if is_instance_valid(target):
			return target
	
	return null

func _start_gamma_mode(arg_enemy, cd_to_use):
	_is_in_gamma_mode = true
	_attk_module_disabled_by_gamma = main_attack_module
	if is_instance_valid(_attk_module_disabled_by_gamma):
		_attk_module_disabled_by_gamma.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.NUCLEUS_DISABLE)
	
	# change beam pos/size/length
	_current_gamma_beam = gamma_attack_module.construct_aoe(gamma_attack_module.global_position, _get_extended_beam_pos(arg_enemy.global_position))
	_set_current_direction_of_beam(gamma_attack_module.global_position.direction_to(arg_enemy.global_position), arg_enemy.global_position)
	_current_gamma_beam.modulate = Color(1, 1, 1, 0.8)
	_current_gamma_beam.damage_instance.scale_only_damage_by(gamma_ability.get_potency_to_use(last_calculated_final_ability_potency))
	
	if _is_energy_module_on:
		_current_gamma_beam.damage_instance.scale_only_damage_by(2.5)
	
	gamma_attack_module.set_up_aoe__add_child_and_emit_signals(_current_gamma_beam)
	
	_gamma_duration_timer.connect("timeout", self, "_gamma_duration_timer_timeout", [], CONNECT_ONESHOT)
	_gamma_duration_timer.start(gamma_ability_duration)
	
	gamma_ability.start_time_cooldown(cd_to_use)


func _gamma_duration_timer_timeout():
	_end_gamma_mode()

func _end_gamma_mode():
	if _is_in_gamma_mode:
		_is_in_gamma_mode = false
		if is_instance_valid(_attk_module_disabled_by_gamma):
			_attk_module_disabled_by_gamma.can_be_commanded_by_tower_other_clauses.remove_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.NUCLEUS_DISABLE)
		
		_attk_module_disabled_by_gamma = null
		
		if is_instance_valid(_current_gamma_beam):
			_current_gamma_beam.queue_free()


func _on_round_end_n():
	_end_gamma_mode_and_disconnect_duration_timer()

func _on_tower_health_reached_zero():
	_end_gamma_mode_and_disconnect_duration_timer()


func _end_gamma_mode_and_disconnect_duration_timer():
	_end_gamma_mode()
	
	if _gamma_duration_timer.is_connected("timeout", self, "_gamma_duration_timer_timeout"):
		_gamma_duration_timer.disconnect("timeout", self, "_gamma_duration_timer_timeout")


#

func _set_current_direction_of_beam(arg_direction : Vector2, arg_enemy_pos : Vector2):
	_current_direction_of_beam = arg_direction
	_current_angle_of_beam = gamma_attack_module.global_position.angle_to_point(_get_extended_beam_pos(arg_enemy_pos)) #gamma_attack_module.global_position.angle_to(_current_gamma_beam.global_position)
	
	if !_is_energy_module_on:
		gamma_attack_module._modify_center_pos_and_sizeshape_of_aoe(gamma_attack_module.global_position, _get_extended_beam_pos(arg_enemy_pos), _current_gamma_beam)
	else:
		gamma_attack_module._modify_center_pos_and_sizeshape_of_aoe(_get_extended_beam_pos(arg_enemy_pos, -1), _get_extended_beam_pos(arg_enemy_pos), _current_gamma_beam)


func _get_extended_beam_pos(arg_enemy_pos : Vector2, dir_scale : float = 1):
	var direction = gamma_attack_module.global_position.direction_to(arg_enemy_pos)
	
	var beam_length = _base_gamma_length
	if _is_energy_module_on:
		beam_length = _base_gamma_length_energy_module_on
	
	return gamma_attack_module.global_position + (direction * dir_scale * beam_length)


#

func _physics_process(delta):
	if _is_in_gamma_mode:
		var target = _get_single_targetable_enemy()
		if is_instance_valid(target):
			_steer_beam_to_target(target, delta)



func _steer_beam_to_target(arg_enemy, delta):
	if is_instance_valid(_current_gamma_beam):
		var rotated_direction = _current_direction_of_beam.rotated(_get_rotation_for_steer(arg_enemy.global_position, delta))
		_set_current_direction_of_beam(rotated_direction, gamma_attack_module.global_position + rotated_direction)


func _get_rotation_for_steer(arg_enemy_pos, delta) -> float:
	var angle_to_enemy = gamma_attack_module.global_position.angle_to_point(arg_enemy_pos)
	
	var steer_angle : float = 0
	
	angle_to_enemy = _conv_angle_to_positive_val(angle_to_enemy)
	_current_angle_of_beam = _conv_angle_to_positive_val(_current_angle_of_beam)
	
	
	var rotation_per_sec = _beam_rotation_per_sec
	
	if angle_to_enemy > _current_angle_of_beam:
		var diff = angle_to_enemy - _current_angle_of_beam
		if diff < rotation_per_sec:
			rotation_per_sec = diff * 3
		
		if abs(_current_angle_of_beam - angle_to_enemy) > PI:
			steer_angle = delta * rotation_per_sec * -1
		else:
			steer_angle = delta * rotation_per_sec * 1
		
	elif angle_to_enemy < _current_angle_of_beam:
		var diff = _current_angle_of_beam - angle_to_enemy
		if diff < rotation_per_sec:
			rotation_per_sec = diff * 3
		
		if abs(_current_angle_of_beam - angle_to_enemy) > PI:
			steer_angle = delta * rotation_per_sec * 1
		else:
			steer_angle = delta * rotation_per_sec * -1
	
	return steer_angle


func _conv_angle_to_positive_val(arg_angle):
	if arg_angle < 0:
		return (2*PI) + arg_angle
	else:
		if arg_angle < 2 * PI:
			return arg_angle
		else:
			return arg_angle - (2 * PI)

#

func _on_main_attack_hit_enemy_n(enemy, damage_register_id, damage_instance, module):
	if is_instance_valid(enemy):
		damage_instance.final_percent_enemy_armor_pierce = percent_armor_ignore
#		var enemy_armor = enemy._last_calculated_final_armor
#
#		var ignore_armor_amount = enemy_armor * (percent_armor_ignore / 100.0)
#		if ignore_armor_amount < 0:
#			ignore_armor_amount = 0
#
#		damage_instance.final_armor_pierce = ignore_armor_amount


#

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Gamma is fired from both directions, and gains increased range. Gamma also deals 150% more damage."
		]


func _module_turned_on(_first_time_per_round : bool):
	_is_energy_module_on = true


func _module_turned_off():
	_is_energy_module_on = false

