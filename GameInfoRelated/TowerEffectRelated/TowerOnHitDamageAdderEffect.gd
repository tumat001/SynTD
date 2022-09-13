extends "res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd"

const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")

const img_on_hit_physical = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_OnHitPhysical.png")
const img_on_hit_elemental = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_OnHitElemental.png")
const img_on_hit_pure = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_OnHitPure.png")


signal on_value_of_on_hit_damage_modified()



var on_hit_damage : OnHitDamage setget _set_on_hit_damage

func _init(arg_on_hit_damage : OnHitDamage, 
		arg_effect_uuid : int).(EffectType.ON_HIT_DAMAGE,
		arg_effect_uuid):
	
	on_hit_damage = arg_on_hit_damage
	description = _get_description()
	effect_icon = _get_icon()
	
	on_hit_damage.internal_id = arg_effect_uuid
	on_hit_damage.damage_as_modifier.internal_id = arg_effect_uuid
	
	on_hit_damage.connect("on_damage_as_modifier_values_changed", self, "_on_on_hit_dmg_vals_changed", [], CONNECT_PERSIST)
	
	_can_be_scaled_by_yel_vio = true

#

func _set_on_hit_damage(arg_new_ohd):
	if on_hit_damage != null:
		on_hit_damage.disconnect("on_damage_as_modifier_values_changed", self, "_on_on_hit_dmg_vals_changed")
	
	on_hit_damage = arg_new_ohd
	
	if on_hit_damage != null:
		on_hit_damage.connect("on_damage_as_modifier_values_changed", self, "_on_on_hit_dmg_vals_changed", [], CONNECT_PERSIST)
	

#

func _on_on_hit_dmg_vals_changed():
	emit_signal("on_value_of_on_hit_damage_modified")


# Descriptions related

func _get_description() -> String:
	var type_name = DamageType.get_name_of_damage_type(on_hit_damage.damage_type)
	
	var modifier = on_hit_damage.damage_as_modifier
	var modifier_desc = modifier.get_description_scaled(_current_additive_scale)
	
	if modifier is FlatModifier:
		var primary_desc = ("+" + modifier_desc + " " + type_name + " on hit damage")
		primary_desc += _generate_desc_for_persisting_total_additive_scaling()
		return primary_desc
		
	elif modifier is PercentModifier:
		var first_part : String = modifier_desc[0]
		var second_part : String 
		if modifier_desc.size() > 1:
			second_part = modifier_desc[1]
		
		var part1 = (first_part + " enemy health as " + type_name + " damage on hit,")
		if second_part != null:
			part1 += " " + second_part
		
		part1 += _generate_desc_for_persisting_total_additive_scaling()
		
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
	_configure_copy_to_match_self(copy)
	
	return copy


#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)
	
	_on_on_hit_dmg_vals_changed()

func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	on_hit_damage.scale_by(_current_additive_scale)
	_current_additive_scale = 1
