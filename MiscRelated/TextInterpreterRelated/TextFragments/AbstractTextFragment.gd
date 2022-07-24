extends Reference

const DamageType = preload("res://GameInfoRelated/DamageType.gd")

#


enum STAT_TYPE {
	BASE_DAMAGE = 100,
	ON_HIT_DAMAGE = 101,
	ATTACK_SPEED = 102,
	RANGE = 103,
	ABILITY_POTENCY = 104,
	PERCENT_COOLDOWN_REDUCTION = 105,
	PIERCE = 106,
	
	#
	
	DAMAGE_SCALE_AMP = 200,
	
}


const type_to_for_light_color_map : Dictionary = {
	-1 : "#4F4F4F",
	
	STAT_TYPE.BASE_DAMAGE : "#F72302",
	STAT_TYPE.ATTACK_SPEED : "#B07D00",
	STAT_TYPE.RANGE : "#01730B",
	STAT_TYPE.ABILITY_POTENCY : "#225FA1",
	STAT_TYPE.ON_HIT_DAMAGE : "#6F6F6F",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "#02ACAA",
	STAT_TYPE.PIERCE : "#B61691",
	
	STAT_TYPE.DAMAGE_SCALE_AMP : "#C00205"
}

const type_to_for_dark_color_map : Dictionary = {
	-1 : "#B8B8B8",
	
	STAT_TYPE.BASE_DAMAGE : "#FD6453",
	STAT_TYPE.ATTACK_SPEED : "#E8BA00",
	STAT_TYPE.RANGE : "#21B33B",
	STAT_TYPE.ABILITY_POTENCY : "#459DFD",
	STAT_TYPE.ON_HIT_DAMAGE : "#B8B8B8",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "#02F7F5",
	STAT_TYPE.PIERCE : "#ED6ED0",
	
	STAT_TYPE.DAMAGE_SCALE_AMP : "#FD4E51",
	
}


const type_to_name_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "base damage",
	STAT_TYPE.ATTACK_SPEED : "attack speed",
	STAT_TYPE.RANGE : "range",
	STAT_TYPE.ABILITY_POTENCY : "ability potency",
	STAT_TYPE.ON_HIT_DAMAGE : "on hit damages",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "cooldown reduction",
	STAT_TYPE.PIERCE : "bullet pierce",
	
	STAT_TYPE.DAMAGE_SCALE_AMP : "more damage",
}

const type_to_img_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseDamage.png",
	STAT_TYPE.ATTACK_SPEED : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseAtkSpeed.png",
	STAT_TYPE.RANGE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseRange.png",
	STAT_TYPE.ABILITY_POTENCY : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseAbilityPotency.png",
	STAT_TYPE.ON_HIT_DAMAGE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_OnHitMultiplier.png",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "res://GameInfoRelated/TowerStatsIcons/StatIcon_CooldownReduction.png",
	STAT_TYPE.PIERCE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_Bullet_Pierce.png",
	
	STAT_TYPE.DAMAGE_SCALE_AMP : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BonusDamageScale.png"
}


#

enum ColorMode {
	FOR_LIGHT_BACKGROUND = 0,
	FOR_DARK_BACKGROUND = 1
}



const dmg_type_to_img_map : Dictionary = {
	DamageType.PHYSICAL : "res://GameInfoRelated/TowerStatsIcons/StatIcon_DamageType_Physical.png",
	DamageType.ELEMENTAL : "res://GameInfoRelated/TowerStatsIcons/StatIcon_DamageType_Elemental.png",
	DamageType.PURE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_DamageType_Pure.png",
	
	DamageType.MIXED : "res://GameInfoRelated/TowerStatsIcons/StatIcon_DamageType_Mixed.png"
}

const dmg_type_to_for_light_color_map : Dictionary = {
	-1 : "#4F4F4F",
	
	DamageType.PHYSICAL : "#F72302",
	DamageType.ELEMENTAL : "#A602C0",
	DamageType.PURE : "#D90206",
	
	DamageType.MIXED : "#6C02DA"
}

const dmg_type_to_for_dark_color_map : Dictionary = {
	-1 : "#B8B8B8",
	
	DamageType.PHYSICAL : "#FD6453",
	DamageType.ELEMENTAL : "#FC3DFD",
	DamageType.PURE : "#FD4447",
	
	DamageType.MIXED : "#AA78FD"
}

#



const width_img_val_placeholder : String = "|imgWidth|"




var has_numerical_value : bool
var color_mode : int = ColorMode.FOR_LIGHT_BACKGROUND

#

func _init(arg_has_numerical_value : bool):
	has_numerical_value = arg_has_numerical_value


func _get_as_numerical_value() -> float:
	return 0.0

func _get_as_text() -> String:
	return "";

#


func _get_color_map_to_use() -> Dictionary:
	if color_mode == ColorMode.FOR_DARK_BACKGROUND:
		return dmg_type_to_for_dark_color_map
	else:
		return dmg_type_to_for_light_color_map

func _get_type_color_map_to_use(arg_stat_type, arg_damage_type) -> Dictionary:
	if arg_stat_type != STAT_TYPE.ON_HIT_DAMAGE:
		if color_mode == ColorMode.FOR_DARK_BACKGROUND:
			return type_to_for_dark_color_map[arg_stat_type]
		else:
			return type_to_for_light_color_map[arg_stat_type]
	else:
		if color_mode == ColorMode.FOR_DARK_BACKGROUND:
			return dmg_type_to_for_dark_color_map[arg_damage_type]
		else:
			return dmg_type_to_for_light_color_map[arg_damage_type]

