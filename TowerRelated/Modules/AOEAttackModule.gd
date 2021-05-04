extends "res://TowerRelated/Modules/AbstractAttackModule.gd"

const SpawnAOETemplate = preload("res://TowerRelated/Templates/SpawnAOETemplate.gd")

enum SpawnMethod {
	CENTERED_TO_TOWER,
	CENTERED_TO_ENEMY,
	IN_FRONT_OF_TOWER,
}

var spawn_method : int = SpawnMethod.IN_FRONT_OF_TOWER
var aoe_template : SpawnAOETemplate


func _attack_enemy(_enemy : AbstractEnemy):
	pass

func _attack_enemies(_enemies : Array):
	pass

func _attack_at_positions(_positions : Array):
	pass

func _attack_at_position(_pos : Vector2):
	pass

