extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")

const Propel_ProjPic = preload("res://TowerRelated/Color_Orange/Propel/Attks/Propel_RocketProj.png")
const Propel_ExplosionPic_01 = preload("res://TowerRelated/Color_Orange/Propel/Attks/Explosion/Propel_Explosion_01.png")
const Propel_ExplosionPic_02 = preload("res://TowerRelated/Color_Orange/Propel/Attks/Explosion/Propel_Explosion_02.png")
const Propel_ExplosionPic_03 = preload("res://TowerRelated/Color_Orange/Propel/Attks/Explosion/Propel_Explosion_03.png")
const Propel_ExplosionPic_04 = preload("res://TowerRelated/Color_Orange/Propel/Attks/Explosion/Propel_Explosion_04.png")
const Propel_ExplosionPic_05 = preload("res://TowerRelated/Color_Orange/Propel/Attks/Explosion/Propel_Explosion_05.png")
const Propel_ExplosionPic_06 = preload("res://TowerRelated/Color_Orange/Propel/Attks/Explosion/Propel_Explosion_06.png")

const Propel_PlowPic_01 = preload("res://TowerRelated/Color_Orange/Propel/OtherAssets/Propel_PlowParticle_01.png")
const Propel_PlowPic_02 = preload("res://TowerRelated/Color_Orange/Propel/OtherAssets/Propel_PlowParticle_02.png")
const Propel_PlowPic_03 = preload("res://TowerRelated/Color_Orange/Propel/OtherAssets/Propel_PlowParticle_03.png")
const Propel_PlowPic_04 = preload("res://TowerRelated/Color_Orange/Propel/OtherAssets/Propel_PlowParticle_04.png")
const Propel_PlowPic_05 = preload("res://TowerRelated/Color_Orange/Propel/OtherAssets/Propel_PlowParticle_05.png")
const Propel_PlowPic_06 = preload("res://TowerRelated/Color_Orange/Propel/OtherAssets/Propel_PlowParticle_06.png")
const Propel_PlowPic_07 = preload("res://TowerRelated/Color_Orange/Propel/OtherAssets/Propel_PlowParticle_07.png")
const Propel_PlowPic_08 = preload("res://TowerRelated/Color_Orange/Propel/OtherAssets/Propel_PlowParticle_08.png")

const Propel_Plow_SmallOrangeParticle = preload("res://TowerRelated/Color_Orange/Propel/OtherAssets/Propel_Plow_SmallOrangeParticle.png")
const Propel_Plow_SmallYellowParticle = preload("res://TowerRelated/Color_Orange/Propel/OtherAssets/Propel_Plow_SmallYellowParticle.png")

const EnemyKnockUpEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyKnockUpEffect.gd")
const EnemyForcedPathOffsetMovementEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyForcedPathOffsetMovementEffect.gd")


const MapManager = preload("res://GameElementsRelated/MapManager.gd")


var plow_ability : BaseAbility
const plow_base_cooldown : float = 16.0
const plow_is_during_cast_clause_id : int = -10


const plow_flat_damage : float = 5.0
var plow_attack_module : BulletAttackModule


var plow_knockup_effect : EnemyKnockUpEffect
var plow_forced_path_mov_effect : EnemyForcedPathOffsetMovementEffect
const plow_base_stun_duration : float = 2.5

const plow_knockup_accel : float = 20.0
const plow_knockup_time : float = 0.5

const plow_mov_speed : float = 20.0
const plow_mov_speed_deceleration : float = 65.0


#

const main_proj_explosion_flat_dmg : float = 2.0
const main_prok_explosion_pierce : int = 3
var proj_aoe_attack_module : AOEAttackModule

#

var is_plow_ability_ready : bool

var line_range_module_to_in_map_placable_map : Dictionary = {}
const line_range_module_width : float = 10.0
const plow_hitbox_extent_amount : float = 17.0

var line_range_module_enemy_to_in_range_count_map : Dictionary = {}

#

#var _original_placable_at_round_start : InMapAreaPlacable

#

func _ready():
	var info = Towers.get_tower_info(Towers.PROPEL)
	
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
	range_module.position.y += 10
	
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 400#250
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 10
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents.x = 13
	bullet_shape.extents.y = 5
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Propel_ProjPic)
	
	add_attack_module(attack_module)
	
	
	#
	
	
	proj_aoe_attack_module = AOEAttackModule_Scene.instance()
	proj_aoe_attack_module.base_damage = main_proj_explosion_flat_dmg
	proj_aoe_attack_module.base_damage_type = DamageType.PHYSICAL
	proj_aoe_attack_module.base_attack_speed = 0
	proj_aoe_attack_module.base_attack_wind_up = 0
	proj_aoe_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_aoe_attack_module.is_main_attack = false
	proj_aoe_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	proj_aoe_attack_module.base_explosion_scale = 1.75
	
	proj_aoe_attack_module.benefits_from_bonus_explosion_scale = true
	proj_aoe_attack_module.benefits_from_bonus_base_damage = false
	proj_aoe_attack_module.benefits_from_bonus_attack_speed = false
	proj_aoe_attack_module.benefits_from_bonus_on_hit_damage = false
	proj_aoe_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Propel_ExplosionPic_01)
	sprite_frames.add_frame("default", Propel_ExplosionPic_02)
	sprite_frames.add_frame("default", Propel_ExplosionPic_03)
	sprite_frames.add_frame("default", Propel_ExplosionPic_04)
	sprite_frames.add_frame("default", Propel_ExplosionPic_05)
	sprite_frames.add_frame("default", Propel_ExplosionPic_06)
	
	proj_aoe_attack_module.aoe_sprite_frames = sprite_frames
	proj_aoe_attack_module.sprite_frames_only_play_once = true
	proj_aoe_attack_module.pierce = main_prok_explosion_pierce
	proj_aoe_attack_module.duration = 0.3
	proj_aoe_attack_module.damage_repeat_count = 1
	
	proj_aoe_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	proj_aoe_attack_module.base_aoe_scene = BaseAOE_Scene
	proj_aoe_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	proj_aoe_attack_module.can_be_commanded_by_tower = false
	
	proj_aoe_attack_module.set_image_as_tracker_image(Propel_ExplosionPic_05)
	
	add_attack_module(proj_aoe_attack_module)
	
	#
	
	_construct_and_add_plow_attk_module()
	_construct_and_register_ability()
	
	
	plow_knockup_effect = EnemyKnockUpEffect.new(plow_knockup_time, plow_knockup_accel, StoreOfEnemyEffectsUUID.PROPEL_KNOCK_UP_EFFECT)
	plow_knockup_effect.custom_stun_duration = plow_base_stun_duration
	
	plow_forced_path_mov_effect = EnemyForcedPathOffsetMovementEffect.new(plow_mov_speed, plow_mov_speed_deceleration, StoreOfEnemyEffectsUUID.PROPEL_FORCED_MOV_EFFECT)
	plow_forced_path_mov_effect.is_timebound = true
	plow_forced_path_mov_effect.time_in_seconds = plow_base_stun_duration

	
	#
	
	connect("on_main_bullet_attack_module_bullet_reached_zero_pierce", self, "_on_main_bullet_attk_reached_zero_pierce", [], CONNECT_PERSIST)
	connect("final_range_changed", self, "_on_final_range_changed_p", [], CONNECT_PERSIST)
	#connect("tower_dropped_from_dragged", self, "_on_tower_dropped_from_dragged", [], CONNECT_PERSIST)
	connect("tree_exiting", self, "_on_tree_exiting", [], CONNECT_PERSIST)
	
	connect("on_tower_transfered_to_placable", self, "_on_tower_placable_changed", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_p", [], CONNECT_PERSIST)
	connect("on_round_start", self, "_on_round_start_p", [], CONNECT_PERSIST)
	
	_post_inherit_ready()

#

func _construct_and_add_plow_attk_module():
	plow_attack_module = BulletAttackModule_Scene.instance()
	plow_attack_module.base_damage = plow_flat_damage
	plow_attack_module.base_damage_type = DamageType.PHYSICAL
	plow_attack_module.base_attack_speed = 0
	plow_attack_module.base_attack_wind_up = 0
	plow_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	plow_attack_module.is_main_attack = false
	plow_attack_module.base_pierce = 1
	plow_attack_module.base_proj_speed = 300
	#plow_attack_module.base_proj_life_distance = info.base_range
	plow_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	plow_attack_module.on_hit_damage_scale = 1
	
	plow_attack_module.benefits_from_bonus_attack_speed = false
	plow_attack_module.benefits_from_bonus_base_damage = false
	plow_attack_module.benefits_from_bonus_on_hit_damage = false
	plow_attack_module.benefits_from_bonus_on_hit_effect = false
	plow_attack_module.benefits_from_bonus_pierce = false
	
	var bullet_shape = RectangleShape2D.new()
	bullet_shape.extents = Vector2(plow_hitbox_extent_amount, plow_hitbox_extent_amount)
	
	plow_attack_module.bullet_shape = bullet_shape
	plow_attack_module.bullet_scene = BaseBullet_Scene
	
	var sp = SpriteFrames.new()
	sp.add_frame("default", Propel_PlowPic_01)
	sp.add_frame("default", Propel_PlowPic_02)
	sp.add_frame("default", Propel_PlowPic_03)
	sp.add_frame("default", Propel_PlowPic_04)
	sp.add_frame("default", Propel_PlowPic_05)
	sp.add_frame("default", Propel_PlowPic_06)
	sp.add_frame("default", Propel_PlowPic_07)
	sp.add_frame("default", Propel_PlowPic_08)
	sp.set_animation_speed("default", 24)
	plow_attack_module.bullet_sprite_frames = sp
	plow_attack_module.bullet_play_animation = true
	
	plow_attack_module.can_be_commanded_by_tower = false
	
	plow_attack_module.set_image_as_tracker_image(preload("res://TowerRelated/Color_Orange/Propel/OtherAssets/Propel_AttackModuleIcon.png"))
	
	add_attack_module(plow_attack_module)


#

func _construct_and_register_ability():
	plow_ability = BaseAbility.new()
	
	plow_ability.is_timebound = true
	
	plow_ability.set_properties_to_usual_tower_based()
	plow_ability.tower = self
	
	plow_ability.connect("updated_is_ready_for_activation", self, "_on_plow_ability_can_cast_changed", [], CONNECT_PERSIST)
	register_ability_to_manager(plow_ability, false)
	

func _on_plow_ability_can_cast_changed(arg_val):
	is_plow_ability_ready = arg_val
	
	_attempt_cast_plow()


#

func _on_main_bullet_attk_reached_zero_pierce(arg_bullet, arg_module):
	var pos = arg_bullet.global_position
	
	var aoe = proj_aoe_attack_module.construct_aoe(pos, pos)
	
	proj_aoe_attack_module.set_up_aoe__add_child_and_emit_signals(aoe)

####


func _on_final_range_changed_p():
	if is_current_placable_in_map():
		_update_line_range_modules_state()

#func _on_tower_dropped_from_dragged(arg_self):
#	if is_current_placable_in_map():
#		_update_line_range_modules_state()
#
#		if is_round_started and _original_placable_at_round_start == null:
#			_original_placable_at_round_start = current_placable

func _on_tower_placable_changed(arg_tower, arg_placable):
	if is_current_placable_in_map():
		_update_line_range_modules_state()
		
		#if is_round_started and !is_instance_valid(_original_placable_at_round_start):
		#	_original_placable_at_round_start = current_placable


func _update_line_range_modules_state():
	var all_placables_in_range = game_elements.map_manager.get_all_placables_in_range(global_position, get_last_calculated_range_of_main_attk_module(), MapManager.PlacableState.ANY)
	if is_instance_valid(current_placable) and all_placables_in_range.has(current_placable):
		all_placables_in_range.erase(current_placable)
	
	for in_map_placable in all_placables_in_range:
		if !line_range_module_to_in_map_placable_map.values().has(in_map_placable):
			var line_rng_module = _create_range_module_for_line_detection(in_map_placable.global_position)
			line_range_module_to_in_map_placable_map[line_rng_module] = in_map_placable
	
	for range_mod in line_range_module_to_in_map_placable_map.keys():
		if all_placables_in_range.has(line_range_module_to_in_map_placable_map[range_mod]):
			var placable = line_range_module_to_in_map_placable_map[range_mod]
			var range_mod_shape = range_mod.get_range_shape()
			_configure_shape_of_range_mod(range_mod_shape, placable.global_position)
			range_mod.set_range_shape(range_mod_shape)
			
			var angle = global_position.angle_to_point(placable.global_position)
			range_mod.global_position = (global_position + placable.global_position) / 2.0
			range_mod.rotation = angle
			
			line_range_module_enemy_to_in_range_count_map[range_mod] = 0 # reset purposes
			range_mod.range_shape.disabled = false
		else:
			range_mod.get_range_shape().extents = Vector2(0, 0)
			range_mod.range_shape.disabled = true
			line_range_module_enemy_to_in_range_count_map[range_mod] = 0


func _create_range_module_for_line_detection(arg_placable_pos : Vector2):
	var line_range_module = RangeModule_Scene.instance()
	
	line_range_module.can_display_range = false
	line_range_module.set_range_shape(RectangleShape2D.new())
	
	line_range_module.connect("enemy_entered_range", self, "_on_line_range_module_enemy_entered", [line_range_module], CONNECT_PERSIST)
	line_range_module.connect("enemy_left_range", self, "_on_line_range_module_enemy_exited", [line_range_module], CONNECT_PERSIST | CONNECT_DEFERRED)
	
	line_range_module_enemy_to_in_range_count_map[line_range_module] = 0
	
	line_range_module.position = global_position
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(line_range_module)
	
	return line_range_module

func _configure_shape_of_range_mod(arg_shape : RectangleShape2D, arg_placable_pos : Vector2):
	var distance = global_position.distance_to(arg_placable_pos)
	
	var vector : Vector2 = Vector2(-(distance / 2.0), line_range_module_width)
	
	arg_shape.extents = vector
	

func _on_tree_exiting():
	for range_module in line_range_module_to_in_map_placable_map.keys():
		range_module.queue_free()



#

func _on_line_range_module_enemy_entered(enemy, arg_range_mod):
	line_range_module_enemy_to_in_range_count_map[arg_range_mod] = arg_range_mod.get_enemy_in_range_count()
	
	if is_instance_valid(enemy) and !enemy.is_connected("on_death_by_any_cause", self, "_on_enemy_death_by_any_cause__on_line_range_module"):
		enemy.connect("on_death_by_any_cause", self, "_on_enemy_death_by_any_cause__on_line_range_module", [enemy, arg_range_mod], CONNECT_DEFERRED)
	
	_attempt_cast_plow()

func _on_line_range_module_enemy_exited(enemy, arg_range_mod):
	line_range_module_enemy_to_in_range_count_map[arg_range_mod] = arg_range_mod.get_enemy_in_range_count()
	
	if is_instance_valid(enemy) and enemy.is_connected("on_death_by_any_cause", self, "_on_enemy_death_by_any_cause__on_line_range_module"):
		enemy.disconnect("on_death_by_any_cause", self, "_on_enemy_death_by_any_cause__on_line_range_module")

func _on_enemy_death_by_any_cause__on_line_range_module(enemy, arg_line_range_module):
	_on_line_range_module_enemy_exited(enemy, arg_line_range_module)

#

func _attempt_cast_plow():
	if is_plow_ability_ready:
		var placable = _get_placable_with_most_enemies_in_between()
		if is_instance_valid(placable):
			_cast_plow_ability(placable)


func _get_placable_with_most_enemies_in_between():
	var candidate_placable
	var candidate_line_range_module
	var candidate_count : int = 0
	
	for line_range_module in line_range_module_enemy_to_in_range_count_map.keys():
		var placable = line_range_module_to_in_map_placable_map[line_range_module]
		
		if is_instance_valid(placable) and placable.tower_occupying == null:
			var curr_count = line_range_module_enemy_to_in_range_count_map[line_range_module]
			if curr_count > candidate_count:
				candidate_count = curr_count
				candidate_line_range_module = line_range_module
	
	if is_instance_valid(candidate_line_range_module) and candidate_count != 0:
		if line_range_module_to_in_map_placable_map.has(candidate_line_range_module):
			return line_range_module_to_in_map_placable_map[candidate_line_range_module]
	
	return null


func _cast_plow_ability(arg_placable):
	plow_ability.activation_conditional_clauses.attempt_insert_clause(plow_is_during_cast_clause_id)
	disabled_from_attacking_clauses.attempt_insert_clause(DisabledFromAttackingSourceClauses.PROPEL_DURING_PLOW)
	untargetability_clauses.attempt_insert_clause(UntargetabilityClauses.PROPEL_DURING_PLOW)
	
	var cd = _get_cd_to_use(plow_base_cooldown)
	plow_ability.on_ability_before_cast_start(cd)
	
	plow_ability.start_time_cooldown(cd)
	_construct_plow_bullet(arg_placable)
	
	plow_ability.on_ability_after_cast_ended(cd)
	
	set_tower_base_modulate(TowerModulateIds.PROPEL_INVIS, Color(1, 1, 1, 0))


func _construct_plow_bullet(arg_placable):
	var bullet = plow_attack_module.construct_bullet(arg_placable.global_position)
	
	bullet.connect("hit_an_enemy", self, "_on_bullet_hit_enemy")
	bullet.connect("tree_exiting", self, "_on_plow_bullet_tree_exiting", [arg_placable], CONNECT_ONESHOT)
	bullet.decrease_pierce = false
	bullet.life_distance = global_position.distance_to(arg_placable.global_position)
	
	plow_attack_module.set_up_bullet__add_child_and_emit_signals(bullet)


func _on_plow_bullet_tree_exiting(arg_placable):
	if is_instance_valid(arg_placable) and arg_placable.tower_occupying == null and is_round_started:
		_transfer_to_placable_with_default_params(arg_placable)
	
	plow_ability.activation_conditional_clauses.remove_clause(plow_is_during_cast_clause_id)
	disabled_from_attacking_clauses.remove_clause(DisabledFromAttackingSourceClauses.PROPEL_DURING_PLOW)
	untargetability_clauses.remove_clause(UntargetabilityClauses.PROPEL_DURING_PLOW)
	
	remove_tower_base_modulate(TowerModulateIds.PROPEL_INVIS)



func _transfer_to_placable_with_default_params(arg_placable):
	transfer_to_placable(arg_placable, false, !tower_manager.can_place_tower_based_on_limit_and_curr_placement(self))


# plow bullet
func _on_bullet_hit_enemy(bullet, enemy):
	var knock_up_effect = plow_knockup_effect._get_copy_scaled_by(plow_ability.get_potency_to_use(last_calculated_final_ability_potency))
	var forced_mov_effect = plow_forced_path_mov_effect._get_copy_scaled_by(plow_ability.get_potency_to_use(last_calculated_final_ability_potency))
	
	if !is_enemy_facing_self(enemy):
		forced_mov_effect.reverse_movements()
	
	enemy._add_effect(knock_up_effect)
	enemy._add_effect(forced_mov_effect)


#

func _on_round_end_p():
#	if is_instance_valid(_original_placable_at_round_start):
#		if _original_placable_at_round_start.tower_occupying == null:
#			_transfer_to_placable_with_default_params(_original_placable_at_round_start)
#		_original_placable_at_round_start = null
	
	for range_module_i in line_range_module_to_in_map_placable_map.keys():
		if is_instance_valid(range_module_i):
			range_module_i.clear_all_detected_enemies()
			
			line_range_module_enemy_to_in_range_count_map[range_module_i] = 0

func _on_round_start_p():
	pass
#	if is_current_placable_in_map():
#		_original_placable_at_round_start = current_placable


#


# Heat Module

func set_heat_module(module):
	module.heat_per_attack = 3
	.set_heat_module(module)

func _construct_heat_effect():
	var base_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)
	base_attr_mod.percent_amount = 12
	base_attr_mod.percent_based_on = PercentType.BASE
	
	base_heat_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_ABILITY_CDR , base_attr_mod, StoreOfTowerEffectsUUID.HEAT_MODULE_CURRENT_EFFECT)

func _heat_module_current_heat_effect_changed():
	._heat_module_current_heat_effect_changed()
	
	_calculate_final_ability_potency()

