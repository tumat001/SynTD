extends "res://TowerRelated/AbstractTower.gd"

signal available_points_changed
signal fire_level_changed
signal explosive_level_changed
signal toughness_pierce_level_changed


const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const InstantDamageAttackModule = preload("res://TowerRelated/Modules/InstantDamageAttackModule.gd")
const InstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/InstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const EnemyDmgOverTimeEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyDmgOverTimeEffect.gd")

const _704_EmblemBase = preload("res://TowerRelated/Color_Orange/704/704_EmblemBase.gd")

const HeatModule = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Orange_Related/HeatModule.gd")

const _704_Beam01 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam01.png")
const _704_Beam02 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam02.png")
const _704_Beam03 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam03.png")
const _704_Beam04 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam04.png")
const _704_Beam05 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam05.png")
const _704_Beam06 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam06.png")
const _704_Beam07 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam07.png")
const _704_Beam08 = preload("res://TowerRelated/Color_Orange/704/704_Beam/704_Beam08.png")

const _704_Explosion01 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion01.png")
const _704_Explosion02 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion02.png")
const _704_Explosion03 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion03.png")
const _704_Explosion04 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion04.png")
const _704_Explosion05 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion05.png")
const _704_Explosion06 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion06.png")
const _704_Explosion07 = preload("res://TowerRelated/Color_Orange/704/704_Explosion/704_Explosion07.png")

const _704Explosion_AttackModule_Icon = preload("res://TowerRelated/Color_Orange/704/AMAssets/_704Explosion_AttackModule_Icon.png")


var available_points : int = 4
var emblem_fire_points : int = 0 setget set_emblem_fire_level
var emblem_explosive_points : int = 0 setget set_emblem_explosive_level
var emblem_toughness_pierce_points : int = 0 setget set_emblem_toughness_pierce_level
var _spent_points : int = 0
const total_points_from_all_limit : int = 12 # 3 emblems * 4 levels

var sky_attack_module : InstantDamageAttackModule
var sky_attack_sprite_frames : SpriteFrames
var sky_attack_beams_enemy_map : Dictionary = {}

var explosion_attack_module : AOEAttackModule

var fire_burn_dmg_modifier : FlatModifier
var fire_burn_dmg_instance : DamageInstance
var fire_effect : TowerOnHitEffectAdderEffect

onready var in_field_emblem_fire : _704_EmblemBase = $TowerBase/KnockUpLayer/Emblem_Fire
onready var in_field_emblem_explosive : _704_EmblemBase = $TowerBase/KnockUpLayer/Emblem_Explosive
onready var in_field_emblem_toughness_pierce : _704_EmblemBase = $TowerBase/KnockUpLayer/Emblem_ToughnessPierce


# Called when the node enters the scene tree for the first time.
func _ready():
	_construct_burn_effect()
	
	var info : TowerTypeInformation = Towers.get_tower_info(Towers._704)
	
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
	range_module.position.y += 8
	
	# sky attack
	
	var attack_module : InstantDamageAttackModule = InstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 4
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 8
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	
	sky_attack_module = attack_module
	
	sky_attack_module.connect("in_attack_windup", self, "_on_704_attack_windup", [], CONNECT_PERSIST)
	
	add_attack_module(attack_module)
	
	# sky attack sprite frames
	
	sky_attack_sprite_frames = SpriteFrames.new()
	sky_attack_sprite_frames.add_frame("default", _704_Beam01)
	sky_attack_sprite_frames.add_frame("default", _704_Beam02)
	sky_attack_sprite_frames.add_frame("default", _704_Beam03)
	sky_attack_sprite_frames.add_frame("default", _704_Beam04)
	sky_attack_sprite_frames.add_frame("default", _704_Beam05)
	sky_attack_sprite_frames.add_frame("default", _704_Beam06)
	sky_attack_sprite_frames.add_frame("default", _704_Beam07)
	sky_attack_sprite_frames.add_frame("default", _704_Beam08)
	
	
	# AOE module
	
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = 1.5
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	explosion_attack_module.benefits_from_bonus_on_hit_effect = true
	
	explosion_attack_module.on_hit_damage_scale = 0.5
	explosion_attack_module.on_hit_effect_scale = 0.5
	
	var aoe_sprite_frames = SpriteFrames.new()
	aoe_sprite_frames.add_frame("default", _704_Explosion01)
	aoe_sprite_frames.add_frame("default", _704_Explosion02)
	aoe_sprite_frames.add_frame("default", _704_Explosion03)
	aoe_sprite_frames.add_frame("default", _704_Explosion04)
	aoe_sprite_frames.add_frame("default", _704_Explosion05)
	aoe_sprite_frames.add_frame("default", _704_Explosion06)
	aoe_sprite_frames.add_frame("default", _704_Explosion07)
	
	explosion_attack_module.aoe_sprite_frames = aoe_sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = 5
	explosion_attack_module.duration = 0.3
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(_704Explosion_AttackModule_Icon)
	
	add_attack_module(explosion_attack_module)
	
	#
	connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy_7", [], CONNECT_PERSIST)
	
	in_field_emblem_fire.use_parent_material = false
	in_field_emblem_explosive.use_parent_material = false
	in_field_emblem_toughness_pierce.use_parent_material = false
	
	_post_inherit_ready()


func _construct_burn_effect():
	fire_burn_dmg_modifier = FlatModifier.new(StoreOfTowerEffectsUUID._704_FIRE_BURN)
	fire_burn_dmg_modifier.flat_modifier = 0.5
	
	var burn_on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID._704_FIRE_BURN, fire_burn_dmg_modifier, DamageType.ELEMENTAL)
	fire_burn_dmg_instance = DamageInstance.new()
	fire_burn_dmg_instance.on_hit_damages[burn_on_hit.internal_id] = burn_on_hit
	
	var burn_effect = EnemyDmgOverTimeEffect.new(fire_burn_dmg_instance, StoreOfEnemyEffectsUUID._704_FIRE_BURN, 0.5)
	burn_effect.is_timebound = true
	burn_effect.time_in_seconds = 5
	burn_effect.effect_source_ref = self
	
	fire_effect = TowerOnHitEffectAdderEffect.new(burn_effect, StoreOfTowerEffectsUUID._704_FIRE_BURN)
	

func _post_inherit_ready():
	._post_inherit_ready()
	
	add_tower_effect(fire_effect)
	
	set_emblem_fire_level(0)
	set_emblem_toughness_pierce_level(0)
	set_emblem_explosive_level(0)

# Attacks related

func _on_704_attack_windup(windup_time : float, enemies : Array):
	var available_beams = _get_available_beams()
	var enemies_count : float = enemies.size()
	var beam_count : float = available_beams.size()
	
	if enemies_count > beam_count:
		for i in range(0, enemies_count - beam_count):
			_construct_sky_beam()
	
	if enemies_count > 0:
		available_beams = _get_available_beams()
		for i in enemies.size():
			var beam = available_beams[i]
			var enemy = enemies[i]
			var enemy_pos = global_position
			if is_instance_valid(enemy):
				enemy_pos = enemy.global_position
			
			sky_attack_beams_enemy_map[beam] = enemy
			
			beam.connect("time_visible_is_over", self, "_beam_in_sky", [beam, windup_time, enemy, enemy_pos], CONNECT_ONESHOT)
			
			beam.frames.set_animation_speed("default", 8 / (windup_time / 2))
			beam.frame = 0
			beam.play("default", false)
			
			beam.time_visible = windup_time / 2
			beam.visible = true
			beam.global_position = global_position
			beam.update_destination_position(Vector2(global_position.x, global_position.y - 100))


func _beam_in_sky(beam : BeamAesthetic, windup_time : float, enemy, enemy_pos):
	beam.time_visible = windup_time / 2
	beam.frames.set_animation_speed("default", 8 / (windup_time / 2))
	beam.frame = 8
	beam.play("default", true)
	
	beam.connect("time_visible_is_over", self, "_downward_beam_expired", [enemy, enemy_pos, beam], CONNECT_ONESHOT)
	beam.visible = true
	beam.global_position = enemy_pos
	beam.update_destination_position(Vector2(enemy_pos.x, enemy_pos.y - 100))
	


func _get_available_beams():
	var bucket : Array = []
	for beam in sky_attack_beams_enemy_map.keys():
		if !beam.visible:
			bucket.append(beam)
	
	return bucket


func _construct_sky_beam():
	var beam : BeamAesthetic = BeamAesthetic_Scene.instance()
	beam.is_timebound = true
	beam.visible = false
	
	beam.set_sprite_frames(sky_attack_sprite_frames)
	beam.frames.set_animation_loop("default", false)

	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(beam)
	
	sky_attack_beams_enemy_map[beam] = null


# AOE Related

func _downward_beam_expired(enemy, explosion_pos : Vector2, beam):
	
	sky_attack_beams_enemy_map[beam] = null
	
	_attempt_summon_explosion(explosion_pos, enemy)

func _attempt_summon_explosion(explosion_pos : Vector2, arg_enemy):
	if emblem_explosive_points > 0:
		var explosion = explosion_attack_module.construct_aoe(explosion_pos, explosion_pos)
		if is_instance_valid(arg_enemy):
			explosion.enemies_to_ignore.append(arg_enemy)
		
		explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)



func _on_main_attack_hit_enemy_7(enemy, damage_register_id, damage_instance, module):
	if module != sky_attack_module:
		_attempt_summon_explosion(enemy.global_position, enemy)





# EMBLEM RELATED ---------------------- #

# Fire
func can_give_points_to_fire() -> bool:
	return emblem_fire_points < 4 and available_points > 0

func set_emblem_fire_level(level : int):
	emblem_fire_points = level
	in_field_emblem_fire.set_level(level)
	
	var burn_per_tick : float = 0
	if level == 0:
		pass
	elif level == 1:
		burn_per_tick = 0.4
	elif level == 2:
		burn_per_tick = 0.7
	elif level == 3:
		burn_per_tick = 1.0
	elif level == 4:
		burn_per_tick = 1.3
	
	fire_burn_dmg_modifier.flat_modifier = burn_per_tick
	emit_signal("fire_level_changed")

# Explosion
func can_give_points_to_explosive() -> bool:
	return emblem_explosive_points < 4 and available_points > 0

func set_emblem_explosive_level(level : int):
	emblem_explosive_points = level
	in_field_emblem_explosive.set_level(level)
	
	var exp_on_hit_damage_scale : float = 0
	var exp_on_hit_effect_scale : float = 0
	var exp_base_scale : float = 0
	
	if level == 0:
		pass
	elif level == 1:
		exp_base_scale = 1#0.66
	elif level == 2:
		exp_on_hit_damage_scale = 0.33
		exp_base_scale = 1#0.66
	elif level == 3:
		exp_on_hit_damage_scale = 0.66
		exp_base_scale = 1.25#1
	elif level == 4:
		exp_on_hit_damage_scale = 1
		exp_on_hit_effect_scale = 1
		exp_base_scale = 1.5 #1.25
	
	explosion_attack_module.on_hit_damage_scale = exp_on_hit_damage_scale
	explosion_attack_module.on_hit_effect_scale = exp_on_hit_effect_scale
	explosion_attack_module.base_explosion_scale = exp_base_scale
	explosion_attack_module.calculate_final_explosion_scale()
	emit_signal("explosive_level_changed")


# Toughness pierce
func can_give_points_to_toughness_pierce() -> bool:
	return emblem_toughness_pierce_points < 4 and available_points > 0


func set_emblem_toughness_pierce_level(level : int):
	emblem_toughness_pierce_points = level
	in_field_emblem_toughness_pierce.set_level(level)
	
	var toughness_pierce_bonus : float = 0
	if level == 0:
		pass
	elif level == 1:
		toughness_pierce_bonus = 2
	elif level == 2:
		toughness_pierce_bonus = 4
	elif level == 3:
		toughness_pierce_bonus = 6
	elif level == 4:
		toughness_pierce_bonus = 8
	
	sky_attack_module.base_toughness_pierce = toughness_pierce_bonus
	sky_attack_module.calculate_final_toughness_pierce()
	
	if level == 4:
		explosion_attack_module.base_toughness_pierce = toughness_pierce_bonus
	else:
		explosion_attack_module.base_toughness_pierce = 0
	
	explosion_attack_module.calculate_final_toughness_pierce()
	
	
	if level >= 3:
		fire_burn_dmg_instance.final_toughness_pierce = toughness_pierce_bonus
	else:
		fire_burn_dmg_instance.final_toughness_pierce = 0
	
	emit_signal("toughness_pierce_level_changed")


# Emblem points allocation

func attempt_allocate_points_to_fire():
	if can_give_points_to_fire():
		available_points -= 1
		emit_signal("available_points_changed")
		set_emblem_fire_level(emblem_fire_points + 1)
		_spent_points += 1

func attempt_allocate_points_to_explosive():
	if can_give_points_to_explosive():
		available_points -= 1
		emit_signal("available_points_changed")
		set_emblem_explosive_level(emblem_explosive_points + 1)
		_spent_points += 1

func attempt_allocate_points_to_toughness_pierce():
	if can_give_points_to_toughness_pierce():
		available_points -= 1
		emit_signal("available_points_changed")
		set_emblem_toughness_pierce_level(emblem_toughness_pierce_points + 1)
		_spent_points += 1

# Ing

func _special_case_tower_effect_added(effect : TowerBaseEffect):
	if effect is _704EmblemPointsEffect:
		available_points += 4

func _can_accept_ingredient(ingredient_effect : IngredientEffect, tower_selected) -> bool:
	if ingredient_effect != null and ingredient_effect.tower_id == Towers._704 and tower_selected.last_calculated_can_be_used_as_ingredient:
		return _spent_points + available_points < total_points_from_all_limit
	
	return ._can_accept_ingredient(ingredient_effect, tower_selected)


# Heat Module

func set_heat_module(module : HeatModule):
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
