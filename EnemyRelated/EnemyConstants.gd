extends Node

const EnemyTypeInformation = preload("res://EnemyRelated/EnemyTypeInformation.gd")

const TextFragmentInterpreter = preload("res://MiscRelated/TextInterpreterRelated/TextFragmentInterpreter.gd")
const NumericalTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/NumericalTextFragment.gd")
#const TowerStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/TowerStatTextFragment.gd")
const OutcomeTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/OutcomeTextFragment.gd")
const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")
const EnemyStatTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/EnemyStatTextFragment.gd")


enum EnemyFactions {
	BASIC = 0,
	
	EXPERT = 1,
	FAITHFUL = 2,
	SKIRMISHERS = 3,
	
	#BEAST,
	#LIFE_MEDDLERS,
	#REBELS,
	
	OTHERS = 1000,
}

enum Enemies {
	############## BASIC (100)
	BASIC = 100,
	BRUTE = 101,
	DASH = 102,
	HEALER = 103,
	WIZARD = 104,
	PAIN = 105,
	
	############# EXPERT (200)
	EXPERIENCED = 200,
	FIEND = 201,
	CHARGE = 202,
	ENCHANTRESS = 203,
	MAGUS = 204,
	ASSASSIN = 205,
	GRANDMASTER = 206,
	
	########### FAITHFUL (300)
	DEITY = 300,
	BELIEVER = 301,
	PRIEST = 302,
	SACRIFICER = 303,
	SEER = 304,
	CROSS_BEARER = 305,
	DVARAPALA = 306,
	PROVIDENCE = 307,
	
	########## SKIRMISHERS (400)
	#BLUE (400)
	COSMIC = 400,
	SMOKE = 401,
	RALLIER = 402,
	PROXIMITY = 403,
	BLESSER = 404,
	ASCENDER = 405,
	
	# RED (440)
	BLASTER = 450
	ARTILLERY = 451
	DANSEUR = 452
	FINISHER = 453
	TOSSER = 454
	
	# BOTH (480)
	HOMERUNNER = 480
	RUFFIAN = 481
	
	############
	
	# OTHERS (10000)
	TRIASYN_OGV_SOUL = 10000,
	DOMSYN_RED_ORACLES_EYE_SHADOW = 10001,
	MAP_ENCHANT_ANTI_MAGIK = 10002,
	
}


var first_half_faction_id_pool : Array
var second_half_faction_id_pool : Array

const enemy_id_info_type_singleton_map : Dictionary = {}


func _init():
	first_half_faction_id_pool.append(EnemyFactions.BASIC)
	
	second_half_faction_id_pool.append(EnemyFactions.EXPERT)
	second_half_faction_id_pool.append(EnemyFactions.FAITHFUL)
	second_half_faction_id_pool.append(EnemyFactions.SKIRMISHERS)
	
	for enemy_id in Enemies.values():
		enemy_id_info_type_singleton_map[enemy_id] = get_enemy_info(enemy_id, true)


#

static func get_enemy_info(enemy_id : int, arg_include_non_combat_info : bool = false) -> EnemyTypeInformation:
	var info : EnemyTypeInformation
	
	############################### BASIC FACTION
	if enemy_id == Enemies.BASIC:
		info = EnemyTypeInformation.new(Enemies.BASIC, EnemyFactions.BASIC)
		info.base_health = 16
		info.base_movement_speed = 60
		
		if arg_include_non_combat_info:
			info.enemy_name = "Basic"
			info.descriptions = [
				"A basic and weak enemy."
			]
		
	elif enemy_id == Enemies.BRUTE:
		info = EnemyTypeInformation.new(Enemies.BRUTE, EnemyFactions.BASIC)
		info.base_health = 88
		info.base_movement_speed = 37
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			info.enemy_name = "Brute"
			info.descriptions = [
				"A slow but bulky unit."
			]
		
	elif enemy_id == Enemies.DASH:
		info = EnemyTypeInformation.new(Enemies.DASH, EnemyFactions.BASIC)
		info.base_health = 27 
		info.base_movement_speed = 51
		
		if arg_include_non_combat_info:
			var plain_fragment__speed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.MOV_SPEED, "speed")
			
			info.enemy_name = "Dash"
			info.descriptions = [
				["Gains a burst of temporary |0| upon reaching half health.", [plain_fragment__speed]]
			]
		
	elif enemy_id == Enemies.HEALER:
		info = EnemyTypeInformation.new(Enemies.HEALER, EnemyFactions.BASIC)
		info.base_health = 26
		info.base_movement_speed = 45
		
		if arg_include_non_combat_info:
			var plain_fragment__heal = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "Heals")
			var plain_fragment__enemy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "enemy")
			
			
			info.enemy_name = "Healer"
			info.descriptions = [
				["|0| the lowest percent health |1| for 6 every 10 seconds within its range (140).", [plain_fragment__heal, plain_fragment__enemy]]
			]
			info.simple_descriptions = [
				["|0| the lowest health |1| every 10 seconds.", [plain_fragment__heal, plain_fragment__enemy]]
			]
		
	elif enemy_id == Enemies.WIZARD:
		info = EnemyTypeInformation.new(Enemies.WIZARD, EnemyFactions.BASIC)
		info.base_health = 22
		info.base_movement_speed = 44
		
		if arg_include_non_combat_info:
			var plain_fragment__tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "tower")
			
			info.enemy_name = "Wizard"
			info.descriptions = [
				["Deals 2.05 damage over 3 attacks to a random |0| every 6 seconds within its range (80).", [plain_fragment__tower]],
				"Most towers have 10 health."
			]
			info.simple_descriptions = [
				["Deals damage to a random |0| every 6 seconds.", [plain_fragment__tower]],
			]
		
	elif enemy_id == Enemies.PAIN:
		info = EnemyTypeInformation.new(Enemies.PAIN, EnemyFactions.BASIC)
		info.base_health = 17
		info.base_movement_speed = 57
		info.base_player_damage = 2
		
		if arg_include_non_combat_info:
			info.enemy_name = "Pain"
			info.descriptions = [
				"Deals more player damage when escaping." 
			]
		
	################################# EXPERT FACTION
	elif enemy_id == Enemies.EXPERIENCED:
		info = EnemyTypeInformation.new(Enemies.EXPERIENCED, EnemyFactions.EXPERT)
		info.base_health = 23
		info.base_movement_speed = 60
		#info.base_resistance = 25
		info.base_toughness = 4.5
		info.base_armor = 3
		
		if arg_include_non_combat_info:
			info.enemy_name = "Experienced"
			info.descriptions = [
				"Having survived as a basic, the experienced become stronger."
			]
		
	elif enemy_id == Enemies.FIEND:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 120
		info.base_movement_speed = 38
		info.base_armor = 18
		info.base_toughness = 10
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			var plain_fragment__armor = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ARMOR, "armor")
			var plain_fragment__toughness = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOUGHNESS, "toughness")
			
			
			info.enemy_name = "Fiend"
			info.descriptions = [
				["A slow but extremely tanky enemy. Has high amounts of |0| and |1|.", [plain_fragment__armor, plain_fragment__toughness]]
			]
		
	elif enemy_id == Enemies.CHARGE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 38
		info.base_movement_speed = 54
		
		if arg_include_non_combat_info:
			var plain_fragment__speed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.MOV_SPEED, "speed")
			
			info.enemy_name = "Charge"
			info.descriptions = [
				["Gains a burst of temporary |0| upon reaching 75% health and 25% health.", [plain_fragment__speed]]
			]
		
	elif enemy_id == Enemies.ENCHANTRESS:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 20
		info.base_movement_speed = 45
		info.base_toughness = 1
		
		if arg_include_non_combat_info:
			var plain_fragment__heals = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "Heals")
			var plain_fragment__shields = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHIELD, "shields")
			var plain_fragment__enemy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "enemy")
			
			
			info.enemy_name = "Enchantress"
			info.simple_descriptions = [
				["|0| and |1| the two lowest percent health |2| every 7.5 seconds.", [plain_fragment__heals, plain_fragment__shields, plain_fragment__enemy]],
				"Heal amount: 10.",
				"Shield amount: 35% of target's missing health after the heal."
			]
			info.descriptions = [
				["|0| and |1| the two lowest percent health |2| every 7.5 seconds.", [plain_fragment__heals, plain_fragment__shields, plain_fragment__enemy]],
			]
		
	elif enemy_id == Enemies.MAGUS:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 21
		info.base_movement_speed = 43
		
		if arg_include_non_combat_info:
			var plain_fragment__tower = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOWER, "tower")
			
			info.enemy_name = "Magus"
			info.descriptions = [
				["Deals 5.05 damage over 3 attacks to the lowest health |0| every 5 seconds within its range (140).", [plain_fragment__tower]],
				"Most towers have 10 health."
			]
			info.simple_descriptions = [
				["Deals significant damage to the lowest health |0| every 5 seconds.", [plain_fragment__tower]],
			]
		
	elif enemy_id == Enemies.ASSASSIN:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 23
		info.base_movement_speed = 60
		info.base_player_damage = 2
		
		if arg_include_non_combat_info:
			var plain_fragment__invisible = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INVISIBLE, "invisible")
			
			info.enemy_name = "Assassin"
			info.descriptions = [
				"Deals more player damage.",
				["Becomes |0| for 8 seconds upon reaching 50% health.", [plain_fragment__invisible]],
				"Invisibility is removed upon being too close to the exit."
			]
			info.simple_descriptions = [
				"Deals more player damage.",
				["Becomes |0| for 8 seconds upon reaching 50% health.", [plain_fragment__invisible]],
			]
		
	elif enemy_id == Enemies.GRANDMASTER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 67 
		info.base_movement_speed = 60
		info.base_effect_vulnerability = 0.2
		#info.base_resistance = 25
		info.base_toughness = 3
		info.base_armor = 2
		info.enemy_type = info.EnemyType.ELITE
		
		if arg_include_non_combat_info:
			var plain_fragment__speed = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.MOV_SPEED, "speed")
			var plain_fragment__shield = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.SHIELD, "shield")
			var plain_fragment__invisible = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INVISIBLE, "invisible")
			
			
			info.enemy_name = "Grandmaster"
			info.descriptions = [
				["Gains a burst of temporary |0| and a 75% max health |1| for 2 seconds upon reaching 75% and 25% health.", [plain_fragment__speed, plain_fragment__shield]],
				["Becomes invisible for 2 seconds upon reaching 50% health.", [plain_fragment__invisible]],
				"",
				"\"Mastery of techniques.\""
			]
			info.simple_descriptions = [
				["Gains a burst of temporary |0| and a 75% max health |1| for 2 seconds upon reaching 75% and 25% health.", [plain_fragment__speed, plain_fragment__shield]],
				["Becomes invisible for 2 seconds upon reaching 50% health.", [plain_fragment__invisible]],
			]
		
	################################# FAITHFUL FACTION
	elif enemy_id == Enemies.DEITY:
		# stats set by faction
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.enemy_type = EnemyTypeInformation.EnemyType.BOSS
		
		info.base_health = EnemyTypeInformation.VALUE_DETERMINED_BY_OTHER_FACTORS
		info.base_effect_vulnerability = EnemyTypeInformation.VALUE_DETERMINED_BY_OTHER_FACTORS
		info.base_player_damage = EnemyTypeInformation.VALUE_DETERMINED_BY_OTHER_FACTORS
		
		info.base_movement_speed = 14
		info.base_player_damage = 18
		
		info.base_armor = 13
		info.base_toughness = 13
		
		if arg_include_non_combat_info:
			#var plain_fragment__armor = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ARMOR, "armor")
			#var plain_fragment__toughness = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.TOUGHNESS, "toughness")
			
			var interpreter_for_armor = TextFragmentInterpreter.new()
			interpreter_for_armor.tower_info_to_use_for_tower_stat_fragments = info
			interpreter_for_armor.display_body = true
			interpreter_for_armor.header_description = "armor"
			var ins_for_armor = []
			ins_for_armor.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.ARMOR, -1))
			ins_for_armor.append(NumericalTextFragment.new(1, false, -1))
			ins_for_armor.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_armor.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_armor.array_of_instructions = ins_for_armor
			
			var interpreter_for_toughness = TextFragmentInterpreter.new()
			interpreter_for_toughness.tower_info_to_use_for_tower_stat_fragments = info
			interpreter_for_toughness.display_body = true
			interpreter_for_toughness.header_description = "toughness"
			var ins_for_toughness = []
			ins_for_armor.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.TOUGHNESS, -1))
			ins_for_toughness.append(NumericalTextFragment.new(1, false, -1))
			ins_for_toughness.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_toughness.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_toughness.array_of_instructions = ins_for_toughness
			
			var plain_fragment__faithful_enemy = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Faithful enemy")
			
			var interpreter_for_health_per_sec = TextFragmentInterpreter.new()
			interpreter_for_health_per_sec.tower_info_to_use_for_tower_stat_fragments = info
			interpreter_for_health_per_sec.display_body = true
			interpreter_for_health_per_sec.header_description = "health per second"
			var ins_for_health_per_sec = []
			ins_for_armor.append(OutcomeTextFragment.new(EnemyStatTextFragment.STAT_TYPE.HEALTH, -1))
			ins_for_health_per_sec.append(NumericalTextFragment.new(1, false, -1))
			ins_for_health_per_sec.append(TextFragmentInterpreter.STAT_OPERATION.MULTIPLICATION)
			ins_for_health_per_sec.append(EnemyStatTextFragment.new(null, info, EnemyStatTextFragment.STAT_TYPE.ENEMY_STAT__ABILITY_POTENCY, EnemyStatTextFragment.STAT_BASIS.TOTAL, 1.0))
			interpreter_for_health_per_sec.array_of_instructions = ins_for_health_per_sec
			
			var plain_fragment__sacrificer = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Sacrificer")
			
			var ap_per_seer : float = 0.5
			var plain_fragment__x_ability_potency = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ABILITY_POTENCY, "%s Ability Potency" % ap_per_seer)
			var plain_fragment__seer = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Seer")
			
			var health_gain_for_cross : float = 15.0
			var plain_fragment__x_health_gain = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.HEALTH, "%s%% additional Health" % health_gain_for_cross)
			var plain_fragment__cross_bearer = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.ENEMY, "Cross Bearer")
			
			
			info.enemy_name = "Deity"
			info.descriptions = [
				"The centerpiece of the Faithfuls.",
				"",
				["Gains |0| and |1| per nearby |2|.", [interpreter_for_armor, interpreter_for_toughness, plain_fragment__faithful_enemy]],
				["Gains |0| per second per nearby |1|.", [interpreter_for_health_per_sec, plain_fragment__sacrificer]],
				["Gains |0| per nearby |1|.", [plain_fragment__x_ability_potency, plain_fragment__seer]],
				["Gains |0| while behind the cross left by |1|.", [plain_fragment__x_health_gain, plain_fragment__cross_bearer]],
				"",
				""
			]
			info.simple_descriptions = [
				
			]
		
	elif enemy_id == Enemies.BELIEVER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 29
		info.base_movement_speed = 57
		
	elif enemy_id == Enemies.PRIEST:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 28
		info.base_movement_speed = 37
		
	elif enemy_id == Enemies.SACRIFICER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 26
		info.base_movement_speed = 35
		
	elif enemy_id == Enemies.SEER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 28
		info.base_movement_speed = 37
		info.base_toughness = 2
		
	elif enemy_id == Enemies.CROSS_BEARER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 32
		info.base_movement_speed = 51
		info.base_armor = 2
		info.base_toughness = 2
		
	elif enemy_id == Enemies.DVARAPALA:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 88
		info.base_movement_speed = 39
		info.base_armor = 9
		info.base_toughness = 9
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.PROVIDENCE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 60
		info.base_movement_speed = 44
		info.base_armor = 5
		info.base_toughness = 5
		info.enemy_type = info.EnemyType.ELITE
		
		
	########################### SKIRMISHER
	elif enemy_id == Enemies.COSMIC:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 32
		info.base_movement_speed = 35
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.SMOKE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 30
		info.base_movement_speed = 55
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.RALLIER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 29
		info.base_movement_speed = 55
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.PROXIMITY:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 36.5
		info.base_movement_speed = 45
		info.base_toughness = 3
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.BLESSER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 26
		info.base_movement_speed = 40
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.ASCENDER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 48
		info.base_movement_speed = 55
		info.enemy_type = info.EnemyType.ELITE
		
		
	elif enemy_id == Enemies.BLASTER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 35
		info.base_movement_speed = 50
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.ARTILLERY:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 26
		info.base_movement_speed = 40
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.DANSEUR:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 28
		info.base_movement_speed = 52
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.FINISHER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 35
		info.base_movement_speed = 60
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.TOSSER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 24
		info.base_movement_speed = 55
		info.enemy_type = info.EnemyType.NORMAL
		
		
	elif enemy_id == Enemies.HOMERUNNER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 50
		info.base_movement_speed = 60
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.RUFFIAN:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 27
		info.base_movement_speed = 58
		info.enemy_type = info.EnemyType.NORMAL
		
		
	############################# OTHERS
	elif enemy_id == Enemies.TRIASYN_OGV_SOUL:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.OTHERS)
		info.base_health = 35 #39 
		info.base_movement_speed = 40
		info.base_armor = 5
		info.base_toughness = 5
		info.enemy_type = info.EnemyType.ELITE
		
		
	elif enemy_id == Enemies.DOMSYN_RED_ORACLES_EYE_SHADOW:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.OTHERS)
		info.base_health = 45 #50
		info.base_movement_speed = 35
		#info.base_armor = 5
		#info.base_toughness = 5
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.MAP_ENCHANT_ANTI_MAGIK:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.OTHERS)
		info.base_health = 25
		info.base_movement_speed = 38
		#info.base_armor = 5
		#info.base_toughness = 5
		info.enemy_type = info.EnemyType.NORMAL
		
	
	
	return info


static func get_enemy_scene(enemy_id : int):
	# BASIC FACTION
	if enemy_id == Enemies.BASIC:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Basic/Basic.tscn")
	elif enemy_id == Enemies.BRUTE:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Brute/Brute.tscn")
	elif enemy_id == Enemies.DASH:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Dash/Dash.tscn")
	elif enemy_id == Enemies.HEALER:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Healer/Healer.tscn")
	elif enemy_id == Enemies.WIZARD:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Wizard/Wizard.tscn")
	elif enemy_id == Enemies.PAIN:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Pain/Pain.tscn")
		
	# EXPERT FACTION
	elif enemy_id == Enemies.EXPERIENCED:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Experienced(Basic)/Experienced.tscn")
	elif enemy_id == Enemies.FIEND:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Fiend(Brute)/Fiend.tscn")
	elif enemy_id == Enemies.CHARGE:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Charge(Dash)/Charge.tscn")
	elif enemy_id == Enemies.ENCHANTRESS:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Enchantress(Healer)/Enchantress.tscn")
	elif enemy_id == Enemies.MAGUS:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Magus(Wizard)/Magus.tscn")
	elif enemy_id == Enemies.ASSASSIN:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Assassin(Pain)/Assassin.tscn")
	elif enemy_id == Enemies.GRANDMASTER:
		return load("res://EnemyRelated/EnemyTypes/Type_Expert/Grandmaster/Grandmaster.tscn")
		
	# FAITHFUL FACTION
	elif enemy_id == Enemies.DEITY:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Deity/Deity.tscn")
	elif enemy_id == Enemies.BELIEVER:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Believer/Believer.tscn")
	elif enemy_id == Enemies.PRIEST:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Priest/Priest.tscn")
	elif enemy_id == Enemies.SACRIFICER:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Sacrificer/Sacrificer.tscn")
	elif enemy_id == Enemies.SEER:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Seer/Seer.tscn")
	elif enemy_id == Enemies.CROSS_BEARER:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/CrossBearer/CrossBearer.tscn")
	elif enemy_id == Enemies.DVARAPALA:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Dvarapala/Dvarapala.tscn")
	elif enemy_id == Enemies.PROVIDENCE:
		return load("res://EnemyRelated/EnemyTypes/Type_Faithful/Providence/Providence.tscn")
		
	# SKIRMISHERS FACTION
	elif enemy_id == Enemies.COSMIC:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Cosmic/Cosmic.tscn")
	elif enemy_id == Enemies.SMOKE:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Smoke/Smoke.tscn")
	elif enemy_id == Enemies.RALLIER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Rallier/Rallier.tscn")
	elif enemy_id == Enemies.PROXIMITY:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Proximity/Proximity.tscn")
	elif enemy_id == Enemies.BLESSER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Blesser/Blesser.tscn")
	elif enemy_id == Enemies.ASCENDER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Blues/Ascender/Ascender.tscn")
		
	elif enemy_id == Enemies.BLASTER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Blaster/Blaster.tscn")
	elif enemy_id == Enemies.ARTILLERY:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Artillery/Artillery.tscn")
	elif enemy_id == Enemies.DANSEUR:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Danseur/Danseur.tscn")
	elif enemy_id == Enemies.FINISHER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Finisher/Finisher.tscn")
	elif enemy_id == Enemies.TOSSER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Reds/Tosser/Tosser.tscn")
		
	elif enemy_id == Enemies.HOMERUNNER:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Homerunner/Homerunner.tscn") 
	elif enemy_id == Enemies.RUFFIAN:
		return load("res://EnemyRelated/EnemyTypes/Type_Skirmisher/Both/Ruffian/Ruffian.tscn")
		
	# OTHERS
	elif enemy_id == Enemies.TRIASYN_OGV_SOUL:
		return load("res://EnemyRelated/EnemyTypes/Type_Others/TriaSyn_OGV_Soul/TriaSyn_OGV_Soul.tscn")
	elif enemy_id == Enemies.DOMSYN_RED_ORACLES_EYE_SHADOW:
		return load("res://EnemyRelated/EnemyTypes/Type_Others/DomSyn_Red_Pact_OraclesEye_Shadow/DomSyn_Red_Pact_OraclesEye_Shadow.tscn")
	elif enemy_id == Enemies.MAP_ENCHANT_ANTI_MAGIK:
		return load("res://EnemyRelated/EnemyTypes/Type_Others/MapEnchant_AntiMagik/MapEnchant_AntiMagik.tscn")
	
