extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


func _init().(StoreOfTowerEffectsUUID.ING_TIME_MACHINE):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_Reset.png")
	description = "Removes the latest added ingredient effect, refunding gold in the process."


func _make_modifications_to_tower(tower):
	tower._remove_latest_ingredient_by_effect()
	tower._remove_latest_ingredient_by_effect()

func _undo_modifications_to_tower(tower):
	pass
