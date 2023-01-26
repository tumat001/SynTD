extends "res://EnemyRelated/AbstractEnemy.gd"

const RangeModule = preload("res://TowerRelated/Modules/RangeModule.gd")
const RangeModule_Scene = preload("res://TowerRelated/Modules/RangeModule.tscn")
const TowerDetectingRangeModule_Scene = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.tscn")
const TowerDetectingRangeModule = preload("res://EnemyRelated/TowerInteractingRelated/TowerInteractingModules/TowerDetectingRangeModule.gd")

const TowerPriorityTargetEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerPriorityTargetEffect.gd")
const TowerKnockUpEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerKnockUpEffect.gd")

const AbstractFaithfulEnemy = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/AbstractFaithfulEnemy.gd")


const ArmorToughness_StatusBarIcon = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/StatusBarIcons/Faithful_ArmorToughnessGain.png")
const HealthRegen_StatusBarIcon = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/StatusBarIcons/Faithful_HealthRegenGain.png")
const AP_StatusBarIcon = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/StatusBarIcons/Faithful_APGain.png")
const MaxHealhGain_StatusBarIcon = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/StatusBarIcons/Faithful_MaxHealthGain.png")

const KnockUp_CircleParticle = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/DeityAbilityAssets/Deity_KnockUp_Sprite.tscn")
const Taunt_CircleParticle = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/DeityAbilityAssets/Deity_Taunt_Sprite.tscn")

const DeitySprite_Form01_W = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Deity/Deity_W.png")
const DeitySprite_Form01_E = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Deity/Deity_E.png")

const DeitySprite_Form02_W = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Deity/Deity_W_02.png")
const DeitySprite_Form02_E = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/Deity/Deity_E_02.png")

#onready var Shader_DeityArmorToughness = preload("res://MiscRelated/ShadersRelated/Shader_DeityArmorToughness.shader")


#

enum PeriodicAbilities {
	
	KNOCK_UP_TOWERS,
	GRANT_REVIVE,
	TAUNT_TOWERS,
	
}
const NO_ABILITY_CASTED_YET : int = -1


const faithful_interaction_range_amount : float = 200.0
const tower_interaction_range_amount : float = 160.0

const base_armor_toughness_amount_per_faithful : float = 1.0
const base_health_regen_per_sec_per_sacrificer : float = 3.0#5.0
const base_ap_per_seer : float = 0.5
const base_health_gain_percent_from_cross_marker : float = 15.0

var faithfuls_in_range : int
var sacrificers_in_range : int
var seers_in_range : int

var armor_modi : FlatModifier
var toughness_modi : FlatModifier

var heal_modi : FlatModifier
var heal_effect : EnemyHealEffect

var ap_modi : FlatModifier
var ap_effect : EnemyAttributesEffect

var armor_modi_uuid : int
var heal_modi_uuid : int
var ap_modi_uuid : int


var _heal_timer : Timer
var _first_time_sacrificer_went_to_range : bool = false

var _heal_particle_from_sacrificer_timer : Timer
var _current_delta_per_heal_particle

#

var _time_stunlocked : float
const _base_time_stunlock_for_buff : float = 3.0
const _base_time_stunlock_expire_per_sec : float = 1.25
const _base_effect_immunity_duration : float = 5.0

var _self_effect_shield : EnemyEffectShieldEffect

#

var _current_cross_marker_unit_offset : float

var max_health_gain_modi : PercentModifier
var max_health_effect : EnemyAttributesEffect

#

var current_abilities_ids_ability_map = {}

var current_ability_rotation_cooldown_amount : float = 12.0
var rotation_ability : BaseAbility # ability that determines when abilities should be casted
var last_casted_ability_id : int = NO_ABILITY_CASTED_YET


var taunt_ability : BaseAbility
var taunt_ability_activation_clauses : ConditionalClauses
const taunt_duration : float = 8.0
var tower_target_priority_effect : TowerPriorityTargetEffect
const taunt_health_cast_threshold : float = 0.25


var grant_revive_ability : BaseAbility
var grant_revive_ability_activation_clauses : ConditionalClauses
const revive_target_count : int = 15
const revive_heal_amount : float = 50.0
const revive_delay : float = 3.0
const revive_duration : float = 15.0
var revive_effect : EnemyReviveEffect


var knock_up_towers_ability : BaseAbility
var knock_up_ability_activation_clauses : ConditionalClauses
const knock_up_duration : float = 1.25
const knock_up_stun_duration : float = 2.5
const knock_up_y_accel_amount : float = 40.0
var knock_up_effect : TowerKnockUpEffect

const knock_up_flat_damage_to_towers : float = 2.0

#

var range_module : RangeModule
var tower_detecting_range_module : TowerDetectingRangeModule


var no_tower_in_range_clause_id : int = -10
var no_enemy_in_range_clause_id : int = -11
var below_percent_health_threshold_clause_id : int = -12

#

#var current_armor_toughness_shader
#const shader_max_transparency : float = 0.7
#var _current_shader_transparency : float = 0
#
#const shader_blue_color := Color(0.1, 0, 0.85, 1)
#const shader_orange_color := Color(0.85, 0.32, 0, 1)

const _blue_eyes_max_mod_a : float = 0.5
var _blue_eyes_current_mod_a : float = 0

const _blue_eyes_max_scale : float = 2.4
var _blue_eyes_current_scale : float = 1.0

var _blue_eyes_w_pos : Vector2
var _blue_eyes_e_pos : Vector2


var _backhorn_w_pos : Vector2
var _backhorn_e_pos : Vector2

var _backhorn_w_h_flip : bool
var _backhorn_e_h_flip : bool


enum DeityFormId {
	FORM_01 = 1,
	FORM_02 = 2,
	FORM_03 = 3,
}

var current_deity_form : int setget set_current_deity_form

#

var faithful_faction_passive

#

onready var blue_eyes = $SpriteLayer/KnockUpLayer/BlueEyes
onready var back_horn = $SpriteLayer/KnockUpLayer/BackHorn

#

func _ready():
	#
	
	range_module = RangeModule_Scene.instance()
	range_module.base_range_radius = faithful_interaction_range_amount
	range_module.set_range_shape(CircleShape2D.new())
	range_module.clear_all_targeting()
	range_module.add_targeting_option(Targeting.CLOSE)
	range_module.set_current_targeting(Targeting.CLOSE)
	
	range_module.connect("enemy_entered_range", self, "_on_enemy_entered_range_d")
	range_module.connect("enemy_left_range", self, "_on_enemy_left_range_d")
	
	add_child(range_module)
	range_module.update_range()
	
	#
	
	tower_detecting_range_module = TowerDetectingRangeModule_Scene.instance()
	tower_detecting_range_module.can_display_range = false
	tower_detecting_range_module.detection_range = tower_interaction_range_amount
	
	tower_detecting_range_module.connect("on_tower_entered", self, "_on_tower_entered_range_d")
	tower_detecting_range_module.connect("on_tower_exited", self, "_on_tower_exited_range_d")
	
	add_child(tower_detecting_range_module)
	
	#
	
	#current_armor_toughness_shader = Shader_DeityArmorToughness
	#sprite_layer.material.shader = current_armor_toughness_shader
	
	blue_eyes.modulate.a = _blue_eyes_current_mod_a
	
	z_index = ZIndexStore.ENEMIES_ABOVE_TOWERS
	
	_construct_and_register_abilities()
	connect("final_ability_potency_changed", self, "_on_ability_potency_changed_d")
	connect("on_current_health_changed", self, "_on_curr_health_changed_d")
	
	connect("anim_name_used_changed", self, "_on_anim_name_used_changed_d")
	
	#
	
	_blue_eyes_w_pos = blue_eyes.position
	_blue_eyes_e_pos = Vector2(-blue_eyes.position.x, blue_eyes.position.y)
	_update_blue_eyes_properties()
	
	_backhorn_w_pos = back_horn.position
	_backhorn_e_pos = Vector2(-back_horn.position.x, back_horn.position.y)
	_backhorn_w_h_flip = back_horn.flip_h
	_backhorn_e_h_flip = !back_horn.flip_h
	
	set_current_deity_form(enemy_type_info_metadata[EnemyTypeInformation.TypeInfoMetadata.DEITY_FORM])


func _post_inherit_ready():
	._post_inherit_ready()
	
	_construct_and_add_effects()



func _construct_and_add_effects():
	armor_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.DEITY_ARMOR_EFFECT)
	var armor_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_ARMOR, armor_modi, StoreOfEnemyEffectsUUID.DEITY_ARMOR_EFFECT)
	armor_effect.is_from_enemy = true
	armor_effect.is_clearable = false
	armor_modi_uuid = StoreOfEnemyEffectsUUID.DEITY_ARMOR_EFFECT
	
	
	toughness_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.DEITY_TOUGHNESS_EFFECT)
	var toughness_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_TOUGHNESS, toughness_modi, StoreOfEnemyEffectsUUID.DEITY_TOUGHNESS_EFFECT)
	toughness_effect.is_from_enemy = true
	toughness_effect.is_clearable = false
	
	armor_effect = _add_effect(armor_effect)
	toughness_effect = _add_effect(toughness_effect)
	
	armor_modi = armor_effect.attribute_as_modifier
	toughness_modi = toughness_effect.attribute_as_modifier
	
	#
	
	heal_modi_uuid = StoreOfEnemyEffectsUUID.DEITY_HEALTH_REGEN_EFFECT
	heal_modi = FlatModifier.new(heal_modi_uuid)
	
	heal_effect = EnemyHealEffect.new(heal_modi, heal_modi_uuid)
	heal_effect.is_from_enemy = true
	
	_heal_timer = Timer.new()
	_heal_timer.one_shot = true
	add_child(_heal_timer)
	_heal_timer.connect("timeout", self, "_heal_timer_expired")
	
	_heal_particle_from_sacrificer_timer = Timer.new()
	_heal_particle_from_sacrificer_timer.one_shot = true
	add_child(_heal_particle_from_sacrificer_timer)
	_heal_particle_from_sacrificer_timer.connect("timeout", self, "_on_heal_particle_from_sacrificer_timer_timeout")
	
	#
	
	ap_modi_uuid = StoreOfEnemyEffectsUUID.DEITY_AP_EFFECT
	ap_modi = FlatModifier.new(ap_modi_uuid)
	
	ap_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_ABILITY_POTENCY, ap_modi, ap_modi_uuid)
	ap_effect.is_from_enemy = true
	ap_effect.is_clearable = false
	
	ap_effect = _add_effect(ap_effect)
	ap_modi = ap_effect.attribute_as_modifier
	
	#
	
	if !_if_surpassed_cross_marker():
		max_health_gain_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.DEITY_MAX_HEALTH_GAIN_EFFECT)
		max_health_gain_modi.percent_amount = base_health_gain_percent_from_cross_marker
		max_health_gain_modi.percent_based_on = PercentType.MAX
		
		max_health_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_HEALTH, max_health_gain_modi, StoreOfEnemyEffectsUUID.DEITY_MAX_HEALTH_GAIN_EFFECT)
		max_health_effect.is_clearable = false
		max_health_effect.is_from_enemy = true
		max_health_effect.status_bar_icon = MaxHealhGain_StatusBarIcon
		
		max_health_effect = _add_effect(max_health_effect)
	
	#
	
	tower_target_priority_effect = TowerPriorityTargetEffect.new(self, StoreOfTowerEffectsUUID.FAITHFUL_TAUNT_EFFECT)
	tower_target_priority_effect.is_from_enemy = true
	tower_target_priority_effect.time_in_seconds = taunt_duration
	tower_target_priority_effect.is_timebound = true
	tower_target_priority_effect.status_bar_icon = preload("res://EnemyRelated/EnemyTypes/Type_Faithful/_FactionAssets/StatusBarIcons/Deity_TauntIcon.png")
	
	#
	
	var rev_heal_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.DEITY_GRANTED_REVIVE_HEAL_EFFECT)
	rev_heal_modi.percent_amount = revive_heal_amount
	rev_heal_modi.percent_based_on = PercentType.MAX
	
	var rev_heal_effect = EnemyHealEffect.new(rev_heal_modi, StoreOfEnemyEffectsUUID.DEITY_GRANTED_REVIVE_HEAL_EFFECT)
	
	revive_effect = EnemyReviveEffect.new(rev_heal_effect, StoreOfEnemyEffectsUUID.DEITY_GRANTED_REVIVE_EFFECT, revive_delay)
	revive_effect.time_in_seconds = revive_duration
	revive_effect.is_timebound = true
	revive_effect.is_from_enemy = true
	
	#
	
	knock_up_effect = TowerKnockUpEffect.new(knock_up_duration, knock_up_y_accel_amount, StoreOfTowerEffectsUUID.FAITHFUL_KNOCK_UP_EFFECT)
	knock_up_effect.custom_stun_duration = knock_up_stun_duration
	knock_up_effect.is_from_enemy = true
	knock_up_effect.is_timebound = true


func _construct_and_register_abilities():
	rotation_ability = BaseAbility.new()
	
	rotation_ability.is_timebound = true
	rotation_ability._time_current_cooldown = current_ability_rotation_cooldown_amount / 2
	rotation_ability.connect("updated_is_ready_for_activation", self, "_on_rotation_ability_ready_updated")
	
	register_ability(rotation_ability)
	
	
	#
	taunt_ability = BaseAbility.new()
	
	taunt_ability.is_timebound = true
	
	register_ability(taunt_ability)
	
	taunt_ability_activation_clauses = taunt_ability.activation_conditional_clauses
	taunt_ability_activation_clauses.attempt_insert_clause(no_tower_in_range_clause_id)
	taunt_ability_activation_clauses.attempt_insert_clause(no_enemy_in_range_clause_id)
	current_abilities_ids_ability_map[PeriodicAbilities.TAUNT_TOWERS] = taunt_ability
	
	
	taunt_ability.auto_cast_func = "_cast_taunt_ability"
	
	#
	
	grant_revive_ability = BaseAbility.new()
	
	grant_revive_ability.is_timebound = true
	
	register_ability(grant_revive_ability)
	
	grant_revive_ability_activation_clauses = grant_revive_ability.activation_conditional_clauses
	grant_revive_ability_activation_clauses.attempt_insert_clause(no_enemy_in_range_clause_id)
	current_abilities_ids_ability_map[PeriodicAbilities.GRANT_REVIVE] = grant_revive_ability
	
	grant_revive_ability.auto_cast_func = "_cast_grant_revive_ability"
	
	#
	
	knock_up_towers_ability = BaseAbility.new()
	
	knock_up_towers_ability.is_timebound = true
	
	register_ability(knock_up_towers_ability)
	
	knock_up_ability_activation_clauses = knock_up_towers_ability.activation_conditional_clauses
	knock_up_ability_activation_clauses.attempt_insert_clause(no_tower_in_range_clause_id)
	current_abilities_ids_ability_map[PeriodicAbilities.KNOCK_UP_TOWERS] = knock_up_towers_ability
	
	knock_up_towers_ability.auto_cast_func = "_cast_knock_up_ability"
	

#

func _on_tower_entered_range_d(tower):
	taunt_ability_activation_clauses.remove_clause(no_tower_in_range_clause_id)
	knock_up_ability_activation_clauses.remove_clause(no_tower_in_range_clause_id)

func _on_tower_exited_range_d(tower):
	if tower_detecting_range_module.get_all_in_map_and_active_towers_in_range().size() > 0:
		taunt_ability_activation_clauses.remove_clause(no_tower_in_range_clause_id)
		knock_up_ability_activation_clauses.remove_clause(no_tower_in_range_clause_id)
	else:
		taunt_ability_activation_clauses.attempt_insert_clause(no_tower_in_range_clause_id)
		knock_up_ability_activation_clauses.attempt_insert_clause(no_tower_in_range_clause_id)


#

func _on_enemy_entered_range_d(enemy):
	if enemy is AbstractFaithfulEnemy:
		enemy.on_self_enter_deity_range(self)
		_increment_faithfuls_in_range_by(1)
		
		if enemy.enemy_id == EnemyConstants.Enemies.SACRIFICER:
			_increment_sacrificers_in_range_by(1)
		elif enemy.enemy_id == EnemyConstants.Enemies.SEER:
			_increment_seers_in_range_by(1)
		
		
		grant_revive_ability_activation_clauses.remove_clause(no_enemy_in_range_clause_id)
		taunt_ability_activation_clauses.remove_clause(no_enemy_in_range_clause_id)
		
		if !enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_faithful_killed_with_no_more_revives"):
			enemy.connect("on_killed_by_damage_with_no_more_revives", self, "_on_faithful_killed_with_no_more_revives", [])


func _on_faithful_killed_with_no_more_revives(damage_instance_report, arg_enemy):
	_on_enemy_left_range_d(arg_enemy)

func _on_enemy_left_range_d(enemy):
	if enemy is AbstractFaithfulEnemy:
		enemy.on_self_leave_deity_range(self)
		_increment_faithfuls_in_range_by(-1)
		
		if enemy.enemy_id == EnemyConstants.Enemies.SACRIFICER:
			_increment_sacrificers_in_range_by(-1)
		elif enemy.enemy_id == EnemyConstants.Enemies.SEER:
			_increment_seers_in_range_by(-1)
		
		
		if (range_module.enemies_in_range.size() - 1) > 0:
			grant_revive_ability_activation_clauses.remove_clause(no_enemy_in_range_clause_id)
			taunt_ability_activation_clauses.remove_clause(no_enemy_in_range_clause_id)
		else:
			grant_revive_ability_activation_clauses.attempt_insert_clause(no_enemy_in_range_clause_id)
			taunt_ability_activation_clauses.attempt_insert_clause(no_enemy_in_range_clause_id)
		
		if enemy.is_connected("on_killed_by_damage_with_no_more_revives", self, "_on_faithful_killed_with_no_more_revives"):
			enemy.disconnect("on_killed_by_damage_with_no_more_revives", self, "_on_faithful_killed_with_no_more_revives")


#

func _increment_faithfuls_in_range_by(arg_amount : int):
	faithfuls_in_range += arg_amount
	#_update_armor_toughness_shader()
	
	_update_armor_toughness_effect_from_faithfuls()

func _update_armor_toughness_effect_from_faithfuls():
	var amounts : float = base_armor_toughness_amount_per_faithful * faithfuls_in_range * last_calculated_final_ability_potency
	if faithfuls_in_range > 0:
		statusbar.add_status_icon(armor_modi_uuid, ArmorToughness_StatusBarIcon)
	else:
		statusbar.remove_status_icon(armor_modi_uuid)
	
	armor_modi.flat_modifier = amounts
	toughness_modi.flat_modifier = amounts
	
	calculate_final_armor()
	calculate_final_toughness()


#

func _increment_sacrificers_in_range_by(arg_amount : int):
	sacrificers_in_range += arg_amount
	
	_update_heal_effect_from_sacrificers()
	
	if !_first_time_sacrificer_went_to_range:
		_first_time_sacrificer_went_to_range = true
		_heal_timer_expired()
	
	if sacrificers_in_range > 0:
		_current_delta_per_heal_particle = 2 / sacrificers_in_range
		if _heal_particle_from_sacrificer_timer.time_left == 0:
			_heal_particle_from_sacrificer_timer.start(_current_delta_per_heal_particle)
	else:
		_heal_particle_from_sacrificer_timer.stop()

func _update_heal_effect_from_sacrificers():
	var amounts : float = base_health_regen_per_sec_per_sacrificer * sacrificers_in_range * last_calculated_final_ability_potency
	if sacrificers_in_range > 0:
		statusbar.add_status_icon(heal_modi_uuid, HealthRegen_StatusBarIcon)
	else:
		statusbar.remove_status_icon(heal_modi_uuid)
	
	heal_modi.flat_modifier = amounts

#

func _increment_seers_in_range_by(arg_amount : int):
	seers_in_range += arg_amount
	
	_update_ap_effect_from_seers()
	_update_blue_eyes_properties()

func _update_ap_effect_from_seers():
	var amounts : float = base_ap_per_seer * seers_in_range
	if seers_in_range > 0:
		statusbar.add_status_icon(ap_modi_uuid, AP_StatusBarIcon)
	else:
		statusbar.remove_status_icon(ap_modi_uuid)
	
	ap_modi.flat_modifier = amounts
	
	calculate_final_ability_potency()
	_on_ability_potency_changed_d(last_calculated_final_ability_potency)


#

func _on_ability_potency_changed_d(new_amount):
	_update_armor_toughness_effect_from_faithfuls()
	_update_heal_effect_from_sacrificers()
	
	revive_effect.heal_effect_upon_revival.heal_as_modifier.percent_amount = revive_heal_amount * last_calculated_final_ability_potency
	tower_target_priority_effect.time_in_seconds = taunt_duration * last_calculated_final_ability_potency
	
	knock_up_effect.time_in_seconds = knock_up_duration * last_calculated_final_ability_potency
	knock_up_effect.custom_stun_duration = knock_up_stun_duration * last_calculated_final_ability_potency
	knock_up_effect.knock_up_y_acceleration = knock_up_y_accel_amount * last_calculated_final_ability_potency


#

func _heal_timer_expired():
	if sacrificers_in_range > 0:
		_add_effect(heal_effect)
	
	_heal_timer.start(1)


#

func _on_rotation_ability_ready_updated(is_ready):
	if is_ready:
		var ability := _get_next_ready_ability()
		
		if ability != null:
			var cd = current_ability_rotation_cooldown_amount
			
			call(ability.auto_cast_func, cd)
			rotation_ability.start_time_cooldown(cd)
		else:
			rotation_ability.start_time_cooldown(1)


func _get_next_ready_ability() -> BaseAbility:
	var next_candidiate_id : int = _cycle_to_next_ability_id(last_casted_ability_id)
	var check_cycle_count : int = 0
	
	var ability : BaseAbility = null
	
	if current_abilities_ids_ability_map.size() != 0:
		ability = current_abilities_ids_ability_map[next_candidiate_id]
		while !ability.is_ready_for_activation():
			next_candidiate_id = _cycle_to_next_ability_id(next_candidiate_id)
			ability = current_abilities_ids_ability_map[next_candidiate_id]
			check_cycle_count += 1
			
			if check_cycle_count > current_abilities_ids_ability_map.size() + 1:
				break
	
	last_casted_ability_id = next_candidiate_id
	return ability

func _cycle_to_next_ability_id(curr_ability_id : int):
	curr_ability_id += 1
	
	if !current_abilities_ids_ability_map.has(curr_ability_id):
		curr_ability_id = 0
	
	return curr_ability_id


#

func _cast_taunt_ability(cooldown_amount : float):
	taunt_ability.on_ability_before_cast_start(cooldown_amount)
	
	for tower in tower_detecting_range_module.get_all_in_map_and_active_towers_in_range():
		if is_instance_valid(tower) and is_instance_valid(tower.range_module) and tower.range_module.is_an_enemy_in_range():
			tower.add_tower_effect(tower_target_priority_effect)
	
	_construct_taunt_particle()
	
	taunt_ability.on_ability_after_cast_ended(cooldown_amount)

func _construct_taunt_particle():
	var particle = Taunt_CircleParticle.instance()
	particle.position = global_position
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)


func _on_curr_health_changed_d(curr_health):
	if curr_health >= taunt_health_cast_threshold:
		taunt_ability_activation_clauses.remove_clause(below_percent_health_threshold_clause_id)
	else:
		taunt_ability_activation_clauses.attempt_insert_clause(below_percent_health_threshold_clause_id)


#

func _cast_grant_revive_ability(cooldown_amount : float):
	grant_revive_ability.on_ability_before_cast_start(cooldown_amount)
	
	var count = int(revive_target_count * last_calculated_final_ability_potency)
	if count <= 0:
		count = 1
	
	var enemies = range_module.get_targets_without_affecting_self_current_targets(count)
	
	for enemy in enemies:
		if enemy is AbstractFaithfulEnemy and enemy != self:
			enemy._add_effect(revive_effect)
	
	grant_revive_ability.on_ability_after_cast_ended(cooldown_amount)


#

func _cast_knock_up_ability(cooldown_amount : float):
	knock_up_towers_ability.on_ability_before_cast_start(cooldown_amount)
	
	for tower in tower_detecting_range_module.get_all_in_map_and_active_towers_in_range():
		if is_instance_valid(tower):
			tower.add_tower_effect(knock_up_effect)
			tower.take_damage(knock_up_flat_damage_to_towers, self)
	
	_construct_knock_up_particle()
	
	knock_up_towers_ability.on_ability_after_cast_ended(cooldown_amount)

func _construct_knock_up_particle():
	var particle = KnockUp_CircleParticle.instance()
	particle.position = global_position
	particle.z_index = ZIndexStore.PARTICLE_EFFECTS_BELOW_ENEMIES
	
	CommsForBetweenScenes.deferred_ge_add_child_to_other_node_hoster(particle)


#

func _process(delta): #changed from _phy_pro to _pro
	_remove_max_health_if_surpassed_cross_marker()
	
	if _is_stunned:
		_time_stunlocked += delta
		
		if _time_stunlocked >= _base_time_stunlock_for_buff:
			_time_stunlocked -= _base_time_stunlock_for_buff
			
			_time_stunlock_limit_reached()
	else:
		_time_stunlocked -= _base_time_stunlock_expire_per_sec * delta
		if _time_stunlocked < 0:
			_time_stunlocked = 0


func _remove_max_health_if_surpassed_cross_marker():
	if _if_surpassed_cross_marker() and _percent_base_health_id_effect_map.has(StoreOfEnemyEffectsUUID.DEITY_MAX_HEALTH_GAIN_EFFECT):
		_remove_effect(max_health_effect)

func _if_surpassed_cross_marker():
	return unit_offset >= _current_cross_marker_unit_offset

#

func _time_stunlock_limit_reached():
	if _self_effect_shield == null:
		_construct_self_effect_shield()
	
	_add_effect(_self_effect_shield)
	
	var all_stun_effects : Array = []
	for effect in _stun_id_effects_map.values():
		if !effect.is_from_enemy:
			all_stun_effects.append(effect)
	
	for effect in all_stun_effects:
		_remove_effect(effect)


func _construct_self_effect_shield() :
	_self_effect_shield = EnemyEffectShieldEffect.new(StoreOfEnemyEffectsUUID.DEITY_SELF_EFFECT_SHIELD_EFFECT, _base_effect_immunity_duration)
	_self_effect_shield.is_from_enemy = true
	_self_effect_shield.status_bar_icon = preload("res://EnemyRelated/CommonStatusBarIcons/EffectShieldEffect/EffectShieldEffect_StatusBarIcon.png")


##############

func _on_anim_name_used_changed_d(arg_prev_name, arg_curr_name):
	if arg_curr_name != arg_prev_name:
		if arg_curr_name == "W":
			blue_eyes.position = _blue_eyes_w_pos
			back_horn.position = _backhorn_w_pos
			back_horn.flip_h = _backhorn_w_h_flip
			
		elif arg_curr_name == "E":
			blue_eyes.position = _blue_eyes_e_pos
			back_horn.position = _backhorn_e_pos
			back_horn.flip_h = _backhorn_e_h_flip
			

##

func _on_heal_particle_from_sacrificer_timer_timeout():
	if sacrificers_in_range > 0:
		_heal_particle_from_sacrificer_timer.start(_current_delta_per_heal_particle)
		faithful_faction_passive.request_play_heal_particle_from_sacrificers(global_position)
		

##

#func _update_armor_toughness_shader():
#	var ratio = (faithfuls_in_range / 1) #40)
#	if ratio > 1:
#		ratio = 1
#
#	_current_shader_transparency = shader_max_transparency * ratio
#
#	var blob_blue_color = shader_blue_color
#	blob_blue_color.a = _current_shader_transparency
#
#	var blob_orange_color = shader_orange_color
#	blob_orange_color.a = _current_shader_transparency
#
#	sprite_layer.material.set_shader_param("blob_top", blob_blue_color)
#	sprite_layer.material.set_shader_param("blob_bottom", blob_orange_color)
#
#	#sprite_layer.material.set_shader_param("background_edge", bg_color)
#	#sprite_layer.material.set_shader_param("background_center", bg_color)


func _update_blue_eyes_properties():
	var ratio : float = seers_in_range / 7.0
	if ratio > 1:
		ratio = 1
	
	_blue_eyes_current_mod_a = _blue_eyes_max_mod_a * ratio
	_blue_eyes_current_scale = _blue_eyes_max_scale * ratio
	
	blue_eyes.modulate.a = _blue_eyes_current_mod_a
	blue_eyes.scale = Vector2(_blue_eyes_current_scale, _blue_eyes_current_scale)

#

func set_current_deity_form(arg_id):
	current_deity_form = arg_id
	
	var w_anim_name : String = AnimFaceDirComponent.dir_west_name
	var e_anim_name : String = AnimFaceDirComponent.dir_east_name
	
	if current_deity_form == DeityFormId.FORM_01:
		anim_sprite.frames.set_frame(w_anim_name, 0, DeitySprite_Form01_W)
		anim_sprite.frames.set_frame(e_anim_name, 0, DeitySprite_Form01_E)
		back_horn.visible = false
		
	elif current_deity_form == DeityFormId.FORM_02:
		anim_sprite.frames.set_frame(w_anim_name, 0, DeitySprite_Form02_W)
		anim_sprite.frames.set_frame(e_anim_name, 0, DeitySprite_Form02_E)
		back_horn.visible = false
		
	elif current_deity_form == DeityFormId.FORM_03:
		anim_sprite.frames.set_frame(w_anim_name, 0, DeitySprite_Form02_W)
		anim_sprite.frames.set_frame(e_anim_name, 0, DeitySprite_Form02_E)
		back_horn.visible = true
		

