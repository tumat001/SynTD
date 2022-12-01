extends "res://EnemyRelated/EnemyTypes/Type_Skirmisher/AbstractSkirmisherEnemy.gd"


var _has_ascended : bool = false

const _ascender_armor_amount : float = 4.0
const _ascender_toughness_amount : float = 5.0
const _ascender_slow_flat_amount : float = -15.0
const _ascender_max_health_percent_amount : float = 120.0

const _health_ratio_threshold_for_ascend = 0.5
const _unit_offset_for_ascend : float = 0.5

const animation_normal_w_name = "Normal_W"
const animation_normal_e_name = "Normal_E"

const animation_ascended_w_name = "Ascended_W"
const animation_ascended_e_name = "Ascended_E"

const normal_dir_name_to_primary_rad_angle_map : Dictionary = {
	#dir_omni_name : PI / 2,
	#animation_normal_N_name : PI / 2,
	animation_normal_e_name : PI,
	#animation_normal_S_name : -PI / 2,
	animation_normal_w_name : 0,
}
const normal_dir_name_initial_hierarchy : Array = [
	animation_normal_e_name
]

const ascended_dir_name_to_primary_rad_angle_map : Dictionary = {
	#dir_omni_name : PI / 2,
	#dir_north_name : PI / 2,
	animation_ascended_e_name : PI,
	#dir_south_name : -PI / 2,
	animation_ascended_w_name : 0,
}
const ascended_dir_name_initial_hierarchy : Array = [
	animation_ascended_e_name
]


###########


func _init():
	_stats_initialize(EnemyConstants.get_enemy_info(EnemyConstants.Enemies.ASCENDER))
	
	_anim_face__custom_dir_name_to_primary_rad_angle_map = normal_dir_name_to_primary_rad_angle_map
	_anim_face__custom_anim_names_to_use = normal_dir_name_to_primary_rad_angle_map.keys()
	
	custom_anim_dir_w_name = animation_normal_w_name
	custom_anim_dir_e_name = animation_normal_e_name
	
	is_blue_and_benefits_from_ap = true

func _ready():
	connect("on_current_health_changed", self, "_on_curr_health_changed_a")
	connect("moved__from_process", self, "_on_moved_from_process_a")
	
	#_anim_face__custom_initial_dir_hierarchy = normal_dir_name_initial_hierarchy


func _on_curr_health_changed_a(arg_curr_health):
	if arg_curr_health / _last_calculated_max_health <= _health_ratio_threshold_for_ascend:
		if is_connected("on_current_health_changed", self, "_on_curr_health_changed_a"):
			disconnect("on_current_health_changed", self, "_on_curr_health_changed_a")
		if is_connected("moved__from_process", self, "_on_moved_from_process_a"):
			disconnect("moved__from_process", self, "_on_moved_from_process_a")
		
		_attempt_perform_ascend()

func _on_moved_from_process_a(arg_has_moved_from_natural_means, arg_prev_angle_dir, arg_curr_angle_dir):
	if unit_offset >= _unit_offset_for_ascend:
		if is_connected("on_current_health_changed", self, "_on_curr_health_changed_a"):
			disconnect("on_current_health_changed", self, "_on_curr_health_changed_a")
		if is_connected("moved__from_process", self, "_on_moved_from_process_a"):
			disconnect("moved__from_process", self, "_on_moved_from_process_a")
		
		_attempt_perform_ascend()

##

func _attempt_perform_ascend():
	if !_has_ascended:
		_perform_ascend()

func _perform_ascend():
	_has_ascended = true
	
	skirmisher_faction_passive.request_ascender_ascend_particle_to_play(global_position)
	
	custom_anim_dir_w_name = animation_ascended_w_name
	custom_anim_dir_e_name = animation_ascended_e_name
	_transform_dir_name_from_normal_to_ascended()
	anim_face_dir_component.update_dir_name_to_primary_rad_angle_map(ascended_dir_name_to_primary_rad_angle_map.keys(), ascended_dir_name_to_primary_rad_angle_map, ascended_dir_name_initial_hierarchy)
	
	_construct_and_add_effects()

func _transform_dir_name_from_normal_to_ascended():
	var current_dir_as_name = anim_face_dir_component.get_current_dir_as_name()
	if current_dir_as_name == animation_normal_e_name:
		anim_face_dir_component.set_current_dir_as_name(animation_ascended_e_name)
	elif current_dir_as_name == animation_normal_w_name:
		anim_face_dir_component.set_current_dir_as_name(animation_ascended_w_name)

func _construct_and_add_effects():
	var armor_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.ASCENDER_ARMOR_EFFECT)
	armor_modi.flat_modifier = _ascender_armor_amount * last_calculated_final_ability_potency
	var armor_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_ARMOR, armor_modi, StoreOfEnemyEffectsUUID.DEITY_ARMOR_EFFECT)
	armor_effect.is_from_enemy = true
	armor_effect.is_clearable = false
	
	var toughness_modi = FlatModifier.new(StoreOfEnemyEffectsUUID.ASCENDER_TOUGHNESS_EFFECT)
	toughness_modi.flat_modifier = _ascender_toughness_amount * last_calculated_final_ability_potency
	var toughness_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_TOUGHNESS, toughness_modi, StoreOfEnemyEffectsUUID.DEITY_TOUGHNESS_EFFECT)
	toughness_effect.is_from_enemy = true
	toughness_effect.is_clearable = false
	
	###
	var slow_modifier : FlatModifier = FlatModifier.new(StoreOfEnemyEffectsUUID.ASCENDER_SLOW_EFFECT)
	slow_modifier.flat_modifier = _ascender_slow_flat_amount
	
	var enemy_attr_eff : EnemyAttributesEffect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_MOV_SPEED, slow_modifier, StoreOfEnemyEffectsUUID.ASCENDER_SLOW_EFFECT)
	enemy_attr_eff.is_from_enemy = true
	enemy_attr_eff.is_clearable = false
	
	
	_add_effect(enemy_attr_eff)
	
	_add_effect(armor_effect)
	_add_effect(toughness_effect)
	
	###########
	
	var max_health_gain_modi = PercentModifier.new(StoreOfEnemyEffectsUUID.ASCENDER_MAX_HEALTH_GAIN_EFFECT)
	max_health_gain_modi.percent_amount = _ascender_max_health_percent_amount * last_calculated_final_ability_potency
	max_health_gain_modi.percent_based_on = PercentType.MAX
	
	var max_health_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_HEALTH, max_health_gain_modi, StoreOfEnemyEffectsUUID.ASCENDER_MAX_HEALTH_GAIN_EFFECT)
	max_health_effect.is_clearable = false
	max_health_effect.is_from_enemy = true
	
	_add_effect(max_health_effect)
