extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")

const img_physical_bleed = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyBleedPhysical.png")
const img_elemental_bleed = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyBleedElemental.png")
const img_pure_bleed = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyBleedPure.png")


var damage_type : int
var on_hit_damage : OnHitDamage # Damage per tick

var delay_per_tick : float

func _init(arg_on_hit_damage : OnHitDamage,
		arg_effect_uuid : int,
		arg_delay_per_tick : float).(EffectType.DAMAGE_OVER_TIME,
		arg_effect_uuid):
	
	on_hit_damage = arg_on_hit_damage
	damage_type = on_hit_damage.damage_type
	
	delay_per_tick = arg_delay_per_tick
	
	description = _get_description()
	effect_icon = _get_icon()


# Description related

func _get_description() -> String:
	if description != null and description != "":
		return description
	
	var type_name = DamageType.get_name_of_damage_type(damage_type)
	
	var modifier = on_hit_damage.damage_as_modifier
	var modifier_desc = modifier.get_description_scaled(time_in_seconds / delay_per_tick)
	
	if modifier is FlatModifier:
		if time_in_seconds != 0 and is_timebound:
			return (modifier_desc + " " + type_name + " damage over " + _get_total_duration() + " seconds")
		else:
			return (modifier.flat_modifier + " " + type_name + " damage per " + delay_per_tick + " seconds")
	elif modifier is PercentModifier:
		if time_in_seconds != 0 and is_timebound:
			var first_part : String = modifier_desc[0]
			var second_part : String = modifier_desc[1]
			
			var part1 = (first_part + " enemy health as " + type_name + " damage")
			if second_part != null:
				part1 += " " + second_part
			
			part1 += " over" + _get_total_duration() + " seconds"
		else:
			var desc = modifier.get_description()
			
			var first_part : String = desc[0]
			var second_part : String = desc[1]
			
			var part1 = (first_part + " enemy health as " + type_name + " damage per " + delay_per_tick)
			if second_part != null:
				part1 = " " + second_part
			
			return part1
	
	return ""

func _get_total_duration() -> String:
	return str(time_in_seconds)


# ICON RELATED

func _get_icon():
	if damage_type == DamageType.PHYSICAL:
		return img_physical_bleed
	elif damage_type == DamageType.ELEMENTAL:
		return img_elemental_bleed
	elif damage_type == DamageType.PURE:
		return img_pure_bleed

# copy

func _get_copy_scaled_by(scale : float):
	var scaled_on_hit = on_hit_damage.duplicate()
	scaled_on_hit.damage_as_modifier.get_copy_scaled_by(scale)
	
	var copy = get_script().new(scaled_on_hit, effect_uuid, delay_per_tick)
	return copy
	