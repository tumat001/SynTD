extends Sprite


const Flag_Orange_Pic = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/Assets/EnemySpawnLoc_Flag_Orange.png")
const Flag_Blue_Pic = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/Assets/EnemySpawnLoc_Flag_Blue.png")
const Flag_Red_Pic = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/Assets/EnemySpawnLoc_Flag_Red.png")
const Flag_Pink_Pic__MapEnchant = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/Assets/EnemySpawnLoc_Flag_Pink__MapEnchant.png")


enum FlagTextureIds {
	ORANGE,
	BLUE,
	RED,
	PINK__MAP_ENCHANT,
}


var offset_from_path_start : float
var hide_if_path_is_not_used_for_natural_spawning : bool = true

var enemy_path_associated

func set_flag_texture_id(arg_id):
	if arg_id == FlagTextureIds.ORANGE:
		texture = Flag_Orange_Pic
	elif arg_id == FlagTextureIds.BLUE:
		texture = Flag_Blue_Pic
	elif arg_id == FlagTextureIds.RED:
		texture = Flag_Red_Pic
	elif arg_id == FlagTextureIds.PINK__MAP_ENCHANT:
		texture = Flag_Pink_Pic__MapEnchant

