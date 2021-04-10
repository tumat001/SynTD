
const EnemyDetails = preload("res://EnemyRelated/EnemyDetails.gd")

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
	TEST_ENEMY
}

const test_enemy_scene = preload("res://EnemyRelated/Misc/TestEnemy/TestEnemy.tscn")

var EnemyDetailsMap : Dictionary = {
	Enemies.TEST_ENEMY : EnemyDetails.new(10, 10, EnemyFactions.MISC)
}
