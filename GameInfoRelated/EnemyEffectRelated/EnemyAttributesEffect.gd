extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const img_dec_mov_speed = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyMovSpeedDec.png")
const img_cripple = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyCripple.png")
const img_dec_armor = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyArmorShred.png")
const img_dec_toughness = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyToughnessShred.png")
const img_dec_resistance = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyResistanceShred.png")

enum {
	
	FLAT_MOV_SPEED,
	PERCENT_BASE_MOV_SPEED,
	
	FLAT_PLAYER_DAMAGE,
	PERCENT_BASE_PLAYER_DAMAGE,
	
	FLAT_HEALTH, # Max Health
	PERCENT_BASE_HEALTH,
	
	FLAT_ARMOR,
	PERCENT_BASE_ARMOR,
	
	FLAT_TOUGHNESS,
	PERCENT_BASE_TOUGHNESS,
	
	FLAT_RESISTANCE,
	PERCENT_BASE_RESISTANCE,
	
}

var attribute_type : int
var attribute_as_modifier : Modifier

func _init(arg_attribute_type : int,
		arg_attribute_as_modifier : Modifier,
		arg_effect_source_name : String).(EffectType.ATTRIBUTES,
		arg_effect_source_name):
	
	attribute_type = arg_attribute_type
	attribute_as_modifier = arg_attribute_as_modifier

# Description Related

func _get_description() -> String:
	if description != null:
		return description
	
	if attribute_type == FLAT_MOV_SPEED:
		return _generate_flat_description("mov speed")
	elif attribute_type == PERCENT_BASE_MOV_SPEED:
		return _generate_percent_description("of base mov speed")
	elif attribute_type == FLAT_PLAYER_DAMAGE:
		return _generate_flat_description("player dmg")
	elif attribute_type == PERCENT_BASE_PLAYER_DAMAGE:
		return _generate_percent_description("of base player dmg")
	elif attribute_type == FLAT_HEALTH:
		return _generate_flat_description("max health")
	elif attribute_type == PERCENT_BASE_HEALTH:
		return _generate_percent_description("of max health")
	elif attribute_type == FLAT_ARMOR:
		return _generate_flat_description("armor")
	elif attribute_type == PERCENT_BASE_ARMOR:
		return _generate_percent_description("of base armor")
	elif attribute_type == FLAT_TOUGHNESS:
		return _generate_flat_description("toughness")
	elif attribute_type == PERCENT_BASE_TOUGHNESS:
		return _generate_flat_description("of base toughness")
	elif attribute_type == FLAT_RESISTANCE:
		return _generate_flat_description("resistance")
	elif attribute_type == PERCENT_BASE_RESISTANCE:
		return _generate_flat_description("of base toughness")
	
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

# Icon related

func _get_icon() -> Texture:
	if attribute_type == FLAT_MOV_SPEED:
		return img_dec_mov_speed
	elif attribute_type == PERCENT_BASE_MOV_SPEED:
		return img_dec_mov_speed
	elif attribute_type == FLAT_PLAYER_DAMAGE:
		return img_cripple
	elif attribute_type == PERCENT_BASE_PLAYER_DAMAGE:
		return img_cripple
	elif attribute_type == FLAT_ARMOR:
		return img_dec_armor
	elif attribute_type == PERCENT_BASE_ARMOR:
		return img_dec_armor
	elif attribute_type == FLAT_TOUGHNESS:
		return img_dec_toughness
	elif attribute_type == PERCENT_BASE_TOUGHNESS:
		return img_dec_toughness
	elif attribute_type == FLAT_RESISTANCE:
		return img_dec_resistance
	elif attribute_type == PERCENT_BASE_RESISTANCE:
		return img_dec_resistance
	
	return null
