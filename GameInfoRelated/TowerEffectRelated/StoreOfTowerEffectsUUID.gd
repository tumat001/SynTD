extends Node

enum {
	# MISC ------------------------
	TOWER_MAIN_DAMAGE = -100
	
	# --TOWERS ING EFFECTS---------
	# RED (100)
	ING_REAPER = 100
	ING_SHOCKER = 101
	ING_ADEPT = 102
	ING_REBOUND = 103
	ING_STRIKER = 104
	ING_HEXTRIBUTE = 105
	ING_SOUL = 106
	ING_PROBE = 107
	ING_TRANSMUTATOR = 108
	
	# ORANGE (200)
	ING_EMBER = 200
	ING_LAVA_JET = 201
	ING_CAMPFIRE = 202
	ING_VOLCANO = 203
	ING_704 = 204
	ING_FLAMEBURST = 205
	ING_COAL_LAUNCHER = 206
	ING_ENTHALPHY = 207
	ING_ENTROPY = 208
	ING_ROYAL_FLAME = 209
	ING_IEU = 210
	
	# YELLOW (300)
	ING_COIN = 300
	ING_BEACON_DISH = 301
	ING_MINI_TESLA = 302
	ING_CHARGE = 303
	ING_MAGNETIZER = 304
	ING_RAILGUN = 305
	ING_SUNFLOWER = 306
	ING_NUCLEUS = 307
	
	# GREEN (400)
	ING_BERRY_BUSH = 400
	ING_SPIKE = 401
	ING_IMPALE = 402
	ING_SEEDER = 403
	ING_CANNON = 404
	ING_BLOSSOM = 405
	ING_PESTILENCE = 406
	ING_PINECONE = 407
	ING_FRUIT_TREE = 408
	ING_BREWD = 409
	ING_BURGEON = 410
	
	# BLUE (500)
	ING_SPRINKLER = 500
	ING_LEADER = 501
	ING_ORB = 502
	ING_GRAND = 503
	ING_DOUSER = 504
	ING_WAVE = 505
	ING_BLEACH = 506
	ING_TIME_MACHINE = 507
	ING_TRANSPORTER = 508
	ING_ACCUMULAE = 509
	
	ING_LEADER_ARMOR_PIERCE = 508
	ING_LEADER_TOUGHNESS_PIERCE = 509
	
	# VIOLET (600)
	ING_SIMPLE_OBELISK = 600
	ING_RE = 601
	ING_TESLA = 602
	ING_CHAOS = 603
	ING_PING = 604 # PINGLET
	ING_PROMINENCE = 605
	ING_PROMINENCE_DMG_INSTANCE_REAPPLIED = 606 # damage reg id
	
	ING_SHACKLED = 607
	
	# OTHERS (900)
	
	
	# MISC INGREDIENTS (1000)
	ING_BLUE_FRUIT = 1000
	ING_GREEN_FRUIT = 1001
	ING_RED_FRUIT = 1002
	ING_VIOLET_FRUIT = 1003
	ING_WHITE_FRUIT = 1004
	ING_YELLOW_FRUIT = 1005
	
	
	# --TOWER EFFECTS----------------------
	
	# RED (1100)
	REAPER_PERCENT_HEALTH_DAMAGE = 1100
	SHOCKER_SHOCK_BALL_MAIN_DAMAGE = 1101
	ADEPT_SLOW = 1102
	STRIKER_BONUS_DMG = 1103
	
	HEXTRIBUTE_BONUS_DMG = 1104
	HEXTRIBUTE_EXECUTE = 1105
	HEXTRIBUTE_HEX_STACK = 1106
	
	PROBE_RESEARCH_EFFECT_HOLDER = 1108
	PROBE_ATTK_SPEED_EFFECT = 1107
	
	WYVERN_FULMINATE_ON_HIT_DAMAGE = 1108
	
	# ORANGE (1200)
	EMBER_BURN = 1200
	LAVA_JET_BEAM = 1201 # Percent damage
	CAMPFIRE_PHY_ON_HIT = 1202
	VOLCANO_SLOW = 1203
	_704_FIRE_BURN = 1204
	ENTHALPHY_KILL_ELE_ON_HIT = 1205
	ENTHALPHY_RANGE_ELE_ON_HIT = 1206
	ENTROPY_FIRST_BONUS_ATTK_SPEED = 1207
	ENTROPY_SECOND_BONUS_ATTK_SPEED = 1208
	ROYAL_FLAME_BURN = 1209
	IEU_ATTK_SPEED = 1210
	IEU_RANGE = 1211
	
	LAVA_JET_TOUGHNESS_PIERCE = 1212
	
	# YELLOW (1300)
	BEACON_ELE_ON_HIT = 1300
	BEACON_ATTK_SPEED = 1301
	BEACON_RANGE = 1302
	MINI_TESLA_STACKING_STUN = 1303
	CHARGE_BONUS_ON_HIT = 1304
	MINI_TESLA_STACKING_ATTACK_SPEED = 1305
	
	CHARGE_BONUS_PERCENT_ON_HIT = 1306
	
	# GREEN(1400)
	IMPALE_STUN = 1400
	PESTILENCE_POISON = 1401
	PESTILENCE_TOXIN = 1402
	PESTILENCE_NOXIOUS = 1403
	PESTILENCE_TOWER_LEECH_DEBUFF = 1404
	PESTILENCE_TOWER_LEECH_BUFF = 1405
	BLOSSOM_PERCENT_DMG_OMNIVAMP_BUFF = 1406
	BLOSSOM_TOTAL_ATTK_SPEED_BUFF = 1407
	BLOSSOM_TOTAL_BASE_DMG_BUFF = 1408
	BLOSSOM_MARK_EFFECT = 1409
	SPIKE_BONUS_DAMAGE = 1410
	BLOSSOM_EFFECT_VUL_EFFECT = 1411
	BURGEON_HEAL_REDUC_EFFECT = 1412
	LES_SEMIS_BONUS_BASE_DAMAGE_EFFECT = 1413
	L_ASSAUT_ATTACK_SPEED_EFFECT = 1414
	L_ASSAUT_RANGE_EFFECT = 1415
	L_ASSAUT_BONUS_DMG_EFFECT = 1416
	LA_CHASSEUR_ON_HIT_DMG_EFFECT = 1417
	LA_NATURE_SOLAR_SPIRIT_BONUS_ATTK_SPEED = 1418
	LA_NATURE_TORRENTIAL_TEMPEST_ATTK_SPEED_SLOW = 1419
	
	# BLUE (1500)
	GRAND_PIERCE = 1500
	GRAND_PROJ_SPEED = 1501
	DOUSER_BASE_DAMAGE_INC = 1502
	WAVE_ON_HIT_DMG = 1503
	TRANSPOSE_ATTK_SPEED = 1504
	ACCUMULAE_SELF_SIPHON_BUFF = 1505
	ORB_ABSORB_ORB_BUFF = 1506
	TRANSPOSE_ABILITY_POTENCY_BUFF = 1507
	
	# VIOLET(1600)
	TESLA_STUN = 1600
	RE_CLEAR_EFFECTS = 1601
	PROMINENCE_KNOCK_UP_EFFECT = 1602
	
	# OTHERS (1900)
	HERO_JUDGEMENT_ON_HIT_DMG = 1900
	HERO_JUDGEMENT_STACK_EFFECT = 1901
	HERO_VOL_BUFF_EFFECT = 1902
	
	HERO_MAX_NATURAL_LEVEL_BASE_DAMAGE_EFFECT = 1903
	HERO_MAX_NATURAL_LEVEL_ATTK_SPEED_EFFECT = 1904
	HERO_MAX_NATURAL_LEVEL_ABILITY_POTENCY_EFFECT = 1905
	
	HERO_LEVEL_UP_STATUS_BAR_ICON_INDEX = 1906
	
	AMALGAMATE_TO_CONVERT_MARK_EFFECT = 1950
	
	# -- SYNERGY EFFECTS --
	
	# RED (2000)
	RED_PACT_PLAYING_WITH_FIRE_BUFF_GIVER = 2000
	RED_PACT_PLAYING_WITH_FIRE_BUFF = 2001
	
	RED_DRAGON_SOUL_EXECUTE_DAMAGE = 2002
	
	RED_PACT_JEWELED_BLADE_EFFECT = 2003
	RED_PACT_JEWELED_BLADE_BONUS_BASE_DMG_EFFECT = 2004
	RED_PACT_JEWELED_STAFF_EFFECT = 2005
	RED_PACT_JEWELED_STAFF_BONUS_AP_EFFECT = 2006
	
	RED_PACT_DOMINANCE_SUPPLEMENT_MARK_EFFECT = 2007
	RED_PACT_DOMINANCE_EXTRA_DOMINANCE_SLOTS = 2008
	RED_PACT_DOMINANCE_LESS_COMPLEMENTARY_SLOTS = 2009
	
	RED_PACT_COMPLEMENTARY_SUPPLEMENT_MARK_EFFECT = 2010
	RED_PACT_COMPLEMENTARY_EXTRA_COMPLEMENTARY_SLOTS = 2011
	
	RED_PACT_PERSONAL_SPACE_EFFECT_GIVER = 2013
	RED_PACT_PERSONAL_SPACE_ATTK_SPEED_EFFECT = 2014
	
	RED_PACT_SOLO_VICTOR_BASE_DAMAGE_EFFECT = 2015
	RED_PACT_SOLO_VICTOR_ATTACK_SPEED_EFFECT = 2016
	RED_PACT_SOLO_VICTOR_RANGE_EFFECT = 2017
	
	RED_PACT_TRIO_VICTOR__BASE_DAMAGE_BUFF_EFFECT = 2018
	RED_PACT_TRIO_VICTOR__ATTACK_SPEED_BUFF_EFFECT = 2019
	RED_PACT_TRIO_VICTOR__ATTACK_SPEED_REDUC_EFFECT = 2020
	RED_PACT_TRIO_VICTOR__ABILITY_POTENCY_REDUC_EFFECT = 2021
	
	RED_PACT_RETRIBUTION_EFFECT_GIVER = 2022
	
	RED_PACT_ABILITY_PROVISIONS_EFFECT_GIVER = 2023
	RED_PACT_ABILITY_PROVISIONS_AP_EFFECT = 2024
	RED_PACT_ABILITY_PROVISIONS_ATTK_SPEED_EFFECT = 2025
	
	RED_PACT_ORACLES_EYE_EFFECT_GIVER = 2026
	RED_PACT_ORACLES_EYE_RANGE_EFFECT = 2027
	RED_PACT_ORACLES_EYE_PER_SHADOW_KILL_RANGE_EFFECT = 2028
	
	# ORANGE (2200)
	HEAT_MODULE_CURRENT_EFFECT = 2200
	
	# YELLOW (2300)
	ENERGY_MODULE_ENERGY_EFFECT_GIVER = 2300
	
	
	# GREEN (2400)
	GREEN_PATH_DEEP_ROOT_DMG_BOOST = 2400
	GREEN_PATH_QUICK_ROOT_DMG_BOOST = 2401
	
	GREEN_PATH_HASTE_EFFECT_GIVER = 2402
	GREEN_PATH_HASTE_ATTK_SPEED_BOOST = 2403
	
	GREEN_PATH_PIERCING_EFFECT_GIVER = 2404
	GREEN_PATH_PIERCING_ARMOR_PIERCE = 2405
	GREEN_PATH_PIERCING_TOUGHNESS_PIERCE = 2406
	
	GREEN_PATH_OVERCOME_EFFECT = 2407
	
	GREEN_PATH_RESILIENCE_EFFECT_GIVER = 2408
	GREEN_PATH_RESILIENCE_HEALTH_EFFECT = 2409
	GREEN_PATH_RESILIENCE_VUL_EFFECT = 2410
	
	GREEN_PATH_COLOR_ARTIFACT_DOM_SYN_MODI_ID = 2411
	GREEN_PATH_COLOR_ARTIFACT_COMPO_SYN_MODI_ID = 2412
	
	# BLUE (2500)
	BREEZE_DAMAGE = 2500
	MANA_BLAST_DAMAGE = 2501
	MANA_BLAST_BONUS_AP = 2502
	
	BLUE_AP_EFFECT = 2503
	
	# VIOLET (2600)
	VIOLET_COLOR_MASTERY_EFFECT_GIVER = 2600
	VIOLET_COLOR_MASTERY_EFFECT = 2601
	VIOLET_COLOR_MASTERY_ROUND_COUNTDOWN_MARKER = 2602
	
	
	# OTHERS (2900)
	BLACK_CORRUPTION_STACK = 2900
	BLACK_ATTACK_DAMAGE_BUFF = 2901
	BLACK_ATTACK_SPEED_BUFF = 2902
	BLACK_ATTACK_SPEED_BUFF_GIVER = 2903
	BLACK_PERCENT_HEALTH_DAMAGE = 2904
	BLACK_BLACK_BEAM_AM = 2905
	BLACK_PERCENT_HEALTH_DAMAGE_GIVER = 2906
	BLACK_CORRUPTION_STACK_GIVER = 2907
	
	BLACK_OVERKILL_ATTKMOD_GIVER = 2908
	BLACK_CAPACITOR_NOVA_AP_EFFECT = 2909
	BLACK_CAPACITOR_NOVA_CDR_EFFECT = 2910
	BLACK_CAPACITOR_LIGHTNING_AP_EFFECT = 2911
	BLACK_CAPACITOR_LIGHTNING_PERCENT_ON_HIT_DMG = 2912
	BLACK_CAPACITOR_LIGHTNING_STUN_ON_HIT_EFFECT = 2913
	
	HERO_COMPO_SYN_MODI_ID = 2950
	
	# ------------
	# RED GREEN (3000)
	RED_GREEN_RED_DETONATE_SIDE_EFFECT_GIVER = 3000
	RED_GREEN_RED_DETONATE_DAMAGE = 3001
	
	RED_GREEN_GREEN_DETONATE_SIDE_EFFECT_GIVER = 3005
	RED_GREEN_GREEN_SLOW_ON_HIT_EFFECT = 3006
	
	RED_GREEN_GREEN_EFFECT_SHIELD_EFFECT = 3007
	
	# YELLOW VIOLET (3100)
	
	
	# ORANGE BLUE (3200)
	ORANGE_BLUE_AM_ADDER = 3200
	#ORANGE_BLUE_AP_EFFECT = 3201
	
	# RED OV (3300)
	RED_OV_GIVER_EFFECT = 3300
	RED_OV_ARMOR_PIERCE_EFFECT = 3301
	RED_OV_TOUGHNESS_PIERCE_EFFECT = 3302
	
	# ORANGE YR (3400)
	ORANGE_YR_ATTK_SPEED_EFFECT = 3400
	ORANGE_YR_GIVER_EFFECT = 3401
	
	# YELLOW GO (3500)
	YELLOW_GO_ELE_ON_HIT_EFFECT = 3500
	YELLOW_GO_BASE_DMG_EFFECT = 3501
	YELLOW_GO_ATTK_SPEED_EFFECT = 3502
	YELLOW_GO_RANGE_EFFECT = 3503
	YELLOW_GO_EFFECT_BUNDLE = 3504
	
	# GREEN BY (3600)
	GREEN_BY_SCALING_EFFECT_GIVER = 3600
	GREEN_BY_DAMAGE_EFFECT = 3601
	
	# BLUE VG (3700)
	BLUE_VG_AP_PER_CAST = 3700
	BLUE_VG_STACKING_AP_EFFECT = 3701
	
	# VIOLET RB (3800)
	VIOLET_RB_GIVER_EFFECT = 3800
	VIOLET_RB_RANGE_EFFECT = 3801
	VIOLET_RB_PHY_ON_HIT_EFFECT = 3802
	VIOLET_RB_ELE_ON_HIT_EFFECT = 3803
	VIOLET_RB_MAJOR_ON_HIT_EFFECT = 3804
	
	VIOLET_RB_V2_BASE_DAMAGE_EFFECT = 3810
	VIOLET_RB_V2_ABILITY_POTENCY_EFFECT = 3811
	VIOLET_RB_V2_SELF_DAMAGE_EFFECT = 3815
	VIOLET_RB_V2_INVULNERABILITY_EFFECT = 3818
	VIOLET_RB_V2_EFFECT_IMMUNE_EFFECT = 3819
	VIOLET_RV_V2_PROJ_SPEED_EFFECT = 3820
	
	# RYB (3900)
	
	# OGV (4000)
	OVG_POWER_FUND_ATTACK_SPEED_EFFECT = 4000
	
	# RGB (4100)
	
	# ROYGBV(4200)
	
	
	# --------
	# EXPERT (10 100)
	
	# FAITHFUL (10 200)
	FAITHFUL_TAUNT_EFFECT = 10200
	FAITHFUL_KNOCK_UP_EFFECT = 10201
	
	PROVIDENCE_ATTK_SPEED_DEBUFF_EFFECT = 10202
	PROVIDENCE_BASE_DMG_DEBUFF_EFFECT = 10203
	
}
