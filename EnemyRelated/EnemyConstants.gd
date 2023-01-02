extends Node


const EnemyTypeInformation = preload("res://EnemyRelated/EnemyTypeInformation.gd")

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
	
}


var first_half_faction_id_pool : Array
var second_half_faction_id_pool : Array


func _init():
	first_half_faction_id_pool.append(EnemyFactions.BASIC)
	
	#second_half_faction_id_pool.append(EnemyFactions.EXPERT)
	#second_half_faction_id_pool.append(EnemyFactions.FAITHFUL)
	second_half_faction_id_pool.append(EnemyFactions.SKIRMISHERS)


static func get_enemy_info(enemy_id : int) -> EnemyTypeInformation:
	var info : EnemyTypeInformation
	
	############################### BASIC FACTION
	if enemy_id == Enemies.BASIC:
		info = EnemyTypeInformation.new(Enemies.BASIC, EnemyFactions.BASIC)
		info.base_health = 16
		info.base_movement_speed = 60
		
	elif enemy_id == Enemies.BRUTE:
		info = EnemyTypeInformation.new(Enemies.BRUTE, EnemyFactions.BASIC)
		info.base_health = 88
		info.base_movement_speed = 37
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.DASH:
		info = EnemyTypeInformation.new(Enemies.DASH, EnemyFactions.BASIC)
		info.base_health = 27 
		info.base_movement_speed = 51
		
	elif enemy_id == Enemies.HEALER:
		info = EnemyTypeInformation.new(Enemies.HEALER, EnemyFactions.BASIC)
		info.base_health = 26
		info.base_movement_speed = 45
		
	elif enemy_id == Enemies.WIZARD:
		info = EnemyTypeInformation.new(Enemies.WIZARD, EnemyFactions.BASIC)
		info.base_health = 22
		info.base_movement_speed = 44
		
	elif enemy_id == Enemies.PAIN:
		info = EnemyTypeInformation.new(Enemies.PAIN, EnemyFactions.BASIC)
		info.base_health = 17
		info.base_movement_speed = 57
		info.base_player_damage = 2
		
		
	################################# EXPERT FACTION
	elif enemy_id == Enemies.EXPERIENCED:
		info = EnemyTypeInformation.new(Enemies.EXPERIENCED, EnemyFactions.EXPERT)
		info.base_health = 23
		info.base_movement_speed = 60
		#info.base_resistance = 25
		info.base_toughness = 4.5
		info.base_armor = 3
		
	elif enemy_id == Enemies.FIEND:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 120
		info.base_movement_speed = 38
		info.base_armor = 18
		info.base_toughness = 10
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.CHARGE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 38
		info.base_movement_speed = 54
		
	elif enemy_id == Enemies.ENCHANTRESS:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 20
		info.base_movement_speed = 45
		info.base_toughness = 1
		
	elif enemy_id == Enemies.MAGUS:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 21
		info.base_movement_speed = 43
		
	elif enemy_id == Enemies.ASSASSIN:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 23
		info.base_movement_speed = 60
		info.base_player_damage = 2
		
	elif enemy_id == Enemies.GRANDMASTER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 67 
		info.base_movement_speed = 60
		info.base_effect_vulnerability = 0.2
		#info.base_resistance = 25
		info.base_toughness = 3
		info.base_armor = 2
		info.enemy_type = info.EnemyType.ELITE
		
		
	################################# FAITHFUL FACTION
	elif enemy_id == Enemies.DEITY:
		# stats set by faction
		pass
		
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
		info.base_health = 34 #32
		info.base_movement_speed = 35
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.SMOKE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 31 #29
		info.base_movement_speed = 55
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.RALLIER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 30 #28
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
		info.base_health = 27
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
		info.base_health = 28 #26
		info.base_movement_speed = 40
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.DANSEUR:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 30
		info.base_movement_speed = 52
		info.enemy_type = info.EnemyType.NORMAL
		
	elif enemy_id == Enemies.FINISHER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 38#35
		info.base_movement_speed = 60
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.TOSSER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 26 #24
		info.base_movement_speed = 55
		info.enemy_type = info.EnemyType.NORMAL
		
		
	elif enemy_id == Enemies.HOMERUNNER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 50#45
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
	
