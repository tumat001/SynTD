const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

enum {
	MONO,
}

static func get_tower_info(tower : int) -> TowerTypeInformation :
	var info
	
	if tower == MONO:
		info = TowerTypeInformation.new("Mono", MONO)
		info.tower_cost = 1
		info.colors.append(TowerColors.GRAY)
		
		info.base_damage = 3
		info.base_attk_speed = 0.75
		info.base_pierce = 2
		info.base_range = 200
	
	return info
