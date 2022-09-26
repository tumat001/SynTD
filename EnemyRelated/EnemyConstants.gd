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
	# BASIC (100)
	BASIC = 100,
	BRUTE = 101,
	DASH = 102,
	HEALER = 103,
	WIZARD = 104,
	PAIN = 105,
	
	# EXPERT (200)
	EXPERIENCED = 200,
	FIEND = 201,
	CHARGE = 202,
	ENCHANTRESS = 203,
	MAGUS = 204,
	ASSASSIN = 205,
	GRANDMASTER = 206,
	
	# FAITHFUL (300)
	DEITY = 300,
	BELIEVER = 301,
	PRIEST = 302,
	SACRIFICER = 303,
	SEER = 304,
	CROSS_BEARER = 305,
	DVARAPALA = 306,
	PROVIDENCE = 307,
	
	# SKIRMISHERS (400)
	COSMIC = 400,
	
	
	# OTHERS (10000)
	TRIASYN_OGV_SOUL = 10000,
	DOMSYN_RED_ORACLES_EYE_SHADOW = 10001,
	
}


var first_half_faction_id_pool : Array
var second_half_faction_id_pool : Array


func _init():
	first_half_faction_id_pool.append(EnemyFactions.BASIC)
	
	second_half_faction_id_pool.append(EnemyFactions.EXPERT)
	second_half_faction_id_pool.append(EnemyFactions.FAITHFUL)
	#second_half_faction_id_pool.append(EnemyFactions.SKIRMISHERS)


static func get_enemy_info(enemy_id : int) -> EnemyTypeInformation:
	var info : EnemyTypeInformation
	
	# BASIC FACTION
	if enemy_id == Enemies.BASIC:
		info = EnemyTypeInformation.new(Enemies.BASIC, EnemyFactions.BASIC)
		info.base_health = 1000#24
		info.base_movement_speed = 40
		
	elif enemy_id == Enemies.BRUTE:
		info = EnemyTypeInformation.new(Enemies.BRUTE, EnemyFactions.BASIC)
		info.base_health = 130
		info.base_movement_speed = 25
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.DASH:
		info = EnemyTypeInformation.new(Enemies.DASH, EnemyFactions.BASIC)
		info.base_health = 40 #38
		info.base_movement_speed = 34
		
	elif enemy_id == Enemies.HEALER:
		info = EnemyTypeInformation.new(Enemies.HEALER, EnemyFactions.BASIC)
		info.base_health = 38 #36
		info.base_movement_speed = 30
		
	elif enemy_id == Enemies.WIZARD:
		info = EnemyTypeInformation.new(Enemies.WIZARD, EnemyFactions.BASIC)
		info.base_health = 32
		info.base_movement_speed = 29
		
	elif enemy_id == Enemies.PAIN:
		info = EnemyTypeInformation.new(Enemies.PAIN, EnemyFactions.BASIC)
		info.base_health = 25
		info.base_movement_speed = 38
		info.base_player_damage = 2
		
		
	# EXPERT FACTION
	elif enemy_id == Enemies.EXPERIENCED:
		info = EnemyTypeInformation.new(Enemies.EXPERIENCED, EnemyFactions.EXPERT)
		info.base_health = 34 #33.5
		info.base_movement_speed = 40
		#info.base_resistance = 25
		info.base_toughness = 4.5
		info.base_armor = 3
		
	elif enemy_id == Enemies.FIEND:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 180
		info.base_movement_speed = 25
		info.base_armor = 18
		info.base_toughness = 10
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.CHARGE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 55
		info.base_movement_speed = 36
		
	elif enemy_id == Enemies.ENCHANTRESS:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 29
		info.base_movement_speed = 30
		info.base_toughness = 1
		
	elif enemy_id == Enemies.MAGUS:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 30
		info.base_movement_speed = 29
		
	elif enemy_id == Enemies.ASSASSIN:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 35
		info.base_movement_speed = 40
		info.base_player_damage = 2
		
	elif enemy_id == Enemies.GRANDMASTER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 100
		info.base_movement_speed = 40
		info.base_effect_vulnerability = 0.2
		#info.base_resistance = 25
		info.base_toughness = 3
		info.base_armor = 2
		info.enemy_type = info.EnemyType.ELITE
		
		
	# FAITHFUL FACTION
	elif enemy_id == Enemies.DEITY:
		# stats set by faction
		pass
		
	elif enemy_id == Enemies.BELIEVER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 43
		info.base_movement_speed = 38
		
	elif enemy_id == Enemies.PRIEST:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 41
		info.base_movement_speed = 25
		
	elif enemy_id == Enemies.SACRIFICER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 37
		info.base_movement_speed = 23
		
	elif enemy_id == Enemies.SEER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 42
		info.base_movement_speed = 25
		info.base_toughness = 2
		
	elif enemy_id == Enemies.CROSS_BEARER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 47
		info.base_movement_speed = 34
		info.base_armor = 2
		info.base_toughness = 2
		
	elif enemy_id == Enemies.DVARAPALA:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 130
		info.base_movement_speed = 26
		info.base_armor = 9
		info.base_toughness = 9
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.PROVIDENCE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 88
		info.base_movement_speed = 29
		info.base_armor = 5
		info.base_toughness = 5
		info.enemy_type = info.EnemyType.ELITE
		
		
	# SKIRMISHER
	elif enemy_id == Enemies.COSMIC:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.SKIRMISHERS)
		info.base_health = 54
		info.base_movement_speed = 23
		info.enemy_type = info.EnemyType.NORMAL
		
		
		
		
	# OTHERS
	elif enemy_id == Enemies.TRIASYN_OGV_SOUL:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.OTHERS)
		info.base_health = 52
		info.base_movement_speed = 27
		info.base_armor = 5
		info.base_toughness = 5
		info.enemy_type = info.EnemyType.ELITE
		
		
	elif enemy_id == Enemies.DOMSYN_RED_ORACLES_EYE_SHADOW:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.OTHERS)
		info.base_health = 65
		info.base_movement_speed = 25
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
		
		
	# OTHERS
	elif enemy_id == Enemies.TRIASYN_OGV_SOUL:
		return load("res://EnemyRelated/EnemyTypes/Type_Others/TriaSyn_OGV_Soul/TriaSyn_OGV_Soul.tscn")
	elif enemy_id == Enemies.DOMSYN_RED_ORACLES_EYE_SHADOW:
		return load("res://EnemyRelated/EnemyTypes/Type_Others/DomSyn_Red_Pact_OraclesEye_Shadow/DomSyn_Red_Pact_OraclesEye_Shadow.tscn")
	
