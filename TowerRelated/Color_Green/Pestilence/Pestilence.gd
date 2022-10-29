extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")
const BeamAesthetic = preload("res://MiscRelated/BeamRelated/BeamAesthetic.gd")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const Pestilence_NormalAttk01 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_NormalAttk/Pestilence_NormalAttk_01.png")
const Pestilence_NormalAttk02 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_NormalAttk/Pestilence_NormalAttk_02.png")
const Pestilence_NormalAttk03 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_NormalAttk/Pestilence_NormalAttk_03.png")
const Pestilence_NormalAttk04 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_NormalAttk/Pestilence_NormalAttk_04.png")
const Pestilence_NormalAttk05 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_NormalAttk/Pestilence_NormalAttk_05.png")
const Pestilence_NormalAttk06 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_NormalAttk/Pestilence_NormalAttk_06.png")
const Pestilence_NormalAttk07 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_NormalAttk/Pestilence_NormalAttk_07.png")
const Pestilence_NormalAttk08 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_NormalAttk/Pestilence_NormalAttk_08.png")
const Pestilence_NormalAttk09 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_NormalAttk/Pestilence_NormalAttk_09.png")

const Pestilence_SkyAttk01 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_AirAttk/Pestilence_AirAttk_01.png")
const Pestilence_SkyAttk02 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_AirAttk/Pestilence_AirAttk_02.png")
const Pestilence_SkyAttk03 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_AirAttk/Pestilence_AirAttk_03.png")
const Pestilence_SkyAttk04 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_AirAttk/Pestilence_AirAttk_04.png")
const Pestilence_SkyAttk05 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_AirAttk/Pestilence_AirAttk_05.png")
const Pestilence_SkyAttk06 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_AirAttk/Pestilence_AirAttk_06.png")
const Pestilence_SkyAttk07 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_AirAttk/Pestilence_AirAttk_07.png")
const Pestilence_SkyAttk08 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_AirAttk/Pestilence_AirAttk_08.png")

const Pestilence_Explosion01 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_ExplosionAttk/Pestilence_Explosion01.png")
const Pestilence_Explosion02 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_ExplosionAttk/Pestilence_Explosion02.png")
const Pestilence_Explosion03 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_ExplosionAttk/Pestilence_Explosion03.png")
const Pestilence_Explosion04 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_ExplosionAttk/Pestilence_Explosion04.png")
const Pestilence_Explosion05 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_ExplosionAttk/Pestilence_Explosion05.png")
const Pestilence_Explosion06 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_ExplosionAttk/Pestilence_Explosion06.png")
const Pestilence_Explosion07 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_ExplosionAttk/Pestilence_Explosion07.png")
const Pestilence_Explosion08 = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_ExplosionAttk/Pestilence_Explosion08.png")

const Pestilence_Noxious_StatusIcon = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Attks/Pestilence_Noxious_Icon.png")

const PestilenceExplosion_AttackModule_Icon = preload("res://TowerRelated/Color_Green/Pestilence/AMAssets/PestilenceExplosion_AttackModule_Icon.png")

const EnemyDmgOverTimeEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyDmgOverTimeEffect.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")

const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")
const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")


var enemy_noxious_effect : EnemyStackEffect

const sky_attack_y_shift : float = -100.0
const sky_attack_toxin_stack_threshold : int = 10
const base_sky_attack_delay : float = 0.15
var current_sky_attack_delay : float = base_sky_attack_delay

const num_of_sky_attacks : int = 6

var rng_pestilence_spread : RandomNumberGenerator
var lower_bound_spread : float = -40
var upper_bound_spread : float = 40

var explosion_attack_module : AOEAttackModule

var tower_detecting_range_module : TowerDetectingRangeModule
var leeched_towers : Array = []

var leech_debuff_effect : TowerAttributesEffect
var leech_buff_self_effect : TowerAttributesEffect
var leech_buff_self_modifier : PercentModifier
const base_leech_buff_per_tower : float = 35.0
const base_leech_debuff_tower : float = -25.0


# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.PESTILENCE)
	
	tower_id = info.tower_type_id
	tower_highlight_sprite = info.tower_image_in_buy_card
	tower_image_icon_atlas_texture = info.tower_atlased_image
	_tower_colors = info.colors
	_base_gold_cost = info.tower_cost
	ingredient_of_self = info.ingredient_effect
	tower_type_info = info
	
	_initialize_stats_from_tower_info(info)
	
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.detection_range = info.base_range
	tower_detecting_range_module.can_display_range = false
	add_child(tower_detecting_range_module)
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = info.base_range
	range_module.set_terrain_scan_shape(CircleShape2D.new())
	range_module.position.y += 24
	
	var attack_module : WithBeamInstantDamageAttackModule = WithBeamInstantDamageAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 1 / 0.15
	attack_module.is_main_attack = true
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 24
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	attack_module.commit_to_targets_of_windup = true
	attack_module.fill_empty_windup_target_slots = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Pestilence_NormalAttk01)
	beam_sprite_frame.add_frame("default", Pestilence_NormalAttk02)
	beam_sprite_frame.add_frame("default", Pestilence_NormalAttk03)
	beam_sprite_frame.add_frame("default", Pestilence_NormalAttk04)
	beam_sprite_frame.add_frame("default", Pestilence_NormalAttk05)
	beam_sprite_frame.add_frame("default", Pestilence_NormalAttk06)
	beam_sprite_frame.add_frame("default", Pestilence_NormalAttk07)
	beam_sprite_frame.add_frame("default", Pestilence_NormalAttk08)
	beam_sprite_frame.add_frame("default", Pestilence_NormalAttk09)
	beam_sprite_frame.set_animation_speed("default", 9 / 0.15)
	beam_sprite_frame.set_animation_loop("default", false)
	
	attack_module.beam_scene = BeamAesthetic_Scene
	attack_module.beam_sprite_frames = beam_sprite_frame
	attack_module.beam_is_timebound = true
	attack_module.beam_time_visible = 0.15
	
	attack_module.show_beam_at_windup = true
	attack_module.show_beam_regardless_of_state = true
	
	add_attack_module(attack_module)
	
	
	# explosion
	
	explosion_attack_module = AOEAttackModule_Scene.instance()
	explosion_attack_module.base_damage_scale = 0.35
	explosion_attack_module.base_damage = 3 / explosion_attack_module.base_damage_scale
	explosion_attack_module.base_damage_type = DamageType.ELEMENTAL
	explosion_attack_module.base_attack_speed = 0
	explosion_attack_module.base_attack_wind_up = 0
	explosion_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	explosion_attack_module.is_main_attack = false
	explosion_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	explosion_attack_module.on_hit_damage_scale = 0.35
	explosion_attack_module.on_hit_effect_scale = 1.0
	
	explosion_attack_module.benefits_from_bonus_explosion_scale = true
	explosion_attack_module.benefits_from_bonus_base_damage = true
	explosion_attack_module.benefits_from_bonus_attack_speed = false
	explosion_attack_module.benefits_from_bonus_on_hit_damage = true
	explosion_attack_module.benefits_from_bonus_on_hit_effect = true
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Pestilence_Explosion01)
	sprite_frames.add_frame("default", Pestilence_Explosion02)
	sprite_frames.add_frame("default", Pestilence_Explosion03)
	sprite_frames.add_frame("default", Pestilence_Explosion04)
	sprite_frames.add_frame("default", Pestilence_Explosion05)
	sprite_frames.add_frame("default", Pestilence_Explosion06)
	sprite_frames.add_frame("default", Pestilence_Explosion07)
	sprite_frames.add_frame("default", Pestilence_Explosion08)
	
	explosion_attack_module.aoe_sprite_frames = sprite_frames
	explosion_attack_module.sprite_frames_only_play_once = true
	explosion_attack_module.pierce = 3
	explosion_attack_module.duration = 0.15
	explosion_attack_module.damage_repeat_count = 1
	
	explosion_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	explosion_attack_module.base_aoe_scene = BaseAOE_Scene
	explosion_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ENEMY
	
	explosion_attack_module.can_be_commanded_by_tower = false
	
	explosion_attack_module.set_image_as_tracker_image(PestilenceExplosion_AttackModule_Icon)
	
	add_attack_module(explosion_attack_module)
	
	
	# others
	
	rng_pestilence_spread = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.PESTILENCE_SPREAD)
	connect("on_main_attack" , self, "_on_main_attack_p", [], CONNECT_PERSIST)
	connect("on_any_attack_module_enemy_hit", self, "_on_any_attack_hit_enemy_p", [], CONNECT_PERSIST)
	connect("final_range_changed", self, "_main_final_range_changed_p", [], CONNECT_PERSIST)
	
	connect("tower_active_in_map", self, "_on_self_placed_in_map", [], CONNECT_PERSIST)
	connect("on_round_start", self, "_on_round_started_p", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_p", [], CONNECT_PERSIST)
	
	
	
	_post_inherit_ready()


func _post_inherit_ready():
	._post_inherit_ready()
	
	# psn effect
	var psn_dmg : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.PESTILENCE_POISON)
	psn_dmg.flat_modifier = 2
	
	var psn_on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.PESTILENCE_POISON, psn_dmg, DamageType.ELEMENTAL)
	var psn_dmg_instance = DamageInstance.new()
	psn_dmg_instance.on_hit_damages[psn_on_hit.internal_id] = psn_on_hit
	
	var psn_effect = EnemyDmgOverTimeEffect.new(psn_dmg_instance, StoreOfEnemyEffectsUUID.PESTILENCE_POISON, 1)
	psn_effect.is_timebound = false
	psn_effect.effect_source_ref = self
	
	var tower_effect = TowerOnHitEffectAdderEffect.new(psn_effect, StoreOfTowerEffectsUUID.PESTILENCE_POISON)
	
	add_tower_effect(tower_effect)
	
	
	# toxin stack
	var enemy_toxin_effect = EnemyStackEffect.new(null, 1, 9999, StoreOfEnemyEffectsUUID.PESTILENCE_TOXIN, true, false)
	enemy_toxin_effect.is_timebound = true
	enemy_toxin_effect.time_in_seconds = 8
	var tower_toxin_effect = TowerOnHitEffectAdderEffect.new(enemy_toxin_effect, StoreOfTowerEffectsUUID.PESTILENCE_TOXIN)
	
	
	add_tower_effect(tower_toxin_effect)
	
	enemy_noxious_effect = EnemyStackEffect.new(null, 0, 9999, StoreOfEnemyEffectsUUID.PESTILENCE_NOXIOUS, true, false)
	enemy_noxious_effect._current_stack = 1
	enemy_noxious_effect.status_bar_icon = Pestilence_Noxious_StatusIcon
	
	
	# leech effects
	var leech_debuff_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.PESTILENCE_TOWER_LEECH_DEBUFF)
	leech_debuff_modi.percent_based_on = PercentType.BASE
	leech_debuff_modi.percent_amount = base_leech_debuff_tower
	
	leech_debuff_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, leech_debuff_modi, StoreOfTowerEffectsUUID.PESTILENCE_TOWER_LEECH_DEBUFF)
	leech_debuff_effect.is_timebound = false
	
	
	leech_buff_self_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.PESTILENCE_TOWER_LEECH_BUFF)
	leech_buff_self_modifier.percent_based_on = PercentType.BASE
	leech_buff_self_modifier.percent_amount = 0
	
	leech_buff_self_effect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, leech_buff_self_modifier, StoreOfTowerEffectsUUID.PESTILENCE_TOWER_LEECH_BUFF)
	leech_buff_self_effect.is_timebound = false
	add_tower_effect(leech_buff_self_effect)


func _on_main_attack_p(attk_speed_delay, enemies, module):
	if enemies.size() != 0:
		var enemy = enemies[0]
		
		if is_instance_valid(enemy):
			if enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.PESTILENCE_NOXIOUS):
				_execute_air_attack(enemy.global_position)


func _on_any_attack_hit_enemy_p(enemy, damage_register_id, damage_instance, module):
	if enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.PESTILENCE_TOXIN):
		var stacks = enemy._stack_id_effects_map[StoreOfEnemyEffectsUUID.PESTILENCE_TOXIN]._current_stack
		if stacks >= sky_attack_toxin_stack_threshold - 1:
			_give_noxious_effect_to_enemy(enemy)

func _give_noxious_effect_to_enemy(enemy):
	if !enemy._stack_id_effects_map.has(StoreOfEnemyEffectsUUID.PESTILENCE_NOXIOUS):
		enemy._add_effect(enemy_noxious_effect)


# Air attack

func _execute_air_attack(center_pos : Vector2):
	for i in num_of_sky_attacks:
		var random_pos = center_pos + Vector2(rng_pestilence_spread.randf_range(lower_bound_spread, upper_bound_spread), rng_pestilence_spread.randf_range(lower_bound_spread, upper_bound_spread))
		var beam = _construct_air_beam(random_pos, true)
		
		call_deferred("_add_beam_to_tree", beam)



func _construct_air_beam(pos : Vector2, emit_when_time_over : bool = true) -> BeamAesthetic:
	var beam : BeamAesthetic = BeamAesthetic_Scene.instance()
	beam.is_timebound = true
	beam.time_visible = current_sky_attack_delay
	beam.visible = false
	
	var sf = SpriteFrames.new()
	sf.add_frame("default", Pestilence_SkyAttk01)
	sf.add_frame("default", Pestilence_SkyAttk02)
	sf.add_frame("default", Pestilence_SkyAttk03)
	sf.add_frame("default", Pestilence_SkyAttk04)
	sf.add_frame("default", Pestilence_SkyAttk05)
	sf.add_frame("default", Pestilence_SkyAttk06)
	sf.add_frame("default", Pestilence_SkyAttk07)
	sf.add_frame("default", Pestilence_SkyAttk08)
	sf.set_animation_speed("default", 8 / current_sky_attack_delay)
	sf.set_animation_loop("default", false)
	
	beam.set_sprite_frames(sf)
	
	beam.queue_free_if_time_over = true
	if emit_when_time_over:
		beam.connect("time_visible_is_over", self, "_beam_time_over", [beam], CONNECT_ONESHOT)
	
	beam.global_position = pos
	beam.play("default", true)
	
	return beam

func _add_beam_to_tree(beam : BeamAesthetic):
	#get_tree().get_root().add_child(beam)
	CommsForBetweenScenes.ge_add_child_to_other_node_hoster(beam)
	beam.update_destination_position(beam.global_position + Vector2(0, sky_attack_y_shift))


# Explosion related

func _beam_time_over(beam : BeamAesthetic):
	_summon_explosion(beam.global_position)


func _summon_explosion(pos : Vector2):
	var explosion = explosion_attack_module.construct_aoe(pos, pos)
	
	explosion_attack_module.set_up_aoe__add_child_and_emit_signals(explosion)


# Attack Speed Leaching related ------------------

func _main_final_range_changed_p():
	tower_detecting_range_module.detection_range = main_attack_module.range_module.last_calculated_final_range


func _on_round_started_p():
	if is_current_placable_in_map():
		_activate_leech()

func _on_self_placed_in_map():
	if is_round_started:
		_activate_leech()


func _activate_leech():
	for tower in tower_detecting_range_module.get_all_in_map_towers_in_range():
		_give_tower_debuff(tower)
		leeched_towers.append(tower)
	
	_update_self_buff_from_leeching()


func _give_tower_debuff(tower):
	tower.add_tower_effect(leech_debuff_effect._shallow_duplicate())

func _update_self_buff_from_leeching():
	var num_of_leeched = leeched_towers.size()
	
	leech_buff_self_modifier.percent_amount = base_leech_buff_per_tower * num_of_leeched
	for am in all_attack_modules:
		am.calculate_all_speed_related_attributes()
	_emit_final_attack_speed_changed()


func _on_round_end_p():
	for tower in leeched_towers:
		if is_instance_valid(tower):
			_remove_debuff_from_tower(tower)
	
	leeched_towers.clear()
	_update_self_buff_from_leeching()


func _remove_debuff_from_tower(tower):
	tower.remove_tower_effect(leech_debuff_effect)


#

func toggle_module_ranges():
	.toggle_module_ranges()
	
	if is_showing_ranges:
		if current_placable is InMapAreaPlacable:
			_on_tower_show_range()
	else:
		_on_tower_hide_range()

func _on_tower_show_range():
	tower_detecting_range_module.glow_all_towers_in_range()

func _on_tower_hide_range():
	tower_detecting_range_module.unglow_all_towers_in_range()
