extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

const Modifier = preload("res://GameInfoRelated/Modifier.gd")

const base_damage_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_BaseDamageIncrease.png")
const atk_speed_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_AtkSpeedIncrease.png")
const range_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_RangeIncrease.png")
const pierce_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Pierce.png")
const proj_speed_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_ProjSpeed.png")
const explosion_size_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_ExplosionSizeIncrease.png")
const ability_power_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_AbilityPower.png")
const ability_cdr_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_AbilityCDR.png")
const health_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Health.png")

enum {
	FLAT_BASE_DAMAGE_BONUS,
	PERCENT_BASE_DAMAGE_BONUS,
	
	FLAT_ATTACK_SPEED,
	PERCENT_BASE_ATTACK_SPEED,
	
	FLAT_PIERCE,
	PERCENT_BASE_PIERCE,
	
	FLAT_RANGE,
	PERCENT_BASE_RANGE,
	
	FLAT_PROJ_SPEED,
	PERCENT_BASE_PROJ_SPEED,
	
	FLAT_EXPLOSION_SCALE,
	PERCENT_BASE_EXPLOSION_SCALE, # Includes aoe beam width
	
	FLAT_ARMOR_PIERCE,
	
	FLAT_TOUGHNESS_PIERCE,
	
	FLAT_RESISTANCE_PIERCE,
	
	FLAT_ABILITY_POTENCY,
	PERCENT_ABILITY_POTENCY,
	
	FLAT_ABILITY_CDR
	PERCENT_ABILITY_CDR,
	
	FLAT_HEALTH,
	PERCENT_BASE_HEALTH,
	
	FLAT_OMNIVAMP,
	PERCENT_DAMAGE_OMNIVAMP,
	
	FLAT_ENEMY_EFFECT_VULNERABILITY,
	PERCENT_ENEMY_EFFECT_VULNERABILITY
	
	# PUT OTHER CUSTOM THINGS HERE
}

var attribute_type : int
var attribute_as_modifier : Modifier

func _init(arg_attribute_type : int, arg_modifier,
		arg_effect_uuid : int).(EffectType.ATTRIBUTES,
		arg_effect_uuid):
	
	attribute_type = arg_attribute_type
	attribute_as_modifier = arg_modifier
	description = _get_description()
	effect_icon = _get_icon()
	
	attribute_as_modifier.internal_id = arg_effect_uuid
	
	_can_be_scaled_by_yel_vio = true


# Description Related

func _get_description() -> String:
#	if description != null and description != "":
#		return description
#
	if attribute_type == FLAT_BASE_DAMAGE_BONUS:
		return _generate_flat_description("base dmg")
	elif attribute_type == PERCENT_BASE_DAMAGE_BONUS:
		return _generate_percent_description("dmg")
	elif attribute_type == FLAT_ATTACK_SPEED:
		return _generate_flat_description("bonus attk speed")
	elif attribute_type == PERCENT_BASE_ATTACK_SPEED:
		return _generate_percent_description("attk speed")
	elif attribute_type == FLAT_PIERCE:
		return _generate_flat_description("bonus pierce")
	elif attribute_type == PERCENT_BASE_PIERCE:
		return _generate_percent_description("pierce")
	elif attribute_type == FLAT_RANGE:
		return _generate_flat_description("bonus range")
	elif attribute_type == PERCENT_BASE_RANGE:
		return _generate_percent_description("range")
	elif attribute_type == FLAT_PROJ_SPEED:
		return _generate_flat_description("bonus proj speed")
	elif attribute_type == PERCENT_BASE_PROJ_SPEED:
		return _generate_percent_description("proj speed")
	elif attribute_type == FLAT_EXPLOSION_SCALE:
		return _generate_flat_description("bonus explosion size")
	elif attribute_type == PERCENT_BASE_EXPLOSION_SCALE:
		return _generate_percent_description("explosion size")
	elif attribute_type == FLAT_ABILITY_POTENCY:
		return _generate_flat_description("bonus ability potency")
	elif attribute_type == PERCENT_ABILITY_POTENCY:
		return _generate_percent_description("ability potency")
	elif attribute_type == FLAT_ABILITY_CDR:
		return _generate_flat_description("bonus ability cdr")
	elif attribute_type == PERCENT_ABILITY_CDR:
		return _generate_percent_description("ability cdr")
	elif attribute_type == FLAT_HEALTH:
		return _generate_flat_description("bonus health")
	elif attribute_type == PERCENT_BASE_HEALTH:
		return _generate_percent_description("health")
	
	
	return "Err"


func _generate_flat_description(descriptor : String) -> String:
	var primary_desc = "+" + attribute_as_modifier.get_description_scaled(_current_additive_scale) + " " + descriptor
	primary_desc += _generate_desc_for_persisting_total_additive_scaling()
	return primary_desc

func _generate_percent_description(descriptor : String) -> String:
	var descriptions : Array = attribute_as_modifier.get_description_scaled(_current_additive_scale)
	var desc01 = descriptions[0]
	var desc02 = ""
	
	if descriptions.size() == 2:
		desc02 = descriptions[1]
	
	var primary_desc = "+" + desc01 + " " + descriptor + " " + desc02
	primary_desc += _generate_desc_for_persisting_total_additive_scaling()
	return primary_desc


# Icon Related

func _get_icon() -> Texture:
	
	if attribute_type == FLAT_BASE_DAMAGE_BONUS:
		return base_damage_inc
	elif attribute_type == PERCENT_BASE_DAMAGE_BONUS:
		return base_damage_inc
	elif attribute_type == FLAT_ATTACK_SPEED:
		return atk_speed_inc
	elif attribute_type == PERCENT_BASE_ATTACK_SPEED:
		return atk_speed_inc
	elif attribute_type == FLAT_PIERCE:
		return pierce_inc
	elif attribute_type == PERCENT_BASE_PIERCE:
		return pierce_inc
	elif attribute_type == FLAT_RANGE:
		return range_inc
	elif attribute_type == PERCENT_BASE_RANGE:
		return range_inc
	elif attribute_type == FLAT_PROJ_SPEED:
		return proj_speed_inc
	elif attribute_type == PERCENT_BASE_PROJ_SPEED:
		return proj_speed_inc
	elif attribute_type == FLAT_EXPLOSION_SCALE:
		return explosion_size_inc
	elif attribute_type == PERCENT_BASE_EXPLOSION_SCALE:
		return explosion_size_inc
	elif attribute_type == FLAT_ABILITY_POTENCY:
		return ability_power_inc
	elif attribute_type == PERCENT_ABILITY_POTENCY:
		return ability_power_inc
	elif attribute_type == FLAT_ABILITY_CDR:
		return ability_cdr_inc
	elif attribute_type == PERCENT_ABILITY_CDR:
		return ability_cdr_inc
	elif attribute_type == FLAT_HEALTH:
		return health_inc
	elif attribute_type == PERCENT_BASE_HEALTH:
		return health_inc
	
	return null


# duplicate

func _shallow_duplicate():
	var copy = get_script().new(attribute_type, attribute_as_modifier, effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy

func _get_copy_scaled_by(scale):
	var copy = get_script().new(attribute_type, attribute_as_modifier.get_copy_scaled_by(scale), effect_uuid)
	_configure_copy_to_match_self(copy)
	
	return copy


#

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	attribute_as_modifier.scale_by(_current_additive_scale)
	_current_additive_scale = 1

func has_same_stats_to_effect_except_for_time(arg_other_effect):
	return effect_uuid == arg_other_effect.effect_uuid and attribute_as_modifier.get_value() == arg_other_effect.attribute_as_modifier.get_value()


