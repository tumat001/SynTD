extends "res://GameElementsRelated/AreaTowerPlacablesRelated/BaseAreaTowerPlacable.gd"

const glowing = preload("res://GameElementsRelated/TowerInventoryRelated/TowerInventoryTile_Glowing.png")
const normal = preload("res://GameElementsRelated/TowerInventoryRelated/TowerInventoryTile.png")

func set_area_texture_to_glow():
	$AreaSprite.texture = glowing

func set_area_texture_to_not_glow():
	$AreaSprite.texture = normal


func get_placable_type_name() -> String:
	return "TowerBenchSlot"

