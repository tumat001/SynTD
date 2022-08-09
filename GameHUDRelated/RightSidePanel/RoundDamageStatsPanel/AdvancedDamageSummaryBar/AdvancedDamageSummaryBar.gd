extends "res://MiscRelated/ControlProgressBarRelated/AdvancedControlProgressBar/AdvancedControlProgressBar.gd"

const ElementalDamageFill_Texture = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/Assets/SingleTowerRoundDamagePanel_Assets/SingleDamagePanel_EleDamageFill.png")
const PhysicalDamageFill_Texture = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/Assets/SingleTowerRoundDamagePanel_Assets/SingleDamagePanel_PhyDamageFill.png")
const PureDamageFill_Texture = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/Assets/SingleTowerRoundDamagePanel_Assets/SingleDamagePanel_PureDamageFill.png")

const DamageType = preload("res://GameInfoRelated/DamageType.gd")


func _ready():
	add_bar_foreground(DamageType.PHYSICAL, PhysicalDamageFill_Texture)
	add_bar_foreground(DamageType.ELEMENTAL, ElementalDamageFill_Texture)
	add_bar_foreground(DamageType.PURE, PureDamageFill_Texture)
	
	


func set_total_damage_val(arg_val : float):
	set_max_value(arg_val)


func set_physical_damage_val(arg_val : float):
	set_bar_foreground_current_value(DamageType.PHYSICAL, arg_val)

func set_elemental_damage_val(arg_val : float):
	set_bar_foreground_current_value(DamageType.ELEMENTAL, arg_val)

func set_pure_damage_val(arg_val : float):
	set_bar_foreground_current_value(DamageType.PURE, arg_val)


#


