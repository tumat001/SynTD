extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const TowerColors = preload("res://GameInfoRelated/TowerColors.gd")

func _init().(StoreOfTowerEffectsUUID.ING_GREEN_FRUIT):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_GreenFruit.png")
	description = "The tower is now also color Green."


func _make_modifications_to_tower(tower):
	tower.add_color_to_tower(TowerColors.GREEN)

func _undo_modifications_to_tower(tower):
	tower.remove_color_to_tower(TowerColors.GREEN)
