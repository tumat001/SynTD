extends "res://GameInfoRelated/EnemyEffectRelated/EnemyBaseEffect.gd"

const Modifier = preload("res://GameInfoRelated/Modifier.gd")

const img_dec_mov_speed = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyMovSpeedDec.png")
const img_cripple = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyCripple.png")
const img_dec_armor = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyArmorShred.png")
const img_dec_toughness = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyToughnessShred.png")
const img_dec_resistance = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EnemyResistanceShred.png")
const img_effect_vul = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_EffectVulnerability.png")

enum {
	
	FLAT_MOV_SPEED,
	PERCENT_BASE_MOV_SPEED,
	
	FLAT_PLAYER_DAMAGE,
	PERCENT_BASE_PLAYER_DAMAGE,
	
	FLAT_HEALTH, # Max Health
	PERCENT_BASE_HEALTH,
	
	FLAT_ARMOR,
	PERCENT_BASE_ARMOR,
	
	FLAT_TOUGHNESS,
	PERCENT_BASE_TOUGHNESS,
	
	FLAT_RESISTANCE,
	PERCENT_BASE_RESISTANCE,
	
	FLAT_EFFECT_VULNERABILITY,
	PERCENT_BASE_EFFECT_VULNERABILITY,
	
	FLAT_PERCENT_HEALTH_HIT_SCALE,
	PERCENT_BASE_PERCENT_HEALTH_HIT_SCALE,
	
}

var attribute_type : int
var attribute_as_modifier : Modifier

func _init(arg_attribute_type : int,
		arg_attribute_as_modifier : Modifier,
		arg_effect_uuid : int).(EffectType.ATTRIBUTES,
		arg_effect_uuid):
	
	attribute_type = arg_attribute_type
	attribute_as_modifier = arg_attribute_as_modifier

# Description Related

func _get_overriden_description() -> String:
	if attribute_type == FLAT_MOV_SPEED:
		return _generate_flat_description("mov speed")
	elif attribute_type == PERCENT_BASE_MOV_SPEED:
		return _generate_percent_description("mov speed")
	elif attribute_type == FLAT_PLAYER_DAMAGE:
		return _generate_flat_description("player dmg")
	elif attribute_type == PERCENT_BASE_PLAYER_DAMAGE:
		return _generate_percent_description("player dmg")
	elif attribute_type == FLAT_HEALTH:
		return _generate_flat_description("max health")
	elif attribute_type == PERCENT_BASE_HEALTH:
		return _generate_percent_description("max health")
	elif attribute_type == FLAT_ARMOR:
		return _generate_flat_description("armor")
	elif attribute_type == PERCENT_BASE_ARMOR:
		return _generate_percent_description("armor")
	elif attribute_type == FLAT_TOUGHNESS:
		return _generate_flat_description("toughness")
	elif attribute_type == PERCENT_BASE_TOUGHNESS:
		return _generate_percent_description("toughness")
	elif attribute_type == FLAT_RESISTANCE:
		return _generate_flat_description("resistance")
	elif attribute_type == PERCENT_BASE_RESISTANCE:
		return _generate_percent_description("toughness")
	elif attribute_type == FLAT_EFFECT_VULNERABILITY:
		return _generate_flat_description("effect vulnerability")
	elif attribute_type == PERCENT_BASE_EFFECT_VULNERABILITY:
		return _generate_percent_description("effect vulnerability")
	
	
	return "Err"


func _generate_flat_description(descriptor : String) -> String:
	var semi_final_desc =  "+" + attribute_as_modifier.get_description() + " " + descriptor
	
	if is_timebound:
		var append_plural : String = "s"
		if time_in_seconds == 1:
			append_plural = ""
		
		semi_final_desc += "for %s second%s" % [time_in_seconds, append_plural]
	
	semi_final_desc += " on hit."
	return semi_final_desc

func _generate_percent_description(descriptor : String) -> String:
	var descriptions : Array = attribute_as_modifier.get_description()
	var desc01 = descriptions[0]
	var desc02 = ""
	
	if descriptions.size() == 2:
		desc02 = descriptions[1]
	
	var semi_final_desc =  "+" + desc01 + " " + descriptor + " " + desc02
	if is_timebound:
		var append_plural : String = "s"
		if time_in_seconds == 1:
			append_plural = ""
		
		semi_final_desc += "for %s second%s" % [time_in_seconds, append_plural]
	
	semi_final_desc += " on hit."
	return semi_final_desc

# Icon related

func _get_overriden_icon() -> Texture:
	if attribute_type == FLAT_MOV_SPEED:
		return img_dec_mov_speed
	elif attribute_type == PERCENT_BASE_MOV_SPEED:
		return img_dec_mov_speed
	elif attribute_type == FLAT_PLAYER_DAMAGE:
		return img_cripple
	elif attribute_type == PERCENT_BASE_PLAYER_DAMAGE:
		return img_cripple
	elif attribute_type == FLAT_ARMOR:
		return img_dec_armor
	elif attribute_type == PERCENT_BASE_ARMOR:
		return img_dec_armor
	elif attribute_type == FLAT_TOUGHNESS:
		return img_dec_toughness
	elif attribute_type == PERCENT_BASE_TOUGHNESS:
		return img_dec_toughness
	elif attribute_type == FLAT_RESISTANCE:
		return img_dec_resistance
	elif attribute_type == PERCENT_BASE_RESISTANCE:
		return img_dec_resistance
	elif attribute_type == FLAT_EFFECT_VULNERABILITY:
		return img_effect_vul
	elif attribute_type == PERCENT_BASE_EFFECT_VULNERABILITY:
		return img_effect_vul
	
	return null

func _get_copy_scaled_by(scale : float, force_apply_scale : bool = false):
	if !respect_scale and !force_apply_scale:
		scale = 1
	
	var modifier = attribute_as_modifier.get_copy_scaled_by(scale)
	
	var copy = get_script().new(attribute_type, modifier, effect_uuid)
	copy.is_timebound = is_timebound
	copy.time_in_seconds = time_in_seconds
	copy.status_bar_icon = status_bar_icon
	copy.respect_scale = respect_scale
	
	return copy
	
