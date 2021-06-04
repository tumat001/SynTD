extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

const Modifier = preload("res://GameInfoRelated/Modifier.gd")

const base_damage_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_BaseDamageIncrease.png")
const atk_speed_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_AtkSpeedIncrease.png")
const range_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_RangeIncrease.png")
const pierce_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Pierce.png")
const proj_speed_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_ProjSpeed.png")
const explosion_size_inc = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_ExplosionSizeIncrease.png")

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
	
	attribute_as_modifier.internal_name = str(arg_effect_uuid)


# Description Related

func _get_description() -> String:
	if description != null and description != "":
		return description
	
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
	
	return "Err"


func _generate_flat_description(descriptor : String) -> String:
	return "+" + attribute_as_modifier.get_description() + " " + descriptor

func _generate_percent_description(descriptor : String) -> String:
	var descriptions : Array = attribute_as_modifier.get_description()
	var desc01 = descriptions[0]
	var desc02 = ""
	
	if descriptions.size() == 2:
		desc02 = descriptions[1]
	
	return "+" + desc01 + " " + descriptor + " " + desc02

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
	
	
	return null


# duplicate

func _shallow_duplicate():
	var copy = get_script().new(attribute_type, attribute_as_modifier, effect_uuid)
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	copy.is_ingredient_effect = is_ingredient_effect
	
	copy.is_countbound = is_countbound
	copy.count = count
	copy.count_reduced_by_main_attack_only = count_reduced_by_main_attack_only
	
	copy.force_apply = force_apply
	
	return copy
