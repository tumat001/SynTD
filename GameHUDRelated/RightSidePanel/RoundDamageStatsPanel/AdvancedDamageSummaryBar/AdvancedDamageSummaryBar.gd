extends "res://MiscRelated/ControlProgressBarRelated/AdvancedControlProgressBar/AdvancedControlProgressBar.gd"

const ElementalDamageFill_Texture = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/Assets/SingleTowerRoundDamagePanel_Assets/SingleDamagePanel_EleDamageFill.png")
const PhysicalDamageFill_Texture = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/Assets/SingleTowerRoundDamagePanel_Assets/SingleDamagePanel_PhyDamageFill.png")
const PureDamageFill_Texture = preload("res://GameHUDRelated/RightSidePanel/RoundDamageStatsPanel/Assets/SingleTowerRoundDamagePanel_Assets/SingleDamagePanel_PureDamageFill.png")

const DamageType = preload("res://GameInfoRelated/DamageType.gd")


export(Texture) var physical_damage_bar_pic : Texture = PhysicalDamageFill_Texture
export(Texture) var elemental_damage_bar_pic : Texture = ElementalDamageFill_Texture
export(Texture) var pure_damage_bar_pic : Texture = PureDamageFill_Texture

func _ready():
	add_bar_foreground(DamageType.PHYSICAL, physical_damage_bar_pic)
	add_bar_foreground(DamageType.ELEMENTAL, elemental_damage_bar_pic)
	add_bar_foreground(DamageType.PURE, pure_damage_bar_pic)


func set_total_damage_val(arg_val : float):
	set_max_value(arg_val)


func set_physical_damage_val(arg_val : float):
	set_bar_foreground_current_value(DamageType.PHYSICAL, arg_val)

func set_elemental_damage_val(arg_val : float):
	set_bar_foreground_current_value(DamageType.ELEMENTAL, arg_val)

func set_pure_damage_val(arg_val : float):
	set_bar_foreground_current_value(DamageType.PURE, arg_val)


#


