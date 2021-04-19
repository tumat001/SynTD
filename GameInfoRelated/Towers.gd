const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

enum {
	MONO,
}

static func get_tower_info(tower : int) -> TowerTypeInformation :
	var info
	
	if tower == MONO:
		info = TowerTypeInformation.new("Mono")
		info.tower_cost = 1
		info.colors.append(TowerColors.GRAY)
	
	return info
