const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

enum {
	MONO,
}

static func get_tower_info(tower_id : int) -> TowerTypeInformation :
	var info
	
	if tower_id == MONO:
		info = TowerTypeInformation.new("Mono", MONO)
		info.tower_cost = 1
		info.colors.append(TowerColors.GRAY)
		
		info.base_damage = 3
		info.base_attk_speed = 0.75
		info.base_pierce = 1
		info.base_range = 200
		info.base_damage_type = DamageType.PHYSICAL
		
		info.tower_descriptions = [
			"\"Fires metal bullets at opponents\"",
			"\"First Iteration\""
		]
	
	return info

static func get_tower_scene(tower_id : int):
	if tower_id == MONO:
		return load("res://TowerRelated/Mono_Tower001/Mono.tscn")


