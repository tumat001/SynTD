
const EnemyTypeInformation = preload("res://EnemyRelated/EnemyTypeInformation.gd")


enum EnemyFactions {
	MISC,
	GENERIC,
	BEAST,
	LIFE_MEDDLERS,
	REBELS,
	CULTISTS,
}

enum Enemies {
	#MISC
	TEST_ENEMY,
}

static func get_enemy_info(enemy_id : int) -> EnemyTypeInformation:
	var info : EnemyTypeInformation
	
	if enemy_id == Enemies.TEST_ENEMY:
		info = EnemyTypeInformation.new(Enemies.TEST_ENEMY, EnemyFactions.MISC)
		
	
	return info


static func get_enemy_scene(enemy_id : int):
	if enemy_id == Enemies.TEST_ENEMY:
		return load("res://EnemyRelated/Misc/TestEnemy/TestEnemy.tscn")


