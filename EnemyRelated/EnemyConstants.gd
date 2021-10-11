extends Node


const EnemyTypeInformation = preload("res://EnemyRelated/EnemyTypeInformation.gd")

enum EnemyFactions {
	BASIC = 0,
	EXPERT = 1,
	
	FAITHFUL = 2,
	
	#BEAST,
	#LIFE_MEDDLERS,
	#REBELS,
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
	
}

var faction_id_pool : Array


func _init():
	#for faction_id in EnemyFactions.values():
	#	faction_id_pool.append(faction_id)
	
	faction_id_pool.append(EnemyFactions.FAITHFUL)
	faction_id_pool.append(EnemyFactions.EXPERT)


static func get_enemy_info(enemy_id : int) -> EnemyTypeInformation:
	var info : EnemyTypeInformation
	
	# BASIC FACTION
	if enemy_id == Enemies.BASIC:
		info = EnemyTypeInformation.new(Enemies.BASIC, EnemyFactions.BASIC)
		info.base_health = 22
		info.base_movement_speed = 40
		
	elif enemy_id == Enemies.BRUTE:
		info = EnemyTypeInformation.new(Enemies.BRUTE, EnemyFactions.BASIC)
		info.base_health = 142
		info.base_movement_speed = 25
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.DASH:
		info = EnemyTypeInformation.new(Enemies.DASH, EnemyFactions.BASIC)
		info.base_health = 36
		info.base_movement_speed = 34
		
	elif enemy_id == Enemies.HEALER:
		info = EnemyTypeInformation.new(Enemies.HEALER, EnemyFactions.BASIC)
		info.base_health = 34
		info.base_movement_speed = 30
		
	elif enemy_id == Enemies.WIZARD:
		info = EnemyTypeInformation.new(Enemies.WIZARD, EnemyFactions.BASIC)
		info.base_health = 30
		info.base_movement_speed = 29
		
	elif enemy_id == Enemies.PAIN:
		info = EnemyTypeInformation.new(Enemies.PAIN, EnemyFactions.BASIC)
		info.base_health = 23
		info.base_movement_speed = 38
		info.base_player_damage = 2
		
		
	# EXPERT FACTION
	elif enemy_id == Enemies.EXPERIENCED:
		info = EnemyTypeInformation.new(Enemies.EXPERIENCED, EnemyFactions.EXPERT)
		info.base_health = 34.5
		info.base_movement_speed = 40
		#info.base_resistance = 25
		info.base_toughness = 9#3
		info.base_armor = 6
		
	elif enemy_id == Enemies.FIEND:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 178
		info.base_movement_speed = 25
		info.base_armor = 35
		info.base_toughness = 20
		info.enemy_type = info.EnemyType.ELITE
		
	elif enemy_id == Enemies.CHARGE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 54
		info.base_movement_speed = 36
		
	elif enemy_id == Enemies.ENCHANTRESS:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 40
		info.base_movement_speed = 30
		info.base_toughness = 2
		
	elif enemy_id == Enemies.MAGUS:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.EXPERT)
		info.base_health = 37
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
		info.base_toughness = 8
		info.base_armor = 6
		info.enemy_type = info.EnemyType.ELITE
		
		
	# FAITHFUL FACTION
	elif enemy_id == Enemies.DEITY:
		# stats set by faction
		pass
		
	elif enemy_id == Enemies.BELIEVER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 42
		info.base_movement_speed = 38
		
	elif enemy_id == Enemies.PRIEST:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 37
		info.base_movement_speed = 25
		
	elif enemy_id == Enemies.SACRIFICER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 34
		info.base_movement_speed = 23
		
	elif enemy_id == Enemies.SEER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 40
		info.base_movement_speed = 25
		
	elif enemy_id == Enemies.CROSS_BEARER:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 46
		info.base_movement_speed = 34
		info.base_armor = 3
		info.base_toughness = 3
		
	elif enemy_id == Enemies.DVARAPALA:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 128
		info.base_movement_speed = 26
		info.base_armor = 18
		info.base_toughness = 18
		
	elif enemy_id == Enemies.PROVIDENCE:
		info = EnemyTypeInformation.new(enemy_id, EnemyFactions.FAITHFUL)
		info.base_health = 65
		info.base_movement_speed = 29
		info.base_armor = 10
		info.base_toughness = 10
		
		
	
	
	
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

