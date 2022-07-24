extends Node

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
const Ing_ProminenceEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/Prominence_IngEffect.gd")

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

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")

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
const soul_image = preload("res://TowerRelated/Color_Red/Soul/Soul_Omni.png")
const probe_image = preload("res://TowerRelated/Color_Red/Probe/Probe_E.png")
const wyvern_image = preload("res://TowerRelated/Color_Red/Wyvern/Wyvern_E.png")

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
const nucleus_image = preload("res://TowerRelated/Color_Yellow/Nucleus/Nucleus_Omni.png")

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
const brewd_image = preload("res://TowerRelated/Color_Green/Brewd/Brewd_E.png")
const burgeon_image = preload("res://TowerRelated/Color_Green/Burgeon/Burgeon_Omni.png")
const se_propager_image = preload("res://TowerRelated/Color_Green/SePropager/Assets/Animations/SePropager_Idle.png")
const les_semis_image = preload("res://TowerRelated/Color_Green/SePropager_LesSemis/Assets/Animations/LesSemis_E.png")
const l_assaut_image = preload("res://TowerRelated/Color_Green/L'Assaut/Assets/ImageIn_TowerCard.png")
const la_chasseur_image = preload("res://TowerRelated/Color_Green/La_Chasseur/Assets/Anim/LaChasseur_Omni.png")
const la_nature_image = preload("res://TowerRelated/Color_Green/LaNature/Assets/Anim/LaNature_Omni.png")

# BLUE
const sprinkler_image = preload("res://TowerRelated/Color_Blue/Sprinkler/Sprinkler_E.png")
const leader_image = preload("res://TowerRelated/Color_Blue/Leader/Leader_Omni.png")
const orb_image = preload("res://TowerRelated/Color_Blue/Orb/Orb_Omni.png")
const grand_image = preload("res://TowerRelated/Color_Blue/Grand/Grand_Omni.png")
const douser_image = preload("res://TowerRelated/Color_Blue/Douser/Douser_E.png")
const wave_image = preload("res://TowerRelated/Color_Blue/Wave/Wave_E.png")
const bleach_image = preload("res://TowerRelated/Color_Blue/Bleach/Bleach_E.png")
const time_machine_image = preload("res://TowerRelated/Color_Blue/TimeMachine/TimeMachine_Omni.png")
const transpose_image = preload("res://TowerRelated/Color_Blue/Transpose/Transpose_Omni01.png")
const accumulae_image = preload("res://TowerRelated/Color_Blue/Accumulae/Accumulae_Omni.png")

# VIOLET
const simpleobelisk_image = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_Omni.png")
const re_image = preload("res://TowerRelated/Color_Violet/Re/Re_Omni.png")
const telsa_image = preload("res://TowerRelated/Color_Violet/Tesla/Tesla.png")
const chaos_image = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_01.png")
const ping_image = preload("res://TowerRelated/Color_Violet/Ping/PingWholeBody.png")
const prominence_image = preload("res://TowerRelated/Color_Violet/Prominence/Prominence_OmniWholeBody.png")
const shackled_image = preload("res://TowerRelated/Color_Violet/Shackled/Shackled_Omni_Stage02.png")

# OTHERS
const hero_image = preload("res://TowerRelated/Color_White/Hero/Hero_Omni.png")
const amalgamator_image = preload("res://TowerRelated/Color_Black/Amalgamator/Amalgamator_Omni.png")

enum {
	NONE = 0,
	
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
	SOUL = 207, # NOT INCLUDED IN POOL
	PROBE = 208,
	WYVERN = 209, # NOT INCLUDED IN POOL
	
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
	NUCLEUS = 407,
	
	# GREEN (500)
	BERRY_BUSH = 500,  # REMOVED FROM POOL
	FRUIT_TREE = 501,
	SPIKE = 502,
	IMPALE = 503,
	SEEDER = 504,
	CANNON = 505,
	PESTILENCE = 506,
	BLOSSOM = 507,
	PINECONE = 508,
	BREWD = 509,
	BURGEON = 510,
	
	# GREEN SPECIAL (550)
	SE_PROPAGER = 550,
	L_ASSAUT = 551,
	LA_CHASSEUR = 552,
	LA_NATURE = 553,
	
	LES_SEMIS = 560,
	
	# BLUE (600)
	SPRINKLER = 600,
	LEADER = 601,
	ORB = 602,
	GRAND = 603,
	DOUSER = 604,
	WAVE = 605,
	BLEACH = 606,
	TIME_MACHINE = 607,
	TRANSPORTER = 608,
	ACCUMULAE = 609,
	
	# VIOLET (700)
	SIMPLE_OBELISK = 700, # REMOVED FROM POOL
	RE = 701,
	TESLA = 702,
	CHAOS = 703,
	PING = 704,
	PROMINENCE = 705,
	SHACKLED = 706,
	
	# OTHERS (900)
	HERO = 900, # WHITE
	AMALGAMATOR = 901 # BLACK
	
	
	# MISC (2000)
	FRUIT_TREE_FRUIT = 2000, #THIS VALUE IS HARDCODED IN AbstractTower's can_accept_ingredient..
}

# Can be used as official list of all towers
const TowerTiersMap : Dictionary = {
	MONO : 1,
	SPRINKLER : 1,
	SIMPLEX : 1,
	MINI_TESLA : 1,
	EMBER : 1,
	COAL_LAUNCHER : 1,
	SPIKE : 1,
	REBOUND : 1,
	STRIKER : 1,
	PINECONE : 1,
	
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
	COIN : 2,
	
	#SIMPLE_OBELISK : 3,
	BEACON_DISH : 3,
	CHARGE : 3,
	CAMPFIRE : 3,
	FLAMEBURST : 3,
	GRAND : 3,
	DOUSER : 3,
	WAVE : 3,
	SEEDER : 3,
	#SOUL : 3,
	#BERRY_BUSH : 3,
	PROBE : 3,
	BREWD : 3,
	SHACKLED : 3,
	AMALGAMATOR : 3,
	SE_PROPAGER : 3,
	LES_SEMIS : 3,
	
	RE : 4,
	PING : 4,
	MAGNETIZER : 4,
	SUNFLOWER : 4,
	_704 : 4,
	IEU : 4,
	IMPALE : 4,
	REAPER : 4,
	ADEPT : 4,
	LEADER : 4,
	FRUIT_TREE : 4,
	L_ASSAUT : 4,
	
	VOLCANO : 5,
	LAVA_JET : 5,
	BLOSSOM : 5,
	TRANSPORTER : 5,
	NUCLEUS : 5,
	ORB : 5,
	BURGEON : 5,
	#WYVERN : 5,
	LA_CHASSEUR : 5,
	
	TESLA : 6,
	CHAOS : 6,
	ROYAL_FLAME : 6,
	PESTILENCE : 6,
	PROMINENCE : 6,
	ACCUMULAE : 6,
	HEXTRIBUTE : 6,
	LA_NATURE : 6,
}

const tier_base_dmg_map : Dictionary = {
	1 : 0.5,
	2 : 1.0,
	3 : 1.75,
	
	4 : 2.5, #2.25
	5 : 3.0,
	6 : 3.5,
}

const tier_attk_speed_map : Dictionary = {
	1 : 15,
	2 : 25, #23
	3 : 35, #30
	
	4 : 45,
	5 : 60,
	6 : 70,
}

const tier_on_hit_dmg_map : Dictionary = {
	1 : 0.75,
	2 : 1.25,
	3 : 2,
	
	4 : 2.75, #2.5
	5 : 3.25,
	6 : 3.75,
}

# Do not use this when instancing new tower class. Only use
# for getting details about tower.
const tower_id_info_type_singleton_map : Dictionary = {}
const tower_color_to_tower_id_map : Dictionary = {}


#

func _init():
	for color in TowerColors.get_all_colors():
		tower_color_to_tower_id_map[color] = []
	
	for tower_id in TowerTiersMap:
		var tower_info = get_tower_info(tower_id)
		tower_id_info_type_singleton_map[tower_id] = tower_info
		
		for color in tower_info.colors:
			tower_color_to_tower_id_map[color].append(tower_id)


#

static func _generate_tower_image_icon_atlas_texture(tower_sprite) -> AtlasTexture:
	var tower_image_icon_atlas_texture := AtlasTexture.new()
	
	tower_image_icon_atlas_texture.atlas = tower_sprite
	tower_image_icon_atlas_texture.region = _get_atlas_region(tower_sprite)
	
	return tower_image_icon_atlas_texture


static func _get_atlas_region(tower_sprite) -> Rect2:
	var center = _get_default_center_for_atlas(tower_sprite)
	var size = _get_default_region_size_for_atlas(tower_sprite)
	
	#return Rect2(0, 0, size.x, size.y)
	return Rect2(center.x, center.y, size.x, size.y)

static func _get_default_center_for_atlas(tower_sprite) -> Vector2:
	var highlight_sprite_size = tower_sprite.get_size()
	
	return Vector2(highlight_sprite_size.x / 4, 0)

static func _get_default_region_size_for_atlas(tower_sprite) -> Vector2:
	return Vector2(18, 18)

#

static func get_tower_info(tower_id : int) -> TowerTypeInformation :
	var info
	
	if tower_id == MONO:
		info = TowerTypeInformation.new("Mono", MONO)
		info.tower_tier = TowerTiersMap[MONO]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GRAY)
		info.tower_image_in_buy_card = mono_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3.5
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 1.25
		info.base_attk_speed = 1.5
		info.base_pierce = 1
		info.base_range = 105
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 6
		info.base_attk_speed = 0.475
		info.base_pierce = 1
		info.base_range = 185
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 0.48
		info.base_attk_speed = 5.5
		info.base_pierce = 0
		info.base_range = 105
		info.base_damage_type = DamageType.PURE
		info.on_hit_multiplier = 0.2
		
		info.tower_descriptions = [
			"Directs a constant pure energy beam at a single target.",
			"The energy beam's on hit damages are only 20% effective.",
			"",
			"\"First Iteration\""
		]
		
		
	elif tower_id == RAILGUN:
		info = TowerTypeInformation.new("Railgun", RAILGUN)
		info.tower_tier = TowerTiersMap[RAILGUN]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.YELLOW)
		info.tower_image_in_buy_card = railgun_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 5
		info.base_attk_speed = 0.3
		info.base_pierce = 5
		info.base_range = 100
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_pierce = TextFragmentInterpreter.new()
		interpreter_for_pierce.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_pierce.display_body = true
		interpreter_for_pierce.header_description = "enemies"
		
		var ins_for_pierce = []
		ins_for_pierce.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PIERCE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_pierce.array_of_instructions = ins_for_pierce
		
		# INS END
		
		info.tower_descriptions = [
			["Shoots a dart that pierces through |0|.", [interpreter_for_pierce]]
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 5
		info.base_attk_speed = 0.55
		info.base_pierce = 0
		info.base_range = 155
		info.base_damage_type = DamageType.PURE
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Re's attacks on hit cleanses enemies from almost all buffs and debuffs.",
			"Attacks in bursts of 3."
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 4
		info.base_attk_speed = 1.5
		info.base_pierce = 0
		info.base_range = 150
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Tesla's attacks stun its target for 0.3 seconds on hit.",
			"",
			"\"Simple, yet effective.\""
		]
		
		var enemy_effect : EnemyStunEffect = EnemyStunEffect.new(0.25, StoreOfEnemyEffectsUUID.ING_TESLA)
		var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.ING_TESLA)
		var ing_effect : IngredientEffect = IngredientEffect.new(TESLA, tower_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "stun on hit"
		
		
	elif tower_id == CHAOS: #WHEN CHANGING CHAOS's tower id, look at the takeover effect as well
		info = TowerTypeInformation.new("CHAOS", CHAOS)
		info.tower_tier = TowerTiersMap[CHAOS]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.tower_image_in_buy_card = chaos_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 1.25
		info.base_attk_speed = 1.25
		info.base_pierce = 1
		info.base_range = 130
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_dia = TextFragmentInterpreter.new()
		interpreter_for_dia.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_dia.display_body = true
		
		var ins_for_dia = []
		ins_for_dia.append(NumericalTextFragment.new(2, false, DamageType.PHYSICAL))
		ins_for_dia.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_dia.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.5, DamageType.PHYSICAL))
		ins_for_dia.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_dia.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 2)) # stat basis does not matter here
		
		interpreter_for_dia.array_of_instructions = ins_for_dia
		
		#
		
		var interpreter_for_bolt = TextFragmentInterpreter.new()
		interpreter_for_bolt.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_bolt.display_body = true
		
		var ins_for_bolt = []
		ins_for_bolt.append(NumericalTextFragment.new(1, false, DamageType.ELEMENTAL))
		ins_for_bolt.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_bolt.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 1.25, DamageType.ELEMENTAL))
		
		interpreter_for_bolt.array_of_instructions = ins_for_bolt
		
		#
		
		var interpreter_for_sword = TextFragmentInterpreter.new()
		interpreter_for_sword.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_sword.display_body = true
		
		var ins_for_sword = []
		ins_for_sword.append(NumericalTextFragment.new(20, false, DamageType.PHYSICAL))
		ins_for_sword.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_sword.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 15, DamageType.PHYSICAL))
		
		interpreter_for_sword.array_of_instructions = ins_for_sword
		
		
		# INS END
		
		info.tower_descriptions = [
			"Has many attacks. Shoots orbs, diamonds, and bolts at different rates. Stats shown are for the orbs.",
			"Only the orbs can be controlled by targeting options. The orbs are considered to be CHAOS's main attack.",
			"",
			"Upon dealing 80 damage with the orbs, diamonds and bolts, CHAOS erupts a dark sword to stab the orb's target.",
			"",
			["Diamond damage: |0|. Applies on hit effects.", [interpreter_for_dia]],
			["Bolt damage: |0|. Does not apply on hit effects.", [interpreter_for_bolt]],
			["Sword damage: |0|. Does not apply on hit effects.", [interpreter_for_sword]]
		]
		
		#
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 1
		info.base_attk_speed = 0.38
		info.base_pierce = 1
		info.base_range = 165
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 0
		
		# INS START
		
		var interpreter_for_mark_count = TextFragmentInterpreter.new()
		interpreter_for_mark_count.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_mark_count.display_body = true
		interpreter_for_mark_count.header_description = "enemies"
		interpreter_for_mark_count.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.ROUND
		
		var ins_for_mark_count = []
		ins_for_mark_count.append(NumericalTextFragment.new(4, false, -1))
		ins_for_mark_count.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_mark_count.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.BONUS, 2.0, -1))
		
		interpreter_for_mark_count.array_of_instructions = ins_for_mark_count
		
		#
		
		var interpreter_for_normal_shot = TextFragmentInterpreter.new()
		interpreter_for_normal_shot.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_normal_shot.display_body = true
		
		var ins_for_normal_shot = []
		ins_for_normal_shot.append(NumericalTextFragment.new(5, false, DamageType.PHYSICAL))
		ins_for_normal_shot.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_normal_shot.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 1.0, DamageType.PHYSICAL))
		ins_for_normal_shot.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_normal_shot.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 2.0))
		
		interpreter_for_normal_shot.array_of_instructions = ins_for_normal_shot
		
		#
		
		var interpreter_for_emp_shot = TextFragmentInterpreter.new()
		interpreter_for_emp_shot.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_emp_shot.display_body = true
		
		var ins_for_emp_shot = []
		ins_for_emp_shot.append(NumericalTextFragment.new(10, false, DamageType.PHYSICAL))
		ins_for_emp_shot.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_emp_shot.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 1.0, DamageType.PHYSICAL))
		ins_for_emp_shot.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_emp_shot.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 4.0))
		
		interpreter_for_emp_shot.array_of_instructions = ins_for_emp_shot
		
		
		# INS END
		
		info.tower_descriptions = [
			"Stats shown are for the arrow.",
			["Shoots an arrow that releases a ring. The ring marks up to |0|.", [interpreter_for_mark_count]],
			"After a brief delay, Ping shoots all marked enemies, consuming all marks in the process.",
			"Ping can shoot the next arrow immediately when it kills at least one enemy with its shots.",
			"",
			["Shots deal |0|. Applies on hit effects.", [interpreter_for_normal_shot]],
			["If only 1 enemy is marked, the shot instead deals |0| instead.", [interpreter_for_emp_shot]],
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2
		info.base_attk_speed = 0.5
		info.base_pierce = 2
		info.base_range = 95
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_pierce = TextFragmentInterpreter.new()
		interpreter_for_pierce.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_pierce.display_body = true
		interpreter_for_pierce.header_description = "enemies"
		
		var ins_for_pierce = []
		ins_for_pierce.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PIERCE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_pierce.array_of_instructions = ins_for_pierce
		
		# INS END
		
		info.tower_descriptions = [
			["Shoots coins at enemies. Coins can hit up to |0|.", [interpreter_for_pierce]],
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 1.5
		info.base_attk_speed = 0.6
		info.base_pierce = 0
		info.base_range = 150
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		# INS START
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(5, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		#
		
		var interpreter_for_ele_on_hit = TextFragmentInterpreter.new()
		interpreter_for_ele_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_ele_on_hit.display_body = true
		
		var ins_for_ele_on_hit = []
		ins_for_ele_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL))
		ins_for_ele_on_hit.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.2))
		ins_for_ele_on_hit.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_ele_on_hit.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_ele_on_hit.array_of_instructions = ins_for_ele_on_hit
		
		#
		
		var interpreter_for_attk_speed = TextFragmentInterpreter.new()
		interpreter_for_attk_speed.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_attk_speed.display_body = true
		
		var ins_for_attk_speed = []
		ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "", 0, true))
		ins_for_attk_speed.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, TowerStatTextFragment.STAT_BASIS.TOTAL, 25, -1, true))
		ins_for_attk_speed.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_attk_speed.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
		
		#
		
		var interpreter_for_range = TextFragmentInterpreter.new()
		interpreter_for_range.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_range.display_body = true
		
		var ins_for_range = []
		ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE))
		ins_for_range.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.RANGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.1))
		ins_for_range.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_range.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_range.array_of_instructions = ins_for_range
		
		
		# INS END
		
		info.tower_descriptions = [
			["Does not attack, but instead casts an aura that buffs towers in range every |0| for 4 seconds.", [interpreter_for_cooldown]],
			["Grants |0| as an elemental on hit damage buff.", [interpreter_for_ele_on_hit]],
			["Grants |0| as percent attack speed buff.", [interpreter_for_attk_speed]],
			["Grants |0| as bonus range.", [interpreter_for_range]],
			"Note: Does not grant these buffs to another Beacon-Dish. Also overrides any existing Beacon-Dish buffs a tower may have.",
			"",
			"\"Is it a beacon, or a dish?\""
		]
		
#		info.tower_descriptions = [
#			"Does not attack, but instead casts an aura that buffs towers in range every 5 seconds for 4 seconds.",
#			"Grants 20% of its total base damage as an elemental on hit damage buff.",
#			"Grants 25% x 100 of its total attack speed as percent attack speed (of receiving tower).",
#			"Grants 10% of its total range as bonus range.",
#			"These bonuses are increased by ability potency.",
#			"Note: Does not grant these buffs to another Beacon-Dish. Also overrides any existing Beacon-Dish buffs a tower may have.",
#			"",
#			"\"Is it a beacon, or a dish?\""
#		]
		
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
		info.colors.append(TowerColors.YELLOW)
		info.tower_image_in_buy_card = mini_tesla_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.775
		info.base_pierce = 0
		info.base_range = 110
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Mini Tesla applies a stack of \"static\" on enemies hit for 3 seconds, with this duration refreshing per hit.",
			"When an enemy reaches 5 stacks, all stacks get consumed and the enemy is stunned for 2 seconds."
		]
		
		var enemy_final_effect : EnemyStunEffect = EnemyStunEffect.new(1.25, StoreOfEnemyEffectsUUID.ING_MINI_TELSA_STUN)
		var enemy_effect : EnemyStackEffect = EnemyStackEffect.new(enemy_final_effect, 1, 5, StoreOfEnemyEffectsUUID.ING_MINI_TESLA_STACK)
		enemy_effect.is_timebound = true
		enemy_effect.time_in_seconds = 3
		
		var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.ING_MINI_TESLA)
		tower_effect.description = "Applies a stack of \"mini static\" on enemies hit for 3 seconds, with this duration refreshing per hit. When an enemy reaches 5 stacks, all stacks get consumed and the enemy is stunned for 1.25 seconds."
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3
		info.base_attk_speed = 0.65
		info.base_pierce = 1
		info.base_range = 90
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# INS START
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "", 25))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		#
		
		var interpreter_for_perc_on_hit = TextFragmentInterpreter.new()
		interpreter_for_perc_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_perc_on_hit.display_body = false
		
		var ins_for_perc_on_hit = []
		ins_for_perc_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "", 25, true))
		
		interpreter_for_perc_on_hit.array_of_instructions = ins_for_perc_on_hit
		
		
		# INS END
		
		info.tower_descriptions = [
			"When idle, Charge accumulates energy. Charge's energy is set to 50% when the round starts.",
			"Upon attacking, Charge expends all energy to deal bonus physical on hit damage based on expended energy.",
			["Max flat physical on hit damage portion: |0|", [interpreter_for_flat_on_hit]],
			["Max percent enemy health physical on hit damage portion: |0|", [interpreter_for_perc_on_hit]],
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 0
		info.base_attk_speed = 0.585
		info.base_pierce = 1
		info.base_range = 155
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# ins start
		
		var interpreter = TextFragmentInterpreter.new()
		interpreter.tower_info_to_use_for_tower_stat_fragments = info
		interpreter.display_body = true
		
		var outer_ins = []
		var ins = []
		ins.append(NumericalTextFragment.new(9, false, DamageType.ELEMENTAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 1, DamageType.ELEMENTAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1)) # stat basis does not matter here
		
		outer_ins.append(ins)
		
		outer_ins.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		outer_ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter.array_of_instructions = outer_ins
		
		
		# ins end
		
		info.tower_descriptions = [
			"Stats shown are for the magnets.",
			"When shooting, Magnetizer alternates between blue magnet and red magnet. Magnetizer switches to the next targeting option after shooting a magnet.",
			"Magnets stick to the first enemy they hit. When the enemy they are stuck to dies, they drop on the ground.",
			"When there is at least one blue and one red magnet that has hit an enemy or is on the ground, Magnetizer casts Magnetize.",
			"",
			"Magnetize: Calls upon all of this tower's non traveling magnets to form a beam between their opposite types, consuming them in the process.",
			#"The beam deals 9 elemental damage. The beam benefits from base damage buffs, on hit damages and effects. Damage scales with ability potency.",
			["The beam deals |0|. Applies on hit effects", [interpreter]],
			
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.1
		info.base_attk_speed = 0.375
		info.base_pierce = 1
		info.base_range = 110
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Sprays lots of seeds at enemies with slight inaccuracy. Attacks in bursts of 8.",
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 1.35
		info.base_attk_speed = 0.55
		info.base_pierce = 1
		info.base_range = 95
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# ins start
		
		var interpreter_for_on_hit = TextFragmentInterpreter.new()
		interpreter_for_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_on_hit.display_body = false
		
		var ins_for_on_hit = []
		ins_for_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", 0.5))
		
		interpreter_for_on_hit.array_of_instructions = ins_for_on_hit
		
		
		# ins end
		
		info.tower_descriptions = [
			"Heats up its shots, causing them to burn enemies hit.",
			["Burns enemies for |0| per second for 5 seconds.", [interpreter_for_on_hit]]
		]
		
		
		# Ingredient related
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.75
		info.base_attk_speed = 1.12
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# ins start
		
		var interpreter_for_perc_on_hit = TextFragmentInterpreter.new()
		interpreter_for_perc_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_perc_on_hit.display_body = false
		
		var ins_for_perc_on_hit = []
		ins_for_perc_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "max health damage", 25, true))
		
		interpreter_for_perc_on_hit.array_of_instructions = ins_for_perc_on_hit
		
		
		# ins end
		
		info.tower_descriptions = [
			"Lava Jet's attacks ignore 3 toughness.",
			"",
			#"On its 5th main attack, Lava Jet releases a beam of lava that deals 25% of the enemy's max health as elemental damage, up to 40."
			["On its 5th main attack, Lava Jet releases a beam of lava that deals |0|, up to 40.", [interpreter_for_perc_on_hit]]
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 4
		info.base_attk_speed = 1
		info.base_pierce = 0
		info.base_range = 105
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 0
		
		# ins start
		
		var interpreter_for_rage = TextFragmentInterpreter.new()
		interpreter_for_rage.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_rage.display_body = true
		interpreter_for_rage.header_description = "Rage"
		
		var outer_ins_for_rage = []
		var ins_for_rage = []
		ins_for_rage.append(NumericalTextFragment.new(50, false))
		ins_for_rage.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_rage.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		outer_ins_for_rage.append(ins_for_rage)
		
		outer_ins_for_rage.append(TextFragmentInterpreter.STAT_OPERATION.DIVIDE)
		outer_ins_for_rage.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_rage.array_of_instructions = outer_ins_for_rage
		
		#
		
		var interpreter_for_on_hit = TextFragmentInterpreter.new()
		interpreter_for_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_on_hit.display_body = true
		interpreter_for_on_hit.header_description = "on hit damage"
		
		var ins_for_on_hit = []
		ins_for_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL))
		ins_for_on_hit.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_on_hit.array_of_instructions = ins_for_on_hit
		
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(1, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		# ins end
		
		
		info.tower_descriptions = [
			"Campfire gains Rage equivalent to the post-mitigated damage taken by enemies within its range.",
			["Upon reaching |0|, Campfire consumes all Rage to cast Heat Pact.", [interpreter_for_rage]],
			"",
			["Heat Pact: The next attack of a tower deals bonus |0|.", [interpreter_for_on_hit]],
			"",
			"Campfire does not gain Rage from the damage its buff has dealt.",
			["Campfire cannot gain Rage for |0| after casting Heat Pact.", [interpreter_for_cooldown]],
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 0
		info.base_attk_speed = 0.12
		info.base_pierce = 0
		info.base_range = 240
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_boulder = TextFragmentInterpreter.new()
		interpreter_for_boulder.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_boulder.display_body = true
		
		var ins_for_boulder = []
		ins_for_boulder.append(NumericalTextFragment.new(6, false, DamageType.PHYSICAL))
		ins_for_boulder.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_boulder.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 1, DamageType.PHYSICAL))
		ins_for_boulder.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_boulder.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 5)) # stat basis does not matter here
		
		interpreter_for_boulder.array_of_instructions = ins_for_boulder
		
		#
		
		var interpreter_for_crater = TextFragmentInterpreter.new()
		interpreter_for_crater.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_crater.display_body = true
		
		var ins_for_crater = []
		ins_for_crater.append(NumericalTextFragment.new(1, false, DamageType.ELEMENTAL))
		ins_for_crater.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_crater.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 1, DamageType.ELEMENTAL))
		
		interpreter_for_crater.array_of_instructions = ins_for_crater
		
		
		# INS END
		
		info.tower_descriptions = [
			"Launches a molten boulder at the target's location.",
			["The boulder explodes upon reaching the location, dealing |0|. Applies on hit effects.", [interpreter_for_boulder]],
			["The explosion also leaves behind scorched earth that lasts for 7 seconds, which slows by 30% and deals |0| per 0.5 seconds to enemies while inside it. Does not apply on hit effects.", [interpreter_for_crater]],
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.85
		info.base_attk_speed = 0.785
		info.base_pierce = 0
		info.base_range = 120
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.50
		info.base_attk_speed = 0.830
		info.base_pierce = 1
		info.base_range = 115
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		# INS START
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "damage", 1))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		#
		
		var interpreter_for_pierce = TextFragmentInterpreter.new()
		interpreter_for_pierce.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_pierce.display_body = true
		interpreter_for_pierce.header_description = "pierce"
		
		var ins_for_pierce = []
		ins_for_pierce.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PIERCE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_pierce.array_of_instructions = ins_for_pierce
		
		
		#
		
		info.tower_descriptions = [
			"Flameburst's main attack causes enemies to spew out 4 flamelets around themselves.",
			["Each flamelet deals |0|, and has |1|.", [interpreter_for_flat_on_hit, interpreter_for_pierce]],
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2
		info.base_attk_speed = 0.39
		info.base_pierce = 1
		info.base_range = 110
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Shoots 3 heated iron fragments at enemies."
		]
		
		
	elif tower_id == COAL_LAUNCHER:
		info = TowerTypeInformation.new("Coal Launcher", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.tower_image_in_buy_card = coal_launcher_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3
		info.base_attk_speed = 0.55
		info.base_pierce = 1
		info.base_range = 115
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Launches a piece of coal at enemies. The coal increases the duration of all burns the enemy is suffering from for 3 seconds."
		]
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_COAL_LAUNCHER)
		base_dmg_attr_mod.flat_modifier = tier_base_dmg_map[info.tower_tier]
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.4
		info.base_attk_speed = 0.8
		info.base_pierce = 0
		info.base_range = 135
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# ins start
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "on hit damage", 1.25))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		#
		
		var interpreter_for_bonus_dmg_ratio = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg_ratio.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_bonus_dmg_ratio.display_body = true
		interpreter_for_bonus_dmg_ratio.header_description = "on hit damage"
		
		var ins_for_bonus_dmg_ratio = []
		ins_for_bonus_dmg_ratio.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL))
		ins_for_bonus_dmg_ratio.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.RANGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.01875))
		
		interpreter_for_bonus_dmg_ratio.array_of_instructions = ins_for_bonus_dmg_ratio
		
		
		# ins end
		
		info.tower_descriptions = [
			#"Enthalphy gains bonus 0.75 damage for every 40 range.",
			["Enthalphy gains bonus |0|.", [interpreter_for_bonus_dmg_ratio]],
			["Enthalphy also gains bonus |0| for its next three attacks after killing an enemy.", [interpreter_for_flat_on_hit]],
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.55
		info.base_attk_speed = 0.645
		info.base_pierce = 0
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# ins 
		
		var interpreter_for_first = TextFragmentInterpreter.new()
		interpreter_for_first.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_first.display_body = false
		
		var ins_for_first = []
		ins_for_first.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 30, true))
		
		interpreter_for_first.array_of_instructions = ins_for_first
		
		#
		
		var interpreter_for_second = TextFragmentInterpreter.new()
		interpreter_for_second.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_second.display_body = false
		
		var ins_for_second = []
		ins_for_second.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 30, true))
		
		interpreter_for_second.array_of_instructions = ins_for_second
		
		
		# ins 
		
		
		info.tower_descriptions = [
			["Entropy gains |0| for its first 130 attacks.", [interpreter_for_first]],
			["Entropy also gains |0| for its first 230 attacks.", [interpreter_for_second]],
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3.5
		info.base_attk_speed = 0.98
		info.base_pierce = 1
		info.base_range = 140
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# ins
		
		var interpreter_for_burn = TextFragmentInterpreter.new()
		interpreter_for_burn.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_burn.display_body = true
		
		var ins_for_burn = []
		ins_for_burn.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.25, DamageType.ELEMENTAL))
		
		interpreter_for_burn.array_of_instructions = ins_for_burn
		
		#
		
		var interpreter_for_perc_on_hit = TextFragmentInterpreter.new()
		interpreter_for_perc_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_perc_on_hit.display_body = true
		interpreter_for_perc_on_hit.header_description = "of the burned enemy's missing health as damage"
		
		var ins_for_perc_on_hit = []
		ins_for_perc_on_hit.append(NumericalTextFragment.new(40, true, DamageType.ELEMENTAL))
		ins_for_perc_on_hit.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_perc_on_hit.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1, true))
		
		interpreter_for_perc_on_hit.array_of_instructions = ins_for_perc_on_hit
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(25, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		
		# ins
		
		var ability_descs = [
			["Ability: Steam Burst. Extinguishes the 3 closest enemies burned by Royal Flame. Extinguishing enemies creates a steam explosion that deals |0|, up to 150.", [interpreter_for_perc_on_hit]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION] = ability_descs
		
		info.tower_descriptions = [
			["Royal Flame's attacks burn enemies for |0| every 0.5 seconds for 10 seconds.", [interpreter_for_burn]],
			"",
		]
		for desc in ability_descs:
			info.tower_descriptions.append(desc)
		
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
		info.tower_image_in_buy_card = ieu_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3.5
		info.base_attk_speed = 1.25
		info.base_pierce = 0
		info.base_range = 125
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# ins start
		
		var interpreter_for_entropy_first = TextFragmentInterpreter.new()
		interpreter_for_entropy_first.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_entropy_first.display_body = false
		
		var ins_for_entropy_first = []
		ins_for_entropy_first.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 60, true))
		
		interpreter_for_entropy_first.array_of_instructions = ins_for_entropy_first
		
		#
		
		var interpreter_for_entropy_second = TextFragmentInterpreter.new()
		interpreter_for_entropy_second.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_entropy_second.display_body = false
		
		var ins_for_entropy_second = []
		ins_for_entropy_second.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 20, true))
		
		interpreter_for_entropy_second.array_of_instructions = ins_for_entropy_second
		
		#
		
		var interpreter_for_enthalphy_first = TextFragmentInterpreter.new()
		interpreter_for_enthalphy_first.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_enthalphy_first.display_body = false
		
		var ins_for_enthalphy_first = []
		ins_for_enthalphy_first.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", 125, false))
		
		interpreter_for_enthalphy_first.array_of_instructions = ins_for_enthalphy_first
		
		#
		
		var interpreter_for_enthalphy_second = TextFragmentInterpreter.new()
		interpreter_for_enthalphy_second.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_enthalphy_second.display_body = false
		
		var ins_for_enthalphy_second = []
		ins_for_enthalphy_second.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", 45, false))
		
		interpreter_for_enthalphy_second.array_of_instructions = ins_for_enthalphy_second
		
		
		# ins end
		
		info.tower_descriptions = [
			"IE=U discards the ingredient effect of Entropy and Enthalphy when they are absorbed. Instead, a temporary buff that lasts for 5 rounds is received.",
			["Absorbing Entropy gives |0| for the first, and |1| for the subsequent.", [interpreter_for_entropy_first, interpreter_for_entropy_second]],
			["Absorbing Enthalphy gives |0| for the first, and |1| for the subsequent.", [interpreter_for_enthalphy_first, interpreter_for_enthalphy_second]],
			"",
			"\"Feed the system.\""
		]
		
#		info.tower_descriptions = [
#			"IE=U discards the ingredient effect of Entropy and Enthalphy when they are absorbed. Instead, a temporary buff that lasts for 5 rounds is received.",
#			"Absorbing Entropy gives 60% bonus attack speed for the first, and 20% for the subsequent.",
#			"Absorbing Enthalphy gives 125 bonus range for the first, and 45 for the subsequent.",
#			"",
#			"\"Feed the system.\""
#		]
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Does not attack, but instead gives a fruit at the end of every 3rd round of being in the map.",
			"Fruits appear in the tower bench, and will be converted into gold when no space is available.",
			"Fruits do not attack, but have an ingredient effect. Fruits can be given to any tower regardless of tower color.",
		]
		
		
	elif tower_id == FRUIT_TREE_FRUIT:
		info = TowerTypeInformation.new("Fruit", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.tower_image_in_buy_card = fruit_tree_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 1.85
		info.base_attk_speed = 0.765
		info.base_pierce = 0
		info.base_range = 115
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# ins start
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "extra physical damage", 2))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		
		# ins end
		
		info.tower_descriptions = [
			["Spike's main attack deals |0| to enemies below 50% health.", [interpreter_for_flat_on_hit]]
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 10
		info.base_attk_speed = 0.24
		info.base_pierce = 0
		info.base_range = 105
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_retract_bonus_dmg_on_threshold = TextFragmentInterpreter.new()
		interpreter_for_retract_bonus_dmg_on_threshold.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_retract_bonus_dmg_on_threshold.display_body = true
		
		var ins_for_retract_bonus_dmg_on_threshold = []
		ins_for_retract_bonus_dmg_on_threshold.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", 200, true))
		
		interpreter_for_retract_bonus_dmg_on_threshold.array_of_instructions = ins_for_retract_bonus_dmg_on_threshold
		
		#
		
		var interpreter_for_retract_on_normals = TextFragmentInterpreter.new()
		interpreter_for_retract_on_normals.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_retract_on_normals.display_body = true
		
		var ins_for_retract_bonus_on_normals = []
		ins_for_retract_bonus_on_normals.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", 100, true))
		
		interpreter_for_retract_on_normals.array_of_instructions = ins_for_retract_bonus_on_normals
		
		
		#
		
		info.tower_descriptions = [
			"Impale shoots up a spike that stabs an enemy, stunning them for 2.2 seconds.",
			["When the stun expires, Impale retracts the spike, dealing damage again. The retract damage deals |0| when the enemy has less than 75% of their max health.", [interpreter_for_retract_bonus_dmg_on_threshold]],
			["Normal type enemies take additional |0| from the rectact damage.", [interpreter_for_retract_on_normals]],
			"",
			"\"Big spike for small enemies\""
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.65
		info.base_attk_speed = 1
		info.base_pierce = 0
		info.base_range = 155
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_bonus_dmg.display_body = true
		interpreter_for_bonus_dmg.header_description = "more damage"
		
		var ins_for_bonus_damage = []
		ins_for_bonus_damage.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "", 0.0, true))
		ins_for_bonus_damage.append(NumericalTextFragment.new(100, true, -1, "", false, TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP))
		ins_for_bonus_damage.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_bonus_damage.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_damage
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(13, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		# INS END
		
		var ability_descs = [
			"Ability: Coordinated Attack. Orders all members to attack the marked enemy once, regardless of range.",
			"Projectiles gain extra range to be able to reach the marked target.",
			#"Member's damage in Coordinated Attack scales with Leader's total ability potency.",
			["Member's damage in Coordinated Attack deal |0|.", [interpreter_for_bonus_dmg]],
			"The marked enemy is also stunned for 2.75 seconds.",
			["Cooldown: |0|", [interpreter_for_cooldown]],
		]
		
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION] = ability_descs
		
		info.tower_descriptions = [
			"Leader's main attack marks the target enemy. Only one enemy can be marked at a time.",
			"Leader also manages members. Leader can have up to 5 members. Leader cannot have itself or another Leader as its member.",
			"Leader's main attacks against the marked enemy on hit decreases the cooldown of Coordinated Attack by 1 second.",
			"",
		]
		
		for desc in ability_descs:
			info.tower_descriptions.append(desc)
		
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.75
		info.base_attk_speed = 0.875
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_ap = TextFragmentInterpreter.new()
		interpreter_for_ap.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_ap.display_body = false
		
		var ins_for_ap = []
		ins_for_ap.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", 0.5, false))
		
		interpreter_for_ap.array_of_instructions = ins_for_ap
		
		
		# INS END
		
		info.tower_descriptions = [
			"Orb takes 2 tower slots.",
			"",
			"Orb gains new attacks at 1.5, 2.0, and 2.5 total ability potency.",
			"",
			["Orb absorbs all other Orbs placed in the map, gaining permanent |0| that stacks. This effect also applies when absorbing another Orb's ingredient effect.", [interpreter_for_ap]],
			"",
			"\"Where does the power reside? The wizard, or the orb?\""
		]
		
		
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_ORB)
		base_ap_attr_mod.flat_modifier = 0.5
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 4
		info.base_attk_speed = 0.365
		info.base_pierce = 1
		info.base_range = 135
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
#		info.tower_descriptions = [
#			"Grand gains projectile speed at 1.25, 1.50, and 2.00 total ability potency.",
#			"Grand also gains 1 bonus pierce per 0.25 bonus ability potency.",
#			"",
#			"Grand's main attack damage scales with its total ability potency.",
#			"",
#			"When Grand's orb attack reaches its max distance, the bullet redirects to the farthest enemy from Grand.",
#			"",
#			"\"Where does the power reside? The (hand of a) wizard, or the orb?\""
#		]
		
		#
		
		var interpreter_for_pierce = TextFragmentInterpreter.new()
		interpreter_for_pierce.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_pierce.display_body = true
		interpreter_for_pierce.header_description = "bonus pierce"
		interpreter_for_pierce.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.ROUND
		
		var ins_for_pierce = []
		ins_for_pierce.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.PIERCE, -1))
		ins_for_pierce.append(NumericalTextFragment.new(4, false, -1))
		ins_for_pierce.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_pierce.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.BONUS, 1))
		
		
		interpreter_for_pierce.array_of_instructions = ins_for_pierce
		
		#
		
		info.tower_descriptions = [
			"Grand gains projectile speed at 1.25, 1.50, and 2.00 total ability potency.",
			["Grand also gains |0|.", [interpreter_for_pierce]],
			"",
			"Ability potenct scales Grand's main attack damage.",
			"",
			"When Grand's orb attack reaches its max distance, the bullet redirects to the farthest enemy from Grand.",
			"",
			"\"Where does the power reside? The (hand of a) wizard, or the orb?\""
		]
		
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_GRAND)
		base_ap_attr_mod.flat_modifier = 0.5
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.25
		info.base_attk_speed = 0.82
		info.base_pierce = 0
		info.base_range = 115
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		# INS START
		
		var interpreter_for_attk_count = TextFragmentInterpreter.new()
		interpreter_for_attk_count.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_attk_count.display_body = true
		interpreter_for_attk_count.header_description = "main attacks"
		interpreter_for_attk_count.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.ROUND
		
		var ins_for_attk_count = []
		ins_for_attk_count.append(NumericalTextFragment.new(5, false))
		ins_for_attk_count.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_attk_count.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_attk_count.array_of_instructions = ins_for_attk_count
		
		
		
		#
		
#		var interpreter_for_pierce = TextFragmentInterpreter.new()
#		interpreter_for_pierce.tower_info_to_use_for_tower_stat_fragments = info
#		interpreter_for_pierce.display_body = true
#		interpreter_for_pierce.header_description = "towers"
#
#		var ins_for_pierce = []
#		ins_for_pierce.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PIERCE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
#
#		interpreter_for_pierce.array_of_instructions = ins_for_pierce
#
		#
		
		var interpreter_for_buff = TextFragmentInterpreter.new()
		interpreter_for_buff.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_buff.display_body = true
		interpreter_for_buff.header_description = "bonus base damage"
		
		var ins_for_buff = []
		ins_for_buff.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE))
		ins_for_buff.append(NumericalTextFragment.new(1, false, -1, "", false, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE))
		ins_for_buff.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_buff.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_buff.array_of_instructions = ins_for_buff
		
		
		
		# INS END
		
		info.tower_descriptions = [
			["Douser casts Buffing Waters after every |0|.", [interpreter_for_attk_count]],
			"",
			"Buffing Waters: Douser shoots a water ball at the closest tower",
			["Towers hit by Buffing Waters gain |0| for the next 4 benefiting attacks within 10 seconds.", [interpreter_for_buff]],
			"Douser also benefits from its own Buffing Water's buff.",
			"Douser does not target towers that currently have the buff, and unprioritizes towers that have no means of attacking. Douser also does not target other Dousers, but can affect them if hit.",
		]
		
#		info.tower_descriptions = [
#			"Douser casts Buffing Waters after every 5th main attacks.",
#			"",
#			["Buffing Waters: Douser shoots a water ball at the closest tower, hitting up to |0|.", [interpreter_for_pierce]],
#			"Towers hit by Buffing Waters gain 1 bonus base damage for the next 4 benefiting attacks within 10 seconds.",
#			"Douser also benefits from its own Buffing Water's buff.",
#			"Douser does not target towers that currently have the buff, and unprioritizes towers that have no means of attacking. Douser also does not target other Dousers, but can affect them if hit.",
#			"",
#			"Buffing Waters's projectile benefits from bonus pierce. Ability cdr reduces the needed attacks to trigger this ability."
#		]
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 1
		info.base_attk_speed = 0.40
		info.base_pierce = 0
		info.base_range = 150
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "on hit damage", 2))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		#
		
		var interpreter_for_wave_count = TextFragmentInterpreter.new()
		interpreter_for_wave_count.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_wave_count.display_body = true
		interpreter_for_wave_count.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.CEIL
		interpreter_for_wave_count.header_description = "columns of water"
		
		var ins_for_wave_count = []
		ins_for_wave_count.append(NumericalTextFragment.new(8, false))
		ins_for_wave_count.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_wave_count.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_wave_count.array_of_instructions = ins_for_wave_count
		
		#
		
		var interpreter_for_explosion_dmg = TextFragmentInterpreter.new()
		interpreter_for_explosion_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_explosion_dmg.display_body = false
		
		var ins_for_explosion_dmg = []
		ins_for_explosion_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", 0.75))
		
		interpreter_for_explosion_dmg.array_of_instructions = ins_for_explosion_dmg
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(6, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		#
		
		var interpreter_for_debuff_cooldown = TextFragmentInterpreter.new()
		interpreter_for_debuff_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_debuff_cooldown.display_body = true
		interpreter_for_debuff_cooldown.header_description = "s"
		
		var ins_for_debuff_cooldown = []
		ins_for_debuff_cooldown.append(NumericalTextFragment.new(30, false))
		ins_for_debuff_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_debuff_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_debuff_cooldown.array_of_instructions = ins_for_debuff_cooldown
		
		
		# INS END 
		
		var ability_desc = [
			["Ability: Tidal Wave. Wave sprays |0| in a cone facing its current target.", [interpreter_for_wave_count]],
			"Each column deals 1 + twice of Wave's passive on hit damage as elemental damage to all enemies hit.",
			["Each column explodes when reaching its max distance, or when hitting 2 enemies. Each explosion deals |0| to 2 enemies.", [interpreter_for_explosion_dmg]],
			["Activating Tidal Wave reduces the passive on hit damage by 0.5 for |0|. This effect stacks, but does not refresh other stacks.", [interpreter_for_debuff_cooldown]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
		]
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION] = ability_desc
		
		info.tower_descriptions = [
			"Wave attacks in bursts of 2.",
			["Passive: Wave gains |0|.", [interpreter_for_flat_on_hit]],
			"",
		]
		
		for desc in ability_desc:
			info.tower_descriptions.append(desc)
		
#		info.tower_descriptions = [
#			"Wave attacks in bursts of 2.",
#			["Passive: Wave gains |0|.", [interpreter_for_flat_on_hit]],
#			"",
#			"Ability: Tidal Wave. Wave sprays 8 columns of water in a cone facing its current target.",
#			"Each column deals 1 + twice of Wave's passive on hit damage as elemental damage to all enemies hit.",
#			"Each column explodes when reaching its max distance, or when hitting 2 enemies. Each explosion deals 0.75 elemental damage to 2 enemies.",
#			"Activating Tidal Wave reduces the passive on hit damage by 0.5 for 30 seconds. This effect stacks, but does not refresh other stacks.",
#			"Cooldown: 6 s",
#			"",
#			"Additional info is present in this ability's tooltip."
#		]
		
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.88
		info.base_pierce = 1
		info.base_range = 125
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Every 3rd attack, Bleach's main attack removes 6 toughness from enemies hit for 8 seconds. Does not stack."
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.75
		info.base_pierce = 1
		info.base_range = 125
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_debuff_cooldown = TextFragmentInterpreter.new()
		interpreter_for_debuff_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_debuff_cooldown.display_body = true
		interpreter_for_debuff_cooldown.header_description = "s"
		
		var ins_for_debuff_cooldown = []
		ins_for_debuff_cooldown.append(NumericalTextFragment.new(15, false))
		ins_for_debuff_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_debuff_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_debuff_cooldown.array_of_instructions = ins_for_debuff_cooldown
		
		
		
		#
		
		info.tower_descriptions = [
			"Automatically attempts to cast Rewind at its target.",
			"Rewind: After a brief delay, Time machine teleports its non-boss target a few paces backwards.",
			["Cooldown: |0|", [interpreter_for_debuff_cooldown]],
			"",
			"Rewind also applies 3 stacks of Time Dust onto an enemy for 10 seconds. Time Machine’s main attacks onto an enemy consume a stack of Time Dust, reducing Rewind’s cooldown by 2 seconds."
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.15
		info.base_attk_speed = 0.86
		info.base_pierce = 1
		info.base_range = 132
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(10, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		#
		
		var interpreter_for_bonus_dmg_per_stack = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg_per_stack.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_bonus_dmg_per_stack.display_body = true
		
		var ins_for_retract_bonus_dmg_per_stack = []
		ins_for_retract_bonus_dmg_per_stack.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", 25, true))
		
		interpreter_for_bonus_dmg_per_stack.array_of_instructions = ins_for_retract_bonus_dmg_per_stack
		
		#
		
		var interpreter_for_bonus_dmg_total = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg_total.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_bonus_dmg_total.display_body = true
		
		var ins_for_retract_bonus_dmg_total = []
		ins_for_retract_bonus_dmg_total.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", 100, true))
		
		interpreter_for_bonus_dmg_total.array_of_instructions = ins_for_retract_bonus_dmg_total
		
		
		#
		
		
		var interpreter = TextFragmentInterpreter.new()
		interpreter.tower_info_to_use_for_tower_stat_fragments = info
		interpreter.display_body = true
		
		var outer_ins = []
		var ins = []
		ins.append(NumericalTextFragment.new(8, false, DamageType.PHYSICAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 4, DamageType.PHYSICAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 2)) # stat basis does not matter here
		
		outer_ins.append(ins)
		
		outer_ins.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		outer_ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter.array_of_instructions = outer_ins
		
		
		# INS END
		
		info.tower_descriptions = [
			"Automatically attempts to casts Seed Bomb when hitting an enemy with its main attack.",
			"Seed Bomb: Seeder implants a seed bomb to an enemy. Seeder's pea attacks causes the seed to gain a stack of Fragile.",
			"After 6 seconds or reaching 4 stacks of Fragile, the seed bomb explodes, hitting up to 5 enemies. Fragile stacks increase the explosions's damage.",
			["Cooldown: |0|", [interpreter_for_cooldown]],
			"",
			["Each Fragile stack allows the explosion to deal |0| (up to |1|).", [interpreter_for_bonus_dmg_per_stack, interpreter_for_bonus_dmg_total]],
			["Seed Bomb's explosion deals |0|. Applies on hit effects.", [interpreter]],
		]
		
		
#		info.tower_descriptions = [
#			"Automatically attempts to casts Seed Bomb when hitting an enemy with its main attack.",
#			"Seed Bomb: Seeder implants a seed bomb to an enemy. Seeder's pea attacks causes the seed to gain a stack of Fragile.",
#			"After 6 seconds or reaching 4 stacks of Fragile, the seed bomb explodes, hitting up to 5 enemies. The explosion's damage scales with its Fragile stacks.",
#			"Cooldown: 10 s",
#			"",
#			"Each Fragile stack allows the explosion to deal 25% more damage (up to 100% more damage).",
#			"Seed Bomb's explosion deals 10 physical damage. The explosion benefits from base damage buffs at 400% efficiency, and benefits from on hit damages at 200% efficiency. Applies on hit effects.",
#		]
		
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 0
		info.base_attk_speed = 0.475
		info.base_pierce = 0
		info.base_range = 125
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		
		var interpreter = TextFragmentInterpreter.new()
		interpreter.tower_info_to_use_for_tower_stat_fragments = info
		interpreter.display_body = true
		
		var ins = []
		ins.append(NumericalTextFragment.new(3.25, false, DamageType.PHYSICAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1, DamageType.PHYSICAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1)) # stat basis does not matter here
		
		interpreter.array_of_instructions = ins
		
		info.tower_descriptions = [
			"Shoots an exploding fruit.",
			#"The explosion deals 3.25 physical damage to 3 enemies. The explosion benefits from base damage buffs, on hit damages and effects."
			["The explosion deals |0| to 3 enemies. The explosion applies on hit effects.", [interpreter]]
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2
		info.base_attk_speed = 1.05
		info.base_pierce = 0
		info.base_range = 145
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0.1
		
		#
		
		var interpreter_for_dmg_per_sec = TextFragmentInterpreter.new()
		interpreter_for_dmg_per_sec.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_dmg_per_sec.display_body = true
		
		var ins_for_dmg_per_sec = []
		ins_for_dmg_per_sec.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "damage", 2))
		
		interpreter_for_dmg_per_sec.array_of_instructions = ins_for_dmg_per_sec
		
		#
		
		var interpreter_on_expl_dmg = TextFragmentInterpreter.new()
		interpreter_on_expl_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_on_expl_dmg.display_body = true
		
		var ins_for_expl_dmg = []
		ins_for_expl_dmg.append(NumericalTextFragment.new(3, false, DamageType.ELEMENTAL))
		ins_for_expl_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_expl_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.35, DamageType.ELEMENTAL))
		ins_for_expl_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_expl_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.35)) # stat basis does not matter here
		
		interpreter_on_expl_dmg.array_of_instructions = ins_for_expl_dmg
		
		#
		
		var interpreter_for_attk_speed_debuff = TextFragmentInterpreter.new()
		interpreter_for_attk_speed_debuff.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_attk_speed_debuff.display_body = false
		
		var ins_for_attk_speed_debuff = []
		ins_for_attk_speed_debuff.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "", 25, true))
		
		interpreter_for_attk_speed_debuff.array_of_instructions = ins_for_attk_speed_debuff
		
		#
		
		var interpreter_for_attk_speed_buff = TextFragmentInterpreter.new()
		interpreter_for_attk_speed_buff.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_attk_speed_buff.display_body = false
		
		var ins_for_attk_speed_buff = []
		ins_for_attk_speed_buff.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "", 35, true))
		
		interpreter_for_attk_speed_buff.array_of_instructions = ins_for_attk_speed_buff
		
		
		#
		
		info.tower_descriptions = [
			["Pestilence permanently poisons enemies on hit. The poison deals |0| per second.", [interpreter_for_dmg_per_sec]],
			"Pestilence's attacks also apply one stack of Toxin to enemies hit. Toxin lasts for 8 seconds that refresh per apply. Enemies become permanently Noxious upon gaining 10 Toxin stacks.",
			"",
			"Pestilence's main attacks against Noxious enemies causes 6 exploding poison darts to rain around the target enemy's location.",
			["Each explosion deals |0|. Applies on hit effects.", [interpreter_on_expl_dmg]],
			"",
			["At the start of the round or when placed in the map, Pestilence reduces the attack speed of all towers in range by |0| for the round.", [interpreter_for_attk_speed_debuff]],
			["For each tower affected, Pestilence gains |0| for the round.", [interpreter_for_attk_speed_buff]]
		]
		
#		info.tower_descriptions = [
#			["Pestilence permanently poisons enemies on hit. The poison deals |0| per second.", [interpreter_for_dmg_per_sec]],
#			"Pestilence's attacks also apply one stack of Toxin to enemies hit. Toxin lasts for 8 seconds that refresh per apply. Enemies become permanently Noxious upon gaining 10 Toxin stacks.",
#			"",
#			"Pestilence's main attacks against Noxious enemies causes 6 exploding poison darts to rain around the target enemy's location.",
#			"Each explosion deals 3 elemental damage.",
#			"Explosions apply a stack of Toxin. Explosions benefit from base damage buffs, on hit damages at 33% efficiency. Applies on hit effects.",
#			"",
#			"At the start of the round or when placed in the map, Pestilence reduces the attack speed of all towers in range by 25% for the round.",
#			"For each tower affected, Pestilence gains 35% bonus attack speed for the round."
#		]
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 4.75
		info.base_attk_speed = 0.68
		info.base_pierce = 1
		info.base_range = 115
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# ins start
		
		var interpreter_for_perc_on_hit = TextFragmentInterpreter.new()
		interpreter_for_perc_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_perc_on_hit.display_body = false
		
		var ins_for_perc_on_hit = []
		ins_for_perc_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "missing health as damage", 6, true))
		
		interpreter_for_perc_on_hit.array_of_instructions = ins_for_perc_on_hit
		
		#
		
		var interpreter_for_slash = TextFragmentInterpreter.new()
		interpreter_for_slash.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_slash.display_body = true
		
		var ins_for_slash = []
		ins_for_slash.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 3, DamageType.PHYSICAL))
		ins_for_slash.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_slash.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_slash.array_of_instructions = ins_for_slash
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(0.2, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		# ins end
		
		info.tower_descriptions = [
			["Reaper's attacks deal additional |0|, up to 8 health.", [interpreter_for_perc_on_hit]],
			"",
			"Killing an enemy grants Reaper 1 stack of Death. Reaper attempts to cast Slash while having Death stacks.",
			["Ability: Slash. Reaper consumes 1 Death stack to slash the area of the closest enemy, dealing |0| to each enemy hit. Does not apply on hit effects.", [interpreter_for_slash]],
			"Casting Slash reduces the damage of subsequent slashes by 50% for 0.5 seconds. This does not stack.",
			["Cooldown: |0|.", [interpreter_for_cooldown]]
		]
		
		
#		info.tower_descriptions = [
#			["Reaper's attacks deal additional 6% of the enemy's missing health as elemental damage, up to 8 health.", [interpreter_for_perc_on_hit]],
#			"",
#			"Killing an enemy grants Reaper 1 stack of Death. Reaper attempts to cast Slash while having Death stacks.",
#			"Slash: Reaper consumes 1 Death stack to slash the area of the closest enemy, dealing 300% of Reaper's total base damage as physical damage to each enemy hit. Does not apply on hit damages and effects.",
#			"Casting Slash reduces the damage of subsequent slashes by 50% for 0.5 seconds. This does not stack.",
#			"Cooldown: 0.2 s."
#		]
		
		
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_REAPER)
		base_dmg_attr_mod.flat_modifier = tier_base_dmg_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_REAPER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ base dmg"
		
		
#		var reap_dmg_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_REAPER)
#		reap_dmg_modifier.percent_amount = 5
#		reap_dmg_modifier.percent_based_on = PercentType.MISSING
#		reap_dmg_modifier.ignore_flat_limits = false
#		reap_dmg_modifier.flat_maximum = 3.25
#		reap_dmg_modifier.flat_minimum = 0
#
#		var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_REAPER, reap_dmg_modifier, DamageType.ELEMENTAL)
#
#		var reap_dmg_effect = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.ING_REAPER)
#		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, reap_dmg_effect)
#
#		info.ingredient_effect = ing_effect
#		info.ingredient_effect_simple_description = "+ on hit"
#
		
	elif tower_id == SHOCKER:
		info = TowerTypeInformation.new("Shocker", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = shocker_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 0
		info.base_attk_speed = 0.5
		info.base_pierce = 1
		info.base_range = 145
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# Ins start
		
		var interpreter_for_range = TextFragmentInterpreter.new()
		interpreter_for_range.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_range.display_body = false
		
		var ins_for_range = []
		ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", 100, false))
		
		interpreter_for_range.array_of_instructions = ins_for_range
		
		#
		
		var interpreter_for_bolt = TextFragmentInterpreter.new()
		interpreter_for_bolt.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_bolt.display_body = true
		interpreter_for_bolt.header_description = "elemental damage"
		
		var ins_for_bolt = []
		ins_for_bolt.append(NumericalTextFragment.new(2, false, DamageType.ELEMENTAL))
		ins_for_bolt.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_bolt.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.5, DamageType.ELEMENTAL))
		ins_for_bolt.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_bolt.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.5)) # stat basis does not matter here
		
		interpreter_for_bolt.array_of_instructions = ins_for_bolt
		
		
		# ins end
		
		info.tower_descriptions = [
			"Shocker possesses one shocker ball, which is shot when an enemy is in range. The shocker ball sticks to the first enemy it hits.",
			"The ball zaps the closest enemy within its range every time the enemy it is stuck to is hit by an attack. This event does not occur when the triggering attack is from another shocker ball.",
			"The ball returns to Shocker when the enemy dies, exits the map, when the ball fails to stick to a target, or when the enemy is not hit after 5 seconds.",
			"",
			["Shocker ball has |0|. Its bolts deal |1|. Applies on hit effects.", [interpreter_for_range, interpreter_for_bolt]],
		]
		
#		info.tower_descriptions = [
#			"Shocker possesses one shocker ball, which is shot when an enemy is in range. The shocker ball sticks to the first enemy it hits.",
#			"The ball zaps the closest enemy within its range every time the enemy it is stuck to is hit by an attack. This event does not occur when the triggering attack is from another shocker ball.",
#			"The ball returns to Shocker when the enemy dies, exits the map, when the ball fails to stick to a target, or when the enemy is not hit after 5 seconds.",
#			"",
#			"Shocker ball has 100 range. Its bolts deal 2 elemental damage. Bolts benefit from base damage buffs and on hit damages at 50% efficiency. Applies on hit effects.",
#		]
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.75
		info.base_attk_speed = 1.23
		info.base_pierce = 1
		info.base_range = 145
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_bonus_dmg.display_body = true
		interpreter_for_bonus_dmg.header_description = "more damage"
		
		var ins_for_bonus_dmg = []
		ins_for_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1))
		ins_for_bonus_dmg.append(NumericalTextFragment.new(75, true, -1, "", false, TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP))
		ins_for_bonus_dmg.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_bonus_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_dmg
		
		#
		
		var interpreter_for_snd_attk_dmg = TextFragmentInterpreter.new()
		interpreter_for_snd_attk_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_snd_attk_dmg.display_body = true
		interpreter_for_snd_attk_dmg.header_description = "physical damage"
		
		var ins_for_snd_attk_dmg = []
		ins_for_snd_attk_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, ""))
		ins_for_snd_attk_dmg.append(NumericalTextFragment.new(2.25, false, DamageType.PHYSICAL, "", false, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE))
		ins_for_snd_attk_dmg.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_snd_attk_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_snd_attk_dmg.array_of_instructions = ins_for_snd_attk_dmg
		
		
		# INS END
		
		
		info.tower_descriptions = [
			"Adept's attacks gain bonus effects based on its current target's distance from itself on hit.",
			["Beyond 85% of range: Adept's main attack deals |0|, and slows enemies hit by 30% for 0.75 seconds.", [interpreter_for_bonus_dmg]],
			"Below 35% of range: Adept's main attack causes a secondary attack to fire. The secondary attack seeks another target. This is also considered to be Adept's main attack, but cannot trigger from itself.",
			["The secondary attack deals |0| and applies on hit effects. ", [interpreter_for_snd_attk_dmg]],
			"",
			"After 3 rounds of being active, Adept gains Far and Close targeting options.",
		]
		
#		info.tower_descriptions = [
#			"Adept's attacks gain bonus effects based on its current target's distance from itself on hit.",
#			"Beyond 85% of range: Adept's main attack deals 75% more damage, and slows enemies hit by 30% for 0.75 seconds.",
#			"Below 35% of range: Adept's main attack causes a secondary attack to fire. The secondary attack seeks another target. This is also considered to be Adept's main attack.",
#			"The secondary attack deals 2.25 physical damage and applies on hit effects. The secondary attack cannot trigger another secondary attack.",
#			"",
#			"After 3 rounds of being active, Adept gains Far and Close targeting options.",
#			"",
#			"Adept's bonus damage (from attacking at 85% of range), and secondary attack's damage scale with ability potency."
#		]
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3.2
		info.base_attk_speed = 0.48
		info.base_pierce = 2
		info.base_range = 120
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Rebound shoots discs that slow down upon hitting its first enemy.",
			"Upon reaching its max distance, the disc travels back to Rebound, refreshing its pierce and dealing damage to enemies in its path again."
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.35
		info.base_attk_speed = 0.81
		info.base_pierce = 1
		info.base_range = 135
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_3rd_attk = TextFragmentInterpreter.new()
		interpreter_for_3rd_attk.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_3rd_attk.display_body = false
		
		var ins_for_3rd_attk = []
		ins_for_3rd_attk.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "physical damage on hit", 1))
		
		interpreter_for_3rd_attk.array_of_instructions = ins_for_3rd_attk
		
		#
		
		var interpreter_for_9th_attk = TextFragmentInterpreter.new()
		interpreter_for_9th_attk.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_9th_attk.display_body = false
		
		var ins_for_9th_attk = []
		ins_for_9th_attk.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "physical damage on hit", 2.5))
		
		interpreter_for_9th_attk.array_of_instructions = ins_for_9th_attk
		
		
		# INS END
		
		info.tower_descriptions = [
			["Every 3rd main attack deals extra |0|.", [interpreter_for_3rd_attk]],
			["Every 9th main attack instead deals extra |0|.", [interpreter_for_9th_attk]]
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3
		info.base_attk_speed = 1.25
		info.base_pierce = 1
		info.base_range = 155
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_flat_dmg = TextFragmentInterpreter.new()
		interpreter_for_flat_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_dmg.display_body = false
		
		var ins_for_flat_dmg = []
		ins_for_flat_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", 1.5))
		
		interpreter_for_flat_dmg.array_of_instructions = ins_for_flat_dmg
		
		#
		
		info.tower_descriptions = [
			"Each attack that applies on hit effects is infused with a Hex. Enemies gain Curses as effects after reaching a certain number of Hexes. Hexes and Curses last indefinitely.",
			["2 hex: Enemies take extra |0| from HexTribute's attacks.", [interpreter_for_flat_dmg]],
			"4 hex: Enemies's armor is reduced by 25%.",
			"6 hex: Enemies's toughness is reduced by 25%.",
			"8 hex: Enemies become 75% more vulnerable to effects.",
			"20 hex: Executes normal enemies.",
			"80 hex: Executes elite enemies.",
			"",
			"HexTribute applies 4 hexes per attack for the rest of the round upon infusing 10 hexes to an enemy for the first time.",
		]
		
		
		var effect_vul_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.ING_HEXTRIBUTE_EFFECT_VUL)
		effect_vul_modi.percent_amount = 50
		effect_vul_modi.percent_based_on = PercentType.BASE
		var hextribute_effect_vul_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_EFFECT_VULNERABILITY, effect_vul_modi, StoreOfEnemyEffectsUUID.ING_HEXTRIBUTE_EFFECT_VUL)
		hextribute_effect_vul_effect.is_timebound = true
		hextribute_effect_vul_effect.time_in_seconds = 10
		hextribute_effect_vul_effect.respect_scale = false
		
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 0
		info.base_attk_speed = 0.65
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Main attacks cause different effects based on the enemy’s current health",
			"If the enemy has missing health, the enemy is slowed by 35% for 1.5 seconds.",
			"If the enemy has full health, the enemy’s maximum health is reduced by 12.5% (with a minimum of 5 health, and a maximum of 25 health). This effect does not stack.",
			"Ability potency increases maximum health percent reduction and limits."
		]
		
		var base_health_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_TRANSMUTATOR)
		base_health_mod.percent_amount = 100
		base_health_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_HEALTH , base_health_mod, StoreOfTowerEffectsUUID.ING_TRANSMUTATOR)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ health"
		
		
		
	elif tower_id == HERO:
		info = TowerTypeInformation.new("Hero", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.WHITE)
		info.tower_image_in_buy_card = hero_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 1.3
		info.base_attk_speed = 0.83
		info.base_pierce = 1
		info.base_range = 140
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"The Hero grows stronger by accumulating EXP. EXP is gained by various methods.",
			"Levels are gained by spending EXP and gold. Only 6 levels can be gained this way. Levels are used to unlock and upgrade the Hero's skills.",
			"Upon reaching level 6, Hero increases the limit of activatable composite synergies by 1. Hero also gains 1.5 bonus base damage, 40% bonus attack speed, and 0.5 ability potency.",
			"",
			"Hero's skills are in effect only when White is the active dominant color.",
			"",
			"The Hero can absorb any ingredient color. Hero can also absorb 1 additional ingredient per level up, up to 4.",
		]
		
		
		
	elif tower_id == AMALGAMATOR:
		info = TowerTypeInformation.new("Amalgamator", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLACK)
		info.tower_image_in_buy_card = amalgamator_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3.25
		info.base_attk_speed = 0.95
		info.base_pierce = 1
		info.base_range = 145
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Every end of round, Amalgamator selects a random non-black tower in the map to apply Amalgamate.",
			"Amalgamate: Sets a tower's color to black, erasing all previous colors.",
			"",
			"Ability: Amalgam. Randomly selects 2 non-black towers to apply Amalgamate to. Amalgamator explodes afterwards, destroying itself in the process.",
			"Amalgam prioritizes towers in the map, followed by benched towers.",
		]
		
		
	elif tower_id == BLOSSOM:
		info = TowerTypeInformation.new("Blossom", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = blossom_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Blossom can assign a tower as its Partner.",
			"The Partner receives these bonus effects while Blossom is alive:",
			"+ 20% total attack speed, up to 2 attack speed.",
			"+ 20% total base damage, up to 4 base damage.",
			"+ 50% resistance against enemy effects.",
			"+ 2% healing from all post mitigated damage dealt.",
			"+ Instant Revive effect. If the Partner reaches 0 health, Blossom sacrifices itself for the rest of the round to revive its Partner to full health.",
			"",
			"Blossom can only have one Partner. Blossom cannot pair with another Blossom. Blossom cannot pair with a tower that's already paired with another Blossom."
		]
		
		
		var base_health_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_BLOSSOM)
		base_health_mod.percent_amount = 250
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
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.65
		info.base_attk_speed = 0.6
		info.base_pierce = 1
		info.base_range = 100
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Shoots a pinecone that fragments into 3 pieces upon hitting an enemy.",
			"Each fragment deals 1 physical damage.",
		]
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_PINECONE)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_PINECONE, attr_mod, DamageType.PHYSICAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_PINECONE)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == SOUL:
		info = TowerTypeInformation.new("Soul", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = soul_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3
		info.base_attk_speed = 0.775
		info.base_pierce = 1
		info.base_range = 115
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Main attacks on hit causes Soul to attempt to cast Effigize.",
			"Effigize: Spawns an Effigy of the enemy. Only one Effigy can be maintained by Soul at a time.",
			"Effigy gains max health equal to 50% of the enemy hit's current health. This is increased by Soul's ability potency.",
			"Effigy inherits the enemy's stats, and has 5 less armor.",
			"All damage and on hit effects taken by the Effigy is shared to the enemy associated with the Effigy. This does not trigger on hit events, and does not share execute damage.",
			"Cooldown: 1 s. Cooldown starts when the Effigy is destroyed.",
			"",
			"The Effigy's spawn location is determined by Soul's targeting. \"First\" targeting spawns the Effigy ahead of the enemy, while all other targeting options spawns the Effigy behind the enemy.",
			"",
			"If the associated enemy dies while the Effigy is standing, the Effigy explodes, dealing 50% of its current health as elemental damage to 5 enemies.",
		]
		
		var res_modifier = FlatModifier.new(StoreOfEnemyEffectsUUID.ING_SOUL)
		res_modifier.flat_modifier = -4
		
		var enemy_res_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.FLAT_ARMOR, res_modifier, StoreOfEnemyEffectsUUID.ING_SOUL)
		enemy_res_effect.is_from_enemy = false
		enemy_res_effect.time_in_seconds = 10
		enemy_res_effect.is_timebound = true
		
		var tower_effect = TowerOnHitEffectAdderEffect.new(enemy_res_effect, StoreOfTowerEffectsUUID.ING_SOUL)
		var ing_effect = IngredientEffect.new(tower_id, tower_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "- armor"
		
#		var dmg_modifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_SOUL)
#		dmg_modifier.percent_amount = 2
#		dmg_modifier.percent_based_on = PercentType.CURRENT
#		dmg_modifier.ignore_flat_limits = false
#		dmg_modifier.flat_maximum = 3
#		dmg_modifier.flat_minimum = 0
#
#		var on_hit_dmg : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_SOUL, dmg_modifier, DamageType.ELEMENTAL)
#
#		var dmg_effect = TowerOnHitDamageAdderEffect.new(on_hit_dmg, StoreOfTowerEffectsUUID.ING_SOUL)
#		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, dmg_effect)
#
#		info.ingredient_effect = ing_effect
#		info.ingredient_effect_simple_description = "+ on hit"
#
		
		
	elif tower_id == PROMINENCE:
		info = TowerTypeInformation.new("Prominence", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.tower_image_in_buy_card = prominence_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3
		info.base_attk_speed = 0.6
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Prominence attacks through its Globules. Prominence possesses 4 Globules which attack independently. Globules benefit from all buffs and inherit Prominence's stats.",
			"Globule's attacks are considered to be Prominence's main attacks.",
			"",
			"When at least 2 Globules have enemies in their range, Prominence can cast Regards.",
			"Regards: After a delay, Prominence smashes the ground, knocking up and stunning nearby enemies for 3 seconds, and dealing 12 physical damage.",
			"The farthest tower with range from Prominence also casts Regards using Prominence's ability potency. Enemies can only be affected once.",
			"Prominece also gains 3 attacks with its sword, with each attack exploding, dealing 5 + 300% of its bonus base damage as elemental damage.",
			"Cooldown: 60 s",
			"",
			"Regards' stun duration scales with ability potency."
		]
		
		var effect = Ing_ProminenceEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, effect)
		
		info.ingredient_effect = ing_effect
		#info.ingredient_effect_simple_description = "+ on hit"
		
		
		
	elif tower_id == TRANSPORTER:
		info = TowerTypeInformation.new("Transporter", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.tower_image_in_buy_card = transpose_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.75
		info.base_attk_speed = 0.85
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# INTERPRETERS
		
		var interpreter_for_delay = TextFragmentInterpreter.new()
		interpreter_for_delay.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_delay.display_body = true
		interpreter_for_delay.header_description = "seconds"
		
		var ins_for_delay = []
		ins_for_delay.append(NumericalTextFragment.new(1.5, false))
		ins_for_delay.append(TextFragmentInterpreter.STAT_OPERATION.DIVIDE)
		ins_for_delay.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_delay.array_of_instructions = ins_for_delay
		
		#
		
		var interpreter_for_attk_speed = TextFragmentInterpreter.new()
		interpreter_for_attk_speed.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_attk_speed.display_body = true
		interpreter_for_attk_speed.header_description = "attack speed"
		
		var ins_for_attk_speed = []
		ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1))
		
		ins_for_attk_speed.append(NumericalTextFragment.new(50, true))
		ins_for_attk_speed.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_attk_speed.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
		
		#
		
		var interpreter_for_ap = TextFragmentInterpreter.new()
		interpreter_for_ap.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_ap.display_body = false
		
		var ins_for_ap = []
		ins_for_ap.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", 0.25, false))
		
		interpreter_for_ap.array_of_instructions = ins_for_ap
		
		
		#
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(45, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		# INTERPRETERS END
		
		var ability_descs = [
			["Ability: Transpose. Select a tower to swap places with. Swapping takes |0| to complete.", [interpreter_for_delay]],
			["Both the tower and Transporter gain |0| and |1| for 6 seconds after swapping.", [interpreter_for_attk_speed, interpreter_for_ap]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION] = ability_descs
		
		info.tower_descriptions = [
			"Attacks two enemies at the same time with its beams. This is counted as executing one main attack.",
			"",
		]
		for desc in ability_descs:
			info.tower_descriptions.append(desc)
		
		
		
		
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_TRANSPORTER)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_TRANSPORTER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
	elif tower_id == ACCUMULAE:
		info = TowerTypeInformation.new("Accumulae", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.colors.append(TowerColors.GRAY)
		info.tower_image_in_buy_card = accumulae_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.5
		info.base_attk_speed = 1.12
		info.base_pierce = 1
		info.base_range = 125
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Main attacks remove 0.35 ability potency from enemies hit for 7 seconds. This does not stack.",
			"Accumulae gains 1 Siphon stack per drain application.",
			"",
			"Upon reaching 15 Siphon stacks, Accumulae casts Salvo.",
			"Salvo: Fire a Spell Burst at a random enemy's location every 0.2 seconds, consuming a Siphon stack in the process. This repeats until all Siphon stacks are consumed.",
			"Cooldown: 1.5 s",
			"",
			"Accumulae is unable to execute its main attack during Salvo.",
			"Each Spell Burst explodes upon reaching the target location, dealing 7 elemental damage to 4 enemies.",
			"Spell burst explosions apply on hit effects.",
			"Ability cdr also reduces delay per burst in salvo."
		]
		
		
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_ACCUMULAE)
		base_ap_attr_mod.flat_modifier = 1.0
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.ING_ACCUMULAE)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ ap"
		
		
		
	elif tower_id == PROBE:
		info = TowerTypeInformation.new("Probe", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.tower_image_in_buy_card = probe_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.82#0.79
		info.base_pierce = 1
		info.base_range = 112
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Probe's attacks that apply on hit effects apply a stack of Research.",
			"Probe's main attacks at enemies with 3 Research stacks triggers Searched.",
			"Searched: Probe gains 50% attack speed for 5 seconds, consuming all stacks in the process. Does not stack.",
			"",
			"Triggering Searched while Searched is still active causes a piercing bullet to be shot.",
			"The bullet deals 3 physical damage, and pierces through 4 enemies."
		]
		
		
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_PROBE)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_PROBE)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
		
	elif tower_id == BREWD:
		info = TowerTypeInformation.new("Brewd", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = brewd_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3
		info.base_attk_speed = 0.685
		info.base_pierce = 1
		info.base_range = 122
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Brewd can brew multiple types of potions that have different effects.",
			"",
			"Brewd automatically attempts to cast Concoct.",
			"Concoct: Throws the selected potion type at its current target.",
			"Cooldown: 10 s"
		]
		
		
		var cooldown_modi : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_BREWD)
		cooldown_modi.percent_amount = 20.0
		cooldown_modi.percent_based_on = PercentType.BASE
		
		var effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_ABILITY_CDR, cooldown_modi, StoreOfTowerEffectsUUID.ING_BREWD)
		
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ cdr"
		
		
		
	elif tower_id == SHACKLED:
		info = TowerTypeInformation.new("Shackled", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.colors.append(TowerColors.GRAY)
		info.tower_image_in_buy_card = shackled_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.35
		info.base_attk_speed = 0.78
		info.base_pierce = 1
		info.base_range = 165
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Shackled's main attacks explode upon hitting an enemy, dealing 1 elemental damage to 3 enemies.",
			"",
			"After 18 attacks or dealing 60 post-mitigated damage, Shackled attempts to cast Chains.",
			"Chains: After a brief delay, Shackled pulls 2 non-elite enemies towards its location and stunning them for 0.5 seconds. Targeting affects which enemies are pulled.",
			"Cooldown: 14 s",
			"",
			"After 3 rounds of being active, Shackled is able to pull 2 more enemies per cast."
		]
		
		
		# Ingredient related
		var range_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_SHACKLED)
		range_attr_mod.percent_amount = 35
		range_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.ING_SHACKLED)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ range"
		
		
		
	elif tower_id == NUCLEUS:
		info = TowerTypeInformation.new("Nucleus", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.YELLOW)
		info.tower_image_in_buy_card = nucleus_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3
		info.base_attk_speed = 0.92
		info.base_pierce = 1
		info.base_range = 130
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Nucleus's main attacks ignore 40% of the enemy's armor.",
			"",
			"Nucleus shuffles to Alpha and Beta phases every 5 attacks. Nucleus always starts at Alpha Phase.",
			"Alpha: Nucleus's main attacks's base damage is increased by 100%.",
			"Beta: Nucleus's main attacks pierce through 3 enemies.",
			"",
			"Ability: Gamma. Fires a constant beam towards its current target for 8 seconds. Nucleus rotates the beam towards its current target.",
			"Gamma deals 2.5 + 40% of Nucleus's bonus base damage as elemental damage every 0.5 seconds.",
			"Cooldown: 50 s",
			"Ability potency increases damage dealt by Gamma."
		]
		
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_NUCLEUS)
		base_dmg_attr_mod.flat_modifier = tier_base_dmg_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_NUCLEUS)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ base dmg"
		
		
	elif tower_id == BURGEON:
		info = TowerTypeInformation.new("Burgeon", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = burgeon_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 0
		info.base_attk_speed = 0.34
		info.base_pierce = 0
		info.base_range = 185
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Burgeon's attacks reduce enemy healing by 40% for 8 seconds.",
			"",
			"Burgeon launches seeds that land to the ground. Upon landing, seeds explode when an enemy is nearby only after arming themselves for 1.25 seconds.",
			"Seed explosions deal 5 elemental damage to 4 enemies, and benefit from base damage and on hit damage buffs at 75% efficiency. Also applies on hit effects.",
			"",
			"Burgeon automatically attempts to cast Proliferate.",
			"Proliferate: Launches a seed at a tower in its range, prioritizing towers with enemies in their range. The seed grows to a mini burgeon. Mini burgeons attach to the tower, and borrows their range.", 
			"Mini burgeons attack just like Burgeons, and have the same stats. Mini burgeons benefit from its creator's effects. Each Mini burgeon lasts for 30 seconds, and die when its creator dies.",
			"Cooldown: 20 s.",
			"",
			"Ability potency increases mini burgeon's lifespan."
		]
		
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_BURGEON)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_BURGEON, attr_mod, DamageType.ELEMENTAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_BURGEON)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == SE_PROPAGER:
		info = TowerTypeInformation.new("Se Propager", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = se_propager_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 3
		info.base_attk_speed = 0.75
		info.base_pierce = 0
		info.base_range = 95
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		#Les semis description also uses this. Change les semis desc when changing this
		info.tower_descriptions = [
			"Ability: Production. Se Propager automatically attempts to plant a Les Semis in an unoccupied in-range tower slot every 25 seconds.",
			"",
			"Les Semis: a tower that inherits 50% of its parents base damage.",
			"Once Les Semis kills 3 enemies, it becomes Golden, increasing its sell value by 2.",
			"Les Semis gains 0.75 base damage per 1 gold it is worth selling for.",
			"Les Semis does not contribute to the color synergy, but benefits from it. Does not take a tower slot.",
			"",
			"Se Propager can be commanded to sell all current Golden Les Semis, and to automatically sell Les Semis that have turned Golden."
		]
		
		
	elif tower_id == LES_SEMIS:
		info = TowerTypeInformation.new("Les Semis", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = les_semis_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 0
		info.base_attk_speed = 0.7
		info.base_pierce = 0
		info.base_range = 115
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		#Se Propager description also uses this. Change se prop desc if changing this
		info.tower_descriptions = [
			"Inherits 50% of its parents base damage upon creation.",
			"Once Les Semis kills 3 enemies, it becomes Golden, increasing its sell value by 2.",
			"Les Semis gains 0.75 base damage per 1 gold it is worth selling for.",
			"Les Semis does not contribute to the color synergy, but benefits from it. Does not take a tower slot.",
		]
		
		
		
	elif tower_id == L_ASSAUT:
		info = TowerTypeInformation.new("L' Assaut", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = l_assaut_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 2.25
		info.base_attk_speed = 0.875
		info.base_pierce = 0
		info.base_range = 110
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		
		info.tower_descriptions = [
			"Gain 10% bonus damage per win, up to 50%. This is lost upon losing.",
			"Gain a stack of resurgence per loss. Upon winning, consume all stacks to heal for 2* the stack amount.",
			"",
			"When this tower's current target exits its range, cast Pursuit.",
			"Pursuit: L' Assaut attempts to relocate itself to be able to attack the escapee. L' Assaut then gains 150% attack speed and 25 range for 1 second.",
			"Bonus stats gained from Pursuit scales with ability potency.",
			#"L' Assaut's auto attack timer is reset upon fading in from Pursuit.",
			"",
			"At the end of the round, this tower attempts to return to its original location.",
		]
		
		
	elif tower_id == LA_CHASSEUR:
		info = TowerTypeInformation.new("La Chasseur", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = la_chasseur_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 5
		info.base_attk_speed = 0.5
		info.base_pierce = 0
		info.base_range = 135
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		
		info.tower_descriptions = [
			"Hunt Down is automatically casted twice; once when half of all enemies have been spawned, and once when all enemies have been spawned.",
			"Ability: Hunt Down. Rapidly fire 4 shots at its current target, each dealing 500% total base damage. Shots apply on hit damages and effects.",
			"If the last shot kills an enemy, La Chasseur permanently gains stacking 2 on hit physical damage. Also, gain 3 gold.",
			"Hunt Down's damage scales with ability potency."
		]
		
		
	elif tower_id == LA_NATURE:
		info = TowerTypeInformation.new("La Nature", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.tower_image_in_buy_card = la_nature_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		
		info.tower_descriptions = [
			"Does not attack.",
			"On behalf of nature, La Nature grants access to two abilities: Solar Spirit and Torrential Tempest.",
			"",
			"\"Great wonders of nature\""
		]
		
#	elif tower_id == WYVERN:
#		info = TowerTypeInformation.new("Wyvern", tower_id)
#		info.tower_tier = TowerTiersMap[tower_id]
#		info.tower_cost = info.tower_tier
#		info.colors.append(TowerColors.RED)
#		info.tower_image_in_buy_card = wyvern_image
#		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.tower_image_in_buy_card)
#
#		info.base_damage = 9
#		info.base_attk_speed = 0.35
#		info.base_pierce = 1
#		info.base_range = 185
#		info.base_damage_type = DamageType.PHYSICAL
#		info.on_hit_multiplier = 0
#
#		info.tower_descriptions = [
#			"Wyvern stores 8% of its post mitigated damage dealt as Fury.",
#			"When Wyvern has at least 10 Fury, it attempts to cast Fulminate.",
#			"Fulminate: Wyvern's next 2 main attacks explode, dealing bonus on hit physical damage equal to the Fury amount.",
#			"Bonus on hit damage scales with ability potency.",
#			"Cooldown: 18 s",
#			"",
#
#		]
		
		
	
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
	elif tower_id == SOUL:
		return load("res://TowerRelated/Color_Red/Soul/Soul.tscn")
	elif tower_id == PROMINENCE:
		return load("res://TowerRelated/Color_Violet/Prominence/Prominence.tscn")
	elif tower_id == TRANSPORTER:
		return load("res://TowerRelated/Color_Blue/Transpose/Transpose.tscn")
	elif tower_id == ACCUMULAE:
		return load("res://TowerRelated/Color_Blue/Accumulae/Accumulae.tscn")
	elif tower_id == PROBE:
		return load("res://TowerRelated/Color_Red/Probe/Probe.tscn")
	elif tower_id == BREWD:
		return load("res://TowerRelated/Color_Green/Brewd/Brewd.tscn")
	elif tower_id == SHACKLED:
		return load("res://TowerRelated/Color_Violet/Shackled/Shackled.tscn")
	elif tower_id == NUCLEUS:
		return load("res://TowerRelated/Color_Yellow/Nucleus/Nucleus.tscn")
	elif tower_id == BURGEON:
		return load("res://TowerRelated/Color_Green/Burgeon/Burgeon.tscn")
	elif tower_id == SE_PROPAGER:
		return load("res://TowerRelated/Color_Green/SePropager/SePropager.tscn")
	elif tower_id == LES_SEMIS:
		return load("res://TowerRelated/Color_Green/SePropager_LesSemis/LesSemis.tscn")
	elif tower_id == L_ASSAUT:
		return load("res://TowerRelated/Color_Green/L'Assaut/L'Assaut.tscn")
	elif tower_id == LA_CHASSEUR:
		return load("res://TowerRelated/Color_Green/La_Chasseur/LaChasseur.tscn")
	elif tower_id == LA_NATURE:
		return load("res://TowerRelated/Color_Green/LaNature/La_Nature.tscn")
