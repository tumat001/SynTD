extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

const reset_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Reset.png")


func _init(arg_effect_uuid : int).(EffectType.RESET, arg_effect_uuid):
	effect_icon = reset_icon
	description = "Removes all ingredients from the tower, refunding some gold (including this tower's gold cost)."
