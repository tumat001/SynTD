extends Node


enum {
	# ENEMIES
	# BASIC (100)
	DASH_SPEED_BOOST = 100
	HEALER_HEAL_EFFECT = 101
	
	# EXPERT (200)
	CHARGE_SPEED_BOOST = 200
	ENCHANTRESS_HEAL_EFFECT = 201
	ENCHANTRESS_SHIELD_EFFECT = 202
	ASSASSIN_INVIS_EFFECT = 203
	
	GRANDMASTER_SPEED_BOOST = 204
	GRANDMASTER_INVIS_EFFECT = 205
	GRANDMASTER_SHIELD_EFFECT = 206
	
	# FAITHFUL (300)
	DEITY_STUN_EFFECT_WHILE_SUMMONING = 300
	DEITY_EFFECT_SHIELD_EFFECT_WHILE_SUMMONING = 301
	DEITY_INVUL_EFFECT_WHILE_SUMMONING = 302
	
	DEITY_ARMOR_EFFECT = 303
	DEITY_TOUGHNESS_EFFECT = 304
	DEITY_HEALTH_REGEN_EFFECT = 305
	
	DEITY_GRANTED_REVIVE_HEAL_EFFECT = 306
	DEITY_GRANTED_REVIVE_EFFECT = 307
	
	DEITY_AP_EFFECT = 308
	DEITY_MAX_HEALTH_GAIN_EFFECT = 309
	
	DEITY_SELF_EFFECT_SHIELD_EFFECT = 310
	
	PRIEST_INVUL_EFFECT = 320
	
	FAITHFUL_SPEED_EFFECT = 350
	FAITHFUL_SLOW_EFFECT = 351
	
	
	# SHIRMISHERS (400)
	COSMIC_SHIELD_EFFECT = 400
	SMOKE_INVIS_EFFECT = 401
	RALLIER_SPEED_EFFECT = 402
	BLESSER_HEAL_EFFECT = 403
	ASCENDER_ARMOR_EFFECT = 404
	ASCENDER_TOUGHNESS_EFFECT = 405
	ASCENDER_SLOW_EFFECT = 406
	
	DANSEUR_DASH_EFFECT = 407
	DANSEUR_EFFECT_SHIELD_EFFECT = 408
	DANSEUR_SELF_SLOW_EFFECT = 409
	
	FINISHER_DASH_EFFECT = 410
	FINISHER_SELF_SLOW_EFFECT = 411
	FINISHER_EFFECT_SHIELD_EFFECT = 412
	
	TOSSER_KNOCK_UP_FOR_DISPLACEMENT = 413
	TOSSER_KNOCK_UP_FOR_STUNNAGE = 414
	ASCENDER_MAX_HEALTH_GAIN_EFFECT = 415
	
	HOMERUNNER_BLUE_AP_EFFECT = 416
	HOMERUNNER_RED_GRANTED_REVIVE_HEAL_EFFECT = 417
	HOMERUNNER_RED_GRANTED_REVIVE_EFFECT = 418
	HOMERUNNER_BLUE_SHIELD_EFFECT = 419
	
	COSMIC_AOE_DMG_RECEIVE_SCALE_EFFECT = 420
	
	# TOWERS
	# RED (-100)
	ADEPT_SLOW = -100
	
	HEXTRIBUTE_HEX_STACK = -101
	HEXTRIBUTE_ARMOR_REDUCTION = -102
	HEXTRIBUTE_TOUGHNESS_REDUCTION = -103
	HEXTRIBUTE_EFFECT_VULNERABLE = -104
	
	ING_HEXTRIBUTE_EFFECT_VUL = -105
	
	TRANSMUTATOR_SLOW_EFFECT = -106
	TRANSMUTATOR_MAX_HEALTH_REDUCTION_EFFECT = -107
	TRANSMUTATOR_HEAL = -108
	
	PROBE_RESEARCH_STACK = -109
	
	ING_SOUL = -110
	
	REBOUND_RETURN_STUN_EFFECT = -111
	
	TRUDGE_SLOW_EFFECT = -112
	TRUDGE_SMALL_KNOCK_UP_EFFECT = -113
	TRUDGE_BIG_KNOCK_UP_EFFECT = -114
	ING_TRUDGE = -115
	FULGURANT_SMITE_STUN_EFFECT = -116
	
	ENERVATE_SHRIVEL_ARMOR_REDUC_EFFECT = -117
	ENERVATE_SHRIVEL_TOU_REDUC_EFFECT = -118
	ENERVATE_STUN_EFFECT = -119
	ENERVATE_SLOW_EFFECT = -120
	ENERVATE_DEATH_ON_HIT_DMG = -121
	ENERVATE_HEAL_DECAY_EFFECT = -122
	ENERVATE_SHIELD_DECAY_EFFECT = -123
	FULGURANT_ING_SMITE_STUN_EFFECT = -124
	SOLITAR_ISOLATION_ON_HIT_DMG = -125
	SOLITAR_ISOLATION_STUN_EFFECT = -126
	OUTREACH_MISSLE_EXPLOSION_STUN_EFFECT = -127
	BLAST_KNOCKUP_EFFECT = -128
	BLAST_KNOCKBACK_FORCED_MOV_EFFECT = -129
	BLAST_SLOW_EFFECT = -130
	
	# ORANGE (-200)
	EMBER_BURN = -200
	ING_EMBER_BURN = -201
	
	VOLCANO_SLOW = -202
	_704_FIRE_BURN = -203
	ROYAL_FLAME_BURN = -204
	
	PROPEL_KNOCK_UP_EFFECT = -205
	PROPEL_FORCED_MOV_EFFECT = -206
	
	# YELLOW (-300)
	ING_TESLA = -300
	TESLA_STUN = -301
	
	MINI_TESLA_STACK = -302
	MINI_TESLA_STUN = -303
	
	ING_MINI_TESLA_STACK = -304 # unused
	ING_MINI_TELSA_STUN = -305 # unused
	
	ING_MINI_TESLA_ENEMY_STACK_TRACKER = -306
	ING_MINI_TESLA_ENEMY_STUN = -307
	
	# GREEN (-400)
	IMPALE_STUN = -400
	
	PESTILENCE_POISON = -401
	PESTILENCE_TOXIN = -402
	PESTILENCE_NOXIOUS = -403
	
	BREWD_REPEL_KNOCKUP = -404
	BREWD_REPEL_FORCED_PATH_MOV = -405
	
	BREWD_IMPLOSION_KNOCKUP = -406
	BREWD_IMPLOSION_FORCED_PATH_MOV = -407
	
	BREWD_SHUFFLE_KNOCKUP = -408
	BREWD_SHUFFLE_FORCED_PATH_MOV = -409
	
	BURGEON_HEAL_REDUC_EFFECT = -410
	
	LA_NATURE_TORRENTIAL_TEMPEST_MOV_SPEED_SLOW = -411
	
	# BLUE (-500)
	BLEACH_SHREAD = -500
	ING_BLEACH_SHREAD = -501
	
	TIME_MACHINE_TIME_DUST = -502
	LEADER_STUN = -503
	
	ACCUMULAE_SIPHON_DRAIN_EFFECT = -504
	VACCUM_SLOW_FROM_SUCK_EFFECT = -505
	VACUUM_KNOCK_UP_EFFECT = -506
	VACUUM_FORCED_MOV_OFFSET_EFFECT = -507
	
	# VIOLET (-600)
	RE_CLEAR_EFFECT = -600
	PROMINENCE_KNOCK_UP_EFFECT = -601
	SHACKLED_CHAINS_PULL_EFFECT = -602
	SHACKLED_CHAINS_STUN_EFFECT = -603
	
	CHAOS_BIG_BOLT_EVENT_PRIMARY_STUN_EFFECT = -604
	CHAOS_BIG_BOLT_EVENT_SECONDARY_STUN_EFFECT = -605
	CHAOS_VOID_LAKES_SLOW_EFFECT = -606
	CHAOS_NIGHT_WATCHER_STUN_EFFECT = -607
	CHAOS_EXPLOSIVE_RAIN_KNOCK_UP_EFFECT = -608
	CHAOS_EXPLOSIVE_RAIN_FORCED_OFFSET_EFFECT = -609
	
	VARIANCE_CLEAR_ENEMY_EFFECT = -610
	VARIANCE_RED_KNOCK_UP_EFFECT = -611
	VARIANCE_RED_FORCED_MOV_EFFECT = -612
	
	# GRAY (-800)
	ASHEND_BURN_EFFECT = -800
	
	# OTHERS (-900)
	HERO_JUDGEMENT_STACK = -900
	
	# MISC (-1000)
	ING_BLUE_FRUIT_SLOW = -1002
	ING_RED_FRUIT_BURN = -1001
	
	
	# -- SYNERGY EFFECTS --
	
	# RED (-2000)
	RED_PACT_FIRST_IMPRESSION_ARMOR_LOSS = -2000
	RED_PACT_FIRST_IMPRESSION_TOUGHNESS_LOSS = -2001
	RED_PACT_FIRST_IMPRESSION_ARMOR_GAIN = -2002
	RED_PACT_FIRST_IMPRESSION_TOUGHNESS_GAIN = -2003
	
	RED_PACT_SECOND_IMPRESSION_ARMOR_LOSS = -2004
	RED_PACT_SECOND_IMPRESSION_TOUGHNESS_LOSS = -2005
	RED_PACT_SECOND_IMPRESSION_ARMOR_GAIN = -2006
	RED_PACT_SECOND_IMPRESSION_TOUGHNESS_GAIN = -2007
	
	RED_PACT_A_CHALLENGE_ENEMY_BONUS_HEALTH = -2008
	
	RED_TIGER_SOUL_BLEED_DAMAGE = -2009
	
	RED_ADRENALINE_TOUGHNESS_DECREASE = -2010
	RED_ADRENALINE_SPEED_INCREASE = -2011
	RED_ADRENALINE_SPEED_DECREASE = -2012
	RED_ADRENALINE_MARKER = -2013
	
	RED_RETRIBUTION_DAMAGE_RESISTANCE = -2014
	
	RED_PACT_CLOSE_CONTROL_STUN_EFFECT = -2015
	
	RED_PACT_FROST_IMPLANTS_SLOW_EFFECT = -2016
	
	# ORANGE (-2200)
	
	# YELLOW (-2300)
	
	# GREEN (-2400)
	
	# BLUE (-2500)
	BLUE_BREEZE_FIRST_SLOW = -2500
	BLUE_BREEZE_SECOND_SLOW = -2501
	
	# VIOLET (-2600)
	
	# OTHERS (-2900)
	#BLACK_CORRUPTION_STACK = -2900
	BLACK_CAPACITOR_NOVA_STUN_EFFECT = -2901
	BLACK_CAPACITOR_LIGHTNING_STUN_EFFECT = -2902
	
	# ------------
	# RED GREEN (-3000)
	RED_GREEN_GREEN_STACK_EFFECT = -3000
	RED_GREEN_RED_STACK_EFFECT = -3001
	
	RED_GREEN_GREEN_SLOW_EFFECT = -3002
	
	# YELLOW VIOLET (-3100)
	
	
	# ORANGE BLUE (-3200)
	
	# RED OV (-3300)
	
	# ORANGE YR (-3400)
	
	# YELLOW GO (-3500)
	
	# GREEN BY (-3600)
	
	# BLUE VG (-3700)
	
	# VIOLET RB (-3800)
	VIOLETRB_VOID_GIVER_EFFECT = -3800
	VIOLETRB_PLAYER_DMG_DEC_EFFECT = -3801
	VIOLETRB_ABILITY_VOID_STUN_EFFECT = -3802
	
	# RYB (-3900)
	RYB_BEFORE_END_REACH_EFFECT = -3900
	RYB_ENEMY_DAMAGE_RESISTANCE_EFFECT = -3901
	RYB_ENEMY_HEAL_EFFECT = -3902
	
	# OGV (-4000)
	
	# RGB (-4100)
	
	# ROYGBV(-4200)
	
	
	
	#########
	
	# MISC (-5000)
	
	MAP_MESA__SANDSTORM_SLOW = -5000
	
	
}
