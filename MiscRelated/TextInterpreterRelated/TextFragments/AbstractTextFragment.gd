extends Reference

const DamageType = preload("res://GameInfoRelated/DamageType.gd")



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
	-1 : "#6F6F6F",
	
	DamageType.PHYSICAL : "#F72302",
	DamageType.ELEMENTAL : "#A602C0",
	DamageType.PURE : "#D90206",
	
	DamageType.MIXED : "#6C02DA"
}

const dmg_type_to_for_dark_color_map : Dictionary = {
	-1 : "#B8B8B8",
	
	DamageType.PHYSICAL : "#FD6453",
	DamageType.ELEMENTAL : "#DC0DFD",
	DamageType.PURE : "#FD4447",
	
	DamageType.MIXED : "#AA58FD"
}

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
