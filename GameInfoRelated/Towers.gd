const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")
const FlatModifier = preload("res://GameInfoRelated/FlatModifier.gd")
const PercentModifier = preload("res://GameInfoRelated/PercentModifier.gd")
const IngredientEffect = preload("res://GameInfoRelated/TowerIngredientRelated/IngredientEffect.gd")
const TowerAttributesEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerAttributesEffect.gd")
const TowerBaseEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerBaseEffect.gd")
const StoreOfTowerEffectsUUID = preload("res://GameInfoRelated/TowerEffectRelated/StoreOfTowerEffectsUUID.gd")
const PercentType = preload("res://GameInfoRelated/PercentType.gd")
const TowerResetTeffects = preload("res://GameInfoRelated/TowerEffectRelated/TowerResetEffects.gd")

# GRAY
const mono_image = preload("res://TowerRelated/Color_Gray/Mono/Mono_E.png")
const simplex_image = preload("res://TowerRelated/Color_Gray/Simplex/Simplex_Omni.png")


# YELLOW
const railgun_image = preload("res://TowerRelated/Color_Yellow/Railgun/Railgun_E.png")

# GREEN
const berrybush_image = preload("res://TowerRelated/Color_Green/BerryBush/BerryBush_Omni.png")

# BLUE
const sprinkler_image = preload("res://TowerRelated/Color_Blue/Sprinkler/Sprinkler_E.png")

# VIOLET
const simpleobelisk_image = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_Omni.png")
const re_image = preload("res://TowerRelated/Color_Violet/Re/Re_Omni.png")

enum {
	# GRAY
	MONO,
	SIMPLEX,
	
	# RED
	
	# ORANGE
	
	# YELLOW
	RAILGUN,
	
	# GREEN
	BERRY_BUSH,
	
	# BLUE
	SPRINKLER,
	
	# VIOLET
	SIMPLE_OBELISK,
	RE,
}

static func get_tower_info(tower_id : int) -> TowerTypeInformation :
	var info
	
	if tower_id == MONO:
		info = TowerTypeInformation.new("Mono", MONO)
		info.tower_cost = 1
		info.colors.append(TowerColors.GRAY)
		info.tower_tier = 1
		info.tower_image_in_buy_card = mono_image
		
		info.base_damage = 3
		info.base_attk_speed = 0.75
		info.base_pierce = 1
		info.base_range = 100
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Fires metal bullets at opponents",
			"\"First Iteration\""
		]
	elif tower_id == SPRINKLER:
		info = TowerTypeInformation.new("Sprinkler", SPRINKLER)
		info.tower_cost = 1
		info.colors.append(TowerColors.BLUE)
		info.tower_tier = 1
		info.tower_image_in_buy_card = sprinkler_image
		
		info.base_damage = 1
		info.base_attk_speed = 2.75
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Sprinkles water droplets to enemies"
		]
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new("sp")
		attk_speed_attr_mod.percent_amount = 12.5
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_SPRINKLER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		ing_effect.compatible_colors = [TowerColors.BLUE, TowerColors.GREEN, TowerColors.VIOLET]
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk speed"
		
	elif tower_id == BERRY_BUSH:
		info = TowerTypeInformation.new("Berry Bush", BERRY_BUSH)
		info.tower_cost = 2
		info.colors.append(TowerColors.GREEN)
		info.tower_tier = 2
		info.tower_image_in_buy_card = berrybush_image
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Does not attack, but instead gives gold at the end of the round"
		]
		
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new("sp")
		base_dmg_attr_mod.flat_modifier = 0.75
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_BERRY_BUSH)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		ing_effect.compatible_colors = [TowerColors.BLUE, TowerColors.GREEN, TowerColors.YELLOW]
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ base dmg"
		
		
		
	elif tower_id == SIMPLE_OBELISK:
		info = TowerTypeInformation.new("Simple Obelisk", SIMPLE_OBELISK)
		info.tower_cost = 3
		info.colors.append(TowerColors.VIOLET)
		info.colors.append(TowerColors.GRAY)
		info.tower_tier = 3
		info.tower_image_in_buy_card = simpleobelisk_image
		
		info.base_damage = 6
		info.base_attk_speed = 0.5
		info.base_pierce = 1
		info.base_range = 170
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Fires arcane bolts at enemies that explode before fizzling out, dealing half of this tower's total damage"
		]
		
		# Ingredient related
		var range_attr_mod : PercentModifier = PercentModifier.new("sp")
		range_attr_mod.percent_amount = 50
		range_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.ING_SIMPLE_OBELISK)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		ing_effect.compatible_colors = [TowerColors.VIOLET, TowerColors.RED, TowerColors.BLUE]
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ range"
		
		
	elif tower_id == SIMPLEX:
		info = TowerTypeInformation.new("Simplex", SIMPLEX)
		info.tower_cost = 1
		info.colors.append(TowerColors.GRAY)
		info.tower_tier = 1
		info.tower_image_in_buy_card = simplex_image
		
		info.base_damage = 0.25
		info.base_attk_speed = 8
		info.base_pierce = 0
		info.base_range = 110
		info.base_damage_type = DamageType.PURE
		info.on_hit_multiplier = 1.0 / 8.0
		
		info.tower_descriptions = [
			"Directs a constant pure energy beam at a single target",
			"\"First Iteration\""
		]
	elif tower_id == RAILGUN:
		info = TowerTypeInformation.new("Railgun", RAILGUN)
		info.tower_cost = 3
		info.colors.append(TowerColors.YELLOW)
		info.tower_tier = 3
		info.tower_image_in_buy_card = railgun_image
		
		info.base_damage = 7
		info.base_attk_speed = 0.25
		info.base_pierce = 4
		info.base_range = 100
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Shoots a dart like projectile that pierces through 4 enemies"
		]
		
	elif tower_id == RE:
		info = TowerTypeInformation.new("Re", RE)
		info.tower_cost = 4
		info.colors.append(TowerColors.VIOLET)
		info.tower_tier = 4
		info.tower_image_in_buy_card = re_image
		
		info.base_damage = 1.5
		info.base_attk_speed = 0.5
		info.base_pierce = 0
		info.base_range = 115
		info.base_damage_type = DamageType.PURE
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Cleanses enemies from all buffs and debuffs per hit",
			"Attacks in bursts of 3"
		]
		
		var tower_effect = TowerResetTeffects.new(StoreOfTowerEffectsUUID.ING_RE)
		var ing_effect = IngredientEffect.new(tower_id, tower_effect)
		ing_effect.compatible_colors = [TowerColors.VIOLET, TowerColors.RED, TowerColors.BLUE]
		info.ingredient_effect = ing_effect
	
	return info

static func get_tower_scene(tower_id : int):
	if tower_id == MONO:
		return load("res://TowerRelated/Color_Gray/Mono/Mono.tscn")
	elif tower_id == SPRINKLER:
		return load("res://TowerRelated/Color_Blue/Sprinkler/Sprinkler.tscn")
	elif tower_id == BERRY_BUSH:
		return load("res://TowerRelated/Color_Green/BerryBush/BerryBush.tscn")
	elif tower_id == SIMPLE_OBELISK:
		return load("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk.tscn")
	elif tower_id == SIMPLEX:
		return load("res://TowerRelated/Color_Gray/Simplex/Simplex.tscn")
	elif tower_id == RAILGUN:
		return load("res://TowerRelated/Color_Yellow/Railgun/Railgun.tscn")
	elif tower_id == RE:
		return load("res://TowerRelated/Color_Violet/Re/Re.tscn")
