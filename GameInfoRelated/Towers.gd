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
const TowerResetEffects = preload("res://GameInfoRelated/TowerEffectRelated/TowerResetEffects.gd")
const TowerFullSellbackEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerFullSellbackEffect.gd")

const PingletAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/PingletAdderEffect.gd")
const TowerChaosTakeoverEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerChaosTakeoverEffect.gd")

const StoreOfEnemyEffectsUUID = preload("res://GameInfoRelated/EnemyEffectRelated/StoreOfEnemyEffectsUUID.gd")
const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")
const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")
const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")

# GRAY
const mono_image = preload("res://TowerRelated/Color_Gray/Mono/Mono_E.png")
const simplex_image = preload("res://TowerRelated/Color_Gray/Simplex/Simplex_Omni.png")


# YELLOW
const railgun_image = preload("res://TowerRelated/Color_Yellow/Railgun/Railgun_E.png")
const coin_image = preload("res://TowerRelated/Color_Yellow/Coin/Coin_E.png")
const beacon_dish_image = preload("res://TowerRelated/Color_Yellow/BeaconDish/BeaconDish_Omni.png")
const mini_tesla_image = preload("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla_Omni.png")
const charge_image = preload("res://TowerRelated/Color_Yellow/Charge/Charge_E.png")
const magnetizer_image = preload("res://TowerRelated/Color_Yellow/Magnetizer/Magnetizer_WholeBody.png")

# GREEN
const berrybush_image = preload("res://TowerRelated/Color_Green/BerryBush/BerryBush_Omni.png")

# BLUE
const sprinkler_image = preload("res://TowerRelated/Color_Blue/Sprinkler/Sprinkler_E.png")

# VIOLET
const simpleobelisk_image = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_Omni.png")
const re_image = preload("res://TowerRelated/Color_Violet/Re/Re_Omni.png")
const telsa_image = preload("res://TowerRelated/Color_Violet/Tesla/Tesla.png")
const chaos_image = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_01.png")
const ping_image = preload("res://TowerRelated/Color_Violet/Ping/PingWholeBody.png")

enum {
	# GRAY (100)
	MONO = 100,
	SIMPLEX = 101,
	
	# RED (200)
	
	# ORANGE (300)
	
	# YELLOW (400)
	RAILGUN = 400,
	COIN = 401,
	BEACON_DISH = 402,
	MINI_TESLA = 403,
	CHARGE = 404,
	MAGNETIZER = 405,
	
	# GREEN (500)
	BERRY_BUSH = 500,
	
	# BLUE (600)
	SPRINKLER = 600,
	
	# VIOLET (700)
	SIMPLE_OBELISK = 700,
	RE = 701,
	TESLA = 702,
	CHAOS = 703,
	PING = 704,
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
			"Fires metal bullets at opponents.",
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
			"Does not attack, but instead gives 1 gold at the end of the round"
		]
		
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new("sp")
		base_dmg_attr_mod.flat_modifier = 0.75
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_BERRY_BUSH)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
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
			"Fires arcane bolts at enemies that explode before fizzling out. The explosion deals half of this tower's total base damage"
		]
		
		# Ingredient related
		var range_attr_mod : PercentModifier = PercentModifier.new("sp")
		range_attr_mod.percent_amount = 50
		range_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.ING_SIMPLE_OBELISK)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
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
			"Directs a constant pure energy beam at a single target.",
			"\"First Iteration\""
		]
	elif tower_id == RAILGUN:
		info = TowerTypeInformation.new("Railgun", RAILGUN)
		info.tower_cost = 2
		info.colors.append(TowerColors.YELLOW)
		info.tower_tier = 2
		info.tower_image_in_buy_card = railgun_image
		
		info.base_damage = 6
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
		
		info.base_damage = 3
		info.base_attk_speed = 0.5
		info.base_pierce = 0
		info.base_range = 115
		info.base_damage_type = DamageType.PURE
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Cleanses enemies from all buffs and debuffs per hit.",
			"Attacks in bursts of 3"
		]
		
		var tower_effect = TowerResetEffects.new(StoreOfTowerEffectsUUID.ING_RE)
		var ing_effect = IngredientEffect.new(tower_id, tower_effect)
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "clear"
		
		
	elif tower_id == TESLA:
		info = TowerTypeInformation.new("Tesla", TESLA)
		info.tower_cost = 6
		info.colors.append(TowerColors.VIOLET)
		info.colors.append(TowerColors.YELLOW)
		info.tower_tier = 6
		info.tower_image_in_buy_card = telsa_image
		
		info.base_damage = 3.5
		info.base_attk_speed = 1.5
		info.base_pierce = 0
		info.base_range = 145
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Shocks and stuns its target for 0.3 seconds on hit with the power of electricity"
		]
		
		var enemy_effect : EnemyStunEffect = EnemyStunEffect.new(0.3, StoreOfEnemyEffectsUUID.ING_TESLA)
		var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.ING_TESLA)
		var ing_effect : IngredientEffect = IngredientEffect.new(TESLA, tower_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "stun on hit"
		
		
	elif tower_id == CHAOS:
		info = TowerTypeInformation.new("CHAOS", CHAOS)
		info.tower_cost = 5
		info.colors.append(TowerColors.VIOLET)
		info.tower_tier = 5
		info.tower_image_in_buy_card = chaos_image
		
		info.base_damage = 1.5
		info.base_attk_speed = 1.5
		info.base_pierce = 1
		info.base_range = 135
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Has many attacks. Shoots orbs, diamonds, and bolts. Stats shown are for the orbs.",
			"Only the orbs are affected by targeting options.",
			"Only the diamonds benefit from pierce buffs and apply on hit damage and effects. On hit effects are 200% effective.",
			"Only the bolts benefit from attack speed buffs.",
			"All are affected by range and base damage buffs. Bolts deal 150% of its total base damage.",
			"Upon dealing enough damage with the orbs, diamonds and bolts, CHAOS erupts a dark sword to stab the orb's target. The sword deals 500% of its total base damage."
		]
		
		var tower_base_effect : TowerChaosTakeoverEffect = TowerChaosTakeoverEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(CHAOS, tower_base_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "takeover"
		
		
	elif tower_id == PING:
		info = TowerTypeInformation.new("Ping", PING)
		info.tower_cost = 4
		info.colors.append(TowerColors.VIOLET)
		info.colors.append(TowerColors.BLUE)
		info.tower_tier = 4
		info.tower_image_in_buy_card = ping_image
		
		info.base_damage = 1
		info.base_attk_speed = 0.30
		info.base_pierce = 1
		info.base_range = 155
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Stats shown are for the arrow.",
			"Shoots an arrow that releases a ring. The ring marks up to 4 enemies.",
			"After a brief delay, Ping shoots up to 4 marked enemies. If only 1 enemy is marked, the shot gains +6 base damage and on hit damages become 150% effective.",
			"If Ping kills at least one enemy with its shots, Ping can shoot the next arrow immediately.",
			"Shots deal 7 physical damage, benefit from base damage bonuses, and apply on hit damages and effects."
		]
		
		var tower_base_effect : PingletAdderEffect = PingletAdderEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(PING, tower_base_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "pinglet"
		
		
	elif tower_id == COIN:
		info = TowerTypeInformation.new("Coin", COIN)
		info.tower_cost = 1
		info.colors.append(TowerColors.YELLOW)
		info.tower_tier = 1
		info.tower_image_in_buy_card = coin_image
		
		info.base_damage = 1.5
		info.base_attk_speed = 0.60
		info.base_pierce = 2
		info.base_range = 100
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Shoots coins at enemies. Coins can hit up to 2 enemies.",
			"When the coin hits an enemy, it turns to its left.",
			"When a coin kills 2 enemies, it grants 1 gold to the player. This effect can be triggered by a coin any amount of times.",
			"The tower has a 1/50 chance of shooting a gold coin, and when it does, the tower grants 1 gold to the player.",
		]
		
		var tower_base_effect : TowerFullSellbackEffect = TowerFullSellbackEffect.new(COIN)
		var ing_effect : IngredientEffect = IngredientEffect.new(COIN, tower_base_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "sellback"
		
		
	elif tower_id == BEACON_DISH:
		info = TowerTypeInformation.new("Beacon-Dish", BEACON_DISH)
		info.tower_cost = 3
		info.colors.append(TowerColors.GRAY)
		info.colors.append(TowerColors.YELLOW)
		info.tower_tier = 3
		info.tower_image_in_buy_card = beacon_dish_image
		
		info.base_damage = 2
		info.base_attk_speed = 0.3
		info.base_pierce = 0
		info.base_range = 150
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Does not attack, but instead gives buffs to towers in range every 5 seconds for 7 seconds.",
			"Grants 50% of its total base damage as an elemental on hit damage buff.",
			"Grants 50% x 100 of its total attack speed as percent attack speed.",
			"Grants 10% of its total range as bonus range.",
			"Note: Does not grant these buffs to another Beacon-Dish. Also overrides any existing Beacon-Dish buffs a tower may have.",
			"",
			"\"Is it a beacon, or a dish?\""
		]
		
		var range_attr_mod : FlatModifier = FlatModifier.new("beacon_range")
		range_attr_mod.flat_modifier = 30
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.ING_BEACON_DISH)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ range"
		
		
	elif tower_id == MINI_TESLA:
		info = TowerTypeInformation.new("Mini Tesla", MINI_TESLA)
		info.tower_cost = 1
		info.colors.append(TowerColors.GRAY)
		info.colors.append(TowerColors.YELLOW)
		info.tower_tier = 1
		info.tower_image_in_buy_card = mini_tesla_image
		
		info.base_damage = 1.25
		info.base_attk_speed = 0.8
		info.base_pierce = 0
		info.base_range = 110
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Mini Tesla applies a stack of \"static\" on enemies hit for 3 seconds, with this duration refreshing per hit.",
			"When an enemy reaches 5 stacks, all stacks get consumed and the enemy is stunned for 2 seconds."
		]
		
		var enemy_final_effect : EnemyStunEffect = EnemyStunEffect.new(1.5, StoreOfEnemyEffectsUUID.ING_MINI_TELSA_STUN)
		var enemy_effect : EnemyStackEffect = EnemyStackEffect.new(enemy_final_effect, 1, 5, StoreOfEnemyEffectsUUID.ING_MINI_TESLA_STACK)
		enemy_effect.is_timebound = true
		enemy_effect.time_in_seconds = 3
		
		var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.ING_MINI_TESLA)
		tower_effect.description = "Applies a stack of \"mini static\" on enemies hit for 3 seconds, with this duration refreshing per hit. When an enemy reaches 5 stacks, all stacks get consumed and the enemy is stunned for 1.5 seconds"
		tower_effect.effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Static.png")
		
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, tower_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "static"
		
		
	elif tower_id == CHARGE:
		info = TowerTypeInformation.new("Charge", CHARGE)
		info.tower_cost = 3
		info.colors.append(TowerColors.YELLOW)
		info.colors.append(TowerColors.RED)
		info.tower_tier = 3
		info.tower_image_in_buy_card = charge_image
		
		info.base_damage = 2
		info.base_attk_speed = 0.65
		info.base_pierce = 1
		info.base_range = 90
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"When idle, Charge accumulates energy. Charge's energy is set to 50% when the round starts.",
			"Upon attacking, Charge expends all energy to deal scaling bonus physical on hit damage based on expended energy.",
			"Max physical on hit damage: 16",
			"",
			"Increasing this tower's total attack speed compared to its base attack speed increases the rate of energy accumulation."
		]
		
		var attr_mod : FlatModifier = FlatModifier.new("ing_charge_on_hit_as_modifier")
		attr_mod.flat_modifier = 1.5
		var on_hit : OnHitDamage = OnHitDamage.new("ing_charge_on_hit", attr_mod, DamageType.PHYSICAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_CHARGE)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == MAGNETIZER:
		info = TowerTypeInformation.new("Magnetizer", MAGNETIZER)
		info.tower_cost = 4
		info.colors.append(TowerColors.YELLOW)
		info.tower_tier = 4
		info.tower_image_in_buy_card = magnetizer_image
		
		info.base_damage = 0
		info.base_attk_speed = 0.48
		info.base_pierce = 1
		info.base_range = 155
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Stats shown are for the magnets.",
			"When shooting, Magnetizer alternates between blue magnet and red magnet. Magnetizer cycles to the next targeting option after shooting a magnet.",
			"Magnets stick to the first enemy they hit. When the enemy they are stuck to dies, they drop on the ground.",
			"When there is at least one blue and one red magnet that has hit an enemy, Magnetizer uses Magnetize.",
			"",
			"Magnetize: Calls upon all of this tower's non traveling magnets to form a beam between their opposite types.",
			"The beam has 7 base damage and deals elemental damage. The beam benefits from base damage buffs. On hit effects and on hit damages are 67% effective."
		]
		
		
		var expl_attr_mod : PercentModifier = PercentModifier.new("magnetizer_bonus_expl_range")
		expl_attr_mod.percent_amount = 40
		expl_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_EXPLOSION_SCALE, expl_attr_mod, StoreOfTowerEffectsUUID.ING_MAGNETIZER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ expl size"
		
		
	
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
	elif tower_id == TESLA:
		return load("res://TowerRelated/Color_Violet/Tesla/Tesla.tscn")
	elif tower_id == CHAOS:
		return load("res://TowerRelated/Color_Violet/Chaos/Chaos.tscn")
	elif tower_id == PING:
		return load("res://TowerRelated/Color_Violet/Ping/Ping.tscn")
	elif tower_id == COIN:
		return load("res://TowerRelated/Color_Yellow/Coin/Coin.tscn")
	elif tower_id == BEACON_DISH:
		return load("res://TowerRelated/Color_Yellow/BeaconDish/BeaconDish.tscn")
	elif tower_id == MINI_TESLA:
		return load("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla.tscn")
	elif tower_id == CHARGE:
		return load("res://TowerRelated/Color_Yellow/Charge/Charge.tscn")
	elif tower_id == MAGNETIZER:
		return load("res://TowerRelated/Color_Yellow/Magnetizer/Magnetizer.tscn")
