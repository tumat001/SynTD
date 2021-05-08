extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")

const img_physical_bleed = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyBleedPhysical.png")
const img_elemental_bleed = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyBleedElemental.png")
const img_pure_bleed = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyBleedPure.png")


var damage_type : int
var on_hit_damage : OnHitDamage

var number_of_ticks : int
var delay_per_tick : float


func _init(arg_on_hit_damage : OnHitDamage,
		effect_source : String,
		arg_num_of_ticks : int, 
		arg_delay_per_tick : float).(EffectType.DAMAGE_OVER_TIME,
		effect_source):
	
	on_hit_damage = arg_on_hit_damage
	damage_type = on_hit_damage.damage_type
	
	number_of_ticks = arg_num_of_ticks
	delay_per_tick = arg_delay_per_tick
	
	description = _get_description()
	effect_icon = _get_icon()


# Description related

func _get_description() -> String:
	if description != null:
		return description
	
	var type_name = DamageType.get_name_of_damage_type(damage_type)
	
	var modifier = on_hit_damage.damage_as_modifier
	var modifier_desc = modifier.get_description_scaled(number_of_ticks)
	
	if modifier is FlatModifier:
		return (modifier_desc + " " + type_name + " damage over " + _get_total_duration() + " seconds")
	elif modifier is PercentModifier:
		var first_part : String = modifier_desc[0]
		var second_part : String = modifier_desc[1]
		
		var part1 = (first_part + " enemy health as " + type_name + " damage")
		if second_part != null:
			part1 += " " + second_part
		
		part1 += " over" + _get_total_duration() + " seconds"
	
	return ""

func _get_total_duration() -> String:
	return str(number_of_ticks * delay_per_tick)


# ICON RELATED

func _get_icon():
	if damage_type == DamageType.PHYSICAL:
		return img_physical_bleed
	elif damage_type == DamageType.ELEMENTAL:
		return img_elemental_bleed
	elif damage_type == DamageType.PURE:
		return img_pure_bleed
