
#const AbstractEnemy = preload("res://EnemyRelated/AbstractEnemy.gd")

# SHARED IN AbstractEnemy. Changes here must be
# reflected in that class as well.
enum EnemyType {
	NORMAL = 500,
	ELITE = 600,
	BOSS = 700,
}

enum TypeInfoMetadata {
	DEITY_FORM = 1,
}

# 
var enemy_id : int
var faction


# For random generation -> soon
var value
var requirement_value


# Stats
var base_health : float = 5
var base_movement_speed : float = 0
var base_armor : float = 0
var base_toughness : float = 0
var base_resistance : float = 0
var base_player_damage : float = 1
var base_effect_vulnerability : float = 1

var enemy_type : int = EnemyType.NORMAL

var type_info_metadata : Dictionary

func _init(arg_id : int, arg_faction):
	enemy_id = arg_id
	faction = arg_faction
