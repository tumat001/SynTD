extends "res://TowerRelated/AbstractTower.gd"

const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")
const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")

const WithBeamInstantDamageAttackModule = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.gd")
const WithBeamInstantDamageAttackModule_Scene = preload("res://TowerRelated/Modules/WithBeamInstantDamageAttackModule.tscn")
const BeamAesthetic_Scene = preload("res://MiscRelated/BeamRelated/BeamAesthetic.tscn")

const EnemyForcedPositionalMovementEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyForcedPositionalMovementEffect.gd")
const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")

const Shacked_ProjPic = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Bullet.png")

const Explosion03_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_03.png")
const Explosion04_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_04.png")
const Explosion05_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_05.png")
const Explosion06_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_06.png")
const Explosion07_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_07.png")
const Explosion08_pic = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_ProjExplosion_08.png")

const Chains_Pic01 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_01.png")
const Chains_Pic02 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_02.png")
const Chains_Pic03 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_03.png")
const Chains_Pic04 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_04.png")
const Chains_Pic05 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_05.png")
const Chains_Pic06 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_06.png")
const Chains_Pic07 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_07.png")
const Chains_Pic08 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_08.png")
const Chains_Pic09 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_09.png")
const Chains_Pic10 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_10.png")
const Chains_Pic11 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_11.png")
const Chains_Pic12 = preload("res://TowerRelated/Color_Violet/Shackled/Assets/Shackled_Chains/Shackled_Chains_12.png")

const ShackledBullet_AttackModule_Icon = preload("res://TowerRelated/Color_Violet/Shackled/Assets/AMAssets/ShackledBullet_AttackModule_Icon.png")
const ShackledExplosion_AttackModule_Icon = preload("res://TowerRelated/Color_Violet/Shackled/Assets/AMAssets/ShackledExplosion_AttackModule_Icon.png")

#

const aoe_base_damage : float = 0.9

var proj_aoe_attack_module : AOEAttackModule

#

const chains_time_taken_for_pull : float = 0.2
const chains_stun_duration : float = 0.5

const chains_base_ability_cooldown : float = 14.0
const chains_attk_count_needed : int = 18
const chains_post_mitigated_dmg_needed : float = 60.0

var _current_attk_count : int = 0
var _current_post_mitigated_dmg_total : float = 0

#

const chains_base_pull_amount : int = 2
const chains_base_pull_modi_id : int = -10

const chains_stage2_pull_amount : int = 2
const chains_stage2_pull_modi_id : int = -11

const chains_energy_module_pull_amount : int = 5
const chains_energy_module_modi_id : int = -12

var _chains_pull_amount_modifiers : Dictionary = {}
var _last_calculated_pull_amount : int

#

const rounds_before_stage2_pull : int = 3
var _current_round_count : int = 0

var _current_index_of_sframes_to_use : int = 0

#

var chains_attack_module : WithBeamInstantDamageAttackModule

var chains_ability : BaseAbility
var chains_ability_is_ready : bool = false

var chains_pos_rng = StoreOfRNG.get_rng(StoreOfRNG.RNGSource.SHACKLED_PULL_POSITION)
const chains_upper_pos_limit : float = 25.0 # adjust higher for more random positions

#

func _ready():
	var info = Towers.get_tower_info(Towers.SHACKLED)
	
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
	attack_module.base_proj_speed = 300 #250
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.position.y -= 10
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 4
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	attack_module.set_texture_as_sprite_frame(Shacked_ProjPic)
	
	attack_module.set_image_as_tracker_image(ShackledBullet_AttackModule_Icon)
	
	add_attack_module(attack_module)
	
	# AOE
	
	proj_aoe_attack_module = AOEAttackModule_Scene.instance()
	proj_aoe_attack_module.base_damage = aoe_base_damage
	proj_aoe_attack_module.base_damage_type = DamageType.ELEMENTAL
	proj_aoe_attack_module.base_attack_speed = 0
	proj_aoe_attack_module.base_attack_wind_up = 0
	proj_aoe_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	proj_aoe_attack_module.is_main_attack = false
	proj_aoe_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	proj_aoe_attack_module.benefits_from_bonus_explosion_scale = true
	proj_aoe_attack_module.benefits_from_bonus_base_damage = false
	proj_aoe_attack_module.benefits_from_bonus_attack_speed = false
	proj_aoe_attack_module.benefits_from_bonus_on_hit_damage = false
	proj_aoe_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_frame("default", Explosion03_pic)
	sprite_frames.add_frame("default", Explosion04_pic)
	sprite_frames.add_frame("default", Explosion05_pic)
	sprite_frames.add_frame("default", Explosion06_pic)
	sprite_frames.add_frame("default", Explosion07_pic)
	sprite_frames.add_frame("default", Explosion08_pic)
	
	proj_aoe_attack_module.aoe_sprite_frames = sprite_frames
	proj_aoe_attack_module.sprite_frames_only_play_once = true
	proj_aoe_attack_module.pierce = 3
	proj_aoe_attack_module.duration = 0.4
	proj_aoe_attack_module.damage_repeat_count = 1
	
	proj_aoe_attack_module.aoe_default_coll_shape = BaseAOEDefaultShapes.CIRCLE
	proj_aoe_attack_module.base_aoe_scene = BaseAOE_Scene
	proj_aoe_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.CENTERED_TO_ORIGIN
	
	proj_aoe_attack_module.can_be_commanded_by_tower = false
	
	proj_aoe_attack_module.set_image_as_tracker_image(ShackledExplosion_AttackModule_Icon)
	
	add_attack_module(proj_aoe_attack_module)
	
	#
	
	chains_attack_module = WithBeamInstantDamageAttackModule_Scene.instance()
	chains_attack_module.base_damage = 0
	chains_attack_module.base_damage_type = DamageType.ELEMENTAL
	chains_attack_module.base_attack_speed = 0
	chains_attack_module.base_attack_wind_up = 1.0 / 0.20
	chains_attack_module.is_main_attack = false
	chains_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	chains_attack_module.position.y -= 16
	chains_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	chains_attack_module.on_hit_damage_scale = info.on_hit_multiplier
	
	chains_attack_module.benefits_from_bonus_attack_speed = false
	chains_attack_module.benefits_from_bonus_base_damage = false
	chains_attack_module.benefits_from_bonus_on_hit_damage = false
	chains_attack_module.benefits_from_bonus_on_hit_effect = false
	
	var beam_sprite_frame : SpriteFrames = SpriteFrames.new()
	beam_sprite_frame.add_frame("default", Chains_Pic01)
	beam_sprite_frame.add_frame("default", Chains_Pic02)
	beam_sprite_frame.add_frame("default", Chains_Pic03)
	beam_sprite_frame.add_frame("default", Chains_Pic04)
	beam_sprite_frame.add_frame("default", Chains_Pic05)
	beam_sprite_frame.add_frame("default", Chains_Pic06)
	beam_sprite_frame.add_frame("default", Chains_Pic07)
	beam_sprite_frame.add_frame("default", Chains_Pic08)
	beam_sprite_frame.add_frame("default", Chains_Pic09)
	beam_sprite_frame.add_frame("default", Chains_Pic10)
	beam_sprite_frame.add_frame("default", Chains_Pic11)
	beam_sprite_frame.add_frame("default", Chains_Pic12)
	beam_sprite_frame.set_animation_loop("default", false)
	beam_sprite_frame.set_animation_speed("default", 12.0 / 0.2)
	
	chains_attack_module.commit_to_targets_of_windup = true
	chains_attack_module.fill_empty_windup_target_slots = false
	
	chains_attack_module.beam_scene = BeamAesthetic_Scene
	chains_attack_module.beam_sprite_frames = beam_sprite_frame
	chains_attack_module.beam_is_timebound = true
	chains_attack_module.beam_time_visible = 0.2
	chains_attack_module.show_beam_at_windup = true
	
	chains_attack_module.can_be_commanded_by_tower = false
	
	chains_attack_module.is_displayed_in_tracker = false
	
	add_attack_module(chains_attack_module)
	
	chains_attack_module.connect("on_enemy_hit", self, "_on_chains_hit_enemy", [], CONNECT_PERSIST)
	
	
	#
	
	connect("on_main_attack_module_enemy_hit", self, "_on_main_attack_enemy_hit_s", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_s", [], CONNECT_PERSIST)
	connect("on_main_attack_finished", self, "_on_main_attack_finished_s", [], CONNECT_PERSIST)
	
	connect("changed_anim_from_alive_to_dead", self, "_on_changed_anim_from_alive_to_dead", [], CONNECT_PERSIST)
	connect("changed_anim_from_dead_to_alive", self, "_on_changed_anim_from_dead_to_alive", [], CONNECT_PERSIST)
	
	set_pull_amount(chains_base_pull_modi_id, chains_base_pull_amount)
	
	#connect("on_tower_transfered_in_map_from_bench", self, "_todo_test_pull", [], CONNECT_PERSIST)
	
	#
	
	_construct_and_register_ability()
	
	_post_inherit_ready()


func _construct_and_register_ability():
	chains_ability = BaseAbility.new()
	
	chains_ability.is_timebound = true
	
	chains_ability.set_properties_to_usual_tower_based()
	chains_ability.tower = self
	
	chains_ability.connect("updated_is_ready_for_activation", self, "_can_cast_chains_from_ability_conditionals_updated", [], CONNECT_PERSIST)
	register_ability_to_manager(chains_ability, false)


#

func _on_main_attack_enemy_hit_s(enemy, damage_register_id, damage_instance, module):
	var aoe = proj_aoe_attack_module.construct_aoe(enemy.global_position, enemy.global_position)
	proj_aoe_attack_module.set_up_aoe__add_child_and_emit_signals(aoe)


func _on_round_end_s():
	if is_current_placable_in_map():
		_current_round_count += 1
		
		if _current_round_count >= rounds_before_stage2_pull:
			_ascend()
	
	_current_attk_count = 0
	_current_post_mitigated_dmg_total = 0


func _ascend():
	set_pull_amount(chains_stage2_pull_modi_id, chains_stage2_pull_amount)
	tower_base_sprites.frame = 1
	disconnect("on_round_end", self, "_on_round_end_s")
	
	_current_index_of_sframes_to_use = 1

# pull amount

func set_pull_amount(modi_id : int, amount : int):
	_chains_pull_amount_modifiers[modi_id] = amount
	_calculate_final_pull_amount_s()

func _calculate_final_pull_amount_s():
	var total : int = 0
	
	for amount in _chains_pull_amount_modifiers.values():
		total += amount
	
	_last_calculated_pull_amount = total


# pull conditionals

func _on_main_attack_finished_s(module):
	_current_attk_count += 1
	_attempt_cast_chains()

func _can_cast_chains_from_ability_conditionals_updated(can_cast : bool):
	chains_ability_is_ready = can_cast
	_attempt_cast_chains()

func _on_any_post_mitigated_dmg_dealt_s(damage_instance_report, killed, enemy, damage_register_id, module):
	_current_post_mitigated_dmg_total += damage_instance_report.get_total_post_mitigated_damage()
	_attempt_cast_chains()


func _attempt_cast_chains():
	if (_current_post_mitigated_dmg_total >= chains_post_mitigated_dmg_needed or _current_attk_count >= chains_attk_count_needed) and chains_ability_is_ready:
		var cd = _get_cd_to_use(chains_base_ability_cooldown)
		chains_ability.on_ability_before_cast_start(cd)
		
		_cast_chains_ability()
		
		_current_attk_count = 0
		_current_post_mitigated_dmg_total = 0
		chains_ability.start_time_cooldown(cd)
		chains_ability.on_ability_after_cast_ended(cd)


func _cast_chains_ability():
	var chains_targeting : int = Targeting.FIRST
	
	if is_instance_valid(range_module):
		chains_targeting = range_module.get_current_targeting_option()
	
	var enemies = _get_enemies_to_target(chains_targeting)
	chains_attack_module.on_command_attack_enemies_and_attack_when_ready(enemies, enemies.size(), 1, false)


func _get_enemies_to_target(arg_targeting : int) -> Array:
	var all_enemies = game_elements.enemy_manager.get_all_enemies()
	
	var sorted_enemies = Targeting.enemies_to_target(all_enemies, arg_targeting, all_enemies.size(), global_position)
	var bucket : Array = []
	
	for enemy in sorted_enemies:
		if !enemy.is_enemy_type_boss_or_elite():
			bucket.append(enemy)
			
			if bucket.size() >= _last_calculated_pull_amount:
				break
	
	return bucket

#

func _on_chains_hit_enemy(enemy, damage_register_id, damage_instance, module):
	_pull_enemy_towards_self_by_chains(enemy)

func _pull_enemy_towards_self_by_chains(enemy):
	var final_position = _get_final_position_for_enemy_pull(enemy.current_path.curve)
	
	var pull_effect = EnemyForcedPositionalMovementEffect.new(final_position, EnemyForcedPositionalMovementEffect.TIME_BASED_MOVEMENT_SPEED, true, StoreOfEnemyEffectsUUID.SHACKLED_CHAINS_PULL_EFFECT)
	pull_effect.time_in_seconds = chains_time_taken_for_pull
	
	var stun_effect = EnemyStunEffect.new(chains_stun_duration, StoreOfEnemyEffectsUUID.SHACKLED_CHAINS_STUN_EFFECT)
	
	enemy._add_effect(stun_effect)
	enemy._add_effect(pull_effect)
	
	

func _get_final_position_for_enemy_pull(arg_curve) -> Vector2:
	var source_location := _determine_random_source_location()
	
	var pos = arg_curve.get_closest_point(source_location)
	
	return pos

func _determine_random_source_location() -> Vector2:
	var rand_y : float = chains_pos_rng.randf_range(-chains_upper_pos_limit, chains_upper_pos_limit)
	var rand_x : float = chains_pos_rng.randf_range(-chains_upper_pos_limit, chains_upper_pos_limit)
	
	var new_pos = global_position
	new_pos += Vector2(rand_x, rand_y)
	
	return new_pos

#

func _on_changed_anim_from_alive_to_dead():
	tower_base_sprites.frame = _current_index_of_sframes_to_use

func _on_changed_anim_from_dead_to_alive():
	tower_base_sprites.frame = _current_index_of_sframes_to_use


# energy module related

func set_energy_module(module):
	.set_energy_module(module)
	
	if module != null:
		module.module_effect_descriptions = [
			"Shackled can pull an additional %s enemies at a time." % [str(chains_energy_module_pull_amount)]
		]


func _module_turned_on(_first_time_per_round : bool):
	set_pull_amount(chains_energy_module_modi_id, chains_energy_module_pull_amount)

func _module_turned_off():
	set_pull_amount(chains_energy_module_modi_id, 0)

#########################

#func _todo_test_pull(tower, arg_new_placable, arg_bench):
#	_cast_chains_ability()
