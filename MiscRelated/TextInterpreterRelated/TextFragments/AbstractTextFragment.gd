extends Reference

const DamageType = preload("res://GameInfoRelated/DamageType.gd")

#

enum STAT_TYPE {
	BASE_DAMAGE = 100,
	ON_HIT_DAMAGE = 101,
	ATTACK_SPEED = 102,
	RANGE = 103,
	ABILITY_POTENCY = 104,  # if changing this val, change ENEMY_STAT__ABILITY_POTENCY as well
	PERCENT_COOLDOWN_REDUCTION = 105,
	PIERCE = 106,
	
	DAMAGE_SCALE_AMP = 200,
	
	#
	
	ABILITY = 1000,
	BURN = 1001,
	EXECUTE = 1002,
	GOLD = 1003,
	KNOCK_BACK = 1004,
	KNOCK_UP = 1005,
	#MAIN_ATTACK = 1006,
	#NOT_MAIN_ATTACK = 1007,
	#ON_HIT_EFFECT = 1008,
	ON_ROUND_END = 1009,
	ON_ROUND_START = 1010,
	SLOW = 1011,
	STUN = 1012,
	TOWER_TIER_01 = 1013
	TOWER_TIER_02 = 1014
	TOWER_TIER_03 = 1015
	TOWER_TIER_04 = 1016
	TOWER_TIER_05 = 1017
	TOWER_TIER_06 = 1018
	
	INGREDIENT = 1019
	TOWER = 1020
	LEVEL_UP_ORANGE = 1021 # level up arrow, but color orange
	SHOP = 1022
	SYNERGY = 1023
	SYNERGY_DOMINANT = 1024
	SYNERGY_COMPOSITE = 1025
	LEVEL_UP_GREEN = 1026 # level up arrow, but color green
	RELIC = 1027
	ENEMY = 1028
	
	HEALTH = 1029 # if changing this, change ENEMY_STAT__HEALTH as well
	SHIELD = 1030 
	ARMOR = 1031 # change ENEMY_STAT__ARMOR if changing this
	TOUGHNESS = 1032 # change ENEMY_STAT__TOUGHNESS if changing this
	MOV_SPEED = 1033 # change ENEMY_STAT__MOV_SPEED if change this
	INVISIBLE = 1034
	RESISTANCE = 1035 # change ENEMY_STAT__RESISTANCE if change this
	PLAYER_DMG = 1036 # change ENEMY_STAT__PLAYER_DMG if changing this
	EFFECT_VUL = 1037 # change ENEMY_STAT__EFFECT_VUL if chaning this
	INVULNERABLE = 1038
	AOE_RESISTANCE = 1039
	
	PHYSICAL_DAMAGE = 1040
	ELEMENTAL_DAMAGE = 1041
	
	
	PLAYER_HEALTH = 1050
	
	#
	COLOR_VIOLET = 1100
	COLOR_BLUE = 1101
	COLOR_GREEN = 1102
	COLOR_YELLOW = 1103
	COLOR_ORANGE = 1104
	COLOR_RED = 1105
	
	#
	COMBINATION = 1200
	ABSORB = 1201
	
	
	####
	
	ENEMY_STAT__HEALTH = 1029
	ENEMY_STAT__MOV_SPEED = 1033
	ENEMY_STAT__ARMOR = 1031
	ENEMY_STAT__TOUGHNESS = 1032
	ENEMY_STAT__RESISTANCE = 1035
	ENEMY_STAT__PLAYER_DMG = 1036
	ENEMY_STAT__EFFECT_VUL = 1037
	ENEMY_STAT__ABILITY_POTENCY = 104
	
}


const type_to_for_light_color_map : Dictionary = {
	-1 : "#4F4F4F",
	
	STAT_TYPE.BASE_DAMAGE : "#F72302",
	STAT_TYPE.ATTACK_SPEED : "#B07D00",
	STAT_TYPE.RANGE : "#01730B",
	STAT_TYPE.ABILITY_POTENCY : "#023F81",
	STAT_TYPE.ON_HIT_DAMAGE : "#6F6F6F",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "#026C6A",
	STAT_TYPE.PIERCE : "#B61691",
	STAT_TYPE.DAMAGE_SCALE_AMP : "#C00205",
	
	STAT_TYPE.ABILITY : "#022897",
	STAT_TYPE.BURN : "#4FAA01",
	STAT_TYPE.EXECUTE : "#6F0103",
	STAT_TYPE.GOLD : "#715D21",
	STAT_TYPE.KNOCK_BACK : "#821719",
	STAT_TYPE.KNOCK_UP : "#821719",
	STAT_TYPE.ON_ROUND_END : "#4F4F4F",
	STAT_TYPE.ON_ROUND_START : "#4F4F4F",
	STAT_TYPE.SLOW : "#024F50",
	STAT_TYPE.STUN : "#821719",
	
	STAT_TYPE.TOWER_TIER_01 : "#474747",
	STAT_TYPE.TOWER_TIER_02 : "#0B5101",
	STAT_TYPE.TOWER_TIER_03 : "#011C6A",
	STAT_TYPE.TOWER_TIER_04 : "#2E015B",
	STAT_TYPE.TOWER_TIER_05 : "#6A0103",
	STAT_TYPE.TOWER_TIER_06 : "#6A5001",
	
	STAT_TYPE.INGREDIENT : "#5102A2",
	STAT_TYPE.TOWER : "#016F46",
	STAT_TYPE.LEVEL_UP_ORANGE : "#804000",
	STAT_TYPE.SHOP : "#4A2E1F",
	
	STAT_TYPE.SYNERGY : "#650273",
	STAT_TYPE.SYNERGY_DOMINANT : "#650273",
	STAT_TYPE.SYNERGY_COMPOSITE : "#650273",
	
	STAT_TYPE.LEVEL_UP_GREEN : "#264C01",
	STAT_TYPE.RELIC : "#0A4701",
	STAT_TYPE.ENEMY : "#4B1600",
	
	STAT_TYPE.HEALTH : "#274C01",
	STAT_TYPE.SHIELD : "#2E2E2E",
	STAT_TYPE.ARMOR : "#562001",
	STAT_TYPE.TOUGHNESS : "#0C0165",
	STAT_TYPE.MOV_SPEED : "#025455",
	STAT_TYPE.INVISIBLE : "#025455",
	STAT_TYPE.RESISTANCE : "#6F0103",
	STAT_TYPE.PLAYER_DMG : "#6F2A01",
	STAT_TYPE.EFFECT_VUL : "#323232",
	STAT_TYPE.INVULNERABLE : "#513D01",
	STAT_TYPE.AOE_RESISTANCE : "#5C2E00",
	
	STAT_TYPE.PHYSICAL_DAMAGE : "#F72302",
	STAT_TYPE.ELEMENTAL_DAMAGE : "#A602C0",
	
	STAT_TYPE.PLAYER_HEALTH : "#510102",
	
	STAT_TYPE.COLOR_VIOLET : "#4F0051",
	STAT_TYPE.COLOR_BLUE : "#011F74",
	STAT_TYPE.COLOR_GREEN : "#0B5600",
	STAT_TYPE.COLOR_YELLOW : "#464C00",
	STAT_TYPE.COLOR_ORANGE : "#6B3600",
	STAT_TYPE.COLOR_RED : "#5B0102",
	
	STAT_TYPE.COMBINATION : "#005151",
	STAT_TYPE.ABSORB : "#38016F",
	
}

const type_to_for_dark_color_map : Dictionary = {
	-1 : "#B8B8B8",
	
	STAT_TYPE.BASE_DAMAGE : "#FD6453",
	STAT_TYPE.ATTACK_SPEED : "#E8BA00",
	STAT_TYPE.RANGE : "#41D31B",
	STAT_TYPE.ABILITY_POTENCY : "#459DFD",
	STAT_TYPE.ON_HIT_DAMAGE : "#B8B8B8",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "#02F7F5",
	STAT_TYPE.PIERCE : "#ED6ED0",
	
	STAT_TYPE.DAMAGE_SCALE_AMP : "#FD4E51",
	
	STAT_TYPE.ABILITY : "#C7D6FE",
	STAT_TYPE.BURN : "#FEA572",
	STAT_TYPE.EXECUTE : "#FA9295",
	STAT_TYPE.GOLD : "#ECA242",
	STAT_TYPE.KNOCK_BACK : "#F09294",
	STAT_TYPE.KNOCK_UP : "#F09294",
	STAT_TYPE.ON_ROUND_END : "#B8B8B8",
	STAT_TYPE.ON_ROUND_START : "#B8B8B8",
	STAT_TYPE.SLOW : "#04BABC",
	STAT_TYPE.STUN : "#F09294",
	
	STAT_TYPE.TOWER_TIER_01 : "#BFBFBF",
	STAT_TYPE.TOWER_TIER_02 : "#1FE302",
	STAT_TYPE.TOWER_TIER_03 : "#3FB9FD",
	STAT_TYPE.TOWER_TIER_04 : "#C690FE",
	STAT_TYPE.TOWER_TIER_05 : "#FE9092",
	STAT_TYPE.TOWER_TIER_06 : "#FEDD7C",
	
	STAT_TYPE.INGREDIENT : "#D99FFE",
	STAT_TYPE.TOWER : "#9AFED8",
	STAT_TYPE.LEVEL_UP_ORANGE : "#FFCF9E",
	STAT_TYPE.SHOP : "#DBBEAD",
	
	STAT_TYPE.SYNERGY : "#F7C7FE",
	STAT_TYPE.SYNERGY_DOMINANT : "#F7C7FE",
	STAT_TYPE.SYNERGY_COMPOSITE : "#F7C7FE",
	
	STAT_TYPE.LEVEL_UP_GREEN : "#64FD4D",
	STAT_TYPE.RELIC : "#9AFE8B",
	STAT_TYPE.ENEMY : "#FFB56B",
	
	STAT_TYPE.HEALTH : "#B9FE72",
	STAT_TYPE.SHIELD : "#CFCFCF",
	STAT_TYPE.ARMOR : "#FEA572",
	STAT_TYPE.TOUGHNESS : "#B3A9FE",
	STAT_TYPE.MOV_SPEED : "#B4FCFE",
	STAT_TYPE.INVISIBLE : "#83FAFB",
	STAT_TYPE.RESISTANCE : "#FE9FA1",
	STAT_TYPE.PLAYER_DMG : "#FEB58B",
	STAT_TYPE.EFFECT_VUL : "#DFDFDF",
	STAT_TYPE.INVULNERABLE : "#F0FE8B",
	STAT_TYPE.AOE_RESISTANCE : "#FFBF81",
	
	STAT_TYPE.PHYSICAL_DAMAGE : "#FEAC7C",
	STAT_TYPE.ELEMENTAL_DAMAGE : "#FF9DFF",
	
	STAT_TYPE.PLAYER_HEALTH : "#FE9092",
	
	STAT_TYPE.COLOR_VIOLET : "#F09AFE",
	STAT_TYPE.COLOR_BLUE : "#9AB4FE",
	STAT_TYPE.COLOR_GREEN : "#8CFE7C",
	STAT_TYPE.COLOR_YELLOW : "#F7FF9E",
	STAT_TYPE.COLOR_ORANGE : "#FFCC99",
	STAT_TYPE.COLOR_RED : "#FF9EA0",
	
	STAT_TYPE.COMBINATION : "#C3FEFE",
	STAT_TYPE.ABSORB : "#D1A4FE",
	
}


const type_to_name_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "base damage",
	STAT_TYPE.ATTACK_SPEED : "attack speed",
	STAT_TYPE.RANGE : "range",
	STAT_TYPE.ABILITY_POTENCY : "ability potency",
	STAT_TYPE.ON_HIT_DAMAGE : "on hit damages",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "cooldown reduction",
	STAT_TYPE.PIERCE : "bullet pierce",
	STAT_TYPE.DAMAGE_SCALE_AMP : "more damage",
	
	STAT_TYPE.ABILITY : "ability",
	STAT_TYPE.BURN : "burn",
	STAT_TYPE.EXECUTE : "execute",
	STAT_TYPE.GOLD : "gold",
	STAT_TYPE.KNOCK_BACK : "knock back",
	STAT_TYPE.KNOCK_UP : "knock up",
	STAT_TYPE.ON_ROUND_END : "on round end",
	STAT_TYPE.ON_ROUND_START : "on round start",
	STAT_TYPE.SLOW : "slow",
	STAT_TYPE.STUN : "stun",
	
	STAT_TYPE.TOWER_TIER_01 : "tier 1",
	STAT_TYPE.TOWER_TIER_02 : "tier 2",
	STAT_TYPE.TOWER_TIER_03 : "tier 3",
	STAT_TYPE.TOWER_TIER_04 : "tier 4",
	STAT_TYPE.TOWER_TIER_05 : "tier 5",
	STAT_TYPE.TOWER_TIER_06 : "tier 6",
	
	STAT_TYPE.INGREDIENT : "ingredient",
	STAT_TYPE.TOWER : "tower",
	STAT_TYPE.LEVEL_UP_ORANGE : "level up",
	STAT_TYPE.SHOP : "shop",
	
	STAT_TYPE.SYNERGY : "synergy",
	STAT_TYPE.SYNERGY_DOMINANT : "dominant synergy",
	STAT_TYPE.SYNERGY_COMPOSITE : "composite synergy",
	
	STAT_TYPE.LEVEL_UP_GREEN : "level up",
	STAT_TYPE.RELIC : "relic",
	STAT_TYPE.ENEMY : "enemy",
	
	STAT_TYPE.HEALTH : "health",
	STAT_TYPE.SHIELD : "shield",
	STAT_TYPE.ARMOR : "armor",
	STAT_TYPE.TOUGHNESS : "toughness",
	STAT_TYPE.MOV_SPEED : "movement speed",
	STAT_TYPE.INVISIBLE : "invisible",
	STAT_TYPE.RESISTANCE : "resistance",
	STAT_TYPE.PLAYER_DMG : "player damage",
	STAT_TYPE.EFFECT_VUL : "effect vulnerability",
	STAT_TYPE.INVULNERABLE : "invulnerable",
	STAT_TYPE.AOE_RESISTANCE : "aoe resistance",
	
	STAT_TYPE.PHYSICAL_DAMAGE : "physical damage",
	STAT_TYPE.ELEMENTAL_DAMAGE : "elemental damage",
	
	STAT_TYPE.PLAYER_HEALTH : "player health",
	
	STAT_TYPE.COLOR_VIOLET : "violet",
	STAT_TYPE.COLOR_BLUE : "blue",
	STAT_TYPE.COLOR_GREEN : "green",
	STAT_TYPE.COLOR_YELLOW : "yellow",
	STAT_TYPE.COLOR_ORANGE : "orange",
	STAT_TYPE.COLOR_RED : "red",
	
	STAT_TYPE.COMBINATION : "combination",
	STAT_TYPE.ABSORB : "absorb",
	
}

const type_to_img_map : Dictionary = {
	STAT_TYPE.BASE_DAMAGE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseDamage.png",
	STAT_TYPE.ATTACK_SPEED : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseAtkSpeed.png",
	STAT_TYPE.RANGE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseRange.png",
	STAT_TYPE.ABILITY_POTENCY : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BaseAbilityPotency.png",
	STAT_TYPE.ON_HIT_DAMAGE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_OnHitMultiplier.png",
	STAT_TYPE.PERCENT_COOLDOWN_REDUCTION : "res://GameInfoRelated/TowerStatsIcons/StatIcon_CooldownReduction.png",
	STAT_TYPE.PIERCE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_Bullet_Pierce.png",
	STAT_TYPE.DAMAGE_SCALE_AMP : "res://GameInfoRelated/TowerStatsIcons/StatIcon_BonusDamageScale.png",
	
	STAT_TYPE.ABILITY : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Ability.png",
	STAT_TYPE.BURN : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Burn.png",
	STAT_TYPE.EXECUTE : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Execute.png",
	STAT_TYPE.GOLD : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Gold.png",
	STAT_TYPE.KNOCK_BACK : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Knockback.png",
	STAT_TYPE.KNOCK_UP : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_KnockUp.png",
	
	STAT_TYPE.ON_ROUND_END : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_OnRoundEnd.png",
	STAT_TYPE.ON_ROUND_START : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_OnRoundStart.png",
	STAT_TYPE.SLOW : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Slow.png",
	STAT_TYPE.STUN : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Stun.png",
	
	STAT_TYPE.TOWER_TIER_01 : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_TowerTier01.png",
	STAT_TYPE.TOWER_TIER_02 : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_TowerTier02.png",
	STAT_TYPE.TOWER_TIER_03 : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_TowerTier03.png",
	STAT_TYPE.TOWER_TIER_04 : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_TowerTier04.png",
	STAT_TYPE.TOWER_TIER_05 : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_TowerTier05.png",
	STAT_TYPE.TOWER_TIER_06 : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_TowerTier06.png",
	
	STAT_TYPE.INGREDIENT : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Ingredient.png",
	STAT_TYPE.TOWER : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Tower.png",
	STAT_TYPE.LEVEL_UP_ORANGE : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_LevelUp_Orange.png",
	STAT_TYPE.SHOP : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Shop.png",
	
	STAT_TYPE.SYNERGY : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Synergy.png",
	STAT_TYPE.SYNERGY_DOMINANT : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_SynergyDominant.png",
	STAT_TYPE.SYNERGY_COMPOSITE : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_SynergyComposite.png",
	
	STAT_TYPE.LEVEL_UP_GREEN : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_LevelUp_Green.png",
	STAT_TYPE.RELIC : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Relic.png",
	STAT_TYPE.ENEMY : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Enemy.png",
	
	STAT_TYPE.HEALTH : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Heal.png",
	STAT_TYPE.SHIELD : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Shield.png",
	STAT_TYPE.ARMOR : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Armor.png",
	STAT_TYPE.TOUGHNESS : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Toughness.png",
	STAT_TYPE.MOV_SPEED : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_MovSpeed.png",
	STAT_TYPE.INVISIBLE : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Invisible.png",
	STAT_TYPE.RESISTANCE : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Resistance.png",
	STAT_TYPE.PLAYER_DMG : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_PlayerDmg.png",
	STAT_TYPE.EFFECT_VUL : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_EffectVulnerability.png",
	STAT_TYPE.INVULNERABLE : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Invulnerable.png",
	STAT_TYPE.AOE_RESISTANCE : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_AOEResistance.png",
	
	STAT_TYPE.PHYSICAL_DAMAGE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_DamageType_Physical.png",
	STAT_TYPE.ELEMENTAL_DAMAGE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_DamageType_Elemental.png",
	
	STAT_TYPE.PLAYER_HEALTH : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_PlayerHealth.png",
	
	STAT_TYPE.COLOR_VIOLET : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Color_Violet.png",
	STAT_TYPE.COLOR_BLUE : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Color_Blue.png",
	STAT_TYPE.COLOR_GREEN : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Color_Green.png",
	STAT_TYPE.COLOR_YELLOW : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Color_Yellow.png",
	STAT_TYPE.COLOR_ORANGE : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Color_Orange.png",
	STAT_TYPE.COLOR_RED : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Color_Red.png",
	
	STAT_TYPE.COMBINATION : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Combination.png",
	STAT_TYPE.ABSORB : "res://MiscRelated/TextInterpreterRelated/OtherFragmentIcons/FragmentIcon_Absorb.png",
	
	
}


#

enum ColorMode {
	FOR_LIGHT_BACKGROUND = 0,
	FOR_DARK_BACKGROUND = 1
}



const dmg_type_to_img_map : Dictionary = {
	DamageType.PHYSICAL : "res://GameInfoRelated/TowerStatsIcons/StatIcon_DamageType_Physical.png",
	DamageType.ELEMENTAL : "res://GameInfoRelated/TowerStatsIcons/StatIcon_DamageType_Elemental.png",
	DamageType.PURE : "res://GameInfoRelated/TowerStatsIcons/StatIcon_DamageType_Pure.png",
	
	DamageType.MIXED : "res://GameInfoRelated/TowerStatsIcons/StatIcon_DamageType_Mixed.png"
}

const dmg_type_to_for_light_color_map : Dictionary = {
	-1 : "#4F4F4F",
	
	DamageType.PHYSICAL : "#F72302",
	DamageType.ELEMENTAL : "#A602C0",
	DamageType.PURE : "#D90206",
	
	DamageType.MIXED : "#6C02DA"
}

const dmg_type_to_for_dark_color_map : Dictionary = {
	-1 : "#B8B8B8",
	
	DamageType.PHYSICAL : "#FEAC7C",
	DamageType.ELEMENTAL : "#FF9DFF",
	DamageType.PURE : "#FF8487",
	
	DamageType.MIXED : "#AA78FD"
}

#



const width_img_val_placeholder : String = "|imgWidth|"




var has_numerical_value : bool
var color_mode : int = ColorMode.FOR_LIGHT_BACKGROUND

#

func _init(arg_has_numerical_value : bool):
	has_numerical_value = arg_has_numerical_value


func _get_as_numerical_value() -> float:
	return 0.0

func _get_as_text() -> String:
	return "";

#


func _get_color_map_to_use() -> Dictionary:
	if color_mode == ColorMode.FOR_DARK_BACKGROUND:
		return dmg_type_to_for_dark_color_map
	else:
		return dmg_type_to_for_light_color_map

func _get_type_color_map_to_use(arg_stat_type, arg_damage_type) -> Dictionary:
	if arg_stat_type != STAT_TYPE.ON_HIT_DAMAGE:
		if color_mode == ColorMode.FOR_DARK_BACKGROUND:
			return type_to_for_dark_color_map[arg_stat_type]
		else:
			return type_to_for_light_color_map[arg_stat_type]
	else:
		if color_mode == ColorMode.FOR_DARK_BACKGROUND:
			return dmg_type_to_for_dark_color_map[arg_damage_type]
		else:
			return dmg_type_to_for_light_color_map[arg_damage_type]

#

func _configure_copy_to_match_self(arg_copy):
	arg_copy.has_numerical_value = has_numerical_value
	arg_copy.color_mode = color_mode

#

static func get_stat_type_based_on_tower_tier(arg_tower_tier : int):
	if arg_tower_tier == 1:
		return STAT_TYPE.TOWER_TIER_01
	elif arg_tower_tier == 2:
		return STAT_TYPE.TOWER_TIER_02
	elif arg_tower_tier == 3:
		return STAT_TYPE.TOWER_TIER_03
	elif arg_tower_tier == 4:
		return STAT_TYPE.TOWER_TIER_04
	elif arg_tower_tier == 5:
		return STAT_TYPE.TOWER_TIER_05
	elif arg_tower_tier == 6:
		return STAT_TYPE.TOWER_TIER_06
