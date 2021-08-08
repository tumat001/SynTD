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
const _704_EmblemPointsEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/704EmblemPointsEffect.gd")
const SpikeBonusDamageEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/SpikeBonusDamageEffect.gd")
const ImpaleBonusDamageEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/ImpaleBonusDamage.gd")
const LeaderTargetingTowerEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/LeaderTargetingTowerEffect.gd")
const BleachShredEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/BleachShredEffect.gd")
const TimeMachineEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TimeMachineEffect.gd")

const PingletAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/AttackModuleAdders/PingletAdderEffect.gd")
const TowerChaosTakeoverEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerChaosTakeoverEffect.gd")
const LavaJetModuleAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/AttackModuleAdders/LavaJetModuleAdderEffect.gd")
const FlameBurstModuleAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/AttackModuleAdders/FlameBurstModuleAdderEffect.gd")
const AdeptModuleAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/AttackModuleAdders/AdeptModuleAdderEffect.gd")

const StoreOfEnemyEffectsUUID = preload("res://GameInfoRelated/EnemyEffectRelated/StoreOfEnemyEffectsUUID.gd")
const EnemyAttributesEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyAttributesEffect.gd")
const EnemyStunEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStunEffect.gd")
const TowerOnHitEffectAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitEffectAdderEffect.gd")
const EnemyStackEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyStackEffect.gd")
const TowerOnHitDamageAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerOnHitDamageAdderEffect.gd")
const OnHitDamage = preload("res://GameInfoRelated/OnHitDamage.gd")
const DamageInstance = preload("res://TowerRelated/DamageAndSpawnables/DamageInstance.gd")
const EnemyDmgOverTimeEffect = preload("res://GameInfoRelated/EnemyEffectRelated/EnemyDmgOverTimeEffect.gd")


# GRAY
const mono_image = preload("res://TowerRelated/Color_Gray/Mono/Mono_E.png")
const simplex_image = preload("res://TowerRelated/Color_Gray/Simplex/Simplex_Omni.png")

# RED
const reaper_image = preload("res://TowerRelated/Color_Red/Reaper/Reaper_Omni.png")
const shocker_image = preload("res://TowerRelated/Color_Red/Shocker/Shocker_Omni.png")
const adept_image = preload("res://TowerRelated/Color_Red/Adept/Adept_E.png")
const rebound_image = preload("res://TowerRelated/Color_Red/Rebound/Rebound_E.png")
const striker_image = preload("res://TowerRelated/Color_Red/Striker/Striker_E.png")
const hextribute_image = preload("res://TowerRelated/Color_Red/HexTribute/HexTribute_Omni.png")
const transmutator_image = preload("res://TowerRelated/Color_Red/Transmutator/Transmutator_E.png")

# ORANGE
const ember_image = preload("res://TowerRelated/Color_Orange/Ember/Ember_E.png")
const lava_jet_image = preload("res://TowerRelated/Color_Orange/LavaJet/LavaJet_E.png")
const campfire_image = preload("res://TowerRelated/Color_Orange/Campfire/Campfire_Wholebody.png")
const volcano_image = preload("res://TowerRelated/Color_Orange/Volcano/Volcano_Omni.png")
const _704_image = preload("res://TowerRelated/Color_Orange/704/704_WholeBody.png")
const flameburst_image = preload("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst_E.png")
const scatter_image = preload("res://TowerRelated/Color_Orange/Scatter/Scatter_E.png")
const coal_launcher_image = preload("res://TowerRelated/Color_Orange/CoalLauncher/CoalLauncher_E.png")
const enthalphy_image = preload("res://TowerRelated/Color_Orange/Enthalphy/Enthalphy_WholeBody.png")
const entropy_image = preload("res://TowerRelated/Color_Orange/Entropy/Entropy_WholeBody.png")
const royal_flame_image = preload("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame_E.png")
const ieu_image = preload("res://TowerRelated/Color_Orange/IEU/IEU_Omni_01.png")

# YELLOW
const railgun_image = preload("res://TowerRelated/Color_Yellow/Railgun/Railgun_E.png")
const coin_image = preload("res://TowerRelated/Color_Yellow/Coin/Coin_E.png")
const beacon_dish_image = preload("res://TowerRelated/Color_Yellow/BeaconDish/BeaconDish_Omni.png")
const mini_tesla_image = preload("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla_Omni.png")
const charge_image = preload("res://TowerRelated/Color_Yellow/Charge/Charge_E.png")
const magnetizer_image = preload("res://TowerRelated/Color_Yellow/Magnetizer/Magnetizer_WholeBody.png")
const sunflower_image = preload("res://TowerRelated/Color_Yellow/Sunflower/Sunflower_Idle.png")

# GREEN
const berrybush_image = preload("res://TowerRelated/Color_Green/BerryBush/BerryBush_Omni.png")
const fruit_tree_image = preload("res://TowerRelated/Color_Green/FruitTree/FruitTree_Omni.png")
const spike_image = preload("res://TowerRelated/Color_Green/Spike/Spike_Omni.png")
const impale_image = preload("res://TowerRelated/Color_Green/Impale/Impale_Omni.png")
const seeder_image = preload("res://TowerRelated/Color_Green/Seeder/Seeder_E.png")
const cannon_image = preload("res://TowerRelated/Color_Green/Cannon/Cannon_E.png")
const pestilence_image = preload("res://TowerRelated/Color_Green/Pestilence/Pestilence_Omni.png")
const blossom_image = preload("res://TowerRelated/Color_Green/Blossom/Blossom_Omni_Unpaired.png")
const pinecone_image = preload("res://TowerRelated/Color_Green/PineCone/PineCone_E.png")

# BLUE
const sprinkler_image = preload("res://TowerRelated/Color_Blue/Sprinkler/Sprinkler_E.png")
const leader_image = preload("res://TowerRelated/Color_Blue/Leader/Leader_Omni.png")
const orb_image = preload("res://TowerRelated/Color_Blue/Orb/Orb_Omni.png")
const grand_image = preload("res://TowerRelated/Color_Blue/Grand/Grand_Omni.png")
const douser_image = preload("res://TowerRelated/Color_Blue/Douser/Douser_E.png")
const wave_image = preload("res://TowerRelated/Color_Blue/Wave/Wave_E.png")
const bleach_image = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_E.png")
const time_machine_image = preload("res://TowerRelated/Color_Blue/TimeMachine/TimeMachine_Omni.png")

# VIOLET
const simpleobelisk_image = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_Omni.png")
const re_image = preload("res://TowerRelated/Color_Violet/Re/Re_Omni.png")
const telsa_image = preload("res://TowerRelated/Color_Violet/Tesla/Tesla.png")
const chaos_image = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_01.png")
const ping_image = preload("res://TowerRelated/Color_Violet/Ping/PingWholeBody.png")

# OTHERS
const hero_image = preload("res://TowerRelated/Color_White/Hero/Hero_Omni.png")
const amalgamator_image = preload("res://TowerRelated/Color_Black/Amalgamator/Amalgamator_Omni.png")

enum {
	# GRAY (100)
	MONO = 100,
	SIMPLEX = 101,
	
	# RED (200)
	REAPER = 200,
	SHOCKER = 201,
	ADEPT = 202,
	REBOUND = 203,
	STRIKER = 204,
	HEXTRIBUTE = 205,
	TRANSMUTATOR = 206,
	
	# ORANGE (300)
	EMBER = 300,
	LAVA_JET = 301,
	CAMPFIRE = 302,
	VOLCANO = 303,
	_704 = 304,
	FLAMEBURST = 305,
	SCATTER = 306,
	COAL_LAUNCHER = 307,
	ENTHALPHY = 308,
	ENTROPY = 309,
	ROYAL_FLAME = 310,
	IEU = 311,
	
	# YELLOW (400)
	RAILGUN = 400,
	COIN = 401,
	BEACON_DISH = 402,
	MINI_TESLA = 403,
	CHARGE = 404,
	MAGNETIZER = 405,
	SUNFLOWER = 406,
	
	# GREEN (500)
	BERRY_BUSH = 500,
	FRUIT_TREE = 501,
	SPIKE = 502,
	IMPALE = 503,
	SEEDER = 504,
	CANNON = 505,
	PESTILENCE = 506,
	BLOSSOM = 507,
	PINECONE = 508,
	
	# BLUE (600)
	SPRINKLER = 600,
	LEADER = 601,
	ORB = 602,
	GRAND = 603,
	DOUSER = 604,
	WAVE = 605,
	BLEACH = 606,
	TIME_MACHINE = 607,
	
	# VIOLET (700)
	SIMPLE_OBELISK = 700,
	RE = 701,
	TESLA = 702,
	CHAOS = 703,
	PING = 704,
	
	# OTHERS (900)
	HERO = 900, # WHITE
	AMALGAMATOR = 901 # BLACK
	
	
	# MISC (2000)
	FRUIT_TREE_FRUIT = 2000, #THIS VALUE IS HARDCODED IN AbstractTower's can_accept_ingredient..
}

const TowerTiersMap : Dictionary = {
	
	MONO : 1,
	SPRINKLER : 1,
	SIMPLEX : 1,
	COIN : 1,
	MINI_TESLA : 1,
	EMBER : 1,
	COAL_LAUNCHER : 1,
	SPIKE : 1,
	REBOUND : 1,
	STRIKER : 1,
	PINECONE : 1,
	
	BERRY_BUSH : 2,
	RAILGUN : 2,
	SCATTER : 2,
	ENTHALPHY : 2,
	ENTROPY : 2,
	BLEACH : 2,
	TIME_MACHINE : 2,
	CANNON : 2,
	SHOCKER : 2,
	TRANSMUTATOR : 2,
	HERO : 2,
	FRUIT_TREE_FRUIT : 2,
	AMALGAMATOR : 2,
	
	SIMPLE_OBELISK : 3,
	BEACON_DISH : 3,
	CHARGE : 3,
	CAMPFIRE : 3,
	FLAMEBURST : 3,
	GRAND : 3,
	DOUSER : 3,
	WAVE : 3,
	SEEDER : 3,
	
	RE : 4,
	PING : 4,
	MAGNETIZER : 4,
	SUNFLOWER : 4,
	_704 : 4,
	IEU : 4,
	IMPALE : 4,
	ORB : 4,
	REAPER : 4,
	ADEPT : 4,
	
	VOLCANO : 5,
	FRUIT_TREE : 5,
	LEADER : 5,
	LAVA_JET : 5,
	BLOSSOM : 5,
	
	TESLA : 6,
	CHAOS : 6,
	ROYAL_FLAME : 6,
	PESTILENCE : 6,
	HEXTRIBUTE : 6,
	
}

const tier_base_dmg_map : Dictionary = {
	1 : 0.5,
	2 : 0.75,
	3 : 1.25,
	4 : 1.75,
	5 : 2.5,
	6 : 4.0,
}

const tier_attk_speed_map : Dictionary = {
	1 : 10,
	2 : 20,
	3 : 30,
	4 : 40,
	5 : 50,
	6 : 75,
}

const tier_on_hit_dmg_map : Dictionary = {
	1 : 0.5,
	2 : 1,
	3 : 1.5,
	4 : 2,
	5 : 3,
	6 : 5,
}


static func get_tower_info(tower_id : int) -> TowerTypeInformation :
	var info
	
	if tower_id == MONO:
		info = TowerTypeInformation.new("Mono", MONO)
		info.tower_tier = TowerTiersMap[MONO]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GRAY)
		info.tower_image_in_buy_card = mono_image
		
		info.base_damage = 2.75
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
		info.tower_tier = TowerTiersMap[SPRINKLER]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.tower_image_in_buy_card = sprinkler_image
		
		info.base_damage = 1
		info.base_attk_speed = 2.25
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Sprinkles water droplets at enemies, dealing elemental damage."
		]
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_SPRINKLER)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_SPRINKLER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
	elif tower_id == BERRY_BUSH:
		info = TowerTypeInformation.new("Berry Bush", BERRY_BUSH)
		info.tower_tier = TowerTiersMap[BERRY_BUSH]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = berrybush_image
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Does not attack, but instead gives 1 gold at the end of the round."
		]
		
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_BERRY_BUSH)
		base_dmg_attr_mod.flat_modifier = tier_base_dmg_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_BERRY_BUSH)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ base dmg"
		
		
	elif tower_id == SIMPLE_OBELISK:
		info = TowerTypeInformation.new("Simple Obelisk", SIMPLE_OBELISK)
		info.tower_tier = TowerTiersMap[SIMPLE_OBELISK]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.colors.append(TowerColors.GRAY)
		info.tower_image_in_buy_card = simpleobelisk_image
		
		info.base_damage = 4
		info.base_attk_speed = 0.5
		info.base_pierce = 1
		info.base_range = 180
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Fires arcane bolts at enemies that explode before fizzling out. The explosion deals half of this tower's total base damage.",
			"The explosion does not benefit from bonus on hit damages and effects."
		]
		
		# Ingredient related
		var range_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_SIMPLE_OBELISK)
		range_attr_mod.percent_amount = 35
		range_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.ING_SIMPLE_OBELISK)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ range"
		
		
	elif tower_id == SIMPLEX:
		info = TowerTypeInformation.new("Simplex", SIMPLEX)
		info.tower_tier = TowerTiersMap[SIMPLEX]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GRAY)
		info.tower_image_in_buy_card = simplex_image
		
		info.base_damage = 0.325
		info.base_attk_speed = 8
		info.base_pierce = 0
		info.base_range = 110
		info.base_damage_type = DamageType.PURE
		info.on_hit_multiplier = 0.125
		
		info.tower_descriptions = [
			"Directs a constant pure energy beam at a single target.",
			"\"First Iteration\""
		]
		
		
	elif tower_id == RAILGUN:
		info = TowerTypeInformation.new("Railgun", RAILGUN)
		info.tower_tier = TowerTiersMap[RAILGUN]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.YELLOW)
		info.tower_image_in_buy_card = railgun_image
		
		info.base_damage = 5
		info.base_attk_speed = 0.25
		info.base_pierce = 4
		info.base_range = 100
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Shoots a dart that pierces through 4 enemies."
		]
		
		# Ingredient related
		var base_pierce_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_RAILGUN)
		base_pierce_attr_mod.flat_modifier = 1
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_PIERCE , base_pierce_attr_mod, StoreOfTowerEffectsUUID.ING_RAILGUN)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ pierce"
		
		
	elif tower_id == RE:
		info = TowerTypeInformation.new("Re", RE)
		info.tower_tier = TowerTiersMap[RE]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.tower_image_in_buy_card = re_image
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.5
		info.base_pierce = 0
		info.base_range = 115
		info.base_damage_type = DamageType.PURE
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Cleanses enemies from all buffs and debuffs on hit.",
			"Attacks in bursts of 3"
		]
		
		var tower_effect = TowerResetEffects.new(StoreOfTowerEffectsUUID.ING_RE)
		var ing_effect = IngredientEffect.new(tower_id, tower_effect)
		ing_effect.ignore_ingredient_limit = true
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "clear"
		
		
	elif tower_id == TESLA:
		info = TowerTypeInformation.new("Tesla", TESLA)
		info.tower_tier = TowerTiersMap[TESLA]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.colors.append(TowerColors.YELLOW)
		info.tower_image_in_buy_card = telsa_image
		
		info.base_damage = 3.5
		info.base_attk_speed = 1.5
		info.base_pierce = 0
		info.base_range = 145
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Shocks and stuns its target for 0.3 seconds on hit.",
			"Simple, yet effective."
		]
		
		var enemy_effect : EnemyStunEffect = EnemyStunEffect.new(0.3, StoreOfEnemyEffectsUUID.ING_TESLA)
		var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.ING_TESLA)
		var ing_effect : IngredientEffect = IngredientEffect.new(TESLA, tower_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "stun on hit"
		
		
	elif tower_id == CHAOS:
		info = TowerTypeInformation.new("CHAOS", CHAOS)
		info.tower_tier = TowerTiersMap[CHAOS]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.tower_image_in_buy_card = chaos_image
		
		info.base_damage = 1.5
		info.base_attk_speed = 1.5
		info.base_pierce = 1
		info.base_range = 135
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Has many attacks. Shoots orbs, diamonds, and bolts. Stats shown are for the orbs.",
			"Only the orbs are affected by targeting options. The orbs are considered to be CHAOS's main attack.",
			"Only the diamonds benefit from pierce buffs and apply on hit damage and effects. On hit effects are 200% effective.",
			"Only the bolts benefit from attack speed buffs.",
			"All benefit from range and base damage buffs. Diamonds and bolts benefit from base damage buffs at 25% efficiency.",
			"Upon dealing 80 damage with the orbs, diamonds and bolts, CHAOS erupts a dark sword to stab the orb's target. The sword deals 20 + 500% of CHAOS's total base damage as physical damage."
		]
		
		var tower_base_effect : TowerChaosTakeoverEffect = TowerChaosTakeoverEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(CHAOS, tower_base_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "takeover"
		
		
	elif tower_id == PING:
		info = TowerTypeInformation.new("Ping", PING)
		info.tower_tier = TowerTiersMap[PING]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.colors.append(TowerColors.BLUE)
		info.tower_image_in_buy_card = ping_image
		
		info.base_damage = 1
		info.base_attk_speed = 0.30
		info.base_pierce = 1
		info.base_range = 155
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Stats shown are for the arrow.",
			"Shoots an arrow that releases a ring. The ring marks up to 4 unmarked enemies.",
			"After a brief delay, Ping shoots all marked enemies, consuming all marks in the process. If only 1 enemy is marked, the shot is empowered, dealing 9 base damage and on hit damages become 150% effective.",
			"Ping can shoot the next arrow immediately when it kills at least one enemy with its shots.",
			"Shots deal 3.5 physical damage, benefit from base damage bonuses, and apply on hit damages and effects."
		]
		
		var tower_base_effect : PingletAdderEffect = PingletAdderEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(PING, tower_base_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "pinglet"
		
		
	elif tower_id == COIN:
		info = TowerTypeInformation.new("Coin", COIN)
		info.tower_tier = TowerTiersMap[COIN]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.YELLOW)
		info.tower_image_in_buy_card = coin_image
		
		info.base_damage = 1.75
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
		info.tower_tier = TowerTiersMap[BEACON_DISH]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GRAY)
		info.colors.append(TowerColors.YELLOW)
		info.tower_image_in_buy_card = beacon_dish_image
		
		info.base_damage = 1.0
		info.base_attk_speed = 0.6
		info.base_pierce = 0
		info.base_range = 150
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Does not attack, but instead casts an aura that buffs towers in range every 5 seconds for 7 seconds.",
			"Grants 25% of its total base damage as an elemental on hit damage buff.",
			"Grants 25% x 100 of its total attack speed as percent attack speed (of receiving tower).",
			"Grants 10% of its total range as bonus range.",
			"These bonuses are increased by ability potency.",
			"Note: Does not grant these buffs to another Beacon-Dish. Also overrides any existing Beacon-Dish buffs a tower may have.",
			"",
			"\"Is it a beacon, or a dish?\""
		]
		
		var range_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_BEACON_DISH)
		range_attr_mod.flat_modifier = 45
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.ING_BEACON_DISH)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ range"
		
		
	elif tower_id == MINI_TESLA:
		info = TowerTypeInformation.new("Mini Tesla", MINI_TESLA)
		info.tower_tier = TowerTiersMap[MINI_TESLA]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GRAY)
		info.colors.append(TowerColors.YELLOW)
		info.tower_image_in_buy_card = mini_tesla_image
		
		info.base_damage = 1.5
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
		info.tower_tier = TowerTiersMap[CHARGE]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.YELLOW)
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = charge_image
		
		info.base_damage = 2
		info.base_attk_speed = 0.65
		info.base_pierce = 1
		info.base_range = 90
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"When idle, Charge accumulates energy. Charge's energy is set to 50% when the round starts.",
			"Upon attacking, Charge expends all energy to deal bonus physical on hit damage based on expended energy.",
			"Max physical on hit damage: 16",
			"",
			"Increasing this tower's total attack speed compared to its base attack speed increases the rate of energy accumulation."
		]
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_CHARGE)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_CHARGE, attr_mod, DamageType.PHYSICAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_CHARGE)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == MAGNETIZER:
		info = TowerTypeInformation.new("Magnetizer", MAGNETIZER)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.YELLOW)
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
			"When there is at least one blue and one red magnet that has hit an enemy, Magnetizer casts Magnetize.",
			"",
			"Magnetize: Calls upon all of this tower's non traveling magnets to form a beam between their opposite types.",
			"The beam has 7 base damage and deals elemental damage. The beam benefits from base damage buffs. On hit effects and on hit damages are 67% effective."
		]
		
		
		var expl_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_MAGNETIZER)
		expl_attr_mod.percent_amount = 80
		expl_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_EXPLOSION_SCALE, expl_attr_mod, StoreOfTowerEffectsUUID.ING_MAGNETIZER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ expl"
		
		
	elif tower_id == SUNFLOWER:
		info = TowerTypeInformation.new("Sunflower", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.colors.append(TowerColors.YELLOW)
		info.tower_image_in_buy_card = sunflower_image
		
		info.base_damage = 1
		info.base_attk_speed = 0.35
		info.base_pierce = 1
		info.base_range = 115
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 0.5
		
		info.tower_descriptions = [
			"Sprays lots of seeds at enemies. Attacks in bursts of 7.",
			"Sunflower's attacks benefit from base damage and on hit damages at 50% efficiency.",
			"",
			"\"Half plant half machine\""
		]
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_SUNFLOWER)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_SUNFLOWER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
	elif tower_id == EMBER:
		info = TowerTypeInformation.new("Ember", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.tower_image_in_buy_card = ember_image
		
		info.base_damage = 0.5
		info.base_attk_speed = 0.65
		info.base_pierce = 1
		info.base_range = 95
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Heats up its shots, causing them to burn enemies hit.",
			"Burns enemies for 0.5 elemental damage per second for 5 seconds."
		]
		
		# Ingredient related TODO REPLACE THIS
		var burn_dmg : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_EMBER)
		burn_dmg.flat_modifier = 0.5
		
		var burn_on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_EMBER, burn_dmg, DamageType.ELEMENTAL)
		var burn_dmg_instance = DamageInstance.new()
		burn_dmg_instance.on_hit_damages[burn_on_hit.internal_id] = burn_on_hit
		
		var burn_effect = EnemyDmgOverTimeEffect.new(burn_dmg_instance, StoreOfEnemyEffectsUUID.ING_EMBER_BURN, 1)
		burn_effect.is_timebound = true
		burn_effect.time_in_seconds = 5
		
		var tower_effect = TowerOnHitEffectAdderEffect.new(burn_effect, StoreOfTowerEffectsUUID.ING_EMBER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, tower_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "burn"
		
		
	elif tower_id == LAVA_JET:
		info = TowerTypeInformation.new("Lava Jet", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.tower_image_in_buy_card = lava_jet_image
		
		info.base_damage = 2
		info.base_attk_speed = 0.975
		info.base_pierce = 1
		info.base_range = 125
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"On its 5th main attack, Lava Jet releases a beam of lava that deals 50% of the enemy's max health as elemental damage, up to a limit."
		]
		
		var tower_effect = LavaJetModuleAdderEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, tower_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "lava jet"
		
		
	elif tower_id == CAMPFIRE:
		info = TowerTypeInformation.new("Campfire", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.tower_image_in_buy_card = campfire_image
		
		info.base_damage = 4
		info.base_attk_speed = 1
		info.base_pierce = 0
		info.base_range = 135
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Campfire gains Rage equivalent to the damage taken by enemies within its range.",
			"Upon reaching the Rage limit, Campfire consumes all Rage to cast Heat-Pact",
			"",
			"Heat Pact: The next (benefiting) shot of a tower deals bonus physical on hit damage equal to Campfire's total damage.",
			"",
			"Campfire does not gain Rage from the damage its buff has dealt.",
			"The Rage threshold is decreased by increasing Campfire's total attack speed or increasing Campfire's ability cdr."
		]
		
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_CAMPFIRE)
		base_dmg_attr_mod.flat_modifier = tier_base_dmg_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_CAMPFIRE)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ base dmg"
		
		
	elif tower_id == VOLCANO:
		info = TowerTypeInformation.new("Volcano", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.tower_image_in_buy_card = volcano_image
		
		info.base_damage = 0
		info.base_attk_speed = 0.1
		info.base_pierce = 0
		info.base_range = 240
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Launches a molten boulder at the target's location.",
			"The boulder explodes upon reaching the location, dealing 6 physical base damage. The explosion applies on hit effects, and applies on hit damages at 500% efficiency.",
			"The explosion also leaves behind scorched earth that lasts for 6 seconds, which slows enemies and deals 0.75 elemental damage per 0.75 seconds while inside it. This does not apply on hit damages and effects.",
			"Both the explosion and scorched earth benefit from base damage buffs."
		]
		
		var expl_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_VOLCANO)
		expl_attr_mod.percent_amount = 100
		expl_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_EXPLOSION_SCALE, expl_attr_mod, StoreOfTowerEffectsUUID.ING_VOLCANO)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ expl"
		
		
	elif tower_id == _704:
		info = TowerTypeInformation.new("704", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.colors.append(TowerColors.GRAY)
		info.tower_image_in_buy_card = _704_image
		
		info.base_damage = 3
		info.base_attk_speed = 0.8
		info.base_pierce = 0
		info.base_range = 140
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"704 possesses 3 emblems, and each can be upgraded to give bonus effects.",
			"704's emblems can be upgraded with points, and each can be upgraded up to 4 times. 704 starts with 4 points.",
			"",
			"\"704 is an open furnace with [redacted] origins.\""
		]
		
		var effect := _704_EmblemPointsEffect.new()
		var ing_effect := IngredientEffect.new(tower_id, effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "points"
		
		
	elif tower_id == FLAMEBURST:
		info = TowerTypeInformation.new("Flameburst", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.tower_image_in_buy_card = flameburst_image
		
		info.base_damage = 3
		info.base_attk_speed = 0.775
		info.base_pierce = 1
		info.base_range = 115
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Flameburst's main attack causes enemies to spew out 6 flamelets around itself.",
			"The flamelets deal 1 elemental damage. These benefit from base damage buffs and on hit damages at 15% efficiency. Does not apply on hit effects.",
			"Bonus range gained increases the range of the flamelets."
		]
		
		var effect := FlameBurstModuleAdderEffect.new()
		var ing_effect := IngredientEffect.new(tower_id, effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "flamelets"
		
		
	elif tower_id == SCATTER:
		info = TowerTypeInformation.new("Scatter", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.tower_image_in_buy_card = scatter_image
		
		info.base_damage = 1.5
		info.base_attk_speed = 0.575
		info.base_pierce = 1
		info.base_range = 110
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 0.75
		
		info.tower_descriptions = [
			"Shoots 3 heated iron fragments at enemies."
		]
		
		
	elif tower_id == COAL_LAUNCHER:
		info = TowerTypeInformation.new("Coal Launcher", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.tower_image_in_buy_card = coal_launcher_image
		
		info.base_damage = 2.75
		info.base_attk_speed = 0.475
		info.base_pierce = 1
		info.base_range = 115
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Launches a piece of coal at enemies. The coal increases the duration of all burns the enemy is suffering from for 1.5 seconds."
		]
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_COAL_LAUNCHER)
		base_dmg_attr_mod.flat_modifier = 0.75
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_COAL_LAUNCHER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ base dmg"
		
		
	elif tower_id == ENTHALPHY:
		info = TowerTypeInformation.new("Enthalphy", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.tower_image_in_buy_card = enthalphy_image
		
		info.base_damage = 2
		info.base_attk_speed = 0.8
		info.base_pierce = 0
		info.base_range = 135
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Enthalphy gains bonus elemental on hit damage based on the ratio of its total range to its base range. For every 40 bonus range, Enthalphy gains 0.75 damage.",
			"Enthalphy also deals bonus 1.25 elemental on hit damage for its next two attacks after killing an enemy.",
			"",
			"\"H. 1) Increase reach of system. 2) Increase will of system.\""
		]
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_ENTHALPHY)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_ENTHALPHY, attr_mod, DamageType.ELEMENTAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_ENTHALPHY)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == ENTROPY:
		info = TowerTypeInformation.new("Entropy", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.tower_image_in_buy_card = entropy_image
		
		info.base_damage = 2
		info.base_attk_speed = 0.70
		info.base_pierce = 0
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Entropy gains 20% bonus attack speed for its first 130 attacks.",
			"Entropy also gains 20% bonus attack speed for its first 230 attacks.",
			"",
			"\"S. The inevitable end of all systems.\""
		]
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_ENTROPY)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_ENTROPY)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
	elif tower_id == ROYAL_FLAME:
		info = TowerTypeInformation.new("Royal Flame", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.colors.append(TowerColors.BLUE)
		info.tower_image_in_buy_card = royal_flame_image
		
		info.base_damage = 3
		info.base_attk_speed = 1.05
		info.base_pierce = 1
		info.base_range = 140
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Royal Flame's attacks burn enemies for 22.5% of its base damage every 0.5 seconds for 8 seconds.",
			"",
			"Ability: Steam Burst. Extinguishes the 3 closest enemies burned by Royal Flame. Extinguishing enemies creates a steam explosion that deals 40% of the extinguished enemy's missing health as elemental damage, up to a limit.",
			"The explosion does not affect the extinguished target. The explosion benefits only from explosion size buffs, damage mitigation pierce buffs, and ability related buffs.",
			"Cooldown: 25 s"
			# THIS SAME PASSAGE is placed in royal flame's
			# ability tooltip. If this is changed, then
			# change the ability tooltip.
		]
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_ROYAL_FLAME)
		base_dmg_attr_mod.flat_modifier = tier_base_dmg_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_ROYAL_FLAME)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ base dmg"
		
		
	elif tower_id == IEU:
		info = TowerTypeInformation.new("IE=U", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.colors.append(TowerColors.YELLOW)
		info.tower_image_in_buy_card = ieu_image
		
		info.base_damage = 2
		info.base_attk_speed = 1
		info.base_pierce = 0
		info.base_range = 125
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1.25
		
		info.tower_descriptions = [
			"IE=U discards the ingredient effect of Entropy and Enthalphy when they are absorbed. Instead, a temporary buff that lasts for 5 rounds is received.",
			"Absorbing Entropy gives 60% bonus attack speed for the first, and 20% for the subsequent.",
			"Absorbing Enthalphy gives 125 bonus range for the first, and 45 for the subsequent.",
			"",
			"\"Feed the system.\""
		]
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_IEU)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_IEU)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
	elif tower_id == FRUIT_TREE:
		info = TowerTypeInformation.new("Fruit Tree", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = fruit_tree_image
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Does not attack, but instead gives a fruit at the end of every 3rd round of being in the map.",
			"Fruits appear in the tower bench, and will be converted into gold when no space is available.",
			"Fruits do not attack, but have an ingredient effect. Fruits can be given to any tower disregarding tower color.",
		]
		
		
	elif tower_id == FRUIT_TREE_FRUIT:
		info = TowerTypeInformation.new("Fruit", tower_id)
#		info.tower_tier = TowerTiersMap[tower_id]
#		info.tower_cost = info.tower_tier
		info.tower_tier = 2
		info.tower_cost = 2
		info.tower_image_in_buy_card = fruit_tree_image
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Fruit from Fruit Tree."
		]
		
		
	elif tower_id == SPIKE:
		info = TowerTypeInformation.new("Spike", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = spike_image
		
		info.base_damage = 2
		info.base_attk_speed = 0.75
		info.base_pierce = 0
		info.base_range = 115
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Spike's main attack deals 2 extra physical damage to enemies below 50% health."
		]
		
		
		var spike_dmg_effect = SpikeBonusDamageEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, spike_dmg_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "spike"
		
		
	elif tower_id == IMPALE:
		info = TowerTypeInformation.new("Impale", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = impale_image
		
		info.base_damage = 9
		info.base_attk_speed = 0.2
		info.base_pierce = 0
		info.base_range = 115
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Impale shoots up a spike that stabs an enemy, stunning them for 2.2 seconds.",
			"When the stun expires, Impale retracts the spike, dealing damage again.",
			"The retract damage becomes 180% effective when the enemy has less than 75% of their max health.",
			
		]
		
		var imp_dmg_effect = ImpaleBonusDamageEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, imp_dmg_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "impale"
		
		
		
	elif tower_id == LEADER:
		info = TowerTypeInformation.new("Leader", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.tower_image_in_buy_card = leader_image
		
		info.base_damage = 0.5
		info.base_attk_speed = 1
		info.base_pierce = 0
		info.base_range = 155
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0.5
		
		info.tower_descriptions = [
			"Leader's main attack marks the target enemy. Only one enemy can be marked at a time.",
			"Leader also manages members. Leader can have up to 5 members. Leader cannot have itself or another Leader as its member.",
			"",
			"Ability: Coordinated Attack. Orders all members to attack the marked enemy once, regardless of range.",
			"Projectiles gain extra range to be able to reach the marked target.",
			"Member's damage in Coordinated Attack scales with Leader's total ability potency.",
			"Cooldown: 12.5 s"
			# THIS SAME PASSAGE is placed in leader's
			# ability tooltip. If this is changed, then
			# change the ability tooltip.
		]
		
		var targ_effect = LeaderTargetingTowerEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, targ_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "targeting"
		
		
	elif tower_id == ORB:
		info = TowerTypeInformation.new("Orb", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.tower_image_in_buy_card = orb_image
		
		info.base_damage = 1.75
		info.base_attk_speed = 0.875
		info.base_pierce = 1
		info.base_range = 130
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Orb gains new attacks at 1.25, 1.50, and 2.00 total ability potency.",
			"",
			"\"Where does the power reside? The wizard, or the orb?\""
		]
		
		
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_ORB)
		base_ap_attr_mod.flat_modifier = 0.25
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.ING_ORB)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ ap"
		
		
	elif tower_id == GRAND:
		info = TowerTypeInformation.new("Grand", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.tower_image_in_buy_card = grand_image
		
		info.base_damage = 4
		info.base_attk_speed = 0.55
		info.base_pierce = 1
		info.base_range = 150
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Grand gains bonus pierce and projectile speed at 1.25, 1.50, and 2.00 total ability potency.",
			"Grand's main attack damage also scales with its total ability potency.",
			"",
			"\"Where does the power reside? The (hand of a) wizard, or the orb?\""
		]
		
		
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_GRAND)
		base_ap_attr_mod.flat_modifier = 0.25
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.ING_GRAND)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ ap"
		
		
		
	elif tower_id == DOUSER:
		info = TowerTypeInformation.new("Douser", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.tower_image_in_buy_card = douser_image
		
		info.base_damage = 2
		info.base_attk_speed = 0.85
		info.base_pierce = 0
		info.base_range = 150
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Every after 4th main attack, Douser casts Buffing Waters.",
			"",
			"Buffing Waters: Douser shoots a water ball at the closest tower.",
			"Towers hit by Buffing Waters gain 0.75 bonus base damage for the next 4 benefiting attacks within 10 seconds.",
			"The casting Douser also benefits from its own Buffing Water's buff.",
			"Douser does not target towers that currently have the buff. Douser also does not target other Dousers, but can affect them if hit.",
			"",
			"Buffing Waters benefits from bonus pierce. Ability cdr reduces the needed attacks to trigger this ability."
		]
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_DOUSER)
		base_dmg_attr_mod.flat_modifier = tier_base_dmg_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_DOUSER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ base dmg"
		
		
	elif tower_id == WAVE:
		info = TowerTypeInformation.new("Wave", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.tower_image_in_buy_card = wave_image
		
		info.base_damage = 0.5
		info.base_attk_speed = 0.25
		info.base_pierce = 0
		info.base_range = 150
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Wave attacks in bursts of 2.",
			"Passive: Wave gains 2 elemental on hit damage.",
			"",
			"Ability: Tidal Wave. Wave sprays 8 columns of water in a cone facing its current target.",
			"Each column deals twice of Wave's passive on hit damage to all enemies hit.",
			"Each column explodes when reaching its max distance, or when hitting 2 enemies. Each explosion deals 0.75 elemental damage to 2 enemies.",
			"Activating Tidal Wave reduces the passive on hit damage by 0.5 for 30 seconds. This effect stacks, but does not refresh other stacks.",
			"Cooldown : 6 s",
			"",
			"Additional info is present in this ability's tooltip."
		]
		
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_WAVE)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_WAVE, attr_mod, DamageType.ELEMENTAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_WAVE)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == BLEACH:
		info = TowerTypeInformation.new("Bleach", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.tower_image_in_buy_card = bleach_image
		
		info.base_damage = 2.25
		info.base_attk_speed = 0.92
		info.base_pierce = 1
		info.base_range = 125
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Every 5th attack, Bleach's main attack removes 7.5 toughness from enemies hit for 5 seconds. Does not stack."
		]
		
		
		var shred_effect = BleachShredEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, shred_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "- toughness"
		
		
	elif tower_id == TIME_MACHINE:
		info = TowerTypeInformation.new("Time Machine", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.colors.append(TowerColors.YELLOW)
		info.tower_image_in_buy_card = time_machine_image
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.70
		info.base_pierce = 1
		info.base_range = 125
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Automatically attempts to casts Rewind after attacking an enemy.",
			"Rewind: After a brief delay, Time machine teleports an enemy a few paces backwards.",
			"Cooldown: 15 s",
			"",
			"Rewind also applies 3 stacks of Time Dust onto an enemy for 6 seconds. Time Machine’s main attacks onto an enemy consume a stack of Time Dust, reducing Rewind’s cooldown by 2 seconds."
		]
		
		
		var effect = TimeMachineEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, effect)
		ing_effect.ignore_ingredient_limit = true
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "ing remove"
		
		
	elif tower_id == SEEDER:
		info = TowerTypeInformation.new("Seeder", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = seeder_image
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.85
		info.base_pierce = 1
		info.base_range = 132
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Automatically attempts to casts Seed Bomb when hitting an enemy with its main attack.",
			"Seed Bomb: Seeder implants a seed bomb to an enemy. Seeder's pea attacks causes the seed to gain a stack of Fragile.",
			"After 6 seconds or reaching 4 stacks of Fragile, the seed bomb explodes, hitting up to 5 enemies. The explosion's damage scales with its Fragile stacks.",
			"Cooldown : 25 s",
			"",
			"Seed Bomb's explosion deals 14 physical damage. The explosion benefits from base damage buffs at 400% efficiency, and benefits from on hit damages and effects at 200% efficiency.",
			"The explosion only deals 25% of its damage, but each Fragile stack allows the explosion to deal 25% more of its damage (totalling up to 125%).",
		]
		
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_SEEDER)
		base_dmg_attr_mod.flat_modifier = tier_base_dmg_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_SEEDER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ base dmg"
		
		
	elif tower_id == CANNON:
		info = TowerTypeInformation.new("Cannon", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = cannon_image
		
		info.base_damage = 0
		info.base_attk_speed = 0.425
		info.base_pierce = 0
		info.base_range = 125
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Shoots an exploding fruit.",
			"The explosion deals 2.75 physical damage to 3 enemies. The explosion benefits from base damage buffs, on hit damages and effects."
		]
		
		
		var expl_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_CANNON)
		expl_attr_mod.percent_amount = 60
		expl_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_EXPLOSION_SCALE, expl_attr_mod, StoreOfTowerEffectsUUID.ING_CANNON)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ expl"
		
		
	elif tower_id == PESTILENCE:
		info = TowerTypeInformation.new("Pestilence", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.colors.append(TowerColors.GRAY)
		info.tower_image_in_buy_card = pestilence_image
		
		info.base_damage = 0.5
		info.base_attk_speed = 1.1
		info.base_pierce = 0
		info.base_range = 145
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0.2
		
		info.tower_descriptions = [
			"Pestilence permanently poisons enemies it hits. The poison deals 1 elemental damage per second.",
			"Pestilence also applies one stack of Toxin to enemies hit. Toxin lasts for 8 seconds that refresh per apply.",
			"Enemies become permanently Noxious upon gaining 8 Toxin stacks.",
			"",
			"Pestilence's main attacks against Noxious enemies causes 6 exploding poison darts to rain around the target enemy's location.",
			"Explosions apply a stack of Toxin. Explosions benefit from base damage buffs, on hit damages and effects at 33% efficiency.",
			"",
			"At the start of the round or when placed in the map, Pestilence reduces the attack speed of all towers in range by 25% for the round.",
			"For each tower affected, Pestilence gains 35% attack speed for the round."
		]
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_PESTILENCE)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_PESTILENCE)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
	elif tower_id == REAPER:
		info = TowerTypeInformation.new("Reaper", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.colors.append(TowerColors.GRAY)
		info.tower_image_in_buy_card = reaper_image
		
		info.base_damage = 2.75
		info.base_attk_speed = 0.725
		info.base_pierce = 1
		info.base_range = 135
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Reaper's attacks deal additional 12% of the enemy's missing health as elemental damage, up to 20 health.",
			"",
			"Killing an enemy allows Reaper to cast Slash once. Slash has a cooldown of 0.125 seconds.",
			"Slash: Reaper shashes the area of the closest enemy, dealing 200% of this tower's base damage as physical damage to each enemy hit. Does not apply on hit damages and effects.",
			"Casting Slash reduces the damage of subsequent slashes by 50% for 1 second. This does not stack."
		]
		
		var reap_dmg_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_REAPER)
		reap_dmg_modifier.percent_amount = 8
		reap_dmg_modifier.percent_based_on = PercentType.MISSING
		reap_dmg_modifier.ignore_flat_limits = false
		reap_dmg_modifier.flat_maximum = 15
		reap_dmg_modifier.flat_minimum = 0
		
		var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_REAPER, reap_dmg_modifier, DamageType.ELEMENTAL)
		
		var reap_dmg_effect = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.ING_REAPER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, reap_dmg_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == SHOCKER:
		info = TowerTypeInformation.new("Shocker", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = shocker_image
		
		info.base_damage = 0
		info.base_attk_speed = 0.5
		info.base_pierce = 1
		info.base_range = 115
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Shocker possesses one shocker ball, which is shot when an enemy is in range. The shocker ball sticks to the first enemy it hits.",
			"The ball zaps the closest enemy within its range every time the enemy it is stuck to is hit by an attack. This event does not occur when the triggering attack is from another shocker ball.",
			"The ball returns to Shocker when the enemy dies, exits the map, or when the ball fails to stick to a target.",
			"",
			"Shocker ball has 100 range. Its bolts deal 2 elemental damage. Bolts apply on hit damages and effects at 50% efficiency.",
		]
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_SHOCKER)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_SHOCKER, attr_mod, DamageType.ELEMENTAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_SHOCKER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == ADEPT:
		info = TowerTypeInformation.new("Adept", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = adept_image
		
		info.base_damage = 2.25
		info.base_attk_speed = 1.1
		info.base_pierce = 1
		info.base_range = 140
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Adept's attacks gain bonus effects based on its current target's distance from itself on hit.",
			"Beyond 85% of range: Adept's main attack deals 30% more damage, and slows enemies hit by 10% for 1 second.",
			"Below 35% of range: Adept's main attack causes a secondary attack to fire. The secondary attack seeks another target. This is also considered to be Adept's main attack.",
			"The secondary attack deals 1.5 physical damage and applies on hit effects. The shot benefits from base damage buffs and on hit damages at 15% efficiency.",
			"",
			"After 3 rounds of being active, Adept gains Far and Close targeting options."
		]
		
		var tower_base_effect : AdeptModuleAdderEffect = AdeptModuleAdderEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, tower_base_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "adeptling"
		
		
		
	elif tower_id == REBOUND:
		info = TowerTypeInformation.new("Rebound", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = rebound_image
		
		info.base_damage = 2
		info.base_attk_speed = 0.4
		info.base_pierce = 2
		info.base_range = 115
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Rebound shoots discs that slow down upon hitting its first enemy.",
			"Upon reaching its max distance, the disc travels back to Rebound, refreshing its pierce and dealing damage to enemies in the path again."
		]
		
		var base_pierce_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_REBOUND)
		base_pierce_attr_mod.flat_modifier = 1
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_PIERCE , base_pierce_attr_mod, StoreOfTowerEffectsUUID.ING_REBOUND)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ pierce"
		
		
		
	elif tower_id == STRIKER:
		info = TowerTypeInformation.new("Striker", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = striker_image
		
		info.base_damage = 1.75
		info.base_attk_speed = 0.675
		info.base_pierce = 1
		info.base_range = 125
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Every 3rd main attack deals extra 1 physical damage on hit.",
			"Every 9th main attack deals extra 2.5 physical damage on hit instead."
		]
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_STRIKER)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_STRIKER, attr_mod, DamageType.PHYSICAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_STRIKER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == HEXTRIBUTE:
		info = TowerTypeInformation.new("Hextribute", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = hextribute_image
		
		info.base_damage = 2
		info.base_attk_speed = 2.15
		info.base_pierce = 1
		info.base_range = 155
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Each main attack is infused with a hex. Enemies gain curses as effects after reaching a certain number of hexes. Hexes and Curses last indefinitely.",
			"3 hex: Enemies take extra 1.5 elemental damage from HexTribute's main attack.",
			"6 hex: Enemies's armor is reduced by 25%.",
			"9 hex: Enemies's toughness is reduced by 25%.",
			"12 hex: Enemies become 75% more vulnerable to effects.",
			"15 hex: Enemy buffs HexTribute to infuse 3 hexes per main attack for the rest of the round.",
			"210 hex: Executes the enemy."
		]
		
		
		var effect_vul_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.ING_HEXTRIBUTE_EFFECT_VUL)
		effect_vul_modi.percent_amount = 50
		effect_vul_modi.percent_based_on = PercentType.BASE
		var hextribute_effect_vul_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_EFFECT_VULNERABILITY, effect_vul_modi, StoreOfEnemyEffectsUUID.ING_HEXTRIBUTE_EFFECT_VUL)
		hextribute_effect_vul_effect.is_timebound = true
		hextribute_effect_vul_effect.time_in_seconds = 10
		
		var on_hit_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(hextribute_effect_vul_effect, StoreOfTowerEffectsUUID.ING_HEXTRIBUTE)
		
		
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, on_hit_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ effect vul"
		
		
	elif tower_id == TRANSMUTATOR:
		info = TowerTypeInformation.new("Transmutator", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = transmutator_image
		
		info.base_damage = 2
		info.base_attk_speed = 0.4
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Main attacks cause different effects based on the enemy’s current health",
			"If the enemy has missing health, the enemy is slowed by 70% for 0.5 seconds.",
			"If the enemy has full health, the enemy’s maximum health is reduced by 12.5%. This effect does not stack.",
			"Ability potency increases maximum health percent reduction."
		]
		
		
		
	elif tower_id == HERO:
		info = TowerTypeInformation.new("Hero", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.WHITE)
		info.tower_image_in_buy_card = hero_image
		
		info.base_damage = 1.25
		info.base_attk_speed = 0.80
		info.base_pierce = 1
		info.base_range = 140
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"The Hero grows stronger by accumulating EXP. EXP is gained by various methods.",
			"Levels are gained by spending EXP and gold. Only 6 levels can be gained this way. Levels are used to unlock and upgrade the Hero's skills.",
			"Hero's skills are in effect only when White is the active dominant color.",
			"",
			"The Hero can absorb any ingredient color. Hero can also absorb 3 more ingredients.",
		]
		
		
		
	elif tower_id == AMALGAMATOR:
		info = TowerTypeInformation.new("Amalgamator", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLACK)
		info.tower_image_in_buy_card = amalgamator_image
		
		info.base_damage = 2.25
		info.base_attk_speed = 0.90
		info.base_pierce = 1
		info.base_range = 140
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Every end of round, Amalgamator selects a random non-black tower in the map to apply Amalgamate.",
			"Amalgamate: Sets a tower's color to black, erasing all previous colors."
		]
		
		
	elif tower_id == BLOSSOM:
		info = TowerTypeInformation.new("Blossom", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = blossom_image
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 1
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Blossom can assign a tower as its Partner.",
			"The Partner receives these bonus effects while Blossom is alive:",
			"+ 30% total attack speed, up to 2 attack speed.",
			"+ 40% total base damage, up to 4 base damage.",
			"+ 3% healing from all post mitigated damage dealt.",
			"+ Instant Revive effect. If the Partner reaches 0 health, Blossom sacrifices itself for the rest of the round to revive its Partner to full health.",
			"",
			"Blossom can only have one Partner. Blossom cannot pair with another Blossom. Blossom cannot pair with a tower that's already paired with another Blossom."
		]
		
		
		var base_health_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_BLOSSOM)
		base_health_mod.percent_amount = 100
		base_health_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_HEALTH , base_health_mod, StoreOfTowerEffectsUUID.ING_BLOSSOM)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ health"
		
		
	elif tower_id == PINECONE:
		info = TowerTypeInformation.new("Pinecone", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = pinecone_image
		
		info.base_damage = 2
		info.base_attk_speed = 0.575
		info.base_pierce = 1
		info.base_range = 100
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Shoots a cone that fragments into 3 pieces upon hitting an enemy.",
			"Each piece deals 1 physical damage.",
			"",
			"Cones do not benefit from bonus pierce."
		]
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_PINECONE)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_PINECONE, attr_mod, DamageType.PHYSICAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_PINECONE)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	
	
	
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
	elif tower_id == SUNFLOWER:
		return load("res://TowerRelated/Color_Yellow/Sunflower/Sunflower.tscn")
	elif tower_id == EMBER:
		return load("res://TowerRelated/Color_Orange/Ember/Ember.tscn")
	elif tower_id == LAVA_JET:
		return load("res://TowerRelated/Color_Orange/LavaJet/LavaJet.tscn")
	elif tower_id == CAMPFIRE:
		return load("res://TowerRelated/Color_Orange/Campfire/Campfire.tscn")
	elif tower_id == VOLCANO:
		return load("res://TowerRelated/Color_Orange/Volcano/Volcano.tscn")
	elif tower_id == _704:
		return load("res://TowerRelated/Color_Orange/704/704.tscn")
	elif tower_id == FLAMEBURST:
		return load("res://TowerRelated/Color_Orange/FlameBurst/FlameBurst.tscn")
	elif tower_id == SCATTER:
		return load("res://TowerRelated/Color_Orange/Scatter/Scatter.tscn")
	elif tower_id == COAL_LAUNCHER:
		return load("res://TowerRelated/Color_Orange/CoalLauncher/CoalLauncher.tscn")
	elif tower_id == ENTHALPHY:
		return load("res://TowerRelated/Color_Orange/Enthalphy/Enthalphy.tscn")
	elif tower_id == ENTROPY:
		return load("res://TowerRelated/Color_Orange/Entropy/Entropy.tscn")
	elif tower_id == ROYAL_FLAME:
		return load("res://TowerRelated/Color_Orange/RoyalFlame/RoyalFlame.tscn")
	elif tower_id == IEU: #28th tower
		return load("res://TowerRelated/Color_Orange/IEU/IEU.tscn")
	elif tower_id == FRUIT_TREE:
		return load("res://TowerRelated/Color_Green/FruitTree/FruitTree.tscn")
	elif tower_id == FRUIT_TREE_FRUIT:
		return load("res://TowerRelated/Color_Green/FruitTree/Fruits/FruitTree_Fruit.tscn")
	elif tower_id == SPIKE:
		return load("res://TowerRelated/Color_Green/Spike/Spike.tscn")
	elif tower_id == IMPALE:
		return load("res://TowerRelated/Color_Green/Impale/Impale.tscn")
	elif tower_id == LEADER:
		return load("res://TowerRelated/Color_Blue/Leader/Leader.tscn")
	elif tower_id == ORB:
		return load("res://TowerRelated/Color_Blue/Orb/Orb.tscn")
	elif tower_id == GRAND:
		return load("res://TowerRelated/Color_Blue/Grand/Grand.tscn")
	elif tower_id == DOUSER:
		return load("res://TowerRelated/Color_Blue/Douser/Douser.tscn")
	elif tower_id == WAVE:
		return load("res://TowerRelated/Color_Blue/Wave/Wave.tscn")
	elif tower_id == BLEACH:
		return load("res://TowerRelated/Color_Blue/Bleach/Bleach.tscn")
	elif tower_id == TIME_MACHINE:
		return load("res://TowerRelated/Color_Blue/TimeMachine/TimeMachine.tscn")
	elif tower_id == SEEDER:
		return load("res://TowerRelated/Color_Green/Seeder/Seeder.tscn")
	elif tower_id == CANNON:
		return load("res://TowerRelated/Color_Green/Cannon/Cannon.tscn")
	elif tower_id == PESTILENCE:
		return load("res://TowerRelated/Color_Green/Pestilence/Pestilence.tscn")
	elif tower_id == REAPER:
		return load("res://TowerRelated/Color_Red/Reaper/Reaper.tscn")
	elif tower_id == SHOCKER:
		return load("res://TowerRelated/Color_Red/Shocker/Shocker.tscn")
	elif tower_id == ADEPT:
		return load("res://TowerRelated/Color_Red/Adept/Adept.tscn")
	elif tower_id == REBOUND:
		return load("res://TowerRelated/Color_Red/Rebound/Rebound.tscn")
	elif tower_id == STRIKER:
		return load("res://TowerRelated/Color_Red/Striker/Striker.tscn")
	elif tower_id == HEXTRIBUTE:
		return load("res://TowerRelated/Color_Red/HexTribute/HexTribute.tscn")
	elif tower_id == TRANSMUTATOR:
		return load("res://TowerRelated/Color_Red/Transmutator/Transmutator.tscn")
	elif tower_id == HERO: #50
		return load("res://TowerRelated/Color_White/Hero/Hero.tscn")
	elif tower_id == AMALGAMATOR:
		return load("res://TowerRelated/Color_Black/Amalgamator/Amalgamator.tscn")
	elif tower_id == BLOSSOM:
		return load("res://TowerRelated/Color_Green/Blossom/Blossom.tscn")
	elif tower_id == PINECONE:
		return load("res://TowerRelated/Color_Green/PineCone/PineCone.tscn")
