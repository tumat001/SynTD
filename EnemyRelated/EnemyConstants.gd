
const EnemyTypeInformation = preload("res://EnemyRelated/EnemyTypeInformation.gd")


enum EnemyFactions {
	MISC,
	
	BASIC,
	BEAST,
	LIFE_MEDDLERS,
	REBELS,
	CULTISTS,
}

enum Enemies {
	# MISC (0)
	TEST_ENEMY = 0,
	
	# BASIC (100)
	BASIC = 100,
	BRUTE = 101,
	DASH = 102,
	HEALER = 103,
	WIZARD = 104,
}

static func get_enemy_info(enemy_id : int) -> EnemyTypeInformation:
	var info : EnemyTypeInformation
	
	# MISC
	if enemy_id == Enemies.TEST_ENEMY:
		info = EnemyTypeInformation.new(Enemies.TEST_ENEMY, EnemyFactions.MISC)
		info.base_health = 54
		info.base_movement_speed = 22
		
	# BASIC FACTION
	elif enemy_id == Enemies.BASIC:
		info = EnemyTypeInformation.new(Enemies.BASIC, EnemyFactions.BASIC)
		info.base_health = 8
		info.base_movement_speed = 28
		
	elif enemy_id == Enemies.BRUTE:
		info = EnemyTypeInformation.new(Enemies.BRUTE, EnemyFactions.BASIC)
		info.base_health = 30
		info.base_movement_speed = 18
		
	elif enemy_id == Enemies.DASH:
		info = EnemyTypeInformation.new(Enemies.DASH, EnemyFactions.BASIC)
		info.base_health = 10
		info.base_movement_speed = 26
		
	elif enemy_id == Enemies.HEALER:
		info = EnemyTypeInformation.new(Enemies.HEALER, EnemyFactions.BASIC)
		info.base_health = 14
		info.base_movement_speed = 23
		
	elif enemy_id == Enemies.WIZARD:
		info = EnemyTypeInformation.new(Enemies.WIZARD, EnemyFactions.BASIC)
		info.base_health = 12
		info.base_movement_speed = 21
	
	return info


static func get_enemy_scene(enemy_id : int):
	if enemy_id == Enemies.TEST_ENEMY:
		return load("res://EnemyRelated/Misc/TestEnemy/TestEnemy.tscn")
	elif enemy_id == Enemies.BASIC:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Basic/Basic.tscn")
	elif enemy_id == Enemies.BRUTE:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Brute/Brute.tscn")
	elif enemy_id == Enemies.DASH:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Dash/Dash.tscn")
	elif enemy_id == Enemies.HEALER:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Healer/Healer.tscn")
	elif enemy_id == Enemies.WIZARD:
		return load("res://EnemyRelated/EnemyTypes/Type_Basic/Wizard/Wizard.tscn")
