extends "res://EnemyRelated/AbstractEnemy.gd"

enum ColorType {
	GRAY = 0,
	BLUE = 1,
	RED = 2
}

var skirmisher_path_color_type setget set_skirm_path_color_type

func set_skirm_path_color_type(color_type : int):
	skirmisher_path_color_type = color_type


