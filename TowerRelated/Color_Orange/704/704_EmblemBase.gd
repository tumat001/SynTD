extends Sprite


const EmblemBasePic_Lvl0 = preload("res://TowerRelated/Color_Orange/704/704_Panel_Level0.png")
const EmblemBasePic_Lvl1_2 = preload("res://TowerRelated/Color_Orange/704/704_Panel_Level1-2.png")
const EmblemBasePic_Lvl3 = preload("res://TowerRelated/Color_Orange/704/704_Panel_Level3.png")
const EmblemBasePic_Lvl4 = preload("res://TowerRelated/Color_Orange/704/704_Panel_Level4.png")


func set_level(level : int):
	if level <= 0:
		texture = EmblemBasePic_Lvl0
	elif level == 1 or level == 2:
		texture = EmblemBasePic_Lvl1_2
	elif level == 3:
		texture = EmblemBasePic_Lvl3
	elif level >= 4:
		texture = EmblemBasePic_Lvl4
