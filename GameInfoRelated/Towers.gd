const TowerTypeInformation = preload("res://GameInfoRelated/TowerTypeInformation.gd")
const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")
const DamageType = preload("res://GameInfoRelated/DamageType.gd")

#GRAY
const mono_image = preload("res://TowerRelated/Color_Gray/Mono/Mono_E.png")
const simplex_image = preload("res://TowerRelated/Color_Gray/Simplex/Simplex_Omni.png")

#BLUE
const sprinkler_image = preload("res://TowerRelated/Color_Blue/Sprinkler/Sprinkler_E.png")

#GREEN
const berrybush_image = preload("res://TowerRelated/Color_Green/BerryBush/BerryBush_Omni.png")

#VIOLET
const simpleobelisk_image = preload("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk_Omni.png")

enum {
	#GRAY
	MONO,
	SIMPLEX,
	
	#BLUE
	SPRINKLER,
	
	#GREEN
	BERRY_BUSH,
	
	#VIOLET
	SIMPLE_OBELISK
}

static func get_tower_info(tower_id : int) -> TowerTypeInformation :
	var info
	
	if tower_id == MONO:
		info = TowerTypeInformation.new("Mono", MONO)
		info.tower_cost = 1
		info.colors.append(TowerColors.GRAY)
		info.tower_tier = 1
		info.tower_image_in_buy_card = mono_image
		
		info.base_damage = 3
		info.base_attk_speed = 0.75
		info.base_pierce = 1
		info.base_range = 100
		info.base_damage_type = DamageType.PHYSICAL
		
		info.tower_descriptions = [
			"Fires metal bullets at opponents",
			"\"First Iteration\""
		]
	elif tower_id == SPRINKLER:
		info = TowerTypeInformation.new("Sprinkler", SPRINKLER)
		info.tower_cost = 1
		info.colors.append(TowerColors.BLUE)
		info.tower_tier = 1
		info.tower_image_in_buy_card = sprinkler_image
		
		info.base_damage = 1
		info.base_attk_speed = 2.75
		info.base_pierce = 1
		info.base_range = 120
		info.base_damage_type = DamageType.ELEMENTAL
		
		info.tower_descriptions = [
			"Sprinkles water droplets to enemies"
		]
	elif tower_id == BERRY_BUSH:
		info = TowerTypeInformation.new("Berry Bush", BERRY_BUSH)
		info.tower_cost = 2
		info.colors.append(TowerColors.GREEN)
		info.tower_tier = 2
		info.tower_image_in_buy_card = berrybush_image
		
		info.base_damage = 0
		info.base_attk_speed = 0
		info.base_pierce = 0
		info.base_range = 0
		info.base_damage_type = DamageType.ELEMENTAL
		
		info.tower_descriptions = [
			"Does not attack, but instead gives gold at the end of the round"
		]
	elif tower_id == SIMPLE_OBELISK:
		info = TowerTypeInformation.new("Simple Obelisk", SIMPLE_OBELISK)
		info.tower_cost = 3
		info.colors.append(TowerColors.VIOLET)
		info.colors.append(TowerColors.GRAY)
		info.tower_tier = 3
		info.tower_image_in_buy_card = simpleobelisk_image
		
		info.base_damage = 6
		info.base_attk_speed = 0.5
		info.base_pierce = 1
		info.base_range = 170
		info.base_damage_type = DamageType.ELEMENTAL
		
		info.tower_descriptions = [
			"Fires arcane bolts at enemies that explode before fizzling out"
		]
	elif tower_id == SIMPLEX:
		info = TowerTypeInformation.new("Simplex", SIMPLEX)
		info.tower_cost = 1
		info.colors.append(TowerColors.GRAY)
		info.tower_tier = 1
		info.tower_image_in_buy_card = simplex_image
		
		info.base_damage = 0.25
		info.base_attk_speed = 8
		info.base_pierce = 0
		info.base_range = 110
		info.base_damage_type = DamageType.PURE
		
		info.tower_descriptions = [
			"Directs a constant pure energy beam at a single target",
			"\"First Iteration\""
		]
	
	return info

static func get_tower_scene(tower_id : int):
	if tower_id == MONO:
		return load("res://TowerRelated/Color_Gray/Mono/Mono.tscn")
	elif tower_id == SPRINKLER:
		return load("res://TowerRelated/Color_Blue/Sprinkler/Sprinkler.tscn")
	elif tower_id == BERRY_BUSH:
		return load("res://TowerRelated/Color_Green/BerryBush/BerryBush.tscn")
	elif tower_id == SIMPLE_OBELISK:
		return load("res://TowerRelated/Color_Violet/SimpleObelisk/SimpleObelisk.tscn")
	elif tower_id == SIMPLEX:
		return load("res://TowerRelated/Color_Gray/Simplex/Simplex.tscn")

