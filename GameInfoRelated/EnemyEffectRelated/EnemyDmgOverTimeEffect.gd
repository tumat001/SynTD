extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")

const img_physical_bleed = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyBleedPhysical.png")
const img_elemental_bleed = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyBleedElemental.png")
const img_pure_bleed = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyBleedPure.png")

#signal on_post_mitigated_dmg_dealt(damage_instance_report, is_lethal, enemy, this_effect)

var damage_type : int
var damage_instance : DamageInstance # Damage per tick
var primary_on_hit_damage : OnHitDamage

var delay_per_tick : float
var _curr_delay_per_tick : float


func _init(arg_damage_instance : DamageInstance,
		arg_effect_uuid : int,
		arg_delay_per_tick : float).(EffectType.DAMAGE_OVER_TIME,
		arg_effect_uuid):
	
	damage_instance = arg_damage_instance
	primary_on_hit_damage = damage_instance.on_hit_damages.values()[0]
	
	damage_type = primary_on_hit_damage.damage_type
	
	delay_per_tick = arg_delay_per_tick
	_curr_delay_per_tick = arg_delay_per_tick
	
	effect_icon = _get_icon()
	
	_can_be_scaled_by_yel_vio = true


# Description related

func _get_description() -> String:
	if description != null and description != "":
		return description
	
	var type_name = DamageType.get_name_of_damage_type(damage_type)
	
	var modifier = primary_on_hit_damage.damage_as_modifier
	var modifier_desc = modifier.get_description_scaled((time_in_seconds / delay_per_tick) * _current_additive_scale)
	
	if modifier is FlatModifier:
		if is_timebound:
			return (modifier_desc + " " + type_name + " damage over " + _get_total_duration() + " seconds.%s" % _generate_desc_for_persisting_total_additive_scaling(true))
		else:
			return (str(modifier.flat_modifier) + " " + type_name + " damage per " + str(delay_per_tick) + " " + _attach_plural_if_needed("second", time_in_seconds) + _generate_desc_for_persisting_total_additive_scaling(true))
	elif modifier is PercentModifier:
		if time_in_seconds != 0 and is_timebound:
			var first_part : String = modifier_desc[0]
			var second_part : String = modifier_desc[1]
			
			var part1 = (first_part + " enemy health as " + type_name + " damage")
			if second_part != null:
				part1 += " " + second_part
			
			part1 += " over" + _get_total_duration() + " seconds"
			part1 += _generate_desc_for_persisting_total_additive_scaling(true)
			return part1
		else:
			var desc = modifier.get_description()
			
			var first_part : String = desc[0]
			var second_part : String = desc[1]
			
			var part1 = (first_part + " enemy health as " + type_name + " damage per " + delay_per_tick)
			if second_part != null:
				part1 = " " + second_part
			
			part1 += _generate_desc_for_persisting_total_additive_scaling(true)
			return part1
	
	return ""

func _get_overriden_description() -> String:
	return _get_description()

func _get_total_duration() -> String:
	return str(time_in_seconds)


func _attach_plural_if_needed(desc : String, val : float) -> String:
	if val == 1:
		desc += "s"
	
	return desc

# ICON RELATED

func _get_icon():
	if damage_type == DamageType.PHYSICAL:
		return img_physical_bleed
	elif damage_type == DamageType.ELEMENTAL:
		return img_elemental_bleed
	elif damage_type == DamageType.PURE:
		return img_pure_bleed

# copy

func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale and !force_apply_scale:
		scale = 1
	
	var scaled_dmg_inst = damage_instance.get_copy_scaled_by(scale)
	
	var copy = get_script().new(scaled_dmg_inst, effect_uuid, delay_per_tick)
	_configure_copy_to_match_self(copy)
	
	return copy


# reapplied

func _reapply(copy):
	time_in_seconds = copy.time_in_seconds
	damage_instance = copy.damage_instance
	
	effect_source_ref = copy.effect_source_ref

#

func connect_to_enemy(enemy):
	if !enemy.is_connected("on_post_mitigated_damage_taken", self, "_on_enemy_post_mitigated_dmg_dealt"):
		enemy.connect("on_post_mitigated_damage_taken", self, "_on_enemy_post_mitigated_dmg_dealt")

func disconnect_from_enemy(enemy):
	if enemy.is_connected("on_post_mitigated_damage_taken", self, "_on_enemy_post_mitigated_dmg_dealt"):
		enemy.disconnect("on_post_mitigated_damage_taken", self, "_on_enemy_post_mitigated_dmg_dealt")


func _on_enemy_post_mitigated_dmg_dealt(damage_instance_report, is_lethal, enemy):
	#emit_signal("on_post_mitigated_dmg_dealt", damage_instance_report, is_lethal, enemy, self)
	if effect_source_ref != null and effect_source_ref.get_ref() != null and damage_instance_report.dmg_instance_ref.get_ref() == damage_instance:
		effect_source_ref.get_ref()._on_post_mitigated_dmg_dealt_from_effect(damage_instance_report, is_lethal, enemy, self)

#

# SCALING related. Used by YelVio only.
func add_additive_scaling_by_amount(arg_amount):
	.add_additive_scaling_by_amount(arg_amount)

# to be implemented by classes
func _consume_current_additive_scaling_for_actual_scaling_in_stats():
	damage_instance.scale_only_damage_by(_current_additive_scale)
	description = _get_description()

