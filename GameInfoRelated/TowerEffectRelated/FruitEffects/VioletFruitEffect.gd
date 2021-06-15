extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"


func _init().(StoreOfTowerEffectsUUID.ING_VIOLET_FRUIT):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_VioletFruit.png")
	description = "The tower can now absorb 3 additional towers."


func _make_modifications_to_tower(tower):
	tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.ING_VIOLET_FRUIT, 3)

func _undo_modifications_to_tower(tower):
	tower.remove_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.ING_VIOLET_FRUIT)

