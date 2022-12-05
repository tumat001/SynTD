extends Sprite


const Flag_Orange_Pic = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/Assets/EnemySpawnLoc_Flag_Orange.png")
const Flag_Blue_Pic = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/Assets/EnemySpawnLoc_Flag_Blue.png")
const Flag_Red_Pic = preload("res://MiscRelated/MapRelated/EnemySpawnLocIndicator/Assets/EnemySpawnLoc_Flag_Red.png")


enum FlagTextureIds {
	ORANGE,
	BLUE,
	RED,
}


func set_flag_texture_id(arg_id):
	if arg_id == FlagTextureIds.ORANGE:
		texture = Flag_Orange_Pic
	elif arg_id == FlagTextureIds.BLUE:
		texture = Flag_Blue_Pic
	elif arg_id == FlagTextureIds.RED:
		texture = Flag_Red_Pic

