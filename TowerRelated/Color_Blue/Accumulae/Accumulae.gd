extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const ArcingBaseBullet = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.gd")
const ArcingBaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/ArcingBaseBullet.tscn")
const ArcingBulletAttackModule_Scene = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.tscn")
const ArcingBulletAttackModule = preload("res://TowerRelated/Modules/ArcingBulletAttackModule.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const SiphonStacksBar = preload("res://TowerRelated/Color_Blue/Accumulae/SiphonStacksBar/SiphonStacksBar.gd")
const SiphonStacksBar_Scene = preload("res://TowerRelated/Color_Blue/Accumulae/SiphonStacksBar/SiphonStacksBar.tscn")

const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")


const Accumulae_NormalProj = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_NormalProj.png")
const Accumulae_SiphonBeam01 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_SiphonBeam/Accumulae_SiphonBeam01.png")
const Accumulae_SiphonBeam02 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_SiphonBeam/Accumulae_SiphonBeam02.png")
const Accumulae_SiphonBeam03 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_SiphonBeam/Accumulae_SiphonBeam03.png")
const Accumulae_SiphonBeam04 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_SiphonBeam/Accumulae_SiphonBeam04.png")
const Accumulae_SiphonBeam05 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_SiphonBeam/Accumulae_SiphonBeam05.png")
const Accumulae_SiphonBeam06 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_SiphonBeam/Accumulae_SiphonBeam06.png")
const Accumulae_SiphonBeam07 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_SiphonBeam/Accumulae_SiphonBeam07.png")
const Accumulae_SiphonBeam08 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_SiphonBeam/Accumulae_SiphonBeam08.png")
const Accumulae_SiphonBeam09 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_SiphonBeam/Accumulae_SiphonBeam09.png")
const Accumulae_SiphonBeam10 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_SiphonBeam/Accumulae_SiphonBeam10.png")

const Accumulae_BurstProj = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_BurstProj.png")

const Accumulae_BurstExplosion01 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_Explosion/Accumulae_BurstExplosion01.png")
const Accumulae_BurstExplosion02 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_Explosion/Accumulae_BurstExplosion02.png")
const Accumulae_BurstExplosion03 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_Explosion/Accumulae_BurstExplosion03.png")
const Accumulae_BurstExplosion04 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_Explosion/Accumulae_BurstExplosion04.png")
const Accumulae_BurstExplosion05 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_Explosion/Accumulae_BurstExplosion05.png")
const Accumulae_BurstExplosion06 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_Explosion/Accumulae_BurstExplosion06.png")
const Accumulae_BurstExplosion07 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_Explosion/Accumulae_BurstExplosion07.png")
const Accumulae_BurstExplosion08 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_Explosion/Accumulae_BurstExplosion08.png")
const Accumulae_BurstExplosion09 = preload("res://TowerRelated/Color_Blue/Accumulae/Attks/Accumulae_Explosion/Accumulae_BurstExplosion09.png")

const SalvoBurst_AttackModule_Icon = preload("res://TowerRelated/Color_Blue/Accumulae/AMAssets/SalvoBurst_AttackModule_Icon.png")

#

signal current_siphon_stacks_changed()

const base_siphon_stacks_to_cast_salvo : int = 12
const base_delay_per_burst_in_salvo : float = 0.2
const base_salvo_cooldown : float = 5.0

const enemy_siphon_effect_duration : float = 7.0
const base_enemy_ap_reduction_of_siphon : float = -0.35

#const base_ap_per_siphon_stack : float = 0.25

const base_spell_burst_damage : float = 7.0

# clause for attk module
const lob_attk_module_not_yet_casted_clause : int = -10

const attack_position_source_y_shift : float = 23.0


var enemy_siphon_ap_effect : EnemyAttributesEffect
#var tower_siphon_ap_modi : FlatModifier

var siphon_attk_module : WithBeamInstantDamageAttackModule
var burst_lob_attk_module : ArcingBulletAttackModule
var spell_burst_attk_module : AOEAttackModule

var is_in_salvo : bool = false
var salvo_delay_timer : Timer
var salvo_ability : BaseAbility
var _can_cast_salvo_ability : bool = false

var current_siphon_stacks : int = 0

var _attk_module_disabled_by_salvo_clause : AbstractAttackModule

#

func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.ACCUMULAE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	ingredient_of_self = info.ingredient_effect
	_base_gold_cost = info.tower_cost
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += attack_position_source_y_shift
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 600#515
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.position.y -= attack_position_source_y_shift
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 5
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Accumulae_NormalProj)
	
	add_attack_module(attack_module)
	
	#
	
	_construct_and_add_siphon_attk_module()
	_construct_and_add_lob_attack_module()
	_construct_and_add_spell_burst_explosion()
	
	
	#
	
	connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_hit_enemy_a", [], CONNECT_PERSIST)
	#connect("final_ability_potency_changed", self, "_on_ap_changed_a", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_a", [], CONNECT_PERSIST)
	
	_construct_enemy_siphon_effect()
	_construct_and_add_salvo_ability()
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	#_construct_and_add_self_siphon_effect()
	
	_construct_and_add_slot_bar()
	
	#
	
	salvo_delay_timer = Timer.new()
	salvo_delay_timer.one_shot = true
	
	add_child(salvo_delay_timer)


#


func _construct_and_add_siphon_attk_module():
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = 0
	attack_module.base_damage_type = DamageType.ELEMENTAL
	attack_module.base_attack_speed = 0
	attack_module.base_attack_wind_up = 0
	attack_module.is_main_attack = false
	attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	attack_module.position.y -= attack_position_source_y_shift
	
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = 0
	
	attack_module.benefits_from_bonus_attack_speed = false
	attack_module.benefits_from_bonus_base_damage = false
	attack_module.benefits_from_bonus_on_hit_damage = false
	attack_module.benefits_from_bonus_on_hit_effect = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Accumulae_SiphonBeam01)
	beam_sprite_frame.add_frame("default", Accumulae_SiphonBeam02)
	beam_sprite_frame.add_frame("default", Accumulae_SiphonBeam03)
	beam_sprite_frame.add_frame("default", Accumulae_SiphonBeam04)
	beam_sprite_frame.add_frame("default", Accumulae_SiphonBeam05)
	beam_sprite_frame.add_frame("default", Accumulae_SiphonBeam06)
	beam_sprite_frame.add_frame("default", Accumulae_SiphonBeam07)
	beam_sprite_frame.add_frame("default", Accumulae_SiphonBeam08)
	beam_sprite_frame.add_frame("default", Accumulae_SiphonBeam09)
	beam_sprite_frame.add_frame("default", Accumulae_SiphonBeam10)
	beam_sprite_frame.set_animation_speed("default", 10 / 0.25)
	beam_sprite_frame.set_animation_loop("default", false)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.25
	attack_module.show_beam_regardless_of_state = true
	
	attack_module.can_be_commanded_by_tower = false
	
	attack_module.is_displayed_in_tracker = false
	
	siphon_attk_module = attack_module
	
	add_attack_module(attack_module)


func _construct_and_add_lob_attack_module():
	var proj_attack_module : ArcingBulletAttackModule = ArcingBulletAttackModule_Scene.instance()
	proj_attack_module.base_damage = 0
	proj_attack_module.base_damage_type = DamageType.ELEMENTAL
	proj_attack_module.base_attack_speed = 5
	proj_attack_module.base_attack_wind_up = 0
	proj_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_attack_module.is_main_attack = false
	proj_attack_module.base_pierce = 0
	proj_attack_module.base_proj_speed = 0.45
	proj_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	proj_attack_module.on_hit_damage_scale = 0
	
	proj_attack_module.benefits_from_bonus_base_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_damage = false
	proj_attack_module.benefits_from_bonus_on_hit_effect = false
	
	proj_attack_module.position.y -= attack_position_source_y_shift
	
	proj_attack_module.bullet_scene = ArcingBaseBullet_Scene
	proj_attack_module.set_texture_as_sprite_frame(Accumulae_BurstProj)
	
	proj_attack_module.max_height = 125
	proj_attack_module.bullet_rotation_per_second = 0
	
	proj_attack_module.connect("before_bullet_is_shot", self, "_modify_bullet_a", [], CONNECT_PERSIST)
	
	proj_attack_module.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(lob_attk_module_not_yet_casted_clause)
	
	proj_attack_module.is_displayed_in_tracker = false
	
	burst_lob_attk_module = proj_attack_module
	
	add_attack_module(proj_attack_module)


func _construct_and_add_spell_burst_explosion():
	var explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage = base_spell_burst_damage
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = false
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = false
	explosion_attack_module.benefits_from_bonus_on_hit_effect = true
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Accumulae_BurstExplosion01)
	sprite_frames.add_frame("default", Accumulae_BurstExplosion02)
	sprite_frames.add_frame("default", Accumulae_BurstExplosion03)
	sprite_frames.add_frame("default", Accumulae_BurstExplosion04)
	sprite_frames.add_frame("default", Accumulae_BurstExplosion05)
	sprite_frames.add_frame("default", Accumulae_BurstExplosion06)
	sprite_frames.add_frame("default", Accumulae_BurstExplosion07)
	sprite_frames.add_frame("default", Accumulae_BurstExplosion08)
	sprite_frames.add_frame("default", Accumulae_BurstExplosion09)
	
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = 4
	explosion_attack_module.duration = 0.32
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(SalvoBurst_AttackModule_Icon)
	
	spell_burst_attk_module = explosion_attack_module
	
	add_attack_module(explosion_attack_module)


#

func _construct_and_add_salvo_ability():
	salvo_ability = BaseAbility.new()
	
	salvo_ability.is_timebound = true
	
	salvo_ability.set_properties_to_usual_tower_based()
	salvo_ability.tower = self
	
	salvo_ability.connect("updated_is_ready_for_activation", self, "_can_cast_salvo_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(salvo_ability, false)


func _construct_enemy_siphon_effect():
	var modi : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.ACCUMULAE_SIPHON_DRAIN_EFFECT)
	modi.flat_modifier = base_enemy_ap_reduction_of_siphon
	
	enemy_siphon_ap_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_ABILITY_POTENCY, modi, StoreOfEnemyEffectsUUID.ACCUMULAE_SIPHON_DRAIN_EFFECT)
	enemy_siphon_ap_effect.time_in_seconds = enemy_siphon_effect_duration
	enemy_siphon_ap_effect.is_timebound = true
	enemy_siphon_ap_effect.is_from_enemy = false
	enemy_siphon_ap_effect.status_bar_icon = preload("res://TowerRelated/Color_Blue/Accumulae/AbilityAssets/Siphon_StatusBarIcon.png")

#func _construct_and_add_self_siphon_effect():
#	tower_siphon_ap_modi = FlatModifier.new(StoreOfTowerEffectsUUID.ACCUMULAE_SELF_SIPHON_BUFF)
#	
#	var siphon_effect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY, tower_siphon_ap_modi, StoreOfTowerEffectsUUID.ACCUMULAE_SELF_SIPHON_BUFF)
#	
#	add_tower_effect(siphon_effect)

#

func _construct_and_add_slot_bar():
	var siphon_bar = SiphonStacksBar_Scene.instance()
	
	add_infobar_control(siphon_bar)
	siphon_bar.siphon_bar.max_value = base_siphon_stacks_to_cast_salvo
	siphon_bar.siphon_bar.current_value = current_siphon_stacks
	siphon_bar.tower = self

#

func _on_main_attack_hit_enemy_a(enemy, damage_register_id, damage_instance, module):
	if !enemy._flat_base_ability_potency_effects.has(StoreOfEnemyEffectsUUID.ACCUMULAE_SIPHON_DRAIN_EFFECT):
		call_deferred("_attk_enemy_with_siphon", enemy)

func _attk_enemy_with_siphon(enemy):
	if is_instance_valid(enemy):
		siphon_attk_module.on_command_attack_enemies([enemy])
		enemy._add_effect(enemy_siphon_ap_effect)
		
		set_curr_siphon_stacks(current_siphon_stacks + 1)
		
		#tower_siphon_ap_modi.flat_modifier += base_ap_per_siphon_stack
		#_calculate_final_ability_potency()

#


func _can_cast_salvo_updated(can_cast):
	_can_cast_salvo_ability = can_cast
	_attempt_cast_salvo_ability()


func _attempt_cast_salvo_ability():
	if _can_cast_salvo_ability:
		if !is_in_salvo and current_siphon_stacks >= base_siphon_stacks_to_cast_salvo:
			_enter_in_salvo_mode()


func _enter_in_salvo_mode():
	salvo_ability.on_ability_before_cast_start(_get_cd_to_use(base_salvo_cooldown))
	
	is_in_salvo = true
	_attk_module_disabled_by_salvo_clause = main_attack_module
	if is_instance_valid(_attk_module_disabled_by_salvo_clause):
		_attk_module_disabled_by_salvo_clause.can_be_commanded_by_tower_other_clauses.attempt_insert_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.ACCUMULAE_DISABLE)


func _exit_in_salvo_mode():
	is_in_salvo = false
	if is_instance_valid(_attk_module_disabled_by_salvo_clause):
		_attk_module_disabled_by_salvo_clause.can_be_commanded_by_tower_other_clauses.remove_clause(AbstractAttackModule.CanBeCommandedByTower_ClauseId.ACCUMULAE_DISABLE)
	
	_attk_module_disabled_by_salvo_clause = null

#

func _process(delta):
	if is_in_salvo and salvo_delay_timer.time_left <= 0:
		_fire_single_burst_from_salvo()


func _fire_single_burst_from_salvo():
	var enemies = game_elements.enemy_manager.get_all_targetable_enemies()
	var choices = Targeting.enemies_to_target(enemies, Targeting.RANDOM, 1, global_position)
	
	if choices.size() > 0:
		burst_lob_attk_module.on_command_attack_enemies([choices[0]])
	
	
	salvo_delay_timer.start(_get_cd_to_use(base_delay_per_burst_in_salvo))
	
	set_curr_siphon_stacks(current_siphon_stacks - 1)
	if is_in_salvo and current_siphon_stacks <= 0:
		_exit_in_salvo_mode()
		
		var cd = _get_cd_to_use(base_salvo_cooldown)
		salvo_ability.start_time_cooldown(cd)
		salvo_ability.on_ability_after_cast_ended(cd)


#

func _modify_bullet_a(bullet : ArcingBaseBullet):
	bullet.connect("on_final_location_reached", self, "_on_lob_arcing_bullet_landed", [last_calculated_final_ability_potency], CONNECT_ONESHOT)
	
	#tower_siphon_ap_modi.flat_modifier -= base_ap_per_siphon_stack
	#if tower_siphon_ap_modi.flat_modifier <= 0:
	#	tower_siphon_ap_modi.flat_modifier = 0
	
	#_calculate_final_ability_potency()


func _on_lob_arcing_bullet_landed(arg_final_location : Vector2, bullet : ArcingBaseBullet, arg_ap_to_use : float):
	var explosion = spell_burst_attk_module.construct_aoe(arg_final_location, arg_final_location)
	explosion.damage_instance.scale_only_damage_by(arg_ap_to_use)
	explosion.scale *= 2.5
	
	spell_burst_attk_module.set_up_aoe__add_child_and_emit_signals(explosion)

#

func _on_round_end_a():
	#tower_siphon_ap_modi.flat_modifier = 0
	#_calculate_final_ability_potency()
	
	_exit_in_salvo_mode()
	set_curr_siphon_stacks(0)


#

func set_curr_siphon_stacks(new_amount : int):
	current_siphon_stacks = new_amount
	
	emit_signal("current_siphon_stacks_changed")
	_attempt_cast_salvo_ability()
