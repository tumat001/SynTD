extends "res://TowerRelated/AbstractTower.gd"


const Towers = preload("res://GameInfoRelated/Towers.gd")

const BulletAttackModule_Scene = preload("res://TowerRelated/Modules/BulletAttackModule.tscn")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const BaseBullet_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseBullet.tscn")

const AOEAttackModule_Scene = preload("res://TowerRelated/Modules/AOEAttackModule.tscn")
const BaseAOE_Scene = preload("res://TowerRelated/DamageAndSpawnables/BaseAOE.tscn")
const BaseAOEDefaultShapes = preload("res://TowerRelated/DamageAndSpawnables/BaseAOEDefaultShapes.gd")

const Reaper_NormalAttk_Pic01 = preload("res://TowerRelated/Color_Red/Reaper/Reaper_NormalAttk/Reaper_NormalAttk01.png")
const Reaper_NormalAttk_Pic02 = preload("res://TowerRelated/Color_Red/Reaper/Reaper_NormalAttk/Reaper_NormalAttk02.png")
const Reaper_NormalAttk_Pic03 = preload("res://TowerRelated/Color_Red/Reaper/Reaper_NormalAttk/Reaper_NormalAttk03.png")
const Reaper_NormalAttk_Pic04 = preload("res://TowerRelated/Color_Red/Reaper/Reaper_NormalAttk/Reaper_NormalAttk04.png")

const Reaper_SlashAttk_AOE_Scene = preload("res://TowerRelated/Color_Red/Reaper/Reaper_SlashAttk/Reaper_SlashAttk.tscn")
const Reaper_SlashAttk_AOE = preload("res://TowerRelated/Color_Red/Reaper/Reaper_SlashAttk/Reaper_SlashAttk.gd")

const ReaperSlash_AttackModule_Icon = preload("res://TowerRelated/Color_Red/Reaper/AMAssets/ReaperSlash_AttackModule_Icon.png")


const no_enemies_killed_clause : int = -10
const no_enemy_in_range_clause : int = -11
const slash_static_cooldown : float = 0.2

const slash_primary_damage_ratio : float = 3.0
const slash_subsequent_damage_ratio : float = 1.5

const slash_subsequent_dmg_reduction_duration : float = 0.5

var slash_attack_module : AOEAttackModule
var slash_ability : BaseAbility
var slash_ability_activation_clause : ConditionalClauses
var _current_slash_queue_count : int = 0
var current_slash_subsequent_dmg_reduction_duration : float

# Called when the node enters the scene tree for the first time.
func _ready():
	var info : TowerTypeInformation = Towers.get_tower_info(Towers.REAPER)
	
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
	range_module.position.y += 15
	range_module.position.x -= 8
	
	var attack_module : BulletAttackModule = BulletAttackModule_Scene.instance()
	attack_module.base_damage = info.base_damage
	attack_module.base_damage_type = info.base_damage_type
	attack_module.base_attack_speed = info.base_attk_speed
	attack_module.base_attack_wind_up = 0
	attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	attack_module.is_main_attack = true
	attack_module.base_pierce = info.base_pierce
	attack_module.base_proj_speed = 340 #210
	attack_module.base_proj_life_distance = info.base_range
	attack_module.module_id = StoreOfAttackModuleID.MAIN
	attack_module.on_hit_damage_scale = info.on_hit_multiplier
	attack_module.base_proj_inaccuracy = 5
	attack_module.position.y -= 15
	attack_module.position.x += 8
	
	var bullet_shape = CircleShape2D.new()
	bullet_shape.radius = 6
	
	attack_module.bullet_shape = bullet_shape
	attack_module.bullet_scene = BaseBullet_Scene
	
	var normal_attk_sprite := SpriteFrames.new()
	normal_attk_sprite.add_frame("default", Reaper_NormalAttk_Pic01)
	normal_attk_sprite.add_frame("default", Reaper_NormalAttk_Pic02)
	normal_attk_sprite.add_frame("default", Reaper_NormalAttk_Pic03)
	normal_attk_sprite.add_frame("default", Reaper_NormalAttk_Pic04)
	attack_module.bullet_sprite_frames = normal_attk_sprite
	attack_module.bullet_play_animation = true
	
	add_attack_module(attack_module)
	
	# slash
	
	slash_attack_module = AOEAttackModule_Scene.instance()
	slash_attack_module.base_damage = 0
	slash_attack_module.base_damage_type = DamageType.PHYSICAL
	slash_attack_module.base_attack_speed = 0
	slash_attack_module.base_attack_wind_up = 0
	slash_attack_module.base_on_hit_damage_internal_id = StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE
	slash_attack_module.is_main_attack = false
	slash_attack_module.module_id = StoreOfAttackModuleID.PART_OF_SELF
	
	slash_attack_module.benefits_from_bonus_explosion_scale = false
	slash_attack_module.benefits_from_bonus_base_damage = false #this is intended to be false
	slash_attack_module.benefits_from_bonus_attack_speed = false
	slash_attack_module.benefits_from_bonus_on_hit_damage = false
	slash_attack_module.benefits_from_bonus_on_hit_effect = false
	
	
	slash_attack_module.sprite_frames_only_play_once = true
	slash_attack_module.pierce = -1
	slash_attack_module.duration = slash_static_cooldown
	slash_attack_module.damage_repeat_count = 1
	
	
	slash_attack_module.base_aoe_scene = Reaper_SlashAttk_AOE_Scene
	slash_attack_module.spawn_location_and_change = AOEAttackModule.SpawnLocationAndChange.TO_ENEMY_FACING_AWAY_FROM_ORIGIN
	
	slash_attack_module.can_be_commanded_by_tower = false
	
	slash_attack_module.set_image_as_tracker_image(ReaperSlash_AttackModule_Icon)
	
	add_attack_module(slash_attack_module)
	
	
	#
	connect("on_any_post_mitigation_damage_dealt", self, "_on_post_miti_dmg_dealt_r", [], CONNECT_PERSIST)
	connect("on_round_end", self, "_on_round_end_r", [], CONNECT_PERSIST)
	
	connect("on_range_module_enemy_entered" , self, "_on_range_module_enemy_entered_r", [], CONNECT_PERSIST)
	connect("on_range_module_enemy_exited" , self, "_on_range_module_enemy_exited_r", [], CONNECT_PERSIST)
	
	
	_post_inherit_ready()


func _post_inherit_ready():
	_construct_and_add_effects()
	_construct_and_reg_ability()
	
	._post_inherit_ready()


func _construct_and_add_effects():
	var reap_dmg_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.REAPER_PERCENT_HEALTH_DAMAGE)
	reap_dmg_modifier.percent_amount = 6
	reap_dmg_modifier.percent_based_on = PercentType.MISSING
	reap_dmg_modifier.ignore_flat_limits = false
	reap_dmg_modifier.flat_maximum = 8
	reap_dmg_modifier.flat_minimum = 0
	
	var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.REAPER_PERCENT_HEALTH_DAMAGE, reap_dmg_modifier, DamageType.ELEMENTAL)
	
	var reap_dmg_effect = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.REAPER_PERCENT_HEALTH_DAMAGE)
	
	add_tower_effect(reap_dmg_effect)

func _construct_and_reg_ability():
	slash_ability = BaseAbility.new()
	
	slash_ability.is_timebound = true
	#slash_ability.connect("ability_activated", self, "_royal_flame_ability_activated", [], CONNECT_PERSIST)
	slash_ability.connect("updated_is_ready_for_activation", self, "_ready_for_activation_ability", [], CONNECT_PERSIST)
	
	slash_ability.set_properties_to_usual_tower_based()
	slash_ability.tower = self
	
	slash_ability_activation_clause = slash_ability.activation_conditional_clauses
	slash_ability_activation_clause.attempt_insert_clause(no_enemies_killed_clause)
	
	#slash_ability.auto_cast_func = "_cast_slash_ability"
	
	register_ability_to_manager(slash_ability, false)
	
	#slash_ability.auto_cast_on = true


func _on_range_module_enemy_entered_r(enemy, attk_module, range_module : RangeModule):
	if attk_module == main_attack_module:
		slash_ability_activation_clause.remove_clause(no_enemy_in_range_clause)

func _on_range_module_enemy_exited_r(enemy, attk_module, range_module : RangeModule):
	if attk_module == main_attack_module:
		if main_attack_module.range_module.enemies_in_range.size() == 0:
			slash_ability_activation_clause.attempt_insert_clause(no_enemy_in_range_clause)


func _on_post_miti_dmg_dealt_r(damage_instance_report, killed, enemy, damage_register_id, module):
	if killed:
		_current_slash_queue_count += 1
		slash_ability_activation_clause.remove_clause(no_enemies_killed_clause)


func _cast_slash_ability():
	var cd = _get_cd_to_use(slash_static_cooldown)
	slash_ability.on_ability_before_cast_start(cd)
	
	var ap_to_use : float = slash_ability.get_potency_to_use(last_calculated_final_ability_potency)
	call_deferred("_slash_at_enemy", ap_to_use)
	slash_ability.start_time_cooldown(cd)
	
	_current_slash_queue_count -= 1
	if _current_slash_queue_count <= 0:
		slash_ability_activation_clause.attempt_insert_clause(no_enemies_killed_clause)
		_current_slash_queue_count = 0
	
	slash_ability.on_ability_after_cast_ended(cd)

func _slash_at_enemy(potency_to_use : float):
	var enemies = main_attack_module.range_module.get_targets(1, Targeting.CLOSE)
	
	if enemies.size() != 0:
		var enemy = enemies[0]
		var slash_aoe = slash_attack_module.construct_aoe(slash_attack_module.global_position, enemy.global_position)
		var main_on_hit_dmg = slash_aoe.damage_instance.on_hit_damages[StoreOfTowerEffectsUUID.TOWER_MAIN_DAMAGE]
		
		var final_modi
		if current_slash_subsequent_dmg_reduction_duration <= 0:
			final_modi = main_attack_module.last_calculated_final_damage * slash_primary_damage_ratio
		else:
			final_modi = main_attack_module.last_calculated_final_damage * slash_subsequent_damage_ratio
		
		final_modi *= potency_to_use
		main_on_hit_dmg.damage_as_modifier.flat_modifier = final_modi
		
		
		slash_attack_module.set_up_aoe__add_child_and_emit_signals(slash_aoe)
		
		current_slash_subsequent_dmg_reduction_duration = slash_subsequent_dmg_reduction_duration



func _ready_for_activation_ability(val):
	if val:
		_cast_slash_ability()

#

func _on_round_end_r():
	_current_slash_queue_count = 0
	current_slash_subsequent_dmg_reduction_duration = 0
	
	slash_ability_activation_clause.attempt_insert_clause(no_enemies_killed_clause)
	slash_ability_activation_clause.attempt_insert_clause(no_enemy_in_range_clause)

#

func _process(delta):
	if is_round_started:
		current_slash_subsequent_dmg_reduction_duration -= delta


#

func set_heat_module(module):
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
