extends "res://GameInfoRelated/TowerEffectRelated/BaseTowerModifyingEffect.gd"

const PlainTextFragment = preload("res://MiscRelated/TextInterpreterRelated/TextFragments/PlainTextFragment.gd")


func _init().(StoreOfTowerEffectsUUID.ING_VIOLET_FRUIT):
	effect_icon = preload("res://GameHUDRelated/RightSidePanel/TowerInformationPanel/TowerIngredientIcons/Ing_VioletFruit.png")
	
	var plain_fragment__additional_ingredient = PlainTextFragment.new(PlainTextFragment.STAT_TYPE.INGREDIENT, "3 additional ingredients")
	
	description = ["The tower can now absorb |0|.", [plain_fragment__additional_ingredient]]


func _make_modifications_to_tower(tower):
	tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.ING_VIOLET_FRUIT, 3)

func _undo_modifications_to_tower(tower):
	tower.remove_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.ING_VIOLET_FRUIT)

