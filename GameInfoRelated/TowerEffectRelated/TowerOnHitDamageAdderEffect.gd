extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")

const img_on_hit_physical = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_OnHitPhysical.png")
const img_on_hit_elemental = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_OnHitElemental.png")
const img_on_hit_pure = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_OnHitPure.png")


var on_hit_damage : OnHitDamage

func _init(arg_on_hit_damage : OnHitDamage, 
		arg_effect_uuid : int).(EffectType.ON_HIT_DAMAGE,
		arg_effect_uuid):
	
	on_hit_damage = arg_on_hit_damage
	description = _get_description()
	effect_icon = _get_icon()
	
	on_hit_damage.internal_name = str(arg_effect_uuid)
	on_hit_damage.damage_as_modifier.internal_name = str(arg_effect_uuid)

# Descriptions related

func _get_description() -> String:
	if description != null and description != "":
		return description
	
	var type_name = DamageType.get_name_of_damage_type(on_hit_damage.damage_type)
	
	var modifier = on_hit_damage.damage_as_modifier
	var modifier_desc = modifier.get_description()
	
	if modifier is FlatModifier:
		return ("+" + modifier_desc + " " + type_name + " on hit damage")
	elif modifier is PercentModifier:
		var first_part : String = modifier_desc[0]
		var second_part : String = modifier_desc[1]
		
		var part1 = (first_part + " enemy health as " + type_name + " damage")
		if second_part != null:
			part1 += " " + second_part
		
		return part1
	
	return ""

# Icon Related

func _get_icon() -> Texture:
	if on_hit_damage.damage_type == DamageType.PHYSICAL:
		return img_on_hit_physical
	elif on_hit_damage.damage_type == DamageType.ELEMENTAL:
		return img_on_hit_elemental
	elif on_hit_damage.damage_type == DamageType.PURE:
		return img_on_hit_pure
	
	return null


func _shallow_duplicate():
	var copy = get_script().new(on_hit_damage, effect_uuid)
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	copy.is_ingredient_effect = is_ingredient_effect
	
	copy.is_countbound = is_countbound
	copy.count = count
	
	return copy
