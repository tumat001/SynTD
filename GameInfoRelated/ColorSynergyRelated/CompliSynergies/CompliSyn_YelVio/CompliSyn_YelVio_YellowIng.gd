extends "res://GameInfoRelated/ColorSynergyRelated/AbstractTowerModifyingSynergyEffect.gd"


const tier_3_tower_ing_limit : int = 3

func _apply_syn_to_tower(tower : AbstractTower, tier : int):
	if tower._tower_colors.has(TowerColors.YELLOW):
		if tier <= 3:
			tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.YELVIO_SYNERGY, tier_3_tower_ing_limit)

func _remove_syn_from_tower(tower : AbstractTower, tier : int):
	tower.set_ingredient_limit_modifier(StoreOfIngredientLimitModifierID.YELVIO_SYNERGY, 0)
