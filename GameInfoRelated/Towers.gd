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
#const BleachShredEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/BleachShredEffect.gd")
const TimeMachineEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TimeMachineEffect.gd")
const Ing_ProminenceEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/Prominence_IngEffect.gd")
const BleackAttkModAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/AttackModuleAdders/BleachExplAttkModuleAdderEffect.gd")
const BoundedSameTowersTowerEffect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/BoundedSameTowersTowerEffect.gd")

const PingletAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/AttackModuleAdders/PingletAdderEffect.gd")
const TowerChaosTakeoverEffect = preload("res://GameInfoRelated/TowerEffectRelated/TowerChaosTakeoverEffect.gd")
const LavaJetModuleAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/AttackModuleAdders/LavaJetModuleAdderEffect.gd")
const FlameBurstModuleAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/AttackModuleAdders/FlameBurstModuleAdderEffect.gd")
const AdeptModuleAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/AttackModuleAdders/AdeptModuleAdderEffect.gd")
const FulSmiteAttackModuleAdderEffect = preload("res://GameInfoRelated/TowerEffectRelated/AttackModuleAdders/FulSmiteAttkModuleAdder.gd")

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
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")

# GRAY
const mono_image = preload("res://TowerRelated/Color_Gray/Mono/Mono_E.png")
const simplex_image = preload("res://TowerRelated/Color_Gray/Simplex/Simplex_Omni.png")
const ashend_image = preload("res://TowerRelated/Color_Gray/Ashen'd/Ashend_Omni.png")

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
const trudge_image = preload("res://TowerRelated/Color_Red/Trudge/Trudge_ImageInTowerCard.png")
const sophist_image = preload("res://TowerRelated/Color_Red/Sophist/Sophist_Omni.png")
const fulgurant_image = preload("res://TowerRelated/Color_Red/Fulgurant/Fulgurant.png")
const enervate_image = preload("res://TowerRelated/Color_Red/Enervate/Enervate_Omni.png")
const solitar_image = preload("res://TowerRelated/Color_Red/Solitar/Solitar_E.png")
const trapper_image = preload("res://TowerRelated/Color_Red/Trapper/Trapper_Omni.png")
const outreach_image = preload("res://TowerRelated/Color_Red/Outreach/Outreach_Omni.png")
const blast_image = preload("res://TowerRelated/Color_Red/Blast/Blast_ImageInTowerCard.png")

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
const propel_image = preload("res://TowerRelated/Color_Orange/Propel/Propel_E.png")
const paroxysm_image = preload("res://TowerRelated/Color_Orange/Paroxysm/Paroxysm_E.png")

# YELLOW
const railgun_image = preload("res://TowerRelated/Color_Yellow/Railgun/Railgun_E.png")
const coin_image = preload("res://TowerRelated/Color_Yellow/Coin/Coin_E.png")
const beacon_dish_image = preload("res://TowerRelated/Color_Yellow/BeaconDish/BeaconDish_Omni.png")
const mini_tesla_image = preload("res://TowerRelated/Color_Yellow/MiniTesla/MiniTesla_Omni.png")
const charge_image = preload("res://TowerRelated/Color_Yellow/Charge/Charge_E.png")
const magnetizer_image = preload("res://TowerRelated/Color_Yellow/Magnetizer/Magnetizer_WholeBody.png")
const sunflower_image = preload("res://TowerRelated/Color_Yellow/Sunflower/Sunflower_Idle.png")
const nucleus_image = preload("res://TowerRelated/Color_Yellow/Nucleus/Nucleus_Omni.png")
const iota_image = preload("res://TowerRelated/Color_Yellow/Iota/Iota_WholeTowerImage.png")

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
const vacuum_image = preload("res://TowerRelated/Color_Blue/Vacuum/Vacuum_E.png")

# VIOLET
const simpleobelisk_image = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_Omni.png")
const re_image = preload("res://TowerRelated/Color_Violet/Re/Re_Omni.png")
const telsa_image = preload("res://TowerRelated/Color_Violet/Tesla/Tesla.png")
const chaos_image = preload("res://TowerRelated/Color_Violet/Chaos/Chaos_01.png")
const ping_image = preload("res://TowerRelated/Color_Violet/Ping/PingWholeBody.png")
const prominence_image = preload("res://TowerRelated/Color_Violet/Prominence/Prominence_OmniWholeBody.png")
const shackled_image = preload("res://TowerRelated/Color_Violet/Shackled/Shackled_Omni_Stage02.png")
const variance_image = preload("res://TowerRelated/Color_Violet/Variance/Variance_WholeBodyImageForCard.png")
const bounded_image = preload("res://TowerRelated/Color_Violet/Bounded/Bounded_Omni.png")
const celestial_image = preload("res://TowerRelated/Color_Violet/Celestial/Celestial_TowerBase_Omni.png")
const biomorph_image = preload("res://TowerRelated/Color_Violet/BioMorph/Biomorph_Omni.png")

# OTHERS
const hero_image = preload("res://TowerRelated/Color_White/Hero/Hero_Omni.png")
const amalgamator_image = preload("res://TowerRelated/Color_Black/Amalgamator/Amalgamator_Omni.png")

const healing_symbol_image = preload("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactCustomTowers/HealingSymbols/HealingSymbols_Omni_Charged.png")
const nightwatcher_image = preload("res://TowerRelated/Color_Violet/Chaos/AbilityAssets/NightWatcher/Chaos_NightWatcher.png")
const variance_vessel_image = preload("res://TowerRelated/Color_Violet/Variance_Vessel/Variance_Vessel_Omni.png")
const yelvio_riftaxis_image = preload("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/YelVio_RiftAxis/RiftAxis_Omni.png")

const duned_image = preload("res://TowerRelated/Color__Others/Duned/Duned_Omni.png")


enum {
	NONE = 0,
	
	# GRAY (100)
	MONO = 100,  # NOT IN POOL
	SIMPLEX = 101,
	ASHEND = 102,
	
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
	WYVERN = 209,
	TRUDGE = 210,
	SOPHIST = 211,
	FULGURANT = 212,
	ENERVATE = 213,
	SOLITAR = 214,
	TRAPPER = 215,
	OUTREACH = 216,
	BLAST = 217,
	
	# ORANGE (300)
	EMBER = 300,
	LAVA_JET = 301,
	CAMPFIRE = 302,
	VOLCANO = 303,
	_704 = 304,   # VALUE HARDCODED IN AbstractTower.
	FLAMEBURST = 305,
	SCATTER = 306,
	COAL_LAUNCHER = 307,
	ENTHALPHY = 308, # REMOVED FROM POOL
	ENTROPY = 309,
	ROYAL_FLAME = 310,
	IEU = 311, # REMOVED FROM POOL
	PROPEL = 312,
	PAROXYSM = 313,
	
	# YELLOW (400)
	RAILGUN = 400,
	COIN = 401,
	BEACON_DISH = 402,
	MINI_TESLA = 403,
	CHARGE = 404,
	MAGNETIZER = 405,
	SUNFLOWER = 406,
	NUCLEUS = 407,
	IOTA = 408,
	
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
	VACUUM = 610,
	
	# VIOLET (700)
	SIMPLE_OBELISK = 700, # REMOVED FROM POOL
	RE = 701, # REMOVED FROM POOL
	TESLA = 702,
	CHAOS = 703,  # WHEN CHANGING CHAOS's tower id, change/look at the takeover effect as well
	PING = 704,
	PROMINENCE = 705,
	SHACKLED = 706,
	VARIANCE = 707,
	
	BOUNDED = 708,
	CELESTIAL = 709,
	BIOMORPH = 710,
	
	# OTHERS (900)
	HERO = 900, # WHITE
	AMALGAMATOR = 901, # BLACK
	
	
	# MISC (2000)
	FRUIT_TREE_FRUIT = 2000, #READ: THIS VALUE IS HARDCODED IN AbstractTower's can_accept_ingredient..
	
	HEALING_SYMBOL = 2001,
	NIGHTWATCHER = 2002,
	VARIANCE_VESSEL = 2003,
	YELVIO_RIFT_AXIS = 2004,
	
	DUNED = 2005,
	MAP_PASSAGE__FIRE_PATH = 2006
	MAP_ENCHANT__ATTACKS = 2007
	
	
}



# Can be used as official list of all towers
const TowerTiersMap : Dictionary = {
	HEALING_SYMBOL : 1,
	NIGHTWATCHER : 6,
	YELVIO_RIFT_AXIS : 3,
	DUNED : 2,
	MAP_PASSAGE__FIRE_PATH : 1,
	MAP_ENCHANT__ATTACKS : 1,
	
	#MONO : 1,
	SPRINKLER : 1,
	SIMPLEX : 1,
	MINI_TESLA : 1,
	EMBER : 1,
	COAL_LAUNCHER : 1,
	SPIKE : 1,
	REBOUND : 1,
	STRIKER : 1,
	PINECONE : 1,
	TRAPPER : 1,
	
	RAILGUN : 2,
	SCATTER : 2,
	#ENTHALPHY : 2,
	ENTROPY : 2,
	BLEACH : 2,
	TIME_MACHINE : 2,
	CANNON : 2,
	SHOCKER : 2,
	TRANSMUTATOR : 2,
	HERO : 2,
	FRUIT_TREE_FRUIT : 2,
	COIN : 2,
	PROPEL : 2,
	VACUUM : 2,
	SOLITAR : 2,
	BLAST : 2,
	CELESTIAL : 2,
	BIOMORPH : 2,
	
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
	ENERVATE : 3,
	FULGURANT : 3,
	BOUNDED : 3,
	
	#RE : 4,
	PING : 4,
	MAGNETIZER : 4,
	SUNFLOWER : 4,
	_704 : 4,
	#IEU : 4,
	IMPALE : 4,
	REAPER : 4,
	ADEPT : 4,
	LEADER : 4,
	FRUIT_TREE : 4,
	L_ASSAUT : 4,
	PAROXYSM : 4,
	VARIANCE : 4,
	VARIANCE_VESSEL : 4,
	TRUDGE : 4,
	WYVERN : 4,
	
	VOLCANO : 5,
	LAVA_JET : 5,
	BLOSSOM : 5,
	TRANSPORTER : 5,
	NUCLEUS : 5,
	ORB : 5,
	BURGEON : 5,
	LA_CHASSEUR : 5,
	ASHEND : 5,
	IOTA : 5,
	SOPHIST : 5,
	
	TESLA : 6,
	CHAOS : 6,
	ROYAL_FLAME : 6,
	PESTILENCE : 6,
	PROMINENCE : 6,
	ACCUMULAE : 6,
	HEXTRIBUTE : 6,
	LA_NATURE : 6,
	OUTREACH : 6,
}

const tier_attk_speed_map : Dictionary = {
	1 : 15,
	2 : 25,
	3 : 35,
	
	4 : 50,
	5 : 60,
	6 : 60,
#	6 : 70,
}

const tier_base_dmg_map : Dictionary = {
	1 : 0.5,
	2 : 1.0,
	3 : 1.5,
	
	4 : 2.2,
	5 : 2.5,
	6 : 2.5,
#	6 : 3.0,
	
#	4 : 2.5,
#	5 : 3.0,
#	6 : 3.5,
}

const tier_on_hit_dmg_map : Dictionary = {
	1 : 0.75,
	2 : 1.25,
	3 : 1.75,
	
	4 : 2.5,
	5 : 2.75,
	6 : 2.75,
#	6 : 3.25,
#	4 : 2.7,
#	5 : 3.2,
#	6 : 3.7,
}
const tier_on_hit_dmg_reduc_if_pure : float = 0.25

const tier_flat_range_map : Dictionary = {
	1 : 20,
	2 : 30,
	3 : 40,
	4 : 60,
	5 : 70,
	6 : 70,
#	6 : 80,
}

const tier_ap_map : Dictionary = {
	1 : 0.25,
	2 : 0.35,
	3 : 0.5,
	4 : 0.65,
	5 : 0.75,
	6 : 1,
}


# Do not use this when instancing new tower class. Only use
# for getting details about tower.
const tower_id_info_type_singleton_map : Dictionary = {}
const tower_color_to_tower_id_map : Dictionary = {}



var _singleton_initialize_ran = false

#

func _init():
	pass

func _on_singleton_initialize():
	for color in TowerColors.get_all_colors():
		tower_color_to_tower_id_map[color] = []
	
	for tower_id in TowerTiersMap.keys():
		var tower_info = get_tower_info(tower_id)
		tower_id_info_type_singleton_map[tower_id] = tower_info
		
		for color in tower_info.colors:
			tower_color_to_tower_id_map[color].append(tower_id)
	
	_singleton_initialize_ran = true

#

static func _generate_tower_image_icon_atlas_texture(tower_sprite, center_offset := Vector2(0, 0)) -> AtlasTexture:
	var tower_image_icon_atlas_texture := AtlasTexture.new()
	
	tower_image_icon_atlas_texture.atlas = tower_sprite
	tower_image_icon_atlas_texture.region = _get_atlas_region(tower_sprite, center_offset)
	
	return tower_image_icon_atlas_texture


static func _get_atlas_region(tower_sprite, center_offset = Vector2(0, 0)) -> Rect2:
	var center = _get_default_center_for_atlas(tower_sprite, center_offset)
	var size = _get_default_region_size_for_atlas(tower_sprite)
	
	#return Rect2(0, 0, size.x, size.y)
	return Rect2(center.x, center.y, size.x, size.y)

static func _get_default_center_for_atlas(tower_sprite, center_offset = Vector2(0, 0)) -> Vector2:
	var highlight_sprite_size = tower_sprite.get_size()
	
	return Vector2(highlight_sprite_size.x / 4, 0) + center_offset

static func _get_default_region_size_for_atlas(tower_sprite) -> Vector2:
	var max_width = tower_sprite.get_size().x
	var max_height = tower_sprite.get_size().y
	
	var width_to_use = 27
	if width_to_use > max_width:
		width_to_use = max_width
	
	var length_to_use = 27
	if length_to_use > max_height:
		length_to_use = max_height
	
	return Vector2(width_to_use, length_to_use)

########

static func get_tower_tier_from_tower_id(arg_id : int):
	if tower_id_info_type_singleton_map.has(arg_id):
		return tower_id_info_type_singleton_map[arg_id].tower_tier
	else:
		return -1


#######

#

static func get_tower_info(tower_id : int) -> TowerTypeInformation :
	var info
	
	if tower_id == MONO:
		info = TowerTypeInformation.new("Mono", MONO)
		info.tower_tier = TowerTiersMap[MONO]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GRAY)
		info.base_tower_image = mono_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		info.base_tower_image = sprinkler_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 1.2 #1.25
		info.base_attk_speed = 1.75 #1.5
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
		info.base_tower_image = berrybush_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		info.base_tower_image = simpleobelisk_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		info.base_tower_image = simplex_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0.5 #0.4
		info.base_attk_speed = 4 #4.5
		info.base_pierce = 0
		info.base_range = 95
		info.base_damage_type = DamageType.PURE
		info.on_hit_multiplier = 0.25 #0.3
		
		info.tower_descriptions = [
			"Directs a constant pure energy beam at a single target.",
			"The energy beam's on hit damages are only %s%% effective." % str(info.on_hit_multiplier * 100),
			"",
			"\"First Iteration\""
		]
		
		info.tower_simple_descriptions = [
			"Directs a constant pure energy beam at a single target.",
		]
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_SIMPLEX)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_SIMPLEX)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
		
	elif tower_id == RAILGUN:
		info = TowerTypeInformation.new("Railgun", RAILGUN)
		info.tower_tier = TowerTiersMap[RAILGUN]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.YELLOW)
		info.base_tower_image = railgun_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 6
		info.base_attk_speed = 0.385#0.3
		info.base_pierce = 5
		info.base_range = 135#100
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
			["Shoots a dart that pierces through |0|.", [interpreter_for_pierce]],
			"Railgun's main attacks bounce off the edges of the screen."
		]
		
		info.tower_simple_descriptions = [
			["Shoots a dart that pierces through |0|.", [interpreter_for_pierce]],
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
		info.base_tower_image = re_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		info.base_tower_image = telsa_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2
		info.base_attk_speed = 1.2
		info.base_pierce = 0
		info.base_range = 140
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "damage", 2))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		#
		
		var interpreter_for_orbit_speed = TextFragmentInterpreter.new()
		interpreter_for_orbit_speed.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_orbit_speed.display_body = true
		interpreter_for_orbit_speed.header_description = "distance units"
		interpreter_for_orbit_speed.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.ROUND
		
		var ins_for_orbit_speed = []
		ins_for_orbit_speed.append(NumericalTextFragment.new(150, false, -1))
		ins_for_orbit_speed.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_orbit_speed.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_orbit_speed.array_of_instructions = ins_for_orbit_speed
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(5, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var plain_fragment__stun = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stun")
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		
		#
		
		info.tower_descriptions = [
			["Tesla's attacks |0| its target for 0.25 seconds on hit.", [plain_fragment__stun]],
			"",
			"When not on cooldown, gain a stack per main attack, increased to 2 stacks against stunned enemies. On 20 stacks, cast Amp Up, consuming all stacks in the process.",
			["|0|: Amp Up: Summon an Amp that orbits around Tesla, dealing |1| to enemies hit. Applies on hit effects.", [plain_fragment__ability, interpreter_for_flat_on_hit]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
			"",
			["Amps travel at |0| per second.", [interpreter_for_orbit_speed]],
			"Gain abilities that can adjust the orbit radius during round intermissions."
		]
		
		
		info.tower_simple_descriptions = [
			["Tesla's attacks |0| its target for 0.25 seconds on hit.", [plain_fragment__stun]],
			"",
			"After attacking enough times, cast Amp Up.",
			["|0|: Amp Up: Summon an Amp that orbits around Tesla, dealing |1| to enemies hit. Applies on hit effects.", [plain_fragment__ability, interpreter_for_flat_on_hit]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
			#"",
			#"Ability potency increases orbit speed."
		]
		
		var enemy_effect : EnemyStunEffect = EnemyStunEffect.new(0.25, StoreOfEnemyEffectsUUID.ING_TESLA)
		var tower_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(enemy_effect, StoreOfTowerEffectsUUID.ING_TESLA)
		var ing_effect : IngredientEffect = IngredientEffect.new(TESLA, tower_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "stun on hit"
		
		
	elif tower_id == CHAOS: #WHEN CHANGING CHAOS's tower id, change/look at the takeover effect as well
		info = TowerTypeInformation.new("CHAOS", CHAOS)
		info.tower_tier = TowerTiersMap[CHAOS]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.base_tower_image = chaos_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		ins_for_dia.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.1, DamageType.PHYSICAL))
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
		ins_for_bolt.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.75, DamageType.ELEMENTAL))
		
		interpreter_for_bolt.array_of_instructions = ins_for_bolt
		
		#
		
		var interpreter_for_sword = TextFragmentInterpreter.new()
		interpreter_for_sword.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_sword.display_body = true
		
		var ins_for_sword = []
		ins_for_sword.append(NumericalTextFragment.new(20, false, DamageType.PHYSICAL))
		ins_for_sword.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_sword.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 10, DamageType.PHYSICAL))
		
		interpreter_for_sword.array_of_instructions = ins_for_sword
		
		
		# INS END
		
		info.tower_descriptions = [
			"Has many attacks. Shoots orbs, diamonds, and bolts at different rates",
			"Only the orbs can be controlled by targeting options. The orbs are considered to be CHAOS's main attack.",
			"",
			"Upon dealing 80 damage with the orbs, diamonds and bolts, CHAOS erupts a dark sword to stab the orb's target.",
			"",
			["Diamond damage: |0|. Applies on hit effects.", [interpreter_for_dia]],
			["Bolt damage: |0|. Does not apply on hit effects.", [interpreter_for_bolt]],
			["Sword damage: |0|. Does not apply on hit effects.", [interpreter_for_sword]],
			"",
			"\"What happens when Chaos absorbs a Chaos?\""
		]
		
		info.tower_simple_descriptions = [
			info.tower_descriptions[0],
			["Upon dealing 80 damage with the orbs, diamonds and bolts, CHAOS erupts a dark sword to stab the orb's target, dealing |0|.", [interpreter_for_sword]],
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
		info.base_tower_image = ping_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 1
		info.base_attk_speed = 0.38
		info.base_pierce = 1
		info.base_range = 165
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
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
		ins_for_normal_shot.append(NumericalTextFragment.new(3, false, DamageType.PHYSICAL))
		ins_for_normal_shot.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_normal_shot.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 1.0, DamageType.PHYSICAL))
		ins_for_normal_shot.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_normal_shot.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.5))
		
		interpreter_for_normal_shot.array_of_instructions = ins_for_normal_shot
		
		#
		
		var interpreter_for_emp_shot = TextFragmentInterpreter.new()
		interpreter_for_emp_shot.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_emp_shot.display_body = true
		
		var ins_for_emp_shot = []
		ins_for_emp_shot.append(NumericalTextFragment.new(6, false, DamageType.PHYSICAL))
		ins_for_emp_shot.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_emp_shot.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 1.0, DamageType.PHYSICAL))
		ins_for_emp_shot.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_emp_shot.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 3.0))
		
		interpreter_for_emp_shot.array_of_instructions = ins_for_emp_shot
		
		
		# INS END
		
		info.tower_descriptions = [
			#"Stats shown are for the arrow.",
			["Fire an arrow that releases a ring. The ring marks up to |0|.", [interpreter_for_mark_count]],
			"After a brief delay, Ping shoots all marked enemies, consuming all marks in the process.",
			"Ping can shoot the next arrow immediately when it kills at least one enemy with its shots.",
			"",
			["Shots deal |0|. Applies on hit effects.", [interpreter_for_normal_shot]],
			["If only 1 enemy is marked, the shot instead deals |0|.", [interpreter_for_emp_shot]],
		]
		
		info.tower_simple_descriptions = [
			["Fire an arrow that marks up to |0|.", [interpreter_for_mark_count]],
			["After a brief delay, deal |0| to each marked enemy.", [interpreter_for_normal_shot]],
			["If only 1 enemy is marked, the shot instead deals |0|.", [interpreter_for_emp_shot]],
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
		info.base_tower_image = coin_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.25
		info.base_attk_speed = 0.5
		info.base_pierce = 2
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
		
		
		var plain_fragment__one_gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "1 gold")
		
		# INS END
		
		info.tower_descriptions = [
			["Shoots coins at enemies. Coins can hit up to |0|.", [interpreter_for_pierce]],
			"When the coin hits an enemy, it turns to its left.",
			["When a coin kills 2 enemies, it grants |0| to the player. This effect can be triggered by a coin any amount of times.", [plain_fragment__one_gold]],
			["This tower has a 1/50 chance of granting |0| to the player when shooting coins.", [plain_fragment__one_gold]],
			#"The tower has a 1/50 chance of granting 1 gold to the player.",
		]
		
		info.tower_simple_descriptions = [
			["When a coin kills 2 enemies, it grants |0| to the player.", [plain_fragment__one_gold]],
			["This tower has a 1/50 chance of granting |0| to the player when shooting coins.", [plain_fragment__one_gold]],
		]
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_COIN)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_COIN)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
#		var tower_base_effect : TowerFullSellbackEffect = TowerFullSellbackEffect.new(COIN)
#		var ing_effect : IngredientEffect = IngredientEffect.new(COIN, tower_base_effect)
#
#		info.ingredient_effect = ing_effect
#		info.ingredient_effect_simple_description = "sellback"
#
		
	elif tower_id == BEACON_DISH:
		info = TowerTypeInformation.new("Beacon-Dish", BEACON_DISH)
		info.tower_tier = TowerTiersMap[BEACON_DISH]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GRAY)
		info.colors.append(TowerColors.YELLOW)
		info.base_tower_image = beacon_dish_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 1.0 #1.5
		info.base_attk_speed = 0.5 #0.6
		info.base_pierce = 0
		info.base_range = 140 #145
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		#
		var beacon_dish_ap_ratio : float = 1
		
		var beacon_dish_on_hit__base_dmg_scale : float = 0.3
		var beacon_dish_attkspeed__attkspeed_scale : float = 35.0
		var beacon_dish_range__range_scale : float = 0.2
		
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
		ins_for_ele_on_hit.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, beacon_dish_on_hit__base_dmg_scale))
		#ins_for_ele_on_hit.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		#ins_for_ele_on_hit.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, beacon_dish_ap_ratio))
		
		interpreter_for_ele_on_hit.array_of_instructions = ins_for_ele_on_hit
		
		#
		
		var interpreter_for_attk_speed = TextFragmentInterpreter.new()
		interpreter_for_attk_speed.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_attk_speed.display_body = true
		
		var ins_for_attk_speed = []
		ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "", 0, true))
		ins_for_attk_speed.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, TowerStatTextFragment.STAT_BASIS.TOTAL, beacon_dish_attkspeed__attkspeed_scale, -1, true))
		#ins_for_attk_speed.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		#ins_for_attk_speed.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, beacon_dish_ap_ratio))
		
		
		interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
		
		#
		
		var interpreter_for_range = TextFragmentInterpreter.new()
		interpreter_for_range.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_range.display_body = true
		
		var ins_for_range = []
		ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE))
		ins_for_range.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.RANGE, TowerStatTextFragment.STAT_BASIS.TOTAL, beacon_dish_range__range_scale))
		#ins_for_range.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		#ins_for_range.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, beacon_dish_ap_ratio))
		
		
		interpreter_for_range.array_of_instructions = ins_for_range
		
		
		var plain_fragment__ability_casts = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "casts")
		var plain_fragment__ability_gives = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Gives")
		
		# INS END
		
		info.tower_descriptions = [
			["Does not attack, but instead |0| an aura that buffs towers in range every |1| for 5 seconds.", [plain_fragment__ability_casts, interpreter_for_cooldown]],
			["Grants |0| as an elemental on hit damage buff.", [interpreter_for_ele_on_hit]],
			["Grants |0| as percent attack speed buff.", [interpreter_for_attk_speed]],
			["Grants |0| as bonus range.", [interpreter_for_range]],
			"Note: Does not grant these buffs to another Beacon-Dish. Also overrides any existing Beacon-Dish buffs a tower may have.",
		]
		
		info.tower_simple_descriptions = [
			["|0| buffs to towers in range.", [plain_fragment__ability_gives]],
			["Grants |0| as an elemental on hit damage buff.", [interpreter_for_ele_on_hit]],
			["Grants |0| as percent attack speed buff.", [interpreter_for_attk_speed]],
			["Grants |0| as bonus range.", [interpreter_for_range]],
		]
		
		var range_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_BEACON_DISH)
		range_attr_mod.flat_modifier = tier_flat_range_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.ING_BEACON_DISH)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ range"
		
		
	elif tower_id == MINI_TESLA:
		info = TowerTypeInformation.new("Mini Tesla", MINI_TESLA)
		info.tower_tier = TowerTiersMap[MINI_TESLA]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.YELLOW)
		info.base_tower_image = mini_tesla_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.775
		info.base_pierce = 0
		info.base_range = 110
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		var plain_fragment__stun = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stuns")
		
		info.tower_descriptions = [
#			"Attacks apply a stack of \"static\" on enemies hit for 3 seconds, with this duration refreshing per hit.",
#			"When an enemy reaches 5 stacks, all stacks get consumed and the enemy is stunned for 2 seconds."
			["5 attacks against an enemy within 3 seconds of the last attack |0| them for 2 seconds.", [plain_fragment__stun]]
		]
		
		info.tower_simple_descriptions = [
			["5 attacks against an enemy |0| them for 2 seconds.", [plain_fragment__stun]]
		]
		
		
		var tower_effect = preload("res://GameInfoRelated/TowerEffectRelated/MiscEffects/TowerEffect_MiniTesla_IngEffect.gd").new()
		
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, tower_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "static"
		
		
	elif tower_id == CHARGE:
		info = TowerTypeInformation.new("Charge", CHARGE)
		info.tower_tier = TowerTiersMap[CHARGE]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.YELLOW)
		info.colors.append(TowerColors.RED)
		info.base_tower_image = charge_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 3
		info.base_attk_speed = 0.65
		info.base_pierce = 1
		info.base_range = 90
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# INS START
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = true
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(NumericalTextFragment.new(35, false, DamageType.PHYSICAL))
		ins_for_flat_on_hit.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_flat_on_hit.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		#
		
		var interpreter_for_perc_on_hit = TextFragmentInterpreter.new()
		interpreter_for_perc_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_perc_on_hit.display_body = true
		
		var ins_for_perc_on_hit = []
		#ins_for_perc_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "", 25, true))
		ins_for_perc_on_hit.append(NumericalTextFragment.new(20, true, DamageType.PHYSICAL))
		ins_for_perc_on_hit.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_perc_on_hit.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1, -1, true))
		
		
		interpreter_for_perc_on_hit.array_of_instructions = ins_for_perc_on_hit
		
		
		# INS END
		
		info.tower_descriptions = [
			"When idle, Charge accumulates energy. Charge's energy is set to 50% when the round starts.",
			"Main attacks expend all energy to deal bonus physical on hit damage based on expended energy.",
			["Max flat physical on hit damage portion: |0|", [interpreter_for_flat_on_hit]],
			["Max percent enemy health physical on hit damage portion: |0|", [interpreter_for_perc_on_hit]],
			"",
			"Increasing this tower's total attack speed compared to its base attack speed increases the rate of energy accumulation."
		]
		
		info.tower_simple_descriptions = [
			"Charge empowers its next main attack over a duration.",
			["Max flat physical on hit damage portion: |0|", [interpreter_for_flat_on_hit]],
			["Max percent enemy health physical on hit damage portion: |0|", [interpreter_for_perc_on_hit]],
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
		info.base_tower_image = magnetizer_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		ins.append(NumericalTextFragment.new(5, false, DamageType.ELEMENTAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 1, DamageType.ELEMENTAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1)) # stat basis does not matter here
		
		outer_ins.append(ins)
		
		outer_ins.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		outer_ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter.array_of_instructions = outer_ins
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_form = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "form")
		
		# ins end
		
		info.tower_descriptions = [
			"When shooting, Magnetizer alternates between blue magnet and red magnet. Magnetizer switches to the next targeting option after shooting a magnet.",
			"Magnets stick to the first enemy they hit. When the enemy they are stuck to dies, they drop on the ground.",
			"When there is at least one blue and one red magnet that has hit an enemy or is on the ground, Magnetizer casts Magnetize.",
			"",
			["|0|: Magnetize: Calls upon all of this tower's non traveling magnets to form a beam between their opposite types, consuming them in the process.", [plain_fragment__ability]],
			#"The beam deals 9 elemental damage. The beam benefits from base damage buffs, on hit damages and effects. Damage scales with ability potency.",
			["The beam deals |0|. Applies on hit effects", [interpreter]],
			
		]
		
		info.tower_simple_descriptions = [
			"When shooting, Magnetizer alterates between blue magnet and red magnet. Magnetizer switches to the next targeting option after shooting a magnet.",
			["Beams |0| between blue and red magnets, consuming them in the process.", [plain_fragment__ability_form]],
			["Beams deal |0|.", [interpreter]],
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
		info.base_tower_image = sunflower_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.4
		info.base_attk_speed = 0.375
		info.base_pierce = 1
		info.base_range = 110
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Sprays lots of seeds at enemies with slight inaccuracy. Attacks in bursts of 7.",
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
		info.base_tower_image = ember_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		ins_for_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", 0.8))
		
		interpreter_for_on_hit.array_of_instructions = ins_for_on_hit
		
		
		# ins end
		
		info.tower_descriptions = [
			"Heats up its attacks, causing them to burn enemies on hit.",
			["Burns enemies for |0| per second for 5 seconds.", [interpreter_for_on_hit]]
		]
		
		
		# Ingredient related
		var burn_dmg : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_EMBER)
		burn_dmg.flat_modifier = 0.25
		
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
		info.base_tower_image = lava_jet_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		ins_for_perc_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "enemy max health damage", 25, true))
		
		interpreter_for_perc_on_hit.array_of_instructions = ins_for_perc_on_hit
		
		
		# ins end
		
		info.tower_descriptions = [
			"Lava Jet's attacks ignore 3 toughness.",
			"",
			["On its 5th main attack, Lava Jet releases a beam of lava that deals |0|, up to 40.", [interpreter_for_perc_on_hit]]
		]
		
		info.tower_simple_descriptions = [
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
		info.base_tower_image = campfire_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 6
		info.base_attk_speed = 1
		info.base_pierce = 0
		info.base_range = 115
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
		ins_for_on_hit.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.5))
		
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
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_heat_pact = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Heat Pact")
		
		
		# ins end
		
		info.tower_descriptions = [
			"Campfire gains Rage equivalent to the post-mitigated damage taken by enemies within its range.",
			["Upon reaching |0|, Campfire consumes all Rage to cast Heat Pact.", [interpreter_for_rage]],
			"",
			["|0|: Heat Pact: The next attack of all towers in range deals bonus |1|.", [plain_fragment__ability, interpreter_for_on_hit]],
			"",
			"Campfire does not gain Rage from the damage its buff has dealt.",
			["Campfire cannot gain Rage for |0| after casting Heat Pact.", [interpreter_for_cooldown]],
		]
		
		info.tower_simple_descriptions = [
			"Dealing enough damage to enemies in range triggers Heat Pact.",
			"",
			["|0|: The next attack of all towers in range deals bonus |1|.", [plain_fragment__ability_heat_pact, interpreter_for_on_hit]],
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
		info.base_tower_image = volcano_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		ins_for_boulder.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 3)) # stat basis does not matter here
		
		interpreter_for_boulder.array_of_instructions = ins_for_boulder
		
		#
		
		var interpreter_for_crater = TextFragmentInterpreter.new()
		interpreter_for_crater.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_crater.display_body = true
		
		var ins_for_crater = []
		ins_for_crater.append(NumericalTextFragment.new(1, false, DamageType.ELEMENTAL))
		ins_for_crater.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_crater.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.75, DamageType.ELEMENTAL))
		
		interpreter_for_crater.array_of_instructions = ins_for_crater
		
		
		var plain_fragment__slow = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "slows")
		
		# INS END
		
		info.tower_descriptions = [
			"Launches a molten boulder at the target's location.",
			["The boulder explodes upon reaching the location, dealing |0|. Applies on hit effects.", [interpreter_for_boulder]],
			["The explosion also leaves behind scorched earth that lasts for 7 seconds, which |0| by 30% and deals |1| per 0.5 seconds to enemies while inside it. Does not apply on hit effects.", [plain_fragment__slow, interpreter_for_crater]],
		]
		
		info.tower_simple_descriptions = [
			"Launches a molten boulder at the target's location.",
			["The boulder explodes upon reaching the location, dealing |0|.", [interpreter_for_boulder]],
			["The explosion also leaves behind scorched earth that lasts for 7 seconds, which |0| by 30% and deals |1| per 0.5 seconds to enemies while inside it.", [plain_fragment__slow, interpreter_for_crater]],
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
		info.base_tower_image = _704_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.85
		info.base_attk_speed = 0.815 #0.785
		info.base_pierce = 0
		info.base_range = 128 #120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"704 possesses 3 emblems, and each can be upgraded to give bonus effects.",
			"704's emblems can be upgraded with points, and each can be upgraded up to 4 times. 704 starts with 4 points.",
			"",
			"\"704 is an open furnace with [redacted] origins.\""
		]
		
		info.tower_simple_descriptions = [
			"704 possesses 3 emblems, and each can be upgraded to give bonus effects.",
			"704's emblems can be upgraded with points, and each can be upgraded up to 4 times. 704 starts with 4 points.",
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
		info.base_tower_image = flameburst_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.75 #2.50
		info.base_attk_speed = 0.8
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
		ins_for_pierce.append(NumericalTextFragment.new(1, false, -1))
		ins_for_pierce.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_pierce.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PIERCE, TowerStatTextFragment.STAT_BASIS.BONUS, 1.0, -1))
		
		interpreter_for_pierce.array_of_instructions = ins_for_pierce
		
		#
		
		info.tower_descriptions = [
			"Flameburst's main attack causes enemies to spew out 4 flamelets around themselves.",
			["Each flamelet deals |0|, and has |1|.", [interpreter_for_flat_on_hit, interpreter_for_pierce]],
			"Bonus range gained increases the range of the flamelets."
		]
		
		info.tower_simple_descriptions = [
			"Flameburst's main attack causes enemies to spew out 4 flamelets around themselves.",
			["Each flamelet deals |0|, and has |1|.", [interpreter_for_flat_on_hit, interpreter_for_pierce]],
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
		info.base_tower_image = scatter_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.75
		info.base_attk_speed = 0.39
		info.base_pierce = 1
		info.base_range = 95
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"Shoots 3 heated iron fragments at enemies."
		]
		
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_SCATTER)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_SCATTER, attr_mod, DamageType.PHYSICAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_SCATTER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
		
	elif tower_id == COAL_LAUNCHER:
		info = TowerTypeInformation.new("Coal Launcher", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.base_tower_image = coal_launcher_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		info.base_tower_image = enthalphy_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
			["Enthalphy gains bonus |0|.", [interpreter_for_bonus_dmg_ratio]],
			["Enthalphy also gains bonus |0| for its next three attacks after killing an enemy.", [interpreter_for_flat_on_hit]],
		]
		
		info.tower_simple_descriptions = [
			["Enthalphy gains bonus |0|.", [interpreter_for_bonus_dmg_ratio]],
			["Enthalphy also gains bonus |0| for its next three attacks after killing an enemy.", [interpreter_for_flat_on_hit]],
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
		info.base_tower_image = entropy_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		]
		
		info.tower_simple_descriptions = [
			["Entropy gains |0| for its first 130 attacks.", [interpreter_for_first]],
			["Entropy also gains |0| for its first 230 attacks.", [interpreter_for_second]],
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
		info.base_tower_image = royal_flame_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		
		# ins
		
		var ability_descs = [
			["|0|: Steam Burst. Extinguishes the 3 closest enemies burned by Royal Flame. Extinguishing enemies creates a steam explosion that deals |1|, up to 150.", [plain_fragment__ability, interpreter_for_perc_on_hit]],
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
		info.base_tower_image = ieu_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
			["Absorbing Entropy gives |0| for the first stack, and |1| for the subsequent stacks.", [interpreter_for_entropy_first, interpreter_for_entropy_second]],
			["Absorbing Enthalphy gives |0| for the first stack, and |1| for the subsequent stacks.", [interpreter_for_enthalphy_first, interpreter_for_enthalphy_second]],
		]
		
		info.tower_simple_descriptions = [
			"IE=U discards the ingredient effect of Entropy and Enthalphy when they are absorbed. Instead, a temporary buff that lasts for 5 rounds is received.",
			["Absorbing Entropy gives |0| for the first, and |1| for the subsequent.", [interpreter_for_entropy_first, interpreter_for_entropy_second]],
			["Absorbing Enthalphy gives |0| for the first, and |1| for the subsequent.", [interpreter_for_enthalphy_first, interpreter_for_enthalphy_second]],
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
		info.base_tower_image = fruit_tree_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		var plain_fragment__gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "gold")
		
		
		info.tower_descriptions = [
			"Does not attack",
			"Gives a fruit at the end of every 3rd round of being in the map.",
			"Fruits possess a special ingredient effect. Fruits can be given to any tower regardless of tower color.",
			"",
			["Fruits appear in the tower bench, and will be converted into |0| when no space is available.", [plain_fragment__gold]],
		]
		
		info.tower_simple_descriptions = [
			"Gives a fruit at the end of every 3rd round of being in the map.",
			"Fruits possess a special ingredient effect. Fruits can be given to any tower regardless of tower color.",
		]
		
		
	elif tower_id == FRUIT_TREE_FRUIT:
		info = TowerTypeInformation.new("Fruit", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.base_tower_image = fruit_tree_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		info.tower_descriptions = [
			"Fruit from Fruit Tree.",
			"Cannot be placed in the map."
		]
		
		
	elif tower_id == SPIKE:
		info = TowerTypeInformation.new("Spike", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.base_tower_image = spike_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 1.75 #1.8
		info.base_attk_speed = 0.9 #0.85
		info.base_pierce = 0
		info.base_range = 120
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
		
		var on_hit_dmg_for_tier : float = tier_on_hit_dmg_map[info.tower_tier]
		var bonus_on_hit_amount : float = 0.25
		var spike_dmg_effect = SpikeBonusDamageEffect.new(on_hit_dmg_for_tier + bonus_on_hit_amount)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, spike_dmg_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "spike"
		
		
	elif tower_id == IMPALE:
		info = TowerTypeInformation.new("Impale", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.base_tower_image = impale_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 15 #11
		info.base_attk_speed = 0.24
		info.base_pierce = 0
		info.base_range = 105
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_retract_bonus_dmg_on_threshold = TextFragmentInterpreter.new()
		interpreter_for_retract_bonus_dmg_on_threshold.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_retract_bonus_dmg_on_threshold.display_body = false
		
		var ins_for_retract_bonus_dmg_on_threshold = []
		ins_for_retract_bonus_dmg_on_threshold.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", 200, true))
		
		interpreter_for_retract_bonus_dmg_on_threshold.array_of_instructions = ins_for_retract_bonus_dmg_on_threshold
		
		#
		
		var interpreter_for_retract_on_normals = TextFragmentInterpreter.new()
		interpreter_for_retract_on_normals.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_retract_on_normals.display_body = false
		
		var ins_for_retract_bonus_on_normals = []
		ins_for_retract_bonus_on_normals.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", 100, true))
		
		interpreter_for_retract_on_normals.array_of_instructions = ins_for_retract_bonus_on_normals
		
		
		var plain_fragment__stunning = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunning")
		
		
		#
		
		info.tower_descriptions = [
			["Impale shoots up a spike that stabs an enemy, |0| them for 2.2 seconds.", [plain_fragment__stunning]],
			["When the stun expires, Impale retracts the spike, dealing damage again. The retract damage deals |0| when the enemy has less than 75% of their max health.", [interpreter_for_retract_bonus_dmg_on_threshold]],
			["Normal type enemies take additional |0| from the rectact damage.", [interpreter_for_retract_on_normals]],
		]
		
		info.tower_simple_descriptions = [
			["Impale shoots up a spike that stabs an enemy, |0| them for 2.2 seconds.", [plain_fragment__stunning]],
			["When the stun expires, Impale retracts the spike, dealing damage again. The retract damage deals |0| when the enemy has less than 75% of their max health.", [interpreter_for_retract_bonus_dmg_on_threshold]],
			#["Normal type enemies take additional |0| from the rectact damage.", [interpreter_for_retract_on_normals]],
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
		info.base_tower_image = leader_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		ins_for_cooldown.append(NumericalTextFragment.new(17, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Coordinated Attack")
		var plain_fragment__stunned = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunned")
		
		# INS END
		
		var ability_descs = [
			["|0|: Coordinated Attack. Orders all members to attack the marked enemy once, regardless of range.", [plain_fragment__ability]],
			"Projectiles gain extra range to be able to reach the marked target.",
			["Member's damage in Coordinated Attack deal |0|.", [interpreter_for_bonus_dmg]],
			["The marked enemy is also |0| for 2.75 seconds.", [plain_fragment__stunned]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
		]
		
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION] = ability_descs
		
		info.tower_descriptions = [
			"Leader's main attack marks the target enemy. Only one enemy can be marked at a time.",
			"Leader manages members. Leader can have up to 5 members. Leader cannot have itself or another Leader as its member.",
			"Leader's main attacks against the marked enemy on hit decreases the cooldown of Coordinated Attack by 1 second.",
			"",
		]
		
		for desc in ability_descs:
			info.tower_descriptions.append(desc)
		
		########
		
		var simple_ability_descs = [
			["|0|: Orders all members to attack the marked enemy once, regardless of range.", [plain_fragment__ability_name]],
			#["Member's damage in Coordinated Attack deal |0|.", [interpreter_for_bonus_dmg]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
		]
		
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_SIMPLE_DESCRIPTION] = simple_ability_descs
		
		info.tower_simple_descriptions = [
			"Leader's main attack marks the target enemy.",
			"Leader can manage up to 5 members (towers).",
			"",
		]
		
		for desc in simple_ability_descs:
			info.tower_simple_descriptions.append(desc)
		
		#
		
		var targ_effect = LeaderTargetingTowerEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, targ_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "targeting"
		
		
	elif tower_id == ORB:
		info = TowerTypeInformation.new("Orb", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.base_tower_image = orb_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		ins_for_ap.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", 0.75, false))
		
		interpreter_for_ap.array_of_instructions = ins_for_ap
		
		
		# INS END
		
		info.tower_descriptions = [
			"Orb takes 2 tower slots.",
			"",
			"Orb gains new attacks at 1.5, 2.0, and 2.5 total ability potency.",
			"",
			["Orb absorbs all other Orbs placed in the map, gaining permanent |0| that stacks. This effect also applies when absorbing another Orb's ingredient effect.", [interpreter_for_ap]],
		]
		
		
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_ORB)
		base_ap_attr_mod.flat_modifier = tier_ap_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.ING_ORB)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ ap"
		
		
	elif tower_id == GRAND:
		info = TowerTypeInformation.new("Grand", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.base_tower_image = grand_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 3.5 #4
		info.base_attk_speed = 0.35 #0.365
		info.base_pierce = 1
		info.base_range = 135
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
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
		
		
		var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_bonus_dmg.display_body = true
		interpreter_for_bonus_dmg.header_description = "more damage"
		
		var ins_for_bonus_dmg = []
		ins_for_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1))
		ins_for_bonus_dmg.append(NumericalTextFragment.new(100, true, -1, "", false, TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP))
		ins_for_bonus_dmg.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_bonus_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.BONUS, 1))
		
		interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_dmg
		
		
		#
		
		info.tower_descriptions = [
			"Grand gains projectile speed at 1.25, 1.50, and 2.00 total ability potency.",
			["Grand also gains |0|.", [interpreter_for_pierce]],
			"",
			["Grand's main attack is modified to deal |0|.", [interpreter_for_bonus_dmg]],
			"",
			"The orb bullets redirect to the farthest enemy from Grand when reaching its max distance.",
		]
		
		info.tower_simple_descriptions = [
			["Grand gains |0|.", [interpreter_for_pierce]],
			"",
			["Grand's main attack is modified to deal |0|.", [interpreter_for_bonus_dmg]],
		]
		
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_GRAND)
		base_ap_attr_mod.flat_modifier = tier_ap_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.ING_GRAND)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ ap"
		
		
		
	elif tower_id == DOUSER:
		info = TowerTypeInformation.new("Douser", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.base_tower_image = douser_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.5
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
		
		var interpreter_for_buff = TextFragmentInterpreter.new()
		interpreter_for_buff.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_buff.display_body = true
		interpreter_for_buff.header_description = "bonus base damage"
		
		var ins_for_buff = []
		ins_for_buff.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE))
		ins_for_buff.append(NumericalTextFragment.new(2, false, -1, "", false, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE))
		ins_for_buff.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_buff.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_buff.array_of_instructions = ins_for_buff
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Buffing Waters")
		
		# INS END
		
		info.tower_descriptions = [
			["Douser casts Buffing Waters after every |0|.", [interpreter_for_attk_count]],
			"",
			["|0|: Buffing Waters: Douser shoots a water ball at the closest tower and itself.", [plain_fragment__ability]],
			["Towers hit by Buffing Waters gain |0| for the next 4 attacks within 10 seconds.", [interpreter_for_buff]],
			"Douser does not target towers that currently have the buff, and unprioritizes towers that have no means of attacking. Douser also does not target other Dousers, but can affect them if hit.",
		]
		
		info.tower_simple_descriptions = [
			["Douser casts Buffing Waters after every |0|.", [interpreter_for_attk_count]],
			"",
			["|0|: Douser and the closest tower gain |1| for the next 4 attacks.", [plain_fragment__ability_name, interpreter_for_buff]],
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
		info.base_tower_image = wave_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 1.5
		info.base_attk_speed = 0.45
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
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Tidal Wave")
		
		# INS END 
		
		var ability_desc = [
			["|0|: Tidal Wave. Wave sprays |1| in a cone facing its current target.", [plain_fragment__ability, interpreter_for_wave_count]],
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
		
		###
		
		var simple_ability_desc = [
			["|0|. Wave sprays |1| in a cone facing its current target, dealing damage based on its passive on hit damage.", [plain_fragment__ability_name, interpreter_for_wave_count]],
			["Activating Tidal Wave reduces the passive on hit damage by 0.5 for |0|.", [interpreter_for_debuff_cooldown]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
		]
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_SIMPLE_DESCRIPTION] = simple_ability_desc
		
		info.tower_simple_descriptions = [
			["Passive: Wave gains |0|.", [interpreter_for_flat_on_hit]],
			"",
		]
		
		for desc in simple_ability_desc:
			info.tower_simple_descriptions.append(desc)
		
		
		#
		
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
		info.base_tower_image = bleach_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.8
		info.base_pierce = 1
		info.base_range = 125
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_explo = TextFragmentInterpreter.new()
		interpreter_for_explo.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_explo.display_body = true
		
		var ins_for_explo = []
		ins_for_explo.append(NumericalTextFragment.new(2.5, false, DamageType.ELEMENTAL))
		ins_for_explo.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_explo.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_explo.array_of_instructions = ins_for_explo
		
		info.tower_descriptions = [
			["Every 5th main attack, Bleach fires a blob that explodes, dealing |0| to 3 enemies and removing 3 toughness from enemies hit for 5 seconds. Does not stack.", [interpreter_for_explo]]
		]
		
		info.tower_simple_descriptions = [
			["Every 5th main attack, Bleach fires a blob that explodes, dealing |0| to 3 enemies.", [interpreter_for_explo]]
		]
		
		var shred_effect = BleackAttkModAdderEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, shred_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "- toughness"
		
		
	elif tower_id == TIME_MACHINE:
		info = TowerTypeInformation.new("Time Machine", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.colors.append(TowerColors.YELLOW)
		info.base_tower_image = time_machine_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Rewind")
		
		#
		
		info.tower_descriptions = [
			"Automatically attempts to cast Rewind at its target upon main attacking.",
			["|0|: Rewind: Time machine teleports its non-boss target a few paces backwards. Ability potency increases the distance.", [plain_fragment__ability]],
			["Cooldown: |0|", [interpreter_for_debuff_cooldown]],
			"",
			"Rewind also applies 3 stacks of Time Dust onto an enemy for 10 seconds. Time Machine’s main attacks onto an enemy consume a stack of Time Dust, reducing Rewind’s cooldown by 2 seconds."
		]
		
		info.tower_simple_descriptions = [
			"Main attacks trigger Rewind.",
			["|0|: Time machine teleports its non-boss target a few paces backwards.", [plain_fragment__ability_name]],
			["Cooldown: |0|", [interpreter_for_debuff_cooldown]],
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
		info.base_tower_image = seeder_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		interpreter_for_bonus_dmg_per_stack.display_body = false
		
		var ins_for_retract_bonus_dmg_per_stack = []
		ins_for_retract_bonus_dmg_per_stack.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", 25, true))
		
		interpreter_for_bonus_dmg_per_stack.array_of_instructions = ins_for_retract_bonus_dmg_per_stack
		
		#
		
		var interpreter_for_bonus_dmg_total = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg_total.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_bonus_dmg_total.display_body = false
		
		var ins_for_retract_bonus_dmg_total = []
		ins_for_retract_bonus_dmg_total.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", 100, true))
		
		interpreter_for_bonus_dmg_total.array_of_instructions = ins_for_retract_bonus_dmg_total
		
		
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
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Seed Bomb")
		
		# INS END
		
		info.tower_descriptions = [
			"Main attacks on hit trigger Seed Bomb.",
			["|0|: Seed Bomb: Seeder implants a seed bomb to an enemy. Seeder's pea attacks causes the seed to gain a stack of Fragile.", [plain_fragment__ability]],
			"After 6 seconds or reaching 4 stacks of Fragile, the seed bomb explodes, hitting up to 5 enemies.",
			["Cooldown: |0|", [interpreter_for_cooldown]],
			"",
			["Each Fragile stack allows the explosion to deal |0| (up to |1|).", [interpreter_for_bonus_dmg_per_stack, interpreter_for_bonus_dmg_total]],
			["Seed Bomb's explosion deals |0|. Applies on hit effects.", [interpreter]],
		]
		
		info.tower_simple_descriptions = [
			"Main attacks on hit trigger Seed Bomb.",
			["|0|: Seeder implants a seed bomb to an enemy. Seeder's pea attacks causes the seed deal more damage.", [plain_fragment__ability_name]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
			"",
			["Each Fragile stack allows the explosion to deal |0| (up to |1|).", [interpreter_for_bonus_dmg_per_stack, interpreter_for_bonus_dmg_total]],
			["Seed Bomb's explosion deals |0|.", [interpreter]],
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
		info.base_tower_image = cannon_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0.485
		info.base_pierce = 0
		info.base_range = 135
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
			["The explosion deals |0| to 3 enemies. The explosion applies on hit effects.", [interpreter]]
		]
		
		info.tower_simple_descriptions = [
			"Shoots an exploding fruit.",
			["The explosion deals |0| to 3 enemies.", [interpreter]]
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
		info.base_tower_image = pestilence_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2
		info.base_attk_speed = 1.05
		info.base_pierce = 0
		info.base_range = 145
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1#0.1
		
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
			"Attacks also apply one stack of Toxin to enemies hit. Toxin lasts for 8 seconds that refresh per apply. Enemies become permanently Noxious upon gaining 10 Toxin stacks.",
			"",
			"Main attacks against Noxious enemies causes 6 exploding poison darts to rain around the target enemy's location.",
			["Each explosion deals |0|. Applies on hit effects.", [interpreter_on_expl_dmg]],
			"",
			["At the start of the round or when placed in the map, Pestilence reduces the attack speed of all towers in range by |0| for the round.", [interpreter_for_attk_speed_debuff]],
			["For each tower affected, Pestilence gains |0| for the round.", [interpreter_for_attk_speed_buff]]
		]
		
		info.tower_simple_descriptions = [
			"Attacks apply one stack of Toxin for 8 seconds. Enemies become Noxious upon gaining 10 Toxin stacks.",
			"",
			"Main attacks against Noxious enemies causes 6 exploding poison darts to rain around the target enemy's location.",
			["Each explosion deals |0|. Applies on hit effects.", [interpreter_on_expl_dmg]],
			"",
			["Pestilence reduces the attack speed of all towers in range by |0|.", [interpreter_for_attk_speed_debuff]],
			["For each tower affected, Pestilence gains |0|.", [interpreter_for_attk_speed_buff]]
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
		info.base_tower_image = reaper_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Slash")
		
		# ins end
		
		info.tower_descriptions = [
			["Reaper's attacks deal additional |0|, up to 8.", [interpreter_for_perc_on_hit]],
			"",
			"Killing an enemy grants Reaper 1 stack of Death. Reaper attempts to cast Slash while having Death stacks.",
			["|0|: Slash: Reaper consumes 1 Death stack to slash the area of the closest enemy, dealing |1| to each enemy hit.", [plain_fragment__ability, interpreter_for_slash]],
			"Casting Slash reduces the damage of subsequent slashes by 50% for 0.5 seconds. This does not stack.",
			["Cooldown: |0|.", [interpreter_for_cooldown]]
		]
		
		info.tower_simple_descriptions = [
			#["Reaper's attacks deal additional |0|, up to 8.", [interpreter_for_perc_on_hit]],
			#"",
			"Killing an enemy triggers Slash.",
			["|0|: Slashes the area of the closest enemy, dealing |1| to each enemy hit.", [plain_fragment__ability_name, interpreter_for_slash]],
			#"Subsequent slashes within 0.5 seconds deal only 50%.",
			["Cooldown: |0|.", [interpreter_for_cooldown]]
		]
		
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
		info.base_tower_image = shocker_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		interpreter_for_bolt.header_description = " damage"
		
		var ins_for_bolt = []
		ins_for_bolt.append(NumericalTextFragment.new(1.25, false, DamageType.ELEMENTAL))
		ins_for_bolt.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_bolt.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.40, DamageType.ELEMENTAL))
		ins_for_bolt.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_bolt.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.40)) # stat basis does not matter here
		
		interpreter_for_bolt.array_of_instructions = ins_for_bolt
		
		
		# ins end
		
		info.tower_descriptions = [
			"Shocker possesses one shocker ball as its main attack, which sticks to the first enemy it hits.",
			"The ball zaps the closest enemy within its range every time the enemy it is stuck to is hit by an attack. This event does not occur when the triggering attack is from another shocker ball.",
			"The ball returns to Shocker when the enemy dies, exits the map, when the ball fails to stick to a target, or when the enemy is not hit after 5 seconds.",
			"",
			["Shocker ball has |0|. Its bolts deal |1|. Only 15 bolts can be fired per second.", [interpreter_for_range, interpreter_for_bolt]],
		]
		
		info.tower_simple_descriptions = [
			"Shocker possesses one shocker ball which sticks to the first enemy it hits.",
			"The ball zaps the closest enemy every time the enemy it is stuck to is hit by an attack.",
			"",
			["Shocker ball has |0|. Its bolts deal |1|.", [interpreter_for_range, interpreter_for_bolt]],
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
		info.base_tower_image = adept_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.5
		info.base_attk_speed = 1.20
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
		ins_for_bonus_dmg.append(NumericalTextFragment.new(50, true, -1, "", false, TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP))
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
		
		
		var plain_fragment__slow = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "slow")
		
		# INS END
		
		
		info.tower_descriptions = [
			"Adept's main attacks gain bonus effects based on its current target's distance from itself on hit.",
			["Beyond 75% of range: Deal |0|, and |1| enemies hit by 30% for 0.75 seconds.", [interpreter_for_bonus_dmg, plain_fragment__slow]],
			"Below 40% of range: Fire a secondary attack which seeks another target. This is also considered to be Adept's main attack, but cannot trigger from itself.",
			["The secondary attack deals |0| and applies on hit effects. ", [interpreter_for_snd_attk_dmg]],
			"",
			"After 3 rounds of being in the map, Adept gains Far and Close targeting options.",
		]
		
		info.tower_simple_descriptions = [
			"Adept's main attacks gain bonus effects based on its current target's distance from itself on hit.",
			["Beyond 75% of range: Deal |0|.", [interpreter_for_bonus_dmg]],
			["Below 40% of range: Fire a secondary attack that deals |0| and applies on hit effects. This is also considered to be a main attack.", [interpreter_for_snd_attk_dmg]],
			#"",
			#"After 3 rounds, Adept gains Far and Close targeting options.",
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
		info.base_tower_image = rebound_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 3
		info.base_attk_speed = 0.48
		info.base_pierce = 2
		info.base_range = 110#120
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		
		var plain_fragment__stunning = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunning")
		
		
		info.tower_descriptions = [
			"Rebound shoots discs that slow down upon hitting its first enemy.",
			["Upon reaching its max distance, the disc travels back to Rebound, refreshing its pierce, dealing damage, and |0| enemies hit for 1 second.", [plain_fragment__stunning]]
		]
		
		info.tower_simple_descriptions = [
			["Rebound shoots discs that travel back to itself, |0| enemies hit for 1 second.", [plain_fragment__stunning]]
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
		info.base_tower_image = striker_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.0 #2.3
		info.base_attk_speed = 0.8
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
		info.base_tower_image = hextribute_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		
		var interpreter_for_hex_count = TextFragmentInterpreter.new()
		interpreter_for_hex_count.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_hex_count.display_body = true
		interpreter_for_hex_count.header_description = "hexes"
		interpreter_for_hex_count.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.FLOOR
		
		var ins_for_hex_count = []
		ins_for_hex_count.append(NumericalTextFragment.new(4, false, -1))
		ins_for_hex_count.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_hex_count.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.BONUS, 2.0, -1))
		
		interpreter_for_hex_count.array_of_instructions = ins_for_hex_count
		
		
		var plain_fragment__execute = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.EXECUTE, "Executes")
		
		#
		
		info.tower_descriptions = [
			"Attacks apply 1 Hex as an on hit effect. Enemies gain Curses as effects after reaching a certain number of Hexes. Hexes and Curses last indefinitely.",
			["2 hex: Enemies take extra |0| from HexTribute's attacks.", [interpreter_for_flat_dmg]],
			"4 hex: Enemies's armor is reduced by 25%.",
			"6 hex: Enemies's toughness is reduced by 25%.",
			"8 hex: Enemies become 75% more vulnerable to effects.",
			["20 hex: |0| normal enemies.", [plain_fragment__execute]],
			["80 hex: |0| elite enemies.", [plain_fragment__execute]],
			"",
			["HexTribute applies |0| per attack for the rest of the round upon infusing 10 hexes to an enemy for the first time.", [interpreter_for_hex_count]],
		]
		
		info.tower_simple_descriptions = [
			"Attacks apply 1 Hex to enemies. Hexes stack.",
			["20 hex: |0| normal enemies.", [plain_fragment__execute]],
			["80 hex: |0| elite enemies.", [plain_fragment__execute]],
			"",
			["HexTribute applies |0| per attack for the rest of the round upon infusing 10 hexes to an enemy for the first time.", [interpreter_for_hex_count]],
			"",
			"(To view other effects at different hexes, set description mode to descriptive)",
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
		info.base_tower_image = transmutator_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0.65
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_max_health_reduc_percent = TextFragmentInterpreter.new()
		interpreter_for_max_health_reduc_percent.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_max_health_reduc_percent.display_body = true
		interpreter_for_max_health_reduc_percent.header_description = ""
		
		var ins_for_max_health_reduc_percent = []
		#ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1))
		
		ins_for_max_health_reduc_percent.append(NumericalTextFragment.new(12.5, true))
		ins_for_max_health_reduc_percent.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_max_health_reduc_percent.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_max_health_reduc_percent.array_of_instructions = ins_for_max_health_reduc_percent
		
		#
		
		var interpreter_for_max_health_reduc_max_flat = TextFragmentInterpreter.new()
		interpreter_for_max_health_reduc_max_flat.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_max_health_reduc_max_flat.display_body = true
		interpreter_for_max_health_reduc_max_flat.header_description = "health"
		
		var ins_for_max_health_reduc_max_flat = []
		#ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1))
		
		ins_for_max_health_reduc_max_flat.append(NumericalTextFragment.new(25, false))
		ins_for_max_health_reduc_max_flat.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_max_health_reduc_max_flat.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_max_health_reduc_max_flat.array_of_instructions = ins_for_max_health_reduc_max_flat
		
		
		var plain_fragment__slowed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "slowed")
		
		
		# INS END
		
		info.tower_descriptions = [
			"Main attacks cause different effects based on the enemy’s current health",
			["If the enemy has missing health: the enemy is |0| by 35% for 1.5 seconds.", [plain_fragment__slowed]],
			["If the enemy has full health: the enemy’s maximum health is reduced by |0|, with a minimum of 5 health, and a maximum of |1|. This effect does not stack.", [interpreter_for_max_health_reduc_percent, interpreter_for_max_health_reduc_max_flat]],
		]
		
		
		var base_health_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_TRANSMUTATOR)
		base_health_mod.percent_amount = 50
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
		info.base_tower_image = hero_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 1.7 #1.6
		info.base_attk_speed = 0.9 #0.88
		info.base_pierce = 1
		info.base_range = 140
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# ins start
		
		var interpreter_for_base_dmg = TextFragmentInterpreter.new()
		interpreter_for_base_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_base_dmg.display_body = false
		
		var ins_for_base_dmg = []
		ins_for_base_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "base damage", 1.5, false))
		
		interpreter_for_base_dmg.array_of_instructions = ins_for_base_dmg
		
		
		#
		
		var interpreter_for_attk_speed = TextFragmentInterpreter.new()
		interpreter_for_attk_speed.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_attk_speed.display_body = false
		
		var ins_for_attk_speed = []
		ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 40, true))
		
		interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
		
		#
		
		var interpreter_for_ap = TextFragmentInterpreter.new()
		interpreter_for_ap.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_ap.display_body = false
		
		var ins_for_ap = []
		ins_for_ap.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", 0.5, false))
		
		interpreter_for_ap.array_of_instructions = ins_for_ap
		
		
		var plain_fragment__additional_ingredient = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "1 additional ingredient")
		
		
		# ins end
		
		info.tower_descriptions = [
			"The Hero gains EXP by dealing damage and killing enemies.", # a lie, but a not so harmful lie.
			"Levels are gained by spending EXP and gold. Only 6 levels can be gained this way. Levels are used to unlock and upgrade the Hero's skills.",
			["Upon reaching level 6, Hero increases the limit of activatable composite synergies by 1. Hero also gains |0|, |1|, and |2|.", [interpreter_for_base_dmg, interpreter_for_attk_speed, interpreter_for_ap]],
			"",
			"Hero's skills are in effect only when White is the active dominant color.",
			"",
			["The Hero can absorb any ingredient color. Hero can also absorb |0| per level up, up to 4.", [plain_fragment__additional_ingredient]],
		]
		
		info.tower_simple_descriptions = [
			"The Hero gains EXP by dealing damage and killing enemies.", # a lie, but a not so harmful lie.
			"Levels are gained by spending EXP and gold. Levels are used to unlock and upgrade the Hero's skills.",
			"",
			"Hero's skills are in effect only when White is the active dominant color.",
			"",
			["The Hero can absorb any ingredient color. Hero can also absorb |0| per level up, up to 4.", [plain_fragment__additional_ingredient]],
		]
		
		
	elif tower_id == AMALGAMATOR:
		info = TowerTypeInformation.new("Amalgamator", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLACK)
		info.base_tower_image = amalgamator_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 3.25
		info.base_attk_speed = 0.95
		info.base_pierce = 1
		info.base_range = 145
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		var plain_fragment__round_end = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "On round end")
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		
		info.tower_descriptions = [
			["|0|: Amalgamator selects a random non-black tower in the map to apply Amalgamate.", [plain_fragment__round_end]],
			"Amalgamate: Sets a tower's color to black, erasing all previous colors.",
			"",
			["|0|: Amalgam. Randomly selects 2 non-black towers to apply Amalgamate to. Amalgamator explodes afterwards, destroying itself in the process.", [plain_fragment__ability]],
			"Amalgam prioritizes towers in the map, followed by benched towers.",
		]
		
		
	elif tower_id == BLOSSOM:
		info = TowerTypeInformation.new("Blossom", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.colors.append(TowerColors.RED)
		info.base_tower_image = blossom_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		# INS START
		
		var interpreter_for_attk_speed = TextFragmentInterpreter.new()
		interpreter_for_attk_speed.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_attk_speed.display_body = false
		
		var ins_for_attk_speed = []
		ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "total attack speed", 20, true))
		
		interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
		
		#
		
		var interpreter_for_base_dmg = TextFragmentInterpreter.new()
		interpreter_for_base_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_base_dmg.display_body = false
		
		var ins_for_base_dmg = []
		ins_for_base_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "total base damage", 20, true))
		
		interpreter_for_base_dmg.array_of_instructions = ins_for_base_dmg
		
		
		
		# INS END
		
		
		info.tower_descriptions = [
			"Blossom can assign a tower as its Partner.",
			"The Partner receives these bonus effects while Blossom is alive:",
			["+ |0|, up to 2 attack speed.", [interpreter_for_attk_speed]],
			["+ |0|, up to 4 base damage.", [interpreter_for_base_dmg]],
			"+ 50% resistance against enemy effects.",
			"+ 2% healing from all post mitigated damage dealt.",
			"+ Instant Revive effect. If the Partner reaches 0 health, Blossom sacrifices itself for the rest of the round to revive its Partner to full health.",
			"",
			"Blossom can only have one Partner. Blossom cannot pair with another Blossom. Blossom cannot pair with a tower that's already paired with another Blossom."
		]
		
		
		info.tower_simple_descriptions = [
			"Blossom can assign a tower as its Partner.",
			"The Partner receives these bonus effects while Blossom is alive:",
			["+ |0|, up to 2 attack speed.", [interpreter_for_attk_speed]],
			["+ |0|, up to 4 base damage.", [interpreter_for_base_dmg]],
			"+ 50% resistance against enemy effects.",
			"+ 2% healing from all damage dealt.",
			"+ Instant Revive effect. Blossom sacrifices itself for the rest of the round to revive its Partner to full health.",
		]
		
		
		var base_health_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_BLOSSOM)
		base_health_mod.percent_amount = 200
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
		info.base_tower_image = pinecone_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.25
		info.base_attk_speed = 0.7
		info.base_pierce = 1
		info.base_range = 100
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "physical damage", 1))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		#
		
		var interpreter_for_pierce = TextFragmentInterpreter.new()
		interpreter_for_pierce.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_pierce.display_body = true
		interpreter_for_pierce.header_description = "pierce"
		
		var ins_for_pierce = []
		ins_for_pierce.append(NumericalTextFragment.new(1, false, -1, "", false, TowerStatTextFragment.STAT_TYPE.PIERCE))
		ins_for_pierce.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_pierce.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PIERCE, TowerStatTextFragment.STAT_BASIS.BONUS, 1.0, -1))
		
		interpreter_for_pierce.array_of_instructions = ins_for_pierce
		
		#
		
		info.tower_descriptions = [
			"Shoots a pinecone that releases 3 fragments upon hitting an enemy.",
			["Each fragment deals |0|, and has |1|.", [interpreter_for_flat_on_hit, interpreter_for_pierce]],
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
		info.base_tower_image = soul_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
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
		info.base_tower_image = prominence_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 3
		info.base_attk_speed = 0.6
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_stun_duration = TextFragmentInterpreter.new()
		interpreter_for_stun_duration.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_stun_duration.display_body = true
		interpreter_for_stun_duration.header_description = "s"
		
		var ins_for_stun_duration = []
		ins_for_stun_duration.append(NumericalTextFragment.new(3, false))
		ins_for_stun_duration.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_stun_duration.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_stun_duration.array_of_instructions = ins_for_stun_duration
		
		#
		
		var interpreter_for_smash_damage = TextFragmentInterpreter.new()
		interpreter_for_smash_damage.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_smash_damage.display_body = false
		
		var ins_for_smash_dmg = []
		ins_for_smash_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "physical damage", 12))
		
		interpreter_for_smash_damage.array_of_instructions = ins_for_smash_dmg
		
		#
		
		var interpreter_for_sword_dmg = TextFragmentInterpreter.new()
		interpreter_for_sword_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_sword_dmg.display_body = true
		
		var ins_for_sword_dmg = []
		ins_for_sword_dmg.append(NumericalTextFragment.new(5, false, DamageType.ELEMENTAL))
		ins_for_sword_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_sword_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 3, DamageType.ELEMENTAL))
		
		interpreter_for_sword_dmg.array_of_instructions = ins_for_sword_dmg
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(60, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Regards")
		
		var plain_fragment__knocking_up = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.KNOCK_UP, "knocking up")
		var plain_fragment__stunning = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunning")
		
		#
		
		var ability_desc = [
			["|0|: Regards: After a delay, Prominence smashes the ground, |1| and |2| nearby enemies for |3|, and dealing |4|.", [plain_fragment__ability, plain_fragment__knocking_up, plain_fragment__stunning, interpreter_for_stun_duration, interpreter_for_smash_damage]],
			"Regards also applies to the furthest tower. Enemies can only be affected once.",
			["Prominece also gains 3 attacks with its sword, with each attack exploding, dealing |0| to enemies hit.", [interpreter_for_sword_dmg]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
		]
		
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION] = ability_desc
		
		info.tower_descriptions = [
			"Prominence attacks through its Globules. Prominence possesses 4 Globules which attack independently. Globules benefit from all buffs and inherit Prominence's stats.",
			"Globule's attacks are considered to be Prominence's main attacks.",
			"",
			"When at least 2 Globules have enemies in their range, Prominence can cast Regards.",
		]
		
		for desc in ability_desc:
			info.tower_descriptions.append(desc)
		
		####
		
		var simple_ability_desc = [
			["|0|: Prominence smashes the ground, |1| and |2| nearby enemies for |3|, and dealing |4|.", [plain_fragment__ability_name, plain_fragment__knocking_up, plain_fragment__stunning, interpreter_for_stun_duration, interpreter_for_smash_damage]],
			"Regards also applies to the furthest tower.",
			#["Prominece also gains 3 attacks with its sword, with each attack exploding, dealing |0| to enemies hit.", [interpreter_for_sword_dmg]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
		]
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_SIMPLE_DESCRIPTION] = simple_ability_desc
		
		info.tower_simple_descriptions = [
			"When at least 2 Globules have enemies in their range, Prominence can cast Regards.",
		]
		
		for desc in simple_ability_desc:
			info.tower_simple_descriptions.append(desc)
		
		
		var effect = Ing_ProminenceEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, effect)
		
		info.ingredient_effect = ing_effect
		#info.ingredient_effect_simple_description = "+ on hit"
		
		
		
	elif tower_id == TRANSPORTER:
		info = TowerTypeInformation.new("Transporter", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.base_tower_image = transpose_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 1.5
		info.base_attk_speed = 0.8
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
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Transpose")
		
		
		# INTERPRETERS END
		
		var ability_descs = [
			["|0|: Transpose. Select a tower to swap places with. Swapping takes |1| to complete.", [plain_fragment__ability, interpreter_for_delay]],
			["Both the tower and Transporter gain |0| and |1| for 6 seconds after swapping.", [interpreter_for_attk_speed, interpreter_for_ap]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION] = ability_descs
		
		var ability_simple_descs = [
			["|0|: Select a tower to swap places with.", [plain_fragment__ability_name]],
			["Both the tower and Transporter gain |0| and |1| for 6 seconds after swapping.", [interpreter_for_attk_speed, interpreter_for_ap]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_SIMPLE_DESCRIPTION] = ability_simple_descs
		
		
		info.tower_descriptions = [
			"Attacks two enemies at the same time with its beams. This is counted as executing one main attack.",
			"",
		]
		for desc in ability_descs:
			info.tower_descriptions.append(desc)
		
		##
		
		info.tower_simple_descriptions = [
			#"Attacks two enemies at the same time with its beams.",
			#"",
		]
		
		for desc in ability_simple_descs:
			info.tower_simple_descriptions.append(desc)
		
		
		
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
		info.base_tower_image = accumulae_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.0
		info.base_attk_speed = 1.1
		info.base_pierce = 1
		info.base_range = 125
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_burst_delay = TextFragmentInterpreter.new()
		interpreter_for_burst_delay.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_burst_delay.display_body = true
		interpreter_for_burst_delay.header_description = "s"
		
		var ins_for_burst_delay = []
		ins_for_burst_delay.append(NumericalTextFragment.new(0.2, false))
		ins_for_burst_delay.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_burst_delay.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_burst_delay.array_of_instructions = ins_for_burst_delay
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(5.0, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		#
		
		var interpreter_for_salvo_dmg = TextFragmentInterpreter.new()
		interpreter_for_salvo_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_salvo_dmg.display_body = true
		
		var ins_for_salvo_dmg = []
		ins_for_salvo_dmg.append(NumericalTextFragment.new(7, false, DamageType.ELEMENTAL))
		ins_for_salvo_dmg.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_salvo_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_salvo_dmg.array_of_instructions = ins_for_salvo_dmg
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Salvo")
		
		
		#
		
		
		info.tower_descriptions = [
			"Main attacks mark enemies and remove 0.35 ability potency from them for 7 seconds. Accumulae gains 1 Siphon stack when marking enemies.",
			"",
			"Accumulae casts Salvo upon reaching 15 stacks, consuming all stacks.",
			["|0|: Salvo: Fire a Spell Burst at a random enemy's location every |1| for 15 times.", [plain_fragment__ability, interpreter_for_burst_delay]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
			"",
			"Accumulae is unable to execute its main attack during Salvo.",
			["Each Spell Burst deals |0| to 4 enemies. Applies on hit effects.", [interpreter_for_salvo_dmg]],
		]
		
		info.tower_simple_descriptions = [
			#"Main attacks mark enemies for 7 seconds. Accumulae gains 1 Siphon stack when marking enemies.",
			#"",
			#"Reaching 15 stacks triggers Salvo.",
			"Main attacks against 15 unique enemies triggers Salvo.",
			["|0|: Fire a Spell Burst at a random enemy's location for 15 times.", [plain_fragment__ability_name]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
			
			["Each Spell Burst deals |0| to 4 enemies.", [interpreter_for_salvo_dmg]],
		]
		
		
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_ACCUMULAE)
		base_ap_attr_mod.flat_modifier = tier_ap_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.ING_ACCUMULAE)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ ap"
		
		
		
	elif tower_id == PROBE:
		info = TowerTypeInformation.new("Probe", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.base_tower_image = probe_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.85
		info.base_pierce = 1
		info.base_range = 112
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		# INS START
		
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
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = true
		
		var ins = []
		ins.append(NumericalTextFragment.new(3, false, DamageType.PHYSICAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.5)) # stat basis does not matter here
		
		interpreter_for_flat_on_hit.array_of_instructions = ins
		
		#
		
		var interpreter_for_pierce = TextFragmentInterpreter.new()
		interpreter_for_pierce.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_pierce.display_body = true
		interpreter_for_pierce.header_description = "enemies"
		
		var ins_for_pierce = []
		ins_for_pierce.append(NumericalTextFragment.new(4, false, -1, "", false, TowerStatTextFragment.STAT_TYPE.PIERCE))
		ins_for_pierce.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_pierce.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PIERCE, TowerStatTextFragment.STAT_BASIS.BONUS, 1.0, -1))
		
		interpreter_for_pierce.array_of_instructions = ins_for_pierce
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Searched")
		
		
		# INS END
		
		info.tower_descriptions = [
			"Probe's attacks that apply on hit effects apply a stack of Research.",
			"Probe's main attacks at enemies with 3 Research stacks triggers Searched.",
			["|0|: Searched: Probe gains |1| for 5 seconds, consuming all stacks in the process. Does not stack.", [plain_fragment__ability, interpreter_for_attk_speed]],
			"",
			"Triggering Searched while Searched is still active causes a piercing bullet to be shot.",
			["The bullet deals |0|, and pierces through |1|.", [interpreter_for_flat_on_hit, interpreter_for_pierce]]
		]
		
		info.tower_simple_descriptions = [
			"Probe's 4th attack against an enemy triggers Searched.",
			["|0|: Probe gains |1| for 5 seconds.", [plain_fragment__ability_name, interpreter_for_attk_speed]],
			"",
			"Triggering Searched while Searched is still active causes a piercing bullet to be shot.",
			["The bullet deals |0|, and pierces through |1|.", [interpreter_for_flat_on_hit, interpreter_for_pierce]]
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
		info.base_tower_image = brewd_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 3
		info.base_attk_speed = 0.685
		info.base_pierce = 1
		info.base_range = 122
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(10, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Concoct")
		
		
		#
		
		info.tower_descriptions = [
			"Brewd can brew multiple types of potions that have different effects.",
			"",
			"Auto casts Concoct.",
			["|0|: Concoct: Throws the selected potion type at its current target.", [plain_fragment__ability]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		
		info.tower_simple_descriptions = [
			#"Brewd can brew multiple types of potions that have different effects.",
			#"",
			"Auto casts Concoct.",
			["|0|: Throws the selected potion type at its current target.", [plain_fragment__ability_name]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
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
		info.base_tower_image = shackled_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.25
		info.base_attk_speed = 0.78
		info.base_pierce = 1
		info.base_range = 165
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "damage", 0.9))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(14, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Chains")
		var plain_fragment__stunning = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunning")
		
		
		#
		
		info.tower_descriptions = [
			["Shackled's main attacks explode upon hitting an enemy, dealing |0| to 3 enemies.", [interpreter_for_flat_on_hit]],
			"",
			"Shackled attempts to cast Chains after 18 main attacks or dealing 60 post-mitigated damage. This resets on round end.",
			["|0|: Chains: After a brief delay, Shackled pulls 2 non-elite enemies towards its location and |1| them for 0.5 seconds. Targeting affects which enemies are pulled.", [plain_fragment__ability, plain_fragment__stunning]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
			"",
			"After 3 rounds of being in the map, Shackled is able to pull 2 more enemies per cast."
		]
		
		info.tower_simple_descriptions = [
			"Shackled attempts to cast Chains after 18 main attacks or dealing 60 post-mitigated damage.",
			["|0|: After a brief delay, Shackled pulls 2 non-elite enemies towards its location and |1| them for 0.5 seconds. Targeting affects which enemies are pulled.", [plain_fragment__ability_name, plain_fragment__stunning]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
			#"",
			#"After 3 rounds of being in the map, Shackled is able to pull 2 more enemies per cast."
		]
		
		
		# Ingredient related
		var range_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_SHACKLED)
		range_attr_mod.flat_modifier = tier_flat_range_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.ING_SHACKLED)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ range"
		
		
		
	elif tower_id == NUCLEUS:
		info = TowerTypeInformation.new("Nucleus", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.YELLOW)
		info.base_tower_image = nucleus_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.75
		info.base_attk_speed = 0.9
		info.base_pierce = 1
		info.base_range = 130
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_pierce = TextFragmentInterpreter.new()
		interpreter_for_pierce.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_pierce.display_body = true
		interpreter_for_pierce.header_description = "enemies"
		
		var ins_for_pierce = []
		ins_for_pierce.append(NumericalTextFragment.new(3, false, -1, "", false, TowerStatTextFragment.STAT_TYPE.PIERCE))
		ins_for_pierce.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_pierce.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PIERCE, TowerStatTextFragment.STAT_BASIS.BONUS, 1.0, -1))
		
		interpreter_for_pierce.array_of_instructions = ins_for_pierce
		
		#
		
		var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_bonus_dmg.display_body = false
		
		var ins_for_retract_bonus_dmg = []
		ins_for_retract_bonus_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "", 100, true))
		
		interpreter_for_bonus_dmg.array_of_instructions = ins_for_retract_bonus_dmg
		
		#
		
		var interpreter_for_gamma_dmg = TextFragmentInterpreter.new()
		interpreter_for_gamma_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_gamma_dmg.display_body = true
		
		var outer_ins = []
		var ins = []
		ins.append(NumericalTextFragment.new(1, false, DamageType.ELEMENTAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.75, DamageType.ELEMENTAL))
		
		outer_ins.append(ins)
		
		outer_ins.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		outer_ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_gamma_dmg.array_of_instructions = outer_ins
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(65, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Gamma")
		
		#
		
		var ability_desc = [
			["|0|: Gamma. Fires a constant beam towards its current target for 8 seconds. Nucleus rotates the beam towards its current target.", [plain_fragment__ability]],
			["Gamma deals |0| every 0.5 seconds.", [interpreter_for_gamma_dmg]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
		]
		
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION] = ability_desc
		
		info.tower_descriptions = [
			"Nucleus's main attacks ignore 40% of the enemy's armor.",
			"",
			"Nucleus shuffles phases every 5 main attacks. Nucleus always starts at Alpha Phase.",
			["Alpha Phase: Nucleus's main attacks's base damage is increased by |0|.", [interpreter_for_bonus_dmg]],
			["Beta Phase: Nucleus's main attacks pierce through |0|.", [interpreter_for_pierce]],
			"",
		]
		
		for desc in ability_desc:
			info.tower_descriptions.append(desc)
		
		####
		
		var simple_ability_desc = [
			["|0|: Fires a constant beam towards its current target for 8 seconds.", [plain_fragment__ability_name]],
			["Gamma deals |0| every 0.5 seconds.", [interpreter_for_gamma_dmg]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
		]
		
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_SIMPLE_DESCRIPTION] = simple_ability_desc
		
		info.tower_simple_descriptions = [
			#"Nucleus shuffles phases every 5 main attacks.",
			#["Alpha Phase: Nucleus's main attacks's base damage is increased by |0|.", [interpreter_for_bonus_dmg]],
			#["Beta Phase: Nucleus's main attacks pierce through |0|.", [interpreter_for_pierce]],
			#"",
		]
		
		for desc in simple_ability_desc:
			info.tower_simple_descriptions.append(desc)
		
		
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
		info.base_tower_image = burgeon_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0.34
		info.base_pierce = 0
		info.base_range = 185
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_seed_dmg = TextFragmentInterpreter.new()
		interpreter_for_seed_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_seed_dmg.display_body = true
		
		var ins_for_seed_dmg = []
		ins_for_seed_dmg.append(NumericalTextFragment.new(5, false, DamageType.ELEMENTAL))
		ins_for_seed_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_seed_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.75, DamageType.ELEMENTAL))
		ins_for_seed_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_seed_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.75)) # stat basis does not matter here
		
		interpreter_for_seed_dmg.array_of_instructions = ins_for_seed_dmg
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(20.0, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		#
		
		var interpreter_for_lifespan = TextFragmentInterpreter.new()
		interpreter_for_lifespan.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_lifespan.display_body = true
		interpreter_for_lifespan.header_description = "s"
		
		var ins_for_lifespan = []
		ins_for_lifespan.append(NumericalTextFragment.new(30, false, -1))
		ins_for_lifespan.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_lifespan.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_lifespan.array_of_instructions = ins_for_lifespan
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Proliferate")
		
		#
		
		info.tower_descriptions = [
			"Burgeon's attacks reduce enemy healing by 40% for 8 seconds.",
			"",
			"Burgeon launches seeds that land to the ground. After arming themselves for 1.25 seconds, seeds explode on enemy contact.",
			["Seed explosions deal |0| to 4 enemies. Applies on hit effects.", [interpreter_for_seed_dmg]],
			"",
			"Burgeon auto casts Proliferate.",
			["|0|: Proliferate: Launch a seed at a tower in its range, prioritizing towers with enemies in their range. The seed grows to a mini burgeon. Mini burgeons attach to the tower, and borrows their range.", [plain_fragment__ability]], 
			["Mini burgeons attack just like its creator, and have the same stats and effects. Each Mini burgeon lasts for |0|, and die when its creator dies.", [interpreter_for_lifespan]],
			["Cooldown: |0|.", [interpreter_for_cooldown]],
		]
		
		info.tower_simple_descriptions = [
			["Burgeon launches seeds that land on the ground, dealing |0| to 4 enemies.", [interpreter_for_seed_dmg]],
			"",
			"Burgeon auto casts Proliferate.",
			["|0|: Launch a seed at a tower in its range. The seed grows to a mini burgeon.", [plain_fragment__ability_name]], 
			["Mini burgeons attack just like its creator, and share the same stats and effects (except range). Each Mini burgeon lasts for |0|.", [interpreter_for_lifespan]],
			["Cooldown: |0|.", [interpreter_for_cooldown]],
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
		info.base_tower_image = se_propager_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 3
		info.base_attk_speed = 0.75
		info.base_pierce = 0
		info.base_range = 100
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# INS START
		
		var interpreter_for_base_dmg = TextFragmentInterpreter.new()
		interpreter_for_base_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_base_dmg.display_body = false
		
		var ins_for_base_dmg = []
		ins_for_base_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "base damage", 0.25))
		
		interpreter_for_base_dmg.array_of_instructions = ins_for_base_dmg
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(25.0, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Production")
		
		var plain_fragment__sell_value = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "2")
		var plain_fragment__tower_les_semis = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "Les Semis")
		
		# INS END
		
		#Les semis description also uses this. Change les semis desc when changing this
		info.tower_descriptions = [
			"Auto casts Production.",
			["|0|: Production. Se Propager attempts to plant a |1| in an unoccupied in-range tower slot.", [plain_fragment__ability, plain_fragment__tower_les_semis]],
			["Cooldown : |0|.", [interpreter_for_cooldown]],
			"",
			"Les Semis: a tower that inherits 40% of its parents base damage on creation.",
			["Les Semis becomes Golden on killing 3 enemies, increasing its sell value by |0|.", [plain_fragment__sell_value]],
			["Les Semis gains |0| per 1 gold it is worth selling for.", [interpreter_for_base_dmg]],
			"Les Semis does not contribute to the color synergy, but benefits from it. Does not take a tower slot.",
			"",
			"Se Propager can be commanded to sell all current Golden Les Semis, and to automatically sell Les Semis that have turned Golden."
		]
		
		info.tower_simple_descriptions = [
			"Auto casts Production.",
			["|0|: Se Propager plants a |1| in an unoccupied in-range tower slot.", [plain_fragment__ability_name, plain_fragment__tower_les_semis]],
			["Cooldown : |0|.", [interpreter_for_cooldown]],
			"",
			"Les Semis: a tower that inherits 40% of its parent's base damage on creation.",
			["Les Semis becomes Golden on killing 3 enemies, increasing its sell value by |0|.", [plain_fragment__sell_value]],
			"Does not take a tower slot.",
		]
		
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_SE_PROAPGER)
		base_dmg_attr_mod.flat_modifier = tier_base_dmg_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_SE_PROAPGER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ base dmg"
		
		
		
	elif tower_id == LES_SEMIS:
		info = TowerTypeInformation.new("Les Semis", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.base_tower_image = les_semis_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0 #set by parent
		info.base_attk_speed = 0.75
		info.base_pierce = 0
		info.base_range = 115
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		# ins
		
		var interpreter_for_base_dmg = TextFragmentInterpreter.new()
		interpreter_for_base_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_base_dmg.display_body = false
		
		var ins_for_base_dmg = []
		ins_for_base_dmg.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, -1, "base damage", 0.25))
		
		interpreter_for_base_dmg.array_of_instructions = ins_for_base_dmg
		
		
		var plain_fragment__sell_value = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "2")
		
		# ins
		
		#Se Propager description also uses this. Change se prop desc if changing this
		info.tower_descriptions = [
			"Inherits 40% of its parent's base damage upon creation.",
			["Les Semis becomes Golden on killing 3 enemies, increasing its sell value by |0|.", [plain_fragment__sell_value]],
			["Les Semis gains |0| per 1 gold it is worth selling for.", [interpreter_for_base_dmg]],
			"Les Semis does not contribute to the color synergy, but benefits from it. Does not take a tower slot.",
		]
		
		info.tower_simple_descriptions = [
			"Inherits 40% of its parents base damage on creation.",
			["Les Semis becomes Golden on killing 3 enemies, increasing its sell value by |0|.", [plain_fragment__sell_value]],
			"Does not take a tower slot.",
		]
		
		
	elif tower_id == L_ASSAUT:
		info = TowerTypeInformation.new("L' Assaut", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.base_tower_image = l_assaut_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.75
		info.base_attk_speed = 0.925
		info.base_pierce = 0
		info.base_range = 110
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_retract_bonus_dmg_per_stack = TextFragmentInterpreter.new()
		interpreter_for_retract_bonus_dmg_per_stack.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_retract_bonus_dmg_per_stack.display_body = false
		
		var ins_for_retract_bonus_dmg_per_stack = []
		ins_for_retract_bonus_dmg_per_stack.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "bonus damage", 10, true))
		
		interpreter_for_retract_bonus_dmg_per_stack.array_of_instructions = ins_for_retract_bonus_dmg_per_stack
		
		#
		
		var interpreter_for_retract_bonus_dmg_max = TextFragmentInterpreter.new()
		interpreter_for_retract_bonus_dmg_max.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_retract_bonus_dmg_max.display_body = false
		
		var ins_for_retract_bonus_dmg_max = []
		ins_for_retract_bonus_dmg_max.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "", 50, true))
		
		interpreter_for_retract_bonus_dmg_max.array_of_instructions = ins_for_retract_bonus_dmg_max
		
		#
		
		var interpreter_for_attk_speed = TextFragmentInterpreter.new()
		interpreter_for_attk_speed.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_attk_speed.display_body = true
		interpreter_for_attk_speed.header_description = "attack speed"
		
		var ins_for_attk_speed = []
		ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1))
		
		ins_for_attk_speed.append(NumericalTextFragment.new(150, true))
		ins_for_attk_speed.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_attk_speed.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
		
		#
		
		var interpreter_for_range = TextFragmentInterpreter.new()
		interpreter_for_range.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_range.display_body = true
		interpreter_for_range.header_description = "range"
		
		var ins_for_range = []
		ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1))
		
		ins_for_range.append(NumericalTextFragment.new(25, false))
		ins_for_range.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_range.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_range.array_of_instructions = ins_for_range
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Pursuit")
		
		var plain_fragment__end_of_round = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "On round end")
		
		#
		
		info.tower_descriptions = [
			["Gain |0| per win, up to |1|. This is lost upon losing.", [interpreter_for_retract_bonus_dmg_per_stack, interpreter_for_retract_bonus_dmg_max]],
			"On win: heal for 2 times the lose streak. Only loses where this tower is active in the map are counted.",
			"",
			"When this tower's current target exits its range, cast Pursuit.",
			["|0|: Pursuit: L' Assaut attempts to relocate itself within range of the escapee. L' Assaut then gains |1| and |2| for 1.5 seconds.", [plain_fragment__ability, interpreter_for_attk_speed, interpreter_for_range]],
			"L' Assaut's auto attack timer is reset upon fading in from Pursuit.",
			"",
			["|0|: this tower attempts to return to its original location.", [plain_fragment__end_of_round]],
		]
		
		
		info.tower_simple_descriptions = [
			["Gain |0| per win, up to |1|. This is lost upon losing.", [interpreter_for_retract_bonus_dmg_per_stack, interpreter_for_retract_bonus_dmg_max]],
			"On win: heal for 2 times the lose streak.",
			"",
			"When this tower's current target exits its range, cast Pursuit.",
			["|0|: L' Assaut relocates itself within range of the escapee. L' Assaut then gains |1| and |2| for 1.5 seconds.", [plain_fragment__ability_name, interpreter_for_attk_speed, interpreter_for_range]],
		]
		
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_L_ASSAUT)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_L_ASSAUT)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
		
	elif tower_id == LA_CHASSEUR:
		info = TowerTypeInformation.new("La Chasseur", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.base_tower_image = la_chasseur_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 5
		info.base_attk_speed = 0.5
		info.base_pierce = 0
		info.base_range = 135
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_hunt_down = TextFragmentInterpreter.new()
		interpreter_for_hunt_down.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_hunt_down.display_body = true
		
		var outer_ins = []
		var ins = []
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 10, DamageType.PHYSICAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 5.0)) # stat basis does not matter here
		
		outer_ins.append(ins)
		
		outer_ins.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		outer_ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		
		interpreter_for_hunt_down.array_of_instructions = outer_ins
		
		#
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "on hit physical damage", 3))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		
		var plain_fragment__gold = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.GOLD, "3 gold")
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Pursuit")
		
		#
		
		info.tower_descriptions = [
			"Hunt Down is automatically casted twice; once when half of all enemies have been spawned, and once when all enemies have been spawned.",
			["|0|: Hunt Down: Rapidly fire 4 shots at its current target, each dealing |1|. Shots apply on hit effects.", [plain_fragment__ability, interpreter_for_hunt_down]],
			["If the last shot kills an enemy, La Chasseur permanently gains stacking |0|. Also, gain |1|.", [interpreter_for_flat_on_hit, plain_fragment__gold]],
		]
		
		info.tower_simple_descriptions = [
			"Hunt Down is automatically casted twice per round.",
			["|0|: Rapidly fire 4 shots at its current target, each dealing |1|.", [plain_fragment__ability_name, interpreter_for_hunt_down]],
			["If the last shot kills an enemy, La Chasseur permanently gains stacking |0|. Also, gain |1|.", [interpreter_for_flat_on_hit, plain_fragment__gold]],
		]
		
		#
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_LA_CHASSEUR)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_LA_CHASSEUR, attr_mod, DamageType.PHYSICAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_LA_CHASSEUR)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == LA_NATURE:
		info = TowerTypeInformation.new("La Nature", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GREEN)
		info.base_tower_image = la_nature_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "abilities")
		
		info.tower_descriptions = [
			"Does not attack.",
			["On behalf of nature, La Nature grants access to two |0|: Solar Spirit and Torrential Tempest.", [plain_fragment__ability]],
			"",
			"La nature's stats do not affect these abilties.",
		]
		
		
	elif tower_id == HEALING_SYMBOL:
		info = TowerTypeInformation.new("Healing Symbol", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.base_tower_image = healing_symbol_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 135
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 0
		
		
		var plain_fragment__on_round_end = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "On round end")
		
		
		info.tower_descriptions = [
			"Does not attack.",
			"Every 5 seconds, Healing Symbol heals every tower in range by 10%, increased to 20% for the tower that has dealt the most damage (in range).",
			"Does not heal itself and other Healing Symbols.",
			["|0|: If Healing Symbol is alive and has not healed a damaged tower, heal the player by 2.", [plain_fragment__on_round_end]]
		]
		
		info.tower_simple_descriptions = [
			"Does not attack.",
			"Every 5 seconds, Healing Symbol heals every tower in range by 10%, increased to 20% for the tower that has dealt the most damage (in range).",
			["|0|: If Healing Symbol is alive and has not healed a damaged tower, heal the player by 2.", [plain_fragment__on_round_end]]
		]
		
		
	elif tower_id == NIGHTWATCHER:
		info = TowerTypeInformation.new("Night Watcher", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.base_tower_image = nightwatcher_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 30
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", 4))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		
		var plain_fragment__stunned = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunned")
		
		
		info.tower_descriptions = [
			"Summons a lamp that monitors the area of the path nearest to Night Watcher.",
			["Enemies that enter the area are |0| for 2 seconds. Night Watcher then creates an explosion at the enemy's position, dealing |1| to 3 enemies.", [plain_fragment__stunned, interpreter_for_flat_on_hit]]
		]
		
		info.tower_simple_descriptions = [
			"Summons a lamp that monitors the area of the path nearest to Night Watcher.",
			["Enemies that enter the area are |0| for 2 seconds. Night Watcher then creates an explosion at the enemy's position, dealing |1| to 3 enemies.", [plain_fragment__stunned, interpreter_for_flat_on_hit]]
		]
		
		
	elif tower_id == ASHEND:
		info = TowerTypeInformation.new("Ashen'd", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.GRAY)
		info.base_tower_image = ashend_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2
		info.base_attk_speed = 0.9
		info.base_pierce = 1
		info.base_range = 135
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "elemental damage", 1))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		#
		
		var interpreter_for_ratio_dmg = TextFragmentInterpreter.new()
		interpreter_for_ratio_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_ratio_dmg.display_body = true
		interpreter_for_ratio_dmg.header_description = "of the attack's damage"
		
		var ins_for_ratio_dmg = []
		ins_for_ratio_dmg.append(NumericalTextFragment.new(25, true))
		ins_for_ratio_dmg.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_ratio_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_ratio_dmg.array_of_instructions = ins_for_ratio_dmg
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Efflux")
		
		#
		
		info.tower_descriptions = [
			["Attacks apply Smolder to enemies hit, burning them for |0| every second for 10 seconds.", [interpreter_for_flat_on_hit]],
			"",
			"Cast Efflux after 16 main attacks.",
			["|0|: Efflux. Ashen'd fires a firery wave to the largest line of enemies, applying on hit effects (and Smolder). The firery wave's life distance is equal to trice this tower's range.", [plain_fragment__ability]],
			["Towers that are hit by Efflux become empowered for 15 seconds; their main attacks that hit Smoldered enemies explode, dealing |0| as an explosion hitting up to 3 enemies.", [interpreter_for_ratio_dmg]]
		]
		
		info.tower_simple_descriptions = [
			["Attacks apply Smolder to enemies hit, burning them for |0| every second for 10 seconds.", [interpreter_for_flat_on_hit]],
			"",
			"Cast Efflux after 16 main attacks.",
			["|0|: Ashen'd fires a firery wave to the largest line of enemies, applying on hit effects (and Smolder).", [plain_fragment__ability_name]],
			["Towers that are hit by Efflux become empowered for 15 seconds; their main attacks that hit Smoldered enemies explode, dealing |0| as an explosion hitting up to 3 enemies.", [interpreter_for_ratio_dmg]]
		]
		
		
		
	elif tower_id == PROPEL:
		info = TowerTypeInformation.new("Propel", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.base_tower_image = propel_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.5#2.75
		info.base_attk_speed = 0.45
		info.base_pierce = 1
		info.base_range = 155#145
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(16, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "physical damage", 2))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		
		
		var interpreter_for_flat_on_hit_for_ability = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit_for_ability.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit_for_ability.display_body = false
		
		var ins_for_flat_on_hit_for_ability = []
		ins_for_flat_on_hit_for_ability.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "physical damage", 5))
		
		interpreter_for_flat_on_hit_for_ability.array_of_instructions = ins_for_flat_on_hit_for_ability
		
		
		var interpreter_for_stun_duration = TextFragmentInterpreter.new()
		interpreter_for_stun_duration.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_stun_duration.display_body = true
		interpreter_for_stun_duration.header_description = "s"
		
		var ins_for_stun_duration = []
		ins_for_stun_duration.append(NumericalTextFragment.new(2.5, false))
		ins_for_stun_duration.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_stun_duration.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_stun_duration.array_of_instructions = ins_for_stun_duration
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Plow")
		
		var plain_fragment__stunned = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stunned")
		var plain_fragment__on_round_end = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "On round end")
		
		
		info.tower_descriptions = [
			["Main attacks's bullets explode upon losing all pierce, dealing |0| to 3 enemies.", [interpreter_for_flat_on_hit]],
			"",
			"Auto casts Plow:",
			["|0|: Plow: Propel charges towards the (in range) tower slot with the most enemies between itself and its destination. Enemies hit are dealt |1| and are |2| for |3|.", [plain_fragment__ability, interpreter_for_flat_on_hit_for_ability, plain_fragment__stunned, interpreter_for_stun_duration]],
			["Cooldown: |0|.", [interpreter_for_cooldown]],
			["|0|: Propel will return to its orignal tower slot.", [plain_fragment__on_round_end]]
		]
		
		
		info.tower_simple_descriptions = [
			["Main attacks's bullets explode upon losing all pierce, dealing |0| to 3 enemies.", [interpreter_for_flat_on_hit]],
			"",
			"Auto casts Plow:",
			["|0|: Propel charges towards the (in range) tower slot with the most enemies in the way. Enemies hit are dealt |1| and are |2| for |3|.", [plain_fragment__ability_name, interpreter_for_flat_on_hit_for_ability, plain_fragment__stunned, interpreter_for_stun_duration]],
			["Cooldown: |0|.", [interpreter_for_cooldown]]
		]
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_PROPEL)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_PROPEL, attr_mod, DamageType.PHYSICAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_PROPEL)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
		
	elif tower_id == PAROXYSM:
		info = TowerTypeInformation.new("Paroxysm", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.ORANGE)
		info.base_tower_image = paroxysm_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 4
		info.base_attk_speed = 0.6
		info.base_pierce = 1
		info.base_range = 140
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_direct_rocket_dmg = TextFragmentInterpreter.new()
		interpreter_for_direct_rocket_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_direct_rocket_dmg.display_body = true
		
		var outer_ins_for_direct_rocket_dmg = []
		var ins_for_direct_rocket_dmg = []
		ins_for_direct_rocket_dmg.append(NumericalTextFragment.new(70, false, DamageType.PHYSICAL))
		ins_for_direct_rocket_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_direct_rocket_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 15, DamageType.PHYSICAL))
		
		outer_ins_for_direct_rocket_dmg.append(ins_for_direct_rocket_dmg)
		
		outer_ins_for_direct_rocket_dmg.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		outer_ins_for_direct_rocket_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_direct_rocket_dmg.array_of_instructions = outer_ins_for_direct_rocket_dmg
		#
		
		var interpreter_for_rocket_dmg_splash = TextFragmentInterpreter.new()
		interpreter_for_rocket_dmg_splash.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_rocket_dmg_splash.display_body = false
		
		var ins_for_rocket_dmg_splash = []
		ins_for_rocket_dmg_splash.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "damage", 15))
		
		interpreter_for_rocket_dmg_splash.array_of_instructions = ins_for_rocket_dmg_splash
		#
		
		var interpreter_for_spew_count = TextFragmentInterpreter.new()
		interpreter_for_spew_count.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_spew_count.display_body = true
		interpreter_for_spew_count.header_description = "hot fragments"
		interpreter_for_spew_count.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.CEIL
		
		var ins_for_spew_count = []
		ins_for_spew_count.append(NumericalTextFragment.new(16, false, -1))
		ins_for_spew_count.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_spew_count.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_spew_count.array_of_instructions = ins_for_spew_count
		
		#
		
		var interpreter_for_spew_dmg = TextFragmentInterpreter.new()
		interpreter_for_spew_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_spew_dmg.display_body = true
		
		var ins_for_spew_dmg = []
		ins_for_spew_dmg.append(NumericalTextFragment.new(3, false, DamageType.ELEMENTAL))
		ins_for_spew_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_spew_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.75)) # stat basis does not matter here
		
		interpreter_for_spew_dmg.array_of_instructions = ins_for_spew_dmg
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(18, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Outburst")
		
		#
		
		info.tower_descriptions = [
			"Auto casts Outburst.",
			["|0|: Outburst: Paroxyxm chooses an attack based on its target.", [plain_fragment__ability]],
			["If target has 50+ current health and is 60 range away from itself, fire a homing rocket that deals |0| to its intended target, and explodes to deal |1| to 3 enemies.", [interpreter_for_direct_rocket_dmg, interpreter_for_rocket_dmg_splash]],
			["Otherwise, spew out |0|, with each dealing |1| damage.", [interpreter_for_spew_count, interpreter_for_spew_dmg]],
			["Cooldown: |0|.", [interpreter_for_cooldown]]
		]
		
		info.tower_simple_descriptions = [
			"Auto casts Outburst.",
			["|0|: Paroxyxm chooses an attack based on its target.", [plain_fragment__ability_name]],
			["If target has 50+ current health and is 60 range away from itself, fire a homing rocket that deals |0| to its target.", [interpreter_for_direct_rocket_dmg]],
			["Otherwise, spew out |0|, with each dealing |1| damage.", [interpreter_for_spew_count, interpreter_for_spew_dmg]],
			["Cooldown: |0|.", [interpreter_for_cooldown]]
		]
		
		
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_PAROXYSM)
		base_ap_attr_mod.flat_modifier = tier_ap_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.ING_PAROXYSM)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ ap"
		
		
		
	elif tower_id == IOTA:
		info = TowerTypeInformation.new("Iota", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.YELLOW)
		info.base_tower_image = iota_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.4
		info.base_attk_speed = 0.888
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_crash_dmg = TextFragmentInterpreter.new()
		interpreter_for_crash_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_crash_dmg.display_body = true
		
		var ins_for_crash_dmg = []
		ins_for_crash_dmg.append(NumericalTextFragment.new(5.0, false, DamageType.PHYSICAL))
		ins_for_crash_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_crash_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 7.5)) # stat basis does not matter here
		
		interpreter_for_crash_dmg.array_of_instructions = ins_for_crash_dmg
		
		
		var interpreter_for_beam_dmg = TextFragmentInterpreter.new()
		interpreter_for_beam_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_beam_dmg.display_body = true
		
		var ins_for_beam_dmg = []
		ins_for_beam_dmg.append(NumericalTextFragment.new(0.5, false, DamageType.ELEMENTAL))
		ins_for_beam_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_beam_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.5, DamageType.ELEMENTAL))
		
		interpreter_for_beam_dmg.array_of_instructions = ins_for_beam_dmg
		
		
		var interpreter_for_pierce = TextFragmentInterpreter.new()
		interpreter_for_pierce.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_pierce.display_body = true
		interpreter_for_pierce.header_description = "enemies"
		
		var ins_for_pierce = []
		ins_for_pierce.append(NumericalTextFragment.new(1, false, -1, "", false, TowerStatTextFragment.STAT_TYPE.PIERCE))
		ins_for_pierce.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_pierce.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PIERCE, TowerStatTextFragment.STAT_BASIS.BONUS, 1.0, -1))
		
		interpreter_for_pierce.array_of_instructions = ins_for_pierce
		
		
		#
		
		info.tower_descriptions = [
			["Every 7th main attack leaves a Star near the target's location for 30 seconds. When Stars expire, they crash to the nearest enemy, dealing |0|.", [interpreter_for_crash_dmg]],
			"",
			["When all enemies have spawned, all idle Stars focus a beam at a target, dealing |0| per 0.25 seconds.", [interpreter_for_beam_dmg]],
			"All Stars crash to the last enemy standing once it has 100 health or less.",
			"",
			["Crashing Stars can hit up to |0|.", [interpreter_for_pierce]],
			"Targeting affects which enemies are targeted by the Stars.",
		]
		
		info.tower_simple_descriptions = [
			["Every 7th main attack leaves a Star near the target's location for 30 seconds. When Stars expire, they crash to the nearest enemy, dealing |0|.", [interpreter_for_crash_dmg]],
			"",
			["When all enemies have spawned, all idle Stars focus a beam at a target, dealing |0| per 0.25 seconds.", [interpreter_for_beam_dmg]],
			"All Stars crash to the last enemy standing once it has 100 health or less.",
		]
		
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_IOTA)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_IOTA)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
	elif tower_id == VACUUM:
		info = TowerTypeInformation.new("Vacuum", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.BLUE)
		info.base_tower_image = vacuum_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2
		info.base_attk_speed = 0.7
		info.base_pierce = 1
		info.base_range = 105
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_suck_duration = TextFragmentInterpreter.new()
		interpreter_for_suck_duration.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_suck_duration.display_body = true
		interpreter_for_suck_duration.header_description = "seconds"
		interpreter_for_suck_duration.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.ROUND
		
		var ins_for_suck_duration = []
		ins_for_suck_duration.append(NumericalTextFragment.new(3, false, -1))
		ins_for_suck_duration.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_suck_duration.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_suck_duration.array_of_instructions = ins_for_suck_duration
		
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(18, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Suck")
		
		var plain_fragment__slow = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "slowed")
		var plain_fragment__stun = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stuns")
		
		#
		
		info.tower_descriptions = [
			"Auto casts \"Suck\" when enemies are in range.",
			["|0|: Suck: Enemies in range that are moving away from Vacuum are |1| by 70%.", [plain_fragment__ability, plain_fragment__slow]],
			["After |0| release a shockwave that |1| enemies in range for 1.5 seconds.", [interpreter_for_suck_duration, plain_fragment__stun]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		
		info.tower_simple_descriptions = [
			"Auto casts \"Suck\".",
			["|0|: Enemies in range that are moving away from Vacuum are |1| by 70%.", [plain_fragment__ability_name, plain_fragment__slow]],
			["After |0| release a shockwave that |1| enemies in range for 1.5 seconds.", [interpreter_for_suck_duration, plain_fragment__stun]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		
		
		# Ingredient related
		var range_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_VACUUM)
		range_attr_mod.flat_modifier = tier_flat_range_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.ING_VACUUM)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ range"
		
		
		
	elif tower_id == VARIANCE:
		info = TowerTypeInformation.new("Variance", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.base_tower_image = variance_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image, Vector2(0, 12))
		
		info.base_damage = 3
		info.base_attk_speed = 0.95
		info.base_pierce = 1
		info.base_range = 120#110
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		var plain_fragment__round_end = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_END, "On round end")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Specialize")
		
		
		info.tower_descriptions = [
			["|0|: Variance morphs, changing type and its ingredient effect. Activates even if not placed in the map. Always starts as Clear type, but cannot revert to it.", [plain_fragment__round_end]],
			"",
			"Auto casts Specialize.",
			["|0|: Effect differs based on Variance's type.", [plain_fragment__ability_name]],
		]
		
		var tower_effect = TowerResetEffects.new(StoreOfTowerEffectsUUID.ING_VARIANCE_ING_RESET)
		var ing_effect = IngredientEffect.new(tower_id, tower_effect)
		ing_effect.ignore_ingredient_limit = true
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "clear"
		
		
		
	elif tower_id == VARIANCE_VESSEL:
		info = TowerTypeInformation.new("Var-Vessel", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.base_tower_image = variance_vessel_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		
	elif tower_id == YELVIO_RIFT_AXIS:
		info = TowerTypeInformation.new("Rift Axis", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		#info.colors.append(TowerColors.VIOLET)
		info.base_tower_image = yelvio_riftaxis_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		info.tower_descriptions = [
			"The center of the rift. Move Rift Axis to control the division between the Yellow and Violet rifts."
		]
		
		
	elif tower_id == TRUDGE:
		info = TowerTypeInformation.new("Trudge", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.base_tower_image = trudge_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.75
		info.base_attk_speed = 0.5
		info.base_pierce = 0
		info.base_range = 125
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		
		var interpreter = TextFragmentInterpreter.new()
		interpreter.tower_info_to_use_for_tower_stat_fragments = info
		interpreter.display_body = true
		interpreter.header_description = "damage"
		
		var ins = []
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1, DamageType.PHYSICAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter.array_of_instructions = ins
		
		
		var interpreter_for_spurt_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_spurt_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_spurt_flat_on_hit.display_body = false
		
		var ins_for_spurt_flat_on_hit = []
		ins_for_spurt_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "physical damage", 2))
		
		interpreter_for_spurt_flat_on_hit.array_of_instructions = ins_for_spurt_flat_on_hit
		
		
		var interpreter_for_slam_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_slam_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_slam_flat_on_hit.display_body = false
		
		var ins_for_slam_flat_on_hit = []
		ins_for_slam_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PHYSICAL, "physical damage", 4))
		
		interpreter_for_slam_flat_on_hit.array_of_instructions = ins_for_slam_flat_on_hit
		
		
		var interpreter_for_first_slam_slow = TextFragmentInterpreter.new()
		interpreter_for_first_slam_slow.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_first_slam_slow.display_body = true
		
		var ins_for_first_slam_slow = []
		
		ins_for_first_slam_slow.append(NumericalTextFragment.new(25, true))
		ins_for_first_slam_slow.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_first_slam_slow.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_first_slam_slow.array_of_instructions = ins_for_first_slam_slow
		
		
		var interpreter_for_final_slam_ku_duration = TextFragmentInterpreter.new()
		interpreter_for_final_slam_ku_duration.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_final_slam_ku_duration.display_body = true
		interpreter_for_final_slam_ku_duration.header_description = "seconds"
		
		var ins_for_final_slam_ku_duration = []
		ins_for_final_slam_ku_duration.append(NumericalTextFragment.new(2, false))
		ins_for_final_slam_ku_duration.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_final_slam_ku_duration.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_final_slam_ku_duration.array_of_instructions = ins_for_final_slam_ku_duration
		
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(40, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		var plain_fragment__knock_up = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.KNOCK_UP, "knocks enemies up")
		var plain_fragment__slowing = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "slowing")
		var plain_fragment__slow = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "slow")
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Stampede")
		
		
		info.tower_descriptions = [
			["Trudge's mortar attacks explode, dealing |0| to 3 enemies.", [interpreter]],
			"",
			"Attacks against stunned or slowed targets trigger Spurt.",
			["Spurt: Release an explosion, dealing |0| to 3 enemies and |1| them by |2| for 6 seconds. Additionally, Stampede's cooldown is reduced by 1 second.", [interpreter_for_spurt_flat_on_hit, plain_fragment__slowing, interpreter_for_first_slam_slow]],
			"",
			"Auto casts Stampede when at least 1 enemy is in range.",
			["|0|: Stampede: Trudge slams the ground 3 times, each dealing |1|. Each slam affects up to 15 enemies.", [plain_fragment__ability, interpreter_for_slam_flat_on_hit]],
			["The first slam applies Spurt's |0|. The second slam |1| for 0.5 seconds. The final slam |1| for |2|. Only the final slam can trigger Spurt.", [plain_fragment__slow, plain_fragment__knock_up, interpreter_for_final_slam_ku_duration]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		
		info.tower_simple_descriptions = [
			"Attacks against stunned or slowed targets trigger Spurt.",
			["Spurt: Release an explosion, dealing |0| to 3 enemies and |1| them by |2| for 6 seconds.", [interpreter_for_spurt_flat_on_hit, plain_fragment__slowing, interpreter_for_first_slam_slow]],
			"",
			"Auto casts Stampede.",
			["|0|: Trudge slams the ground 3 times, each dealing |1|. Each slam affects up to 15 enemies.", [plain_fragment__ability_name, interpreter_for_slam_flat_on_hit]],
			["The final slam |0| for |1|.", [plain_fragment__knock_up, interpreter_for_final_slam_ku_duration]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		
		
		var effect_vul_modi : PercentModifier = PercentModifier.new(StoreOfEnemyEffectsUUID.ING_TRUDGE)
		effect_vul_modi.percent_amount = -20
		effect_vul_modi.percent_based_on = PercentType.BASE
		var hextribute_effect_vul_effect = EnemyAttributesEffect.new(EnemyAttributesEffect.PERCENT_BASE_MOV_SPEED, effect_vul_modi, StoreOfEnemyEffectsUUID.ING_TRUDGE)
		hextribute_effect_vul_effect.is_timebound = true
		hextribute_effect_vul_effect.time_in_seconds = 6
		
		var on_hit_effect : TowerOnHitEffectAdderEffect = TowerOnHitEffectAdderEffect.new(hextribute_effect_vul_effect, StoreOfTowerEffectsUUID.ING_TRUDGE)
		
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, on_hit_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "- mov speed"
		
		
		
	elif tower_id == SOPHIST:
		info = TowerTypeInformation.new("Sophist", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.base_tower_image = sophist_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.85 #0.72
		info.base_pierce = 0
		info.base_range = 125
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		var interpreter_for_base_amount = TextFragmentInterpreter.new()
		interpreter_for_base_amount.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_base_amount.display_body = false
		
		var ins_for_base_amount = []
		ins_for_base_amount.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 10, true))
		
		interpreter_for_base_amount.array_of_instructions = ins_for_base_amount
		
		
		var interpreter_for_extra_amount = TextFragmentInterpreter.new()
		interpreter_for_extra_amount.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_extra_amount.display_body = false
		
		var ins_for_extra_amount = []
		ins_for_extra_amount.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 10, true))
		
		interpreter_for_extra_amount.array_of_instructions = ins_for_extra_amount
		
		
		var interpreter_for_max_amount = TextFragmentInterpreter.new()
		interpreter_for_max_amount.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_max_amount.display_body = false
		
		var ins_for_max_amount = []
		ins_for_max_amount.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 60, true))
		
		interpreter_for_max_amount.array_of_instructions = ins_for_max_amount
		
		
		var interpreter_for_range = TextFragmentInterpreter.new()
		interpreter_for_range.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_range.display_body = false
		
		var ins_for_range = []
		ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", 120, false))
		
		interpreter_for_range.array_of_instructions = ins_for_range
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Enchant")
		
		
		info.tower_descriptions = [
			"Casts Enchant every 10th main attack.",
			["|0|: Enchant: Sophist fires a crystal that lands behind its current target. After a brief delay, all crystals emit an aura, giving all towers in its range an attack speed buff for 8 seconds.", [plain_fragment__ability]],
			["Crystals give |0|, which increases by |1| per additional crystal in the map, up to |2|. Crystals have |3|.", [interpreter_for_base_amount, interpreter_for_extra_amount, interpreter_for_max_amount, interpreter_for_range]],
			"Crystals cannot affect Sophist towers.",
		]
		
		# needed even if the same as above.
		info.tower_simple_descriptions = [
			"Casts Enchant every 10th main attack.",
			["|0|: Fires a crystal that lands behind its target. After a brief delay, all crystals emit an aura, giving all towers in its range an attack speed buff for 8 seconds based on the number of crystals.", [plain_fragment__ability_name]],
			#["Crystals give |0|, which increases by |1| per additional crystal in the map, up to |2|. Crystals have |3|.", [interpreter_for_base_amount, interpreter_for_extra_amount, interpreter_for_max_amount, interpreter_for_range]],
			"Crystals cannot affect Sophist towers.",
		]
		
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_SOPHIST)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_SOPHIST)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
	elif tower_id == WYVERN:
		info = TowerTypeInformation.new("Wyvern", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.base_tower_image = wyvern_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 7
		info.base_attk_speed = 0.4
		info.base_pierce = 1
		info.base_range = 185
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		
		var interpreter_for_attk_speed = TextFragmentInterpreter.new()
		interpreter_for_attk_speed.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_attk_speed.display_body = true
		interpreter_for_attk_speed.header_description = "attack speed"
		
		var ins_for_attk_speed = []
		ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1))
		
		ins_for_attk_speed.append(NumericalTextFragment.new(100, true))
		ins_for_attk_speed.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_attk_speed.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
		
		
		var interpreter_for_bonus_dmg = TextFragmentInterpreter.new()
		interpreter_for_bonus_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_bonus_dmg.display_body = true
		interpreter_for_bonus_dmg.header_description = "damage"
		
		var ins_for_bonus_dmg = []
		ins_for_bonus_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 3.5, DamageType.PHYSICAL))
		ins_for_bonus_dmg.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins_for_bonus_dmg.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 4.5)) # stat basis does not matter here
		
		interpreter_for_bonus_dmg.array_of_instructions = ins_for_bonus_dmg
		
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(18, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Fury")
		
		info.tower_descriptions = [
			"Auto casts Fury when at least 1 enemy is in range.",
			["|0|: Fury: Wyvern locks onto the healthiest target in range, continuously firing at that target with modified bullets until the target dies or becomes untargetable.", [plain_fragment__ability]],
			["Each bullet deals |0|, and benefits from bonus pierce. However, the damage is only 75% effective against boss enemies.", [interpreter_for_bonus_dmg]],
			["Wyvern additionally gains |0| during Fury.", [interpreter_for_attk_speed]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		
		info.tower_simple_descriptions = [
			"Auto casts Fury.",
			["|0|: Wyvern locks onto the healthiest target in range, continuously firing at that target with modified bullets until the target dies.", [plain_fragment__ability_name]],
			["Each bullet deals |0|. However, the damage is only 75% effective against boss enemies.", [interpreter_for_bonus_dmg]],
			#["Wyvern additionally gains |0| during Fury.", [interpreter_for_attk_speed]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_WYVERN)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_WYVERN, attr_mod, DamageType.PHYSICAL)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_WYVERN)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == FULGURANT:
		info = TowerTypeInformation.new("Fulgurant", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.base_tower_image = fulgurant_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.925 #0.95
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		var interpreter_for_smite_dmg = TextFragmentInterpreter.new()
		interpreter_for_smite_dmg.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_smite_dmg.display_body = true
		
		var outer_ins = []
		var ins = []
		ins.append(NumericalTextFragment.new(6, false, DamageType.ELEMENTAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 2, DamageType.ELEMENTAL))
		outer_ins.append(ins)
		
		outer_ins.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		outer_ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_smite_dmg.array_of_instructions = outer_ins
		
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(10, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Smite")
		
		var plain_fragment__stuns = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stuns")
		
		info.tower_descriptions = [
			"Auto casts Smite when at least 1 enemy is in the map. If none are found, this ability goes on a 2 second cooldown.",
			["|0|: Smite: Fulgurant smites a random enemy outside of its range, dealing |1| as an explosion hitting up to 3 enemies. The explosion |2| for 1 second.", [plain_fragment__ability, interpreter_for_smite_dmg, plain_fragment__stuns]],
			"Every 3rd cast of Smite targets three enemies instead of one.",
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		
		info.tower_simple_descriptions = [
			"Auto casts Smite.",
			["|0|: Fulgurant smites a random enemy outside of its range, dealing |1| as an explosion hitting up to 3 enemies. The explosion |2| for 1 second.", [plain_fragment__ability_name, interpreter_for_smite_dmg, plain_fragment__stuns]],
			"Every 3rd cast of Smite targets three enemies instead of one.",
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		
		var effect = FulSmiteAttackModuleAdderEffect.new()
		var ing_effect := IngredientEffect.new(tower_id, effect)
		
		info.ingredient_effect = ing_effect
		
		
	elif tower_id == ENERVATE:
		info = TowerTypeInformation.new("Enervate", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.base_tower_image = enervate_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 2.25
		info.base_attk_speed = 0.75
		info.base_pierce = 1
		info.base_range = 115
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		var interpreter_for_armor_tou_shred = TextFragmentInterpreter.new()
		interpreter_for_armor_tou_shred.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_armor_tou_shred.display_body = true
		interpreter_for_armor_tou_shred.header_description = "armor and toughness"
		
		var ins_for_armor_tou_shred = []
		ins_for_armor_tou_shred.append(NumericalTextFragment.new(25, true))
		ins_for_armor_tou_shred.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_armor_tou_shred.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_armor_tou_shred.array_of_instructions = ins_for_armor_tou_shred
		
		#
		
		var interpreter_for_stun_duration = TextFragmentInterpreter.new()
		interpreter_for_stun_duration.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_stun_duration.display_body = true
		interpreter_for_stun_duration.header_description = "s"
		
		var ins_for_stun_duration = []
		ins_for_stun_duration.append(NumericalTextFragment.new(1, false))
		ins_for_stun_duration.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_stun_duration.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_stun_duration.array_of_instructions = ins_for_stun_duration
		
		#
		
		var interpreter_for_slow_amount = TextFragmentInterpreter.new()
		interpreter_for_slow_amount.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_slow_amount.display_body = true
		
		var ins_for_slow_amount = []
		ins_for_slow_amount.append(NumericalTextFragment.new(20, true))
		ins_for_slow_amount.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_slow_amount.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_slow_amount.array_of_instructions = ins_for_slow_amount
		
		#
		
		var interpreter_for_perc_on_hit = TextFragmentInterpreter.new()
		interpreter_for_perc_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_perc_on_hit.display_body = true
		interpreter_for_perc_on_hit.header_description = "of the target's max health as damage"
		
		var ins_for_perc_on_hit = []
		ins_for_perc_on_hit.append(NumericalTextFragment.new(20, true, DamageType.ELEMENTAL))
		ins_for_perc_on_hit.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_perc_on_hit.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1, true))
		
		interpreter_for_perc_on_hit.array_of_instructions = ins_for_perc_on_hit
		
		#
		
		var interpreter_for_decay_amount = TextFragmentInterpreter.new()
		interpreter_for_decay_amount.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_decay_amount.display_body = true
		interpreter_for_decay_amount.header_description = "less healing and shielding"
		
		var ins_for_decay_amount = []
		ins_for_decay_amount.append(NumericalTextFragment.new(40, true))
		ins_for_decay_amount.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_decay_amount.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_decay_amount.array_of_instructions = ins_for_decay_amount
		
		#
		
		var interpreter_for_ap = TextFragmentInterpreter.new()
		interpreter_for_ap.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_ap.display_body = false
		
		var ins_for_ap = []
		ins_for_ap.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, -1, "ability potency", 0.25, false))
		
		interpreter_for_ap.array_of_instructions = ins_for_ap
		
		#
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "damage", 0.4))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		#
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(12, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Chant")
		
		var plain_fragment__stun = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stun")
		var plain_fragment__slow = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "Slow")
		
		#
		
		info.tower_simple_descriptions = [
			"Auto casts Chant.",
			["|0|: Create an orb that curses an enemy. Duplicate orbs are avoided.", [plain_fragment__ability_name]],
			"Each orb has its own unique effect.",
			["Orbs deal |0| per 0.5 seconds.", [interpreter_for_flat_on_hit]],
			["Cooldown : |0|", [interpreter_for_cooldown]]
		]
		
		info.tower_descriptions = [
			"Auto casts Chant when at least 1 enemy is in range.",
			["|0|: Chant: Create an orb that curses an enemy based on Enervate's targeting. Duplicate orbs are avoided.", [plain_fragment__ability]],
			["Orbs deal |0| per 0.5 seconds.", [interpreter_for_flat_on_hit]],
			["Cooldown : |0|", [interpreter_for_cooldown]],
			"",
			["Shrivel Orb: Remove |0| from the target.", [interpreter_for_armor_tou_shred]],
			["Stun Orb: Every 6 seconds, |0| the target for |1|.", [plain_fragment__stun, interpreter_for_stun_duration]],
			["Slow Orb: |0| the target by |1|.", [plain_fragment__slow, interpreter_for_slow_amount]],
			["Death Orb: On the target's death, create an explosion at the target's location, dealing |0|.", [interpreter_for_perc_on_hit]],
			["Decay Orb: The target receives |0|.", [interpreter_for_decay_amount]],
			"",
			["If Chant is casted when all orbs are activated, Enervate instead gains |0|.", [interpreter_for_ap]]
		]
		
		var base_ap_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_ENERVATE)
		base_ap_attr_mod.flat_modifier = tier_ap_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_ABILITY_POTENCY , base_ap_attr_mod, StoreOfTowerEffectsUUID.ING_ENERVATE)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ ap"
		
		
	elif tower_id == SOLITAR:
		info = TowerTypeInformation.new("Solitar", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.base_tower_image = solitar_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 1.5
		info.base_attk_speed = 1.1
		info.base_pierce = 1
		info.base_range = 110
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.PURE, "additional damage", 2))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		
		var interpreter_for_pierce = TextFragmentInterpreter.new()
		interpreter_for_pierce.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_pierce.display_body = false
		
		var ins_for_pierce = []
		ins_for_pierce.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.PIERCE, -1, "bonus pierce", 1))
		
		interpreter_for_pierce.array_of_instructions = ins_for_pierce
		
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(8, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var interpreter_for_stun_duration = TextFragmentInterpreter.new()
		interpreter_for_stun_duration.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_stun_duration.display_body = true
		interpreter_for_stun_duration.header_description = "seconds"
		
		var ins_for_stun_duration = []
		ins_for_stun_duration.append(NumericalTextFragment.new(1, false))
		ins_for_stun_duration.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_stun_duration.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_stun_duration.array_of_instructions = ins_for_stun_duration
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Isolation")
		
		var plain_fragment__stun = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stun")
		
		
		info.tower_descriptions = [
			"Auto casts Isolation when at least 1 enemy is in range.",
			["|0|: Isolation: For 8 seconds, main attacks on hit against isolated enemies deal |1|.", [plain_fragment__ability, interpreter_for_flat_on_hit]],
			["Main attacks also gain |0|, and |1| enemies hit (except the first enemy) for |2|.", [interpreter_for_pierce, plain_fragment__stun, interpreter_for_stun_duration]],
			["Cooldown: |0|. Cooldown starts when Isolation ends.", [interpreter_for_cooldown]],
			"",
			"Enemies with no enemies in range within 30 units are considered isolated."
		]
		
		info.tower_simple_descriptions = [
			"Auto casts Isolation.",
			["|0|: For 8 seconds, main attacks on hit against isolated enemies deal |1|.", [plain_fragment__ability_name, interpreter_for_flat_on_hit]],
			["Main attacks also gain |0|, and |1| enemies hit (except the first enemy) for |2|.", [interpreter_for_pierce, plain_fragment__stun, interpreter_for_stun_duration]],
			["Cooldown: |0|", [interpreter_for_cooldown]]
		]
		
		
		var attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_SOLITAR)
		attr_mod.flat_modifier = tier_on_hit_dmg_map[info.tower_tier]
		attr_mod.flat_modifier -= tier_on_hit_dmg_reduc_if_pure
		var on_hit : OnHitDamage = OnHitDamage.new(StoreOfTowerEffectsUUID.ING_SOLITAR, attr_mod, DamageType.PURE)
		
		var attr_effect : TowerOnHitDamageAdderEffect = TowerOnHitDamageAdderEffect.new(on_hit, StoreOfTowerEffectsUUID.ING_SOLITAR)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ on hit"
		
		
	elif tower_id == TRAPPER:
		info = TowerTypeInformation.new("Trapper", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.base_tower_image = trapper_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 1
		info.base_range = 115
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		
		var interpreter = TextFragmentInterpreter.new()
		interpreter.tower_info_to_use_for_tower_stat_fragments = info
		interpreter.display_body = true
		interpreter.header_description = "damage"
		
		var ins = []
		ins.append(NumericalTextFragment.new(1, false, DamageType.PHYSICAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 2, DamageType.PHYSICAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1)) # stat basis does not matter here
		
		interpreter.array_of_instructions = ins
		
		
		var plain_fragment__on_round_start = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_START, "On round start")
		var plain_fragment__execute = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.EXECUTE, "execute")
		
		info.tower_descriptions = [
			"Does not attack.",
			"",
			["|0|: Trapper lays down 3 traps on the track in its range. Enemies take |1| upon stepping on the trap. Traps are considered to be Trapper's main attack.", [plain_fragment__on_round_start, interpreter]],
			["Traps |0| the last non-boss enemy.", [plain_fragment__execute]]
		]
		
		info.tower_simple_descriptions = [
			"Does not attack.",
			"",
			["|0|: Trapper lays down 3 traps on the track. Enemies take |1| upon stepping on the trap.", [plain_fragment__on_round_start, interpreter]],
			["Traps |0| the last non-boss enemy.", [plain_fragment__execute]]
		]
		
		# Ingredient related
		var base_dmg_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_TRAPPER)
		base_dmg_attr_mod.flat_modifier = tier_base_dmg_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_BASE_DAMAGE_BONUS , base_dmg_attr_mod, StoreOfTowerEffectsUUID.ING_TRAPPER)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ base dmg"
		
		
	elif tower_id == OUTREACH:
		info = TowerTypeInformation.new("Outreach", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.base_tower_image = outreach_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image)
		
		info.base_damage = 6
		info.base_attk_speed = 0.7
		info.base_pierce = 1
		info.base_range = 145
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		#
		
		var interpreter_for_range = TextFragmentInterpreter.new()
		interpreter_for_range.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_range.display_body = false
		
		var ins_for_range = []
		ins_for_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1, "range", 150, false))
		
		interpreter_for_range.array_of_instructions = ins_for_range
		
		
		var interpreter_for_base_missle_count = TextFragmentInterpreter.new()
		interpreter_for_base_missle_count.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_base_missle_count.display_body = true
		interpreter_for_base_missle_count.header_description = "missles"
		interpreter_for_base_missle_count.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.CEIL
		
		var ins_for_base_missle_count = []
		ins_for_base_missle_count.append(NumericalTextFragment.new(20, false, -1))
		ins_for_base_missle_count.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_base_missle_count.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_base_missle_count.array_of_instructions = ins_for_base_missle_count
		
		
		var interpreter = TextFragmentInterpreter.new()
		interpreter.tower_info_to_use_for_tower_stat_fragments = info
		interpreter.display_body = true
		
		var ins = []
		ins.append(NumericalTextFragment.new(2, false, DamageType.ELEMENTAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 0.25)) # stat basis does not matter here
		
		interpreter.array_of_instructions = ins
		
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(54, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var interpreter_for_extra_missle_count = TextFragmentInterpreter.new()
		interpreter_for_extra_missle_count.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_extra_missle_count.display_body = true
		interpreter_for_extra_missle_count.header_description = "additional missles"
		interpreter_for_extra_missle_count.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.CEIL
		
		var ins_for_extra_missle_count = []
		ins_for_extra_missle_count.append(NumericalTextFragment.new(10, false, -1))
		ins_for_extra_missle_count.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_extra_missle_count.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_extra_missle_count.array_of_instructions = ins_for_extra_missle_count
		
		
		var interpreter_for_shorter_cooldown = TextFragmentInterpreter.new()
		interpreter_for_shorter_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_shorter_cooldown.display_body = true
		interpreter_for_shorter_cooldown.header_description = "s"
		
		var ins_for_shorter_cooldown = []
		ins_for_shorter_cooldown.append(NumericalTextFragment.new(27, false))
		ins_for_shorter_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_shorter_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_shorter_cooldown.array_of_instructions = ins_for_shorter_cooldown
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Reach")
		
		var plain_fragment__stun = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.STUN, "stun")
		
		#
		
		info.tower_descriptions = [
			"Auto casts Reach.",
			["|0|: Reach: Outreach gains |1|, then shoots |2| at random enemies, prioritising those in range. Missles explode on impact to deal |3| to 3 enemies and |4| for 0.75 seconds.", [plain_fragment__ability, interpreter_for_range, interpreter_for_base_missle_count, interpreter, plain_fragment__stun]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
			"",
			["If no enemies are in range even after gaining range, the next cast of Reach shoots |0|. The cooldown for triggering this is reduced to |1| instead.", [interpreter_for_extra_missle_count, interpreter_for_shorter_cooldown]],
		]
		
		info.tower_simple_descriptions = [
			"Auto casts Reach.",
			["|0|: Outreach gains |1|, then shoots |2| at random enemies, prioritising those in range. Missles explode on impact to deal |3| to 3 enemies and |4| for 0.75 seconds.", [plain_fragment__ability_name, interpreter_for_range, interpreter_for_base_missle_count, interpreter, plain_fragment__stun]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
			"",
			["If no enemies are in range even after gaining range, the next cast of Reach shoots |0|. The cooldown for triggering this is reduced to |1| instead.", [interpreter_for_extra_missle_count, interpreter_for_shorter_cooldown]],
		]
		
		
		var range_attr_mod : FlatModifier = FlatModifier.new(StoreOfTowerEffectsUUID.ING_OUTREACH)
		range_attr_mod.flat_modifier = tier_flat_range_map[info.tower_tier]
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.FLAT_RANGE, range_attr_mod, StoreOfTowerEffectsUUID.ING_OUTREACH)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ range"
		
		
	elif tower_id == BLAST:
		info = TowerTypeInformation.new("Blast", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.RED)
		info.base_tower_image = blast_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image, Vector2(0, 0))
		
		info.base_damage = 3.5
		info.base_attk_speed = 0.55#0.6
		info.base_pierce = 1
		info.base_range = 115
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		var interpreter_for_slow = TextFragmentInterpreter.new()
		interpreter_for_slow.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_slow.display_body = true
		
		var ins_for_slow = []
		
		ins_for_slow.append(NumericalTextFragment.new(60, true))
		ins_for_slow.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_slow.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_slow.array_of_instructions = ins_for_slow
		
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(10, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		var interpreter_for_attk_speed = TextFragmentInterpreter.new()
		interpreter_for_attk_speed.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_attk_speed.display_body = false
		
		var ins_for_attk_speed = []
		ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1, "attack speed", 80, true))
		
		interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Shockwave")
		
		var plain_fragment__knock_back = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.KNOCK_BACK, "knocks back")
		var plain_fragment__slows = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SLOW, "slows")
		
		
		info.tower_descriptions = [
			"Auto casts Shockwave if at least 1 enemy is in range.",
			["|0|: Shockwave: Send a wave that |1| 5 enemies when facing Blast, or |2| them by |3| for 2 seconds when not. Ability potency increases knockback.", [plain_fragment__ability, plain_fragment__knock_back, plain_fragment__slows, interpreter_for_slow]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
			"",
			["Blast gains |0| against stunned or slowed enemies.", [interpreter_for_attk_speed]]
		]
		
		info.tower_simple_descriptions = [
			"Auto casts Shockwave.",
			["|0|: Send a wave that |1| 5 enemies when facing Blast, or |2| them by |3| for 2 seconds when not.", [plain_fragment__ability_name, plain_fragment__knock_back, plain_fragment__slows, interpreter_for_slow]],
			["Cooldown: |0|", [interpreter_for_cooldown]],
			"",
			["Blast gains |0| against stunned or slowed enemies.", [interpreter_for_attk_speed]]
		]
		
		# Ingredient related
		var attk_speed_attr_mod : PercentModifier = PercentModifier.new(StoreOfTowerEffectsUUID.ING_BLAST)
		attk_speed_attr_mod.percent_amount = tier_attk_speed_map[info.tower_tier]
		attk_speed_attr_mod.percent_based_on = PercentType.BASE
		
		var attr_effect : TowerAttributesEffect = TowerAttributesEffect.new(TowerAttributesEffect.PERCENT_BASE_ATTACK_SPEED, attk_speed_attr_mod, StoreOfTowerEffectsUUID.ING_BLAST)
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, attr_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "+ attk spd"
		
		
	elif tower_id == DUNED:
		info = TowerTypeInformation.new("Duned", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.base_tower_image = duned_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image, Vector2(0, 0))
		
		info.base_damage = 0
		info.base_attk_speed = 0.45
		info.base_pierce = 1
		info.base_range = 155
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		
		var plain_fragment__bonus_base_damage = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.BASE_DAMAGE, "bonus base damage")
		
		info.tower_descriptions = [
			["Duned gains |0| based on the current stage.", [plain_fragment__bonus_base_damage]],
			"Duned can shoot over terrain."
		]
		
		
	elif tower_id == MAP_PASSAGE__FIRE_PATH:
		info = TowerTypeInformation.new("MapPassageFirePath", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.base_tower_image = preload("res://MapsRelated/MapList/Map_Passage/Assets/DamageTrackerIcon_PathFire.png")
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image, Vector2(0, 0))
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 10
		info.base_damage_type = DamageType.PURE
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"If you see this, something has gone wrong...",
			"Hello world"
		]
		
		
	elif tower_id == MAP_ENCHANT__ATTACKS:
		info = TowerTypeInformation.new("MapEnchant_Attacks", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.base_tower_image = preload("res://MapsRelated/MapList/Map_Enchant/Assets/Enchant_DamageTracker_Icons/Enchant_DamageTracker_Icon.png")
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image, Vector2(0, 0))
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.PURE
		info.on_hit_multiplier = 1
		
		info.tower_descriptions = [
			"If you see this, something has gone wrong...",
			"Hello world",
			"Definitely Boccher."
		]
		
	elif tower_id == BOUNDED:
		info = TowerTypeInformation.new("Bounded", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.base_tower_image = bounded_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image, Vector2(0, 0))
		
		info.base_damage = 2.72
		info.base_attk_speed = 0.612
		info.base_pierce = 1
		info.base_range = 142
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Unbound")
		
		var plain_fragment__clone = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "clone")
		var plain_fragment__ingredient_effets = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "ingredients")
		
		
		var interpreter_for_clone_create_range = TextFragmentInterpreter.new()
		interpreter_for_clone_create_range.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_clone_create_range.display_body = true
		
		var ins_for_clone_create_range = []
		ins_for_clone_create_range.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.RANGE, -1))
		ins_for_clone_create_range.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.RANGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 1, -1))
		
		interpreter_for_clone_create_range.array_of_instructions = ins_for_clone_create_range
		
		
		var interpreter_for_clone_duration = TextFragmentInterpreter.new()
		interpreter_for_clone_duration.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_clone_duration.display_body = true
		interpreter_for_clone_duration.header_description = "s"
		interpreter_for_clone_duration.estimate_method_for_final_num_val = TextFragmentInterpreter.ESTIMATE_METHOD.ROUND
		
		var ins_for_clone_duration = []
		ins_for_clone_duration.append(NumericalTextFragment.new(12, false, -1))
		ins_for_clone_duration.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_clone_duration.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_clone_duration.array_of_instructions = ins_for_clone_duration
		
		
		var interpreter_for_cooldown = TextFragmentInterpreter.new()
		interpreter_for_cooldown.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_cooldown.display_body = true
		interpreter_for_cooldown.header_description = "s"
		
		var ins_for_cooldown = []
		ins_for_cooldown.append(NumericalTextFragment.new(18, false))
		ins_for_cooldown.append(TextFragmentInterpreter.STAT_OPERATION.PERCENT_SUBTRACT)
		ins_for_cooldown.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.PERCENT_COOLDOWN_REDUCTION, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter_for_cooldown.array_of_instructions = ins_for_cooldown
		
		
		info.tower_descriptions = [
			"Main attacks on hit trigger Unbound.",
			["|0|: Unbound. Creates a |1| of itself on the nearest unoccupied tower placable to the target enemy within |2|.", [plain_fragment__ability, plain_fragment__clone, interpreter_for_clone_create_range]],
			["The clone copies all |0| the creator has on the time of creation. The clone lasts for |1|.", [plain_fragment__ingredient_effets, interpreter_for_clone_duration]],
			"",
			["Cooldown: |0|. Cooldown starts on clone's end.", [interpreter_for_cooldown]],
			"",
			"The clone cannot cast Unbound. The clone acts like a different, separate tower. Benefits from color synergies, but does not contribute to them.",
			"The clone can absorb ingredient effects, and when it expires, the gold will be refunded under standard selling rules."
		]
		
		info.tower_simple_descriptions = [
			"Main attacks on hit trigger Unbound.",
			["|0|: Unbound. Creates a |1| of itself on the nearest tower placable to the target enemy.", [plain_fragment__ability, plain_fragment__clone]],
			["The clone copies all |0| the creator has. The clone lasts for |1|.", [plain_fragment__ingredient_effets, interpreter_for_clone_duration]],
			"",
			["Cooldown: |0|. Cooldown starts on clone's end.", [interpreter_for_cooldown]],
			"",
			"The clone cannot cast Unbound."
		]
		
		
		var tower_base_effect := BoundedSameTowersTowerEffect.new()
		var ing_effect : IngredientEffect = IngredientEffect.new(tower_id, tower_base_effect)
		
		info.ingredient_effect = ing_effect
		info.ingredient_effect_simple_description = "same tower buff"
		
		
	elif tower_id == CELESTIAL:
		info = TowerTypeInformation.new("Celestial", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.base_tower_image = celestial_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image, Vector2(0, 0))
		
		info.base_damage = 0
		info.base_attk_speed = 0.11
		info.base_pierce = 1
		info.base_range = 175
		info.base_damage_type = DamageType.PHYSICAL
		info.on_hit_multiplier = 1
		
		
		var plain_fragment__Ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Asteroid")
		var plain_fragment__ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "ability")
		
		
		var interpreter = TextFragmentInterpreter.new()
		interpreter.tower_info_to_use_for_tower_stat_fragments = info
		interpreter.display_body = true
		
		var ins = []
		ins.append(NumericalTextFragment.new(6.0, false, DamageType.PHYSICAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 3, DamageType.PHYSICAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, TowerStatTextFragment.STAT_BASIS.TOTAL, 3))
		
		interpreter.array_of_instructions = ins
		
		
		
		var interpreter_for_dmg_scale_of_meteor_explosion = TextFragmentInterpreter.new()
		interpreter_for_dmg_scale_of_meteor_explosion.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_dmg_scale_of_meteor_explosion.display_body = false
		
		var ins_for_dmg_scale_of_meteor_explosion = []
		ins_for_dmg_scale_of_meteor_explosion.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "more damage", 100, true))
		
		interpreter_for_dmg_scale_of_meteor_explosion.array_of_instructions = ins_for_dmg_scale_of_meteor_explosion
		
		
		var interpreter_for_dmg_scale_of_large_aoe = TextFragmentInterpreter.new()
		interpreter_for_dmg_scale_of_large_aoe.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_dmg_scale_of_large_aoe.display_body = false
		
		var ins_for_dmg_scale_of_large_aoe = []
		ins_for_dmg_scale_of_large_aoe.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.DAMAGE_SCALE_AMP, -1, "of that damage", 75, true))
		
		interpreter_for_dmg_scale_of_large_aoe.array_of_instructions = ins_for_dmg_scale_of_large_aoe
		
		
		var interpreter_for_large_aoe_radius = TextFragmentInterpreter.new()
		interpreter_for_large_aoe_radius.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_large_aoe_radius.display_body = true
		interpreter_for_large_aoe_radius.header_description = "radius"
		
		var ins_for_large_aoe_radius = []
		ins_for_large_aoe_radius.append(NumericalTextFragment.new(150, false, -1))
		ins_for_large_aoe_radius.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		ins_for_large_aoe_radius.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1.0, -1))
		
		interpreter_for_large_aoe_radius.array_of_instructions = ins_for_large_aoe_radius
		
		
#		var interpreter_for_attk_speed = TextFragmentInterpreter.new()
#		interpreter_for_attk_speed.tower_info_to_use_for_tower_stat_fragments = info
#		interpreter_for_attk_speed.display_body = true
#		interpreter_for_attk_speed.header_description = "attack speed"
#
#		var ins_for_attk_speed = []
#		ins_for_attk_speed.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ATTACK_SPEED, -1))
#
#		ins_for_attk_speed.append(NumericalTextFragment.new(50, true))
#		ins_for_attk_speed.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
#		ins_for_attk_speed.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
#
#		interpreter_for_attk_speed.array_of_instructions = ins_for_attk_speed
		
		
		info.tower_descriptions = [
			["Fires meteoroids which explode to deal |0|.", [interpreter]],
			"Auto casts Asteroid before the fourth meteorioid.",
			["Ability: |0|. The next meteoroid deals |1|, and is accompanied by another larger explosion that deals |2|. The large explosion has |3|.", [plain_fragment__ability_name, interpreter_for_dmg_scale_of_meteor_explosion, interpreter_for_dmg_scale_of_large_aoe, interpreter_for_large_aoe_radius]],
			#"",
			#"Coronal starts off with a Crown.",
			#["When a Crowned tower casts an |0| or completes 20 main attacks, the Crown Glimmers.", [plain_fragment__ability]],
			#["Glimmer: For the next 8 seconds, grant |0| to the crowned tower. Afterwards, it transfers to another tower in range, prioritising those with abilities. The Crown returns to Crowned if no valid target are found.", [interpreter_for_attk_speed]],
			
		]
		
		info.tower_simple_descriptions = [
			["Fires meteoroids which explode to deal |0|.", [interpreter]],
			"Auto casts Asteroid before the fourth meteorioid.",
			["Ability: |0|. The next meteorioid deals |1|, and is accompanied by another larger explosion. The large explosion has |2|", [plain_fragment__ability_name, interpreter_for_dmg_scale_of_meteor_explosion, interpreter_for_large_aoe_radius]],
			#"",
			#"Coronal starts off with a Crown.",
			#["When a Crowned tower casts an |0| or completes 20 main attacks, the Crown Glimmers.", [plain_fragment__ability]],
			#["Glimmer: For the next 8 seconds, grant |0| to the crowned tower. Afterwards, it transfers to another tower.", [interpreter_for_attk_speed]],
			
		]
		
		
	elif tower_id == BIOMORPH:
		info = TowerTypeInformation.new("BioMorph", tower_id)
		info.tower_tier = TowerTiersMap[tower_id]
		info.tower_cost = info.tower_tier
		info.colors.append(TowerColors.VIOLET)
		info.base_tower_image = biomorph_image
		info.tower_atlased_image = _generate_tower_image_icon_atlas_texture(info.base_tower_image, Vector2(0, 0))
		
		info.base_damage = 2.5
		info.base_attk_speed = 0.735
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		info.on_hit_multiplier = 1
		
		var plain_fragment__on_round_start = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ON_ROUND_START, "On round start")
		var plain_fragment__player_health = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.PLAYER_HEALTH, "player health")
		
		
		var interpreter_for_flat_on_hit = TextFragmentInterpreter.new()
		interpreter_for_flat_on_hit.tower_info_to_use_for_tower_stat_fragments = info
		interpreter_for_flat_on_hit.display_body = false
		
		var ins_for_flat_on_hit = []
		ins_for_flat_on_hit.append(OutcomeTextFragment.new(TowerStatTextFragment.STAT_TYPE.ON_HIT_DAMAGE, DamageType.ELEMENTAL, "on hit damage", 2))
		
		interpreter_for_flat_on_hit.array_of_instructions = ins_for_flat_on_hit
		
		
		var plain_fragment__Ability = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Ability")
		var plain_fragment__ability_name = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY, "Drain")
		
		
		var interpreter = TextFragmentInterpreter.new()
		interpreter.tower_info_to_use_for_tower_stat_fragments = info
		interpreter.display_body = true
		
		var outer_ins = []
		var ins = []
		ins.append(NumericalTextFragment.new(0.35, false, DamageType.ELEMENTAL))
		ins.append(TextFragmentInterpreter.STAT_OPERATION.ADDITION)
		ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.BASE_DAMAGE, TowerStatTextFragment.STAT_BASIS.BONUS, 0.25, DamageType.ELEMENTAL))
		
		outer_ins.append(ins)
		
		outer_ins.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
		outer_ins.append(TowerStatTextFragment.new(null, info, TowerStatTextFragment.STAT_TYPE.ABILITY_POTENCY, TowerStatTextFragment.STAT_BASIS.TOTAL, 1))
		
		interpreter.array_of_instructions = outer_ins
		
		
		
		var ability_desc = [
			["|0|. Drain 3 |1| to activate a laser that deals |2| every 0.25 seconds. The laser lasts for 30 seconds.", [plain_fragment__ability_name, plain_fragment__player_health, interpreter]]
		]
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_DESCRIPTION] = ability_desc
		info.metadata_id_to_data_map[TowerTypeInformation.Metadata.ABILITY_SIMPLE_DESCRIPTION] = ability_desc
		
		info.tower_descriptions = [
			["|0|: Reduces 3 |1| if not lethal. In exchange, Biomorph gains |2|.", [plain_fragment__on_round_start, plain_fragment__player_health, interpreter_for_flat_on_hit]],
			"",
			["|0|: Drain. Drain 3 |1| to activate a laser that deals |2| every 0.25 seconds. The laser lasts for 30 seconds.", [plain_fragment__Ability, plain_fragment__player_health, interpreter]]
		]
		
		info.tower_simple_descriptions = [
			["|0|: Reduces 3 |1| if not lethal. In exchange, Biomorph gains |2|.", [plain_fragment__on_round_start, plain_fragment__player_health, interpreter_for_flat_on_hit]],
			"",
			ability_desc[0]
		]
		
		
	
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
	elif tower_id == IEU: #28
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
	elif tower_id == HEALING_SYMBOL:
		return load("res://GameInfoRelated/ColorSynergyRelated/DominantSynergies/DomSyn_Red_Related/DomSyn_Red_PactRelated/PactCustomTowers/HealingSymbols/HealingSymbol.tscn")
	elif tower_id == NIGHTWATCHER:
		return load("res://TowerRelated/Color_Violet/Chaos/AbilityRelated/NightWatcher/NightWatcher.tscn")
	elif tower_id == ASHEND:
		return load("res://TowerRelated/Color_Gray/Ashen'd/Ashend.tscn")
	elif tower_id == PROPEL:
		return load("res://TowerRelated/Color_Orange/Propel/Propel.tscn")
	elif tower_id == PAROXYSM:
		return load("res://TowerRelated/Color_Orange/Paroxysm/Paroxysm.tscn")
	elif tower_id == IOTA: # 73
		return load("res://TowerRelated/Color_Yellow/Iota/Iota.tscn")
	elif tower_id == VACUUM:
		return load("res://TowerRelated/Color_Blue/Vacuum/Vacuum.tscn")
	elif tower_id == VARIANCE:
		return load("res://TowerRelated/Color_Violet/Variance/Variance.tscn")
	elif tower_id == VARIANCE_VESSEL:
		return load("res://TowerRelated/Color_Violet/Variance_Vessel/Variance_Vessel.tscn")
	elif tower_id == YELVIO_RIFT_AXIS:
		return load("res://GameInfoRelated/ColorSynergyRelated/CompliSynergies/CompliSyn_YelVio_V2/YelVio_RiftAxis/YelVio_RiftAxis.tscn")
	elif tower_id == TRUDGE:
		return load("res://TowerRelated/Color_Red/Trudge/Trudge.tscn")
	elif tower_id == SOPHIST:
		return load("res://TowerRelated/Color_Red/Sophist/Sophist.tscn")
	elif tower_id == WYVERN: # 80
		return load("res://TowerRelated/Color_Red/Wyvern/Wyvern.tscn")
	elif tower_id == FULGURANT:
		return load("res://TowerRelated/Color_Red/Fulgurant/Fulgurant.tscn")
	elif tower_id == ENERVATE:
		return load("res://TowerRelated/Color_Red/Enervate/Enervate.tscn")
	elif tower_id == SOLITAR:
		return load("res://TowerRelated/Color_Red/Solitar/Solitar.tscn")
	elif tower_id == TRAPPER:
		return load("res://TowerRelated/Color_Red/Trapper/Trapper.tscn")
	elif tower_id == OUTREACH:
		return load("res://TowerRelated/Color_Red/Outreach/Outreach.tscn")
	elif tower_id == BLAST:
		return load("res://TowerRelated/Color_Red/Blast/Blast.tscn")
	elif tower_id == DUNED: #87
		return load("res://TowerRelated/Color__Others/Duned/Duned.tscn")
	elif tower_id == MAP_PASSAGE__FIRE_PATH:
		return load("res://TowerRelated/Color__Others/MapPassage_FirePath/MapPassage_PathFire.tscn")
	elif tower_id == MAP_ENCHANT__ATTACKS:
		return load("res://TowerRelated/Color__Others/MapEnchant_Attacks/MapEnchant_Attacks.tscn")
	elif tower_id == BOUNDED:
		return load("res://TowerRelated/Color_Violet/Bounded/Bounded.tscn")
	elif tower_id == CELESTIAL:
		return load("res://TowerRelated/Color_Violet/Celestial/Celestial.tscn")
	elif tower_id == BIOMORPH:
		return load("res://TowerRelated/Color_Violet/BioMorph/Biomorph.tscn")
	
	
